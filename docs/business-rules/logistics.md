# Regras de negócio — Logística & Transporte

## Visão geral

O módulo **Logística & Transporte** gerencia a frota operacional: tipos de veículo, veículos com status cadastral e capacidades, associação planejada a orçamentos e **disponibilidade logística calculada dinamicamente** a partir dos períodos planejados (ou do evento).

- Persistência local: Drift/SQLite (`schemaVersion` **10**).
- `QuoteVehicle` registra alocação **planejada** (motorista opcional, frete, saída/retorno) — não cria GPS, rotas nem altera `VehicleStatus`.
- Disponibilidade (`VehicleAvailability*` / `LogisticsPlanSummary`) **não é persistida** — é função dos vínculos + períodos dos orçamentos consumidores + elegibilidade operacional.

Documento de task: `docs/tasks/TASK-030.md`.

---

## Modelagem

### `VehicleStatus`

| Valor | Label | Papel |
|-------|-------|--------|
| `available` | Disponível | Estado operacional cadastral — **elegível** para vínculo e para disponibilidade temporal livre |
| `maintenance` | Manutenção | Estado operacional cadastral |
| `unavailable` | Indisponível | Estado operacional cadastral |
| `inactive` | Inativo | Estado operacional cadastral |

> **Importante:** `VehicleStatus` é **manual/cadastral**. O cálculo de disponibilidade **não altera** este enum. Para o cálculo temporal, somente `available` é operacionalmente elegível; demais statuses tornam o veículo temporalmente `unavailable` mesmo sem vínculos.

### `VehicleType`

| Campo | Regra |
|-------|--------|
| `name` | Obrigatório; único case-insensitive entre tipos |
| `description` | Opcional |
| `active` | Default `true`; tipo inativo não pode receber novos veículos |
| Exclusão | Bloqueada se existir qualquer veículo com aquele `vehicleTypeId` |

### `Vehicle`

| Campo | Regra |
|-------|--------|
| `plate` | Obrigatória; normalizada (`trim` + `toUpperCase`); única case-insensitive (Service) |
| `description` / `observations` | Texto (podem ser vazios) |
| `vehicleTypeId` | Obrigatório; tipo deve existir e estar **ativo** no create/update |
| `payloadCapacityKg` / `volumeCapacityM3` | `double` **≥ 0** |
| `status` | Um de `VehicleStatus` — cadastral |

### `QuoteVehicle`

| Campo | Regra |
|-------|--------|
| `quoteId` | Orçamento deve existir |
| `vehicleId` | Veículo deve existir e estar **`available`** no add |
| `driverTeamMemberId` | Opcional; se informado, colaborador deve existir e estar **ativo** |
| `plannedDepartureAt` / `plannedReturnAt` | Opcionais; se ambos informados, retorno não pode ser anterior à saída |
| `freightCostCents` | Inteiro **≥ 0** |
| `notes` | Opcional |
| Persistência | Tabela `quote_vehicles`; FK quote **CASCADE**; FK vehicle/driver **RESTRICT** |
| Unicidade | Mesmo veículo **não** pode ser vinculado duas vezes ao mesmo orçamento |

### Período logístico (`VehicleEventPeriod` — computado)

Ordem de resolução (`VehicleEventPeriodResolver`):

1. Usar `plannedDepartureAt` e `plannedReturnAt` quando **ambos** existem e retorno é **posterior** à saída.
2. Caso contrário, usar o período do evento (`Quote.eventSnapshot`) com as mesmas regras civil-date de equipe/estoque.
3. Se apenas um dos timestamps planejados existir, **não inventar** o outro — cair no fallback do evento.
4. Se nenhum período válido for resolvível, o vínculo **é ignorado** no cálculo de disponibilidade.

### `VehicleConsumingQuote` / `VehicleScheduleConflict` / `VehicleAvailability` (computados)

| Conceito | Significado |
|----------|-------------|
| Consuming quote | Orçamento `draft` / `sent` / `approved` com período resolvível vinculado ao veículo |
| Conflito | Dois períodos do mesmo veículo com `startA < endB && startB < endA` (extremos tocantes **não** conflitam) |
| Disponibilidade temporal `available` | Operacionalmente elegível **e** sem demanda relevante no escopo |
| Disponibilidade temporal `unavailable` | Não elegível operacionalmente e/ou ocupado por demanda |

Ignorados no cálculo: `cancelled`, `rejected`, orçamentos sem período resolvível.

### `VehicleAvailabilitySummary` / `LogisticsPlanSummary`

| Campo | Significado |
|-------|-------------|
| `availableCount` / `unavailableCount` | Contagens temporais |
| `conflictCount` | Soma de conflitos |
| `availabilityPercent` | `(availableCount / total) * 100` |
| `maintenanceCount` | Veículos com `VehicleStatus.maintenance` (operacional) |
| `plannedFreightCostCents` | Soma dos fretes de vínculos cujo orçamento é consumidor |

---

## Regras de serviço (resumo)

- Placa e nome de tipo únicos (case-insensitive) após normalização.
- Tipo inativo / inexistente bloqueia create/update de veículo.
- Exclusão de tipo bloqueada se em uso.
- Associação a orçamento exige veículo `available` e motorista ativo (quando informado).
- Disponibilidade **nunca** é escrita no banco; `VehicleStatus` **nunca** é alterado pelo cálculo.

---

## Fora de escopo

GPS, rotas, mapas, telemetria, abastecimento, manutenção preventiva, check-in/out, baixa automática de estoque, confirmação de motorista, bootstrap do módulo, UI dedicada de conflitos.
