# Regras de negócio — Equipe & Escalas

## Visão geral

O módulo **Equipe & Escalas** gerencia o roster operacional da empresa de eventos: funções, colaboradores com status cadastral e diária, associação planejada a orçamentos e **disponibilidade calculada dinamicamente** a partir dos períodos dos eventos.

- Persistência local: Drift/SQLite (`schemaVersion` **8**).
- `QuoteTeamMember` registra alocação **planejada** com snapshot de função e diária — não cria check-in, folha nem altera `TeamMemberStatus`.
- Disponibilidade (`TeamAvailability*`) **não é persistida** — é função dos vínculos + períodos dos orçamentos consumidores.

Documento de task: `docs/tasks/TASK-029.md`.

---

## Modelagem

### `TeamMemberStatus`

| Valor | Label | Papel |
|-------|-------|--------|
| `active` | Ativo | Estado operacional cadastral |
| `unavailable` | Indisponível | Estado operacional cadastral |
| `inactive` | Inativo | Estado operacional cadastral |

> **Importante:** `TeamMemberStatus` é **manual/cadastral**. O cálculo de disponibilidade de escala **não lê nem altera** este enum (exceto a regra de associação a orçamento, que exige `active` no momento do vínculo). Um colaborador `inactive` ainda pode aparecer como `available`/`unavailable` no cálculo se houver vínculos históricos — a decisão operacional permanece com o usuário.

### `TeamRole`

| Campo | Regra |
|-------|--------|
| `name` | Obrigatório; único case-insensitive entre funções |
| `description` | Opcional |
| `active` | Default `true`; função inativa não pode receber novos colaboradores nem novos vínculos a orçamento |
| Exclusão | Bloqueada se existir qualquer colaborador com aquele `roleId` |

### `TeamMember`

| Campo | Regra |
|-------|--------|
| `name` | Obrigatório |
| `phone` | Obrigatório |
| `email` | Opcional |
| `roleId` | Obrigatório; função deve existir e estar **ativa** no create/update |
| `dailyRate` | Inteiro **≥ 0** (centavos) |
| `observations` | Texto (pode ser vazio) |
| `status` | Um de `TeamMemberStatus` — cadastral |

### `QuoteTeamMember`

| Campo | Regra |
|-------|--------|
| `quoteId` | Orçamento deve existir |
| `teamMemberId` | Colaborador deve existir e estar **`active`** no add |
| `roleId` | Snapshot da função do colaborador no momento do vínculo; função deve estar ativa |
| `dailyRate` | Snapshot da diária (centavos) no momento do vínculo |
| `notes` | Opcional |
| Persistência | Tabela `quote_team_members`; FK quote **CASCADE**; FK member/role **RESTRICT** |
| Unicidade | Mesmo colaborador **não** pode ser vinculado duas vezes ao mesmo orçamento |

### `TeamEventPeriod` (computado)

Intervalo `[start, end)` derivado de `Quote.eventSnapshot` (data civil + horários opcionais).

### `TeamConsumingQuote` (DTO computado)

| Campo | Significado |
|-------|-------------|
| `quoteId` | Orçamento consumidor |
| `quoteNumber` | Número do orçamento (quando disponível) |
| `eventName` | Nome do evento (quando disponível) |
| `eventPeriod` | Período resolvido |

### `TeamScheduleConflict` (computado)

| Campo | Significado |
|-------|-------------|
| `teamMemberId` | Colaborador em conflito |
| `quoteId` | Orçamento envolvido |
| `eventPeriod` | Período do evento |
| `reason` | Motivo textual (sobreposição parcial ou total) |

### `TeamAvailability` (computado)

| Campo | Significado |
|-------|-------------|
| `teamMemberId` | Colaborador |
| `status` | `available` / `unavailable` (disponibilidade de escala — **não** é `TeamMemberStatus`) |
| `consumingQuotes` | Orçamentos que ocupam o colaborador no cálculo |
| `conflicts` | Lista de `TeamScheduleConflict` |

### `TeamAvailabilitySummary` (computado)

| Campo | Significado |
|-------|-------------|
| `totalMembers` | Total de colaboradores no escopo |
| `availableCount` | Quantidade disponíveis |
| `unavailableCount` | Quantidade indisponíveis |
| `conflictCount` | Soma de conflitos |
| `availabilityPercent` | `(availableCount / totalMembers) * 100` (0 se vazio) |

---

## Regras de funções

1. Nome obrigatório e **único** (comparação case-insensitive).
2. Função **deve existir** e estar **ativa** no create/update do colaborador.
3. Função **em uso** não pode ser excluída (result object com contagem de colaboradores bloqueantes).
4. Ativar/desativar preserva `createdAt` e atualiza `updatedAt` via relógio injetável.
5. No banco: FK `team_members.role_id` → `team_roles` com `ON DELETE RESTRICT`.

---

## Regras de colaboradores

1. Campos validados por `TeamMemberValidator` (nome, telefone, diária ≥ 0, etc.).
2. `roleId` deve apontar para função existente e ativa.
3. `TeamMemberStatus` é editável no cadastro; **não** é alterado por `QuoteTeamService` nem pela calculadora de disponibilidade.
4. Exclusão do colaborador pode falhar no banco se houver linhas em `quote_team_members` (`ON DELETE RESTRICT`).

