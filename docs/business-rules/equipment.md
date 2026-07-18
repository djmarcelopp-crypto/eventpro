# Regras de negócio — Estoque & Equipamentos

## Visão geral

O módulo **Estoque & Equipamentos** gerencia o inventário operacional da empresa de eventos: categorias, equipamentos com quantidade total e status cadastral, associação planejada a orçamentos e **disponibilidade calculada dinamicamente** a partir dos períodos dos eventos.

- Persistência local: Drift/SQLite (`schemaVersion` **6**).
- Distinção do **Catálogo**: itens comerciais (preço/venda) ≠ ativos físicos de estoque.
- `QuoteEquipment` registra quantidade **planejada** — não reserva estoque nem altera `EquipmentStatus`.
- Disponibilidade (`EquipmentAvailability*`) **não é persistida** — é função de `totalQuantity` + linhas de orçamento + períodos.

Documento de task: `docs/tasks/TASK-028.md`.

---

## Modelagem

### `EquipmentStatus`

| Valor | Label | Papel |
|-------|-------|--------|
| `available` | Disponível | Estado operacional cadastral |
| `reserved` | Reservado | Estado operacional cadastral |
| `maintenance` | Manutenção | Estado operacional cadastral |
| `inactive` | Inativo | Estado operacional cadastral |

> **Importante:** `EquipmentStatus` é **manual/cadastral**. O cálculo de disponibilidade **não lê nem altera** este enum. Um equipamento em `maintenance` ainda pode aparecer no cálculo de pico de demanda se houver linhas de orçamento — a decisão operacional de usar o item permanece com o usuário.

### `EquipmentCategory`

| Campo | Regra |
|-------|--------|
| `name` | Obrigatório (validador) |
| `description` | Opcional |
| `active` | Default `true`; categoria inativa não pode receber novos equipamentos |
| Exclusão | Bloqueada se existir qualquer equipamento com aquele `categoryId` |

### `Equipment`

| Campo | Regra |
|-------|--------|
| `name` | Obrigatório |
| `description` | Texto (pode ser vazio) |
| `categoryId` | Obrigatório; categoria deve existir e estar **ativa** no create/update |
| `serialNumber` | Opcional |
| `totalQuantity` | Inteiro **> 0** — estoque físico total |
| `status` | Um de `EquipmentStatus` — cadastral |

### `QuoteEquipment`

| Campo | Regra |
|-------|--------|
| `quoteId` | Orçamento deve existir |
| `equipmentId` | Equipamento deve existir |
| `quantity` | Inteiro **> 0** |
| Persistência | Tabela `quote_equipment`; FK quote **CASCADE**; FK equipment **RESTRICT** |

Múltiplas linhas por orçamento são permitidas; o mesmo equipamento pode aparecer em vários orçamentos.

### `EquipmentAvailability` (computado)

| Campo | Significado |
|-------|-------------|
| `totalQuantity` | Cópia de `Equipment.totalQuantity` |
| `reservedQuantity` | Pico de demanda concorrente (sweep-line) |
| `availableQuantity` | `max(0, total − reserved)` |
| `level` | `fullyAvailable` / `partiallyAvailable` / `unavailable` |
| `consumingQuotes` | Orçamentos que consomem o item no cálculo |
| `conflicts` | Lista de `EquipmentReservationConflict` |

### `EquipmentAvailabilitySummary` (computado)

Contagens de equipamentos em cada `level` (totalmente / parcialmente / indisponíveis).

### `EquipmentReservationConflict` (computado)

| Campo | Significado |
|-------|-------------|
| `quoteId` | Orçamento em conflito |
| `equipmentId` | Equipamento |
| `requestedQuantity` | Quantidade pedida pela linha |
| `availableQuantity` | Restante considerando **outros** orçamentos sobrepostos |
| `periodStart` / `periodEnd` | Janela do evento do orçamento |

---

## Regras de categoria

1. Categoria **deve existir** no create/update do equipamento.
2. Categoria **deve estar ativa**.
3. Categoria **em uso** não pode ser excluída (resultado de domínio com contagem de equipamentos bloqueantes).
4. Nome validado por `EquipmentCategoryValidator`.

No banco: FK `equipment.category_id` → `equipment_categories` com `ON DELETE RESTRICT`.

---

