# TASK-030 — Logística & Transporte

## Objetivo

Criar o módulo **Logística & Transporte** do EventPro ERP: cadastro de tipos (`VehicleType`) e veículos (`Vehicle`), vínculo planejado de frota a orçamentos (`QuoteVehicle`), UI de gestão e **disponibilidade logística calculada dinamicamente** a partir dos períodos planejados (ou do evento) — sem persistir disponibilidade, sem alterar `VehicleStatus` automaticamente, sem GPS, rotas externas, mapas, telemetria, abastecimento, manutenção preventiva ou check-in/out.

**Branch:** `cursor/task-030-logistica`

**Origem:** necessidade do MVP de controlar a frota operacional e planejar transporte por orçamento/evento, distinguindo o **estado operacional cadastral** (`VehicleStatus`) da **disponibilidade temporal derivada** dos orçamentos consumidores.

## Arquitetura do fluxo

```text
UI (VehiclesScreen, detalhe, NewVehicle, VehicleTypes, QuoteVehiclesScreen)
      │
      ▼
Providers / Notifiers (Riverpod)
  vehicleProvider / vehicleTypeProvider
  vehicleFiltersProvider → filteredVehiclesProvider
  quoteVehicleProvider (family por quoteId)
  vehicleAvailabilityProvider / logisticsPlanSummaryProvider
      │
      ▼
Services (casos de uso — regras de negócio)
  VehicleService / VehicleTypeService
  QuoteVehicleService
  VehicleAvailabilityService
      │
      ├─► Calculators / filtros / resolvers puros (sem I/O)
      │     VehicleListFilter
      │     VehicleEventPeriodResolver
      │     VehicleAvailabilityCalculator
      │
      └─► Repositories (somente leitura/escrita)
            DriftVehicleRepository
            DriftVehicleTypeRepository
            DriftQuoteVehicleRepository
            (+ QuoteRepository / TeamMemberRepository para existência)
                  │
                  ▼
            DAOs → SQLite (schemaVersion 10)
```

- **Domínio puro (CP-A):** entidades, enums, validadores e contratos de repositório.
- **Persistência (CP-B / CP-D):** tabelas Drift, DAOs, mappers, migrações v8→v9 e v9→v10.
- **Serviços (CP-C / CP-D / CP-F):** regras fora de repositórios/DAOs; disponibilidade em calculadora testável.
- **Providers + UI (CP-E):** orquestração e apresentação — **nenhuma regra logística na UI**.
- **Disponibilidade (CP-F):** computada em memória; **nunca** persistida como coluna/tabela.
- **Carregamento:** sob demanda via `AsyncNotifier` / `FutureProvider` — **não** hidratado no `appBootstrapProvider` nesta task.

## Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Fundação do domínio (entidades, enums, validadores, contratos) | *(pendente)* | ✅ Concluído |
| B | Persistência Drift — tipos/veículos, migração v8→v9 | *(pendente)* | ✅ Concluído |
| C | Casos de uso — VehicleService / VehicleTypeService | *(pendente)* | ✅ Concluído |
| D | QuoteVehicle + serviço + migração v9→v10 | *(pendente)* | ✅ Concluído |
| E | UI, providers, dashboard e seção em orçamentos | *(pendente)* | ✅ Concluído |
| F | Disponibilidade logística dinâmica (calculator + service + providers) | *(pendente)* | ✅ Concluído |
| G | Documentação final — este documento, `docs/business-rules/logistics.md`, revisão de `ARCHITECTURE.md`/`PROJECT.md`/`TASKS.md`/`docs/roadmap.md` | *(pendente)* | ✅ Concluído |

**TASK-030 implementada nesta branch.** Commits aguardam aprovação do PO/CTO (trabalho ainda não versionado).

### Checkpoint A — Fundação do domínio ✅

- `Vehicle`, `VehicleType` (+ timestamps), `VehicleStatus` (`available` / `maintenance` / `unavailable` / `inactive`)
- Validadores e contratos `VehicleRepository` / `VehicleTypeRepository`
- Capacidades como `double`; unicidade de placa deferida ao Service
- Sem Drift, providers ou UI

**Verificação:** `flutter analyze` (infos pré-existentes); `flutter test` com **1412** testes passando.

### Checkpoint B — Persistência Drift ✅

- Tabelas `vehicle_types` e `vehicles`
- DAOs, mappers e `Drift*Repository`
- `schemaVersion` **8 → 9**; FK tipo **RESTRICT** / **CASCADE** update
- Snapshot legado v8

**Verificação:** `flutter test` com **1418** testes passando.

### Checkpoint C — Casos de uso ✅

- `VehicleService` / `VehicleTypeService` com result objects
- Placa normalizada (`trim` + `toUpperCase`); única case-insensitive
- Tipo deve existir e estar ativo; exclusão de tipo bloqueada se em uso
- Relógio injetável

**Verificação:** `flutter test` com **1433** testes passando.

### Checkpoint D — Integração com Orçamentos (`quote_vehicles`) ✅