---

## Distinção: `TeamMemberStatus` × disponibilidade calculada

| Conceito | Onde vive | Quem altera | Uso |
|----------|-----------|-------------|-----|
| `TeamMemberStatus` | Coluna persistida em `team_members` | Usuário / `TeamMemberService` | Roster operacional (ativo / indisponível / inativo) |
| `TeamAvailabilityStatus` | Memória (`TeamAvailability`) | Calculadora em runtime | Escala derivada de orçamentos |

Não há transição automática do tipo “ficar `unavailable` porque há um orçamento no mesmo dia”.

---

## Integração com Orçamentos

- `QuoteTeamMember` liga `TeamMember.id` a `Quote.id` com snapshots de função e diária.
- Entrada na UI: detalhe do orçamento → equipe do evento → `/quotes/:id/team`.
- Excluir o orçamento remove as linhas (`ON DELETE CASCADE`).
- Excluir colaborador/função com vínculos existentes é bloqueado no banco (`RESTRICT`).
- `QuoteTeamService.add` exige colaborador `active` e função ativa; bloqueia duplicata no mesmo orçamento.
- Associação **não** cria agenda, check-in, folha nem muda status do roster.

---

## Disponibilidade calculada dinamicamente

### Princípios

1. **Não persistir** disponibilidade, conflitos ou percentual.
2. **Não criar** tabelas/colunas de disponibilidade.
3. Recalcular sob demanda via `TeamAvailabilityService` / providers.
4. Períodos derivados de `Quote.eventSnapshot` via `TeamEventPeriodResolver`.
5. Capacidade implícita = **1** por colaborador (presença no orçamento ocupa o período inteiro).

### Orçamentos que consomem disponibilidade

| Status | Consome? |
|--------|----------|
| `draft` | Sim |
| `sent` | Sim |
| `approved` | Sim |
| `rejected` | Não |
| `cancelled` | Não |

Orçamento **sem** `eventSnapshot.date` **não** consome disponibilidade.

### Algoritmo (`TeamAvailabilityCalculator`)

1. Para cada colaborador, coletar linhas `QuoteTeamMember` cujo orçamento está em status consumidor e tem período resolvido.
2. Resolver período com `TeamEventPeriodResolver` (defaults de dia inteiro quando horários faltam; virada de noite se `end <= start`).
3. Montar `TeamConsumingQuote` por atribuição.
4. Detectar conflitos por **pares** de períodos: overlap se `startA < endB && startB < endA` (intervalos semiabertos — extremos que apenas se tocam **não** conflitam).
5. Motivo do conflito:
   - **total** se um período contém o outro (ou são iguais);
   - **parcial** caso contrário.
6. Disponibilidade no escopo:
   - sem `queryPeriod`: `unavailable` se houver qualquer atribuição consumidora; senão `available`;
   - com `queryPeriod`: `unavailable` se alguma atribuição sobrepõe o período consultado.
7. `TeamMemberStatus` **não** entra no passo de status de disponibilidade.

### Resumo

`TeamAvailabilitySummary.fromItems` agrega totais, conflitos e percentual de disponibilidade.

---

## Persistência Drift

| Tabela | Conteúdo | Desde |
|--------|----------|-------|
| `team_roles` | Funções | v7 |
| `team_members` | Colaboradores | v7 |
| `quote_team_members` | Vínculos orçamento ↔ equipe | v8 |

### Migrações até `schemaVersion` 8

| Transição | Task / CP | O que faz |
|-----------|-----------|-----------|
| v1 → v2 | TASK-025 | `agenda_blocks` |
| v2 → v3 | TASK-027 CP-B | tabelas financeiras |
| v3 → v4 | TASK-027 CP-D | `quote_id` em `financial_entries` |
| v4 → v5 | TASK-028 CP-B | `equipment_categories` + `equipment` |
| v5 → v6 | TASK-028 CP-D | `quote_equipment` |
| v6 → v7 | TASK-029 CP-B | `team_roles` + `team_members` |
| v7 → v8 | TASK-029 CP-D | `quote_team_members` |

Índices relevantes: `team_members.role_id`, `team_members.status`; índices de `quote_team_members` por `quote_id` / `team_member_id` conforme schema.

---

## Camadas e responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| UI | Apresentação e feedback de Result Objects |
| Providers | Orquestração; sem regra de escala |
| Services | Validação, create/update/delete, vínculos, disponibilidade |
| Calculator | Overlap, conflitos, resumo |
| Repository / DAO | Persistência apenas |

---

## Fora de escopo

- Check-in / check-out
- Apontamento de horas
- Folha de pagamento
- Permissões
- Autenticação
- Agenda visual de escalas
- Logística de equipes
- Comunicação interna da equipe
- Hidratação do módulo no bootstrap
- Mutação automática de `TeamMemberStatus`
- Persistência da disponibilidade calculada

---

## Referências

- Task: `docs/tasks/TASK-029.md`
- Arquitetura: `ARCHITECTURE.md` (feature `team/`, schema v8)
- Padrão análogo: `docs/business-rules/equipment.md` (TASK-028)