## Regras de `EquipmentStatus`

1. Status é campo de cadastro editável na UI/serviço de equipamento.
2. Associação a orçamento (`QuoteEquipmentService`) **nunca** muda o status.
3. Calculadora de disponibilidade **ignora** o status ao somar demanda.
4. Não há transição automática (ex.: “ficar reserved quando um orçamento usa o item”).

---

## Integração com Orçamentos

- `QuoteEquipment` liga `Equipment.id` a `Quote.id` com quantidade planejada.
- Entrada na UI: detalhe do orçamento → “Equipamentos do evento” → `/quotes/:id/equipment`.
- Excluir o orçamento remove as linhas (`ON DELETE CASCADE`).
- Excluir equipamento com linhas existentes é bloqueado no banco (`RESTRICT`) — a exclusão pelo serviço de equipamento segue as regras de domínio já existentes.

---

## Disponibilidade calculada dinamicamente

### Princípios

1. **Não persistir** `availableQuantity`, `reservedQuantity` ou `remainingQuantity`.
2. **Não criar** tabelas/colunas de disponibilidade.
3. Recalcular sob demanda via `EquipmentAvailabilityService` / providers.
4. Períodos derivados de `Quote.eventSnapshot` (data civil + `startTime`/`endTime` opcionais).

### Orçamentos que consomem estoque

| Status | Consome? |
|--------|----------|
| `draft` | Sim |
| `sent` | Sim |
| `approved` | Sim |
| `rejected` | Não |
| `cancelled` | Não |

Orçamento **sem** `eventSnapshot.date` **não** consome disponibilidade.

### Algoritmo (`EquipmentAvailabilityCalculator`)

1. Para cada equipamento, coletar linhas `QuoteEquipment` cujo orçamento está em status consumidor e tem período resolvido.
2. Resolver período com `EquipmentEventPeriodResolver` (defaults `00:00`–`23:59`; virada de noite se `end <= start`).
3. Calcular **pico concorrente** (`reservedQuantity`) com sweep-line: eventos `+quantity` no início e `−quantity` no fim; no mesmo instante, liberações antes de aquisições (intervalos que apenas se tocam **não** sobrepõem).
4. `availableQuantity = max(0, totalQuantity − reservedQuantity)`.
5. Nível:
   - `fullyAvailable` se `reserved == 0`
   - `unavailable` se `reserved >= total`
   - `partiallyAvailable` caso contrário
6. Conflitos: para cada demanda, `availableForQuote = total − soma(outros sobrepostos)`; se `requested > availableForQuote`, emitir `EquipmentReservationConflict`.

### Resumo

`EquipmentAvailabilitySummary.fromItems` conta quantos equipamentos estão em cada nível.

---

## Persistência Drift

| Tabela | Conteúdo | Desde |
|--------|----------|-------|
| `equipment_categories` | Categorias de inventário | v5 |
| `equipment` | Equipamentos | v5 |
| `quote_equipment` | Vínculos orçamento ↔ equipamento | v6 |

### Migrações até `schemaVersion` 6

| Transição | Task / CP | O que faz |
|-----------|-----------|-----------|
| v1 → v2 | TASK-025 | `agenda_blocks` |
| v2 → v3 | TASK-027 CP-B | tabelas financeiras |
| v3 → v4 | TASK-027 CP-D | `quote_id` em `financial_entries` |
| v4 → v5 | TASK-028 CP-B | `equipment_categories` + `equipment` |
| v5 → v6 | TASK-028 CP-D | `quote_equipment` |

Índices em `quote_equipment`: `quote_id`, `equipment_id`.

---

## Camadas e responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| UI | Apresentação e feedback de Result Objects |
| Providers | Orquestração; sem regra de estoque |
| Services | Validação, create/update/delete, disponibilidade |
| Calculator | Pico, overlap, conflitos, resumo |
| Repository / DAO | Persistência apenas |

---

## Fora de escopo

- Reservas efetivas / bloqueio automático de quantidade
- Integração com Agenda (ocupação, recursos, conflitos de agenda)
- Gráficos e exportações
- QR Code / RFID
- Rastreamento em tempo real
- Manutenção preventiva
- Logística de retirada / devolução
- Hidratação do módulo no bootstrap

Evoluções futuras: `docs/roadmap.md`.