- Modelo `QuoteVehicle` / `QuoteVehicleSummary`
- Tabela `quote_vehicles` (`schemaVersion` **9 → 10**)
- FKs: quote **CASCADE**; vehicle / driver **RESTRICT**
- `QuoteVehicleService`: veículo operacionalmente `available`; motorista opcional ativo; sem duplicata; frete ≥ 0; retorno ≥ saída
- **Não** calcula conflitos neste checkpoint

**Verificação:** `flutter test` com **1439** testes passando.

### Checkpoint E — UI e providers ✅

- Providers Riverpod (repos, services, clock, vehicles/types, filtros, quote vehicle family)
- Telas: lista Logística, detalhe, formulário, tipos; `QuoteVehiclesScreen`; módulo e resumo no Dashboard
- Seção em detalhe do orçamento; saída/retorno planejados e custo de frete no vínculo
- Schema **inalterado** (permanece v10)
- Dashboard: atalhos de módulos **antes** dos resumos (Equipe/Logística) para manter navegação acessível em viewports curtas

**Verificação:** `flutter test` com **1450** testes passando.

### Checkpoint F — Planejamento logístico (disponibilidade) ✅

- Modelos `VehicleAvailability`, `VehicleAvailabilitySummary`, `VehicleScheduleConflict`, `VehicleConsumingQuote`, `VehicleEventPeriod`, `LogisticsPlanSummary`
- `VehicleEventPeriodResolver` + `VehicleAvailabilityCalculator` + `VehicleAvailabilityService`
- Providers `vehicleAvailabilityProvider` / `vehicleAvailabilitySummaryProvider` / `logisticsPlanSummaryProvider`
- Período: plannedDeparture+Return quando ambos existem; senão período do evento; ignora se irresolvível
- Combina elegibilidade operacional (`VehicleStatus.available`) com vínculos/sobreposições
- Sem novas tabelas; sem mutation de `VehicleStatus`

**Verificação:** `flutter test` com **1468** testes passando.

### Checkpoint G — Documentação final ✅

- `docs/tasks/TASK-030.md` e `docs/business-rules/logistics.md` criados
- `ARCHITECTURE.md`, `PROJECT.md`, `TASKS.md` e `docs/roadmap.md` atualizados
- Nenhuma alteração em `lib/` / `test/` neste checkpoint — exclusivamente documental

**Verificação:** `flutter analyze` e `flutter test` com **1468** testes (suíte inalterada).

## Arquivos principais da task

```text
lib/features/logistics/
  models/          # Vehicle, VehicleType, Status, QuoteVehicle*, Availability*
  data/
    mappers/
    repositories/  # interfaces + Drift*
  utils/           # validators, services, filters, calculators, period resolver
  providers/
  widgets/
  *_screen.dart

lib/core/database/
  tables.dart                    # VehicleTypes, Vehicles, QuoteVehicles
  app_database.dart              # schemaVersion 10, onUpgrade v8→v9 e v9→v10
  daos/vehicle_*_dao.dart
  daos/quote_vehicles_dao.dart

test/features/logistics/         # unitários, providers, widgets, fakes
test/core/database/
  vehicle_migration_test.dart
  quote_vehicle_migration_test.dart
  legacy_schema/legacy_*_v8|v9*
```

## Testes e verificação

| Checkpoint | Testes totais |
|---|---|
| CP-A | 1412 |
| CP-B | 1418 |
| CP-C | 1433 |
| CP-D | 1439 |
| CP-E | 1450 |
| CP-F | 1468 |
| CP-G | 1468 (inalterado — checkpoint documental) |

## Lições aprendidas

1. **`VehicleStatus` ≠ disponibilidade temporal** — o status operacional cadastral é combinado no cálculo (elegibilidade), mas **nunca** é mutado automaticamente pelos orçamentos.
2. **Período logístico tem prioridade** — `plannedDepartureAt`/`plannedReturnAt` quando ambos existem; fallback ao período do evento (mesmo padrão civil-date de equipe/estoque).
3. **Capacidade 1 por veículo** — overlap por pares de períodos (como equipe), não pico de quantidade (estoque).
4. **Dashboard: módulos primeiro** — resumos densos abaixo dos atalhos evitam regressão de hit-test em viewports de teste (800×600).
5. **Providers só orquestram** serviços; UI só apresenta Result Objects.

## Fora de escopo (mantido)

- GPS / rastreamento em tempo real
- Cálculo de rotas externo / mapas
- Telemetria / abastecimento
- Manutenção preventiva
- Check-in / check-out
- Baixa automática de estoque
- Confirmação de motorista
- Hidratação do módulo Logística no bootstrap do app
- Alteração automática de `VehicleStatus` a partir de orçamentos
- Persistência da disponibilidade calculada
- UI dedicada de conflitos (cálculo existe em domínio/providers)

## Critérios de aceite (TASK-030)

- [x] Domínio, persistência (schema v10), serviços, UI e disponibilidade documentados
- [x] Disponibilidade nunca persistida; `VehicleStatus` não mutado automaticamente
- [x] Vínculo a orçamentos com motorista opcional, frete e períodos planejados
- [x] Testes passando em cada checkpoint; documentação alinhada à arquitetura
