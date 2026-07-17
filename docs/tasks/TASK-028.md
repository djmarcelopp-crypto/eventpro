# TASK-028 — Estoque & Equipamentos

## Objetivo

Criar o módulo **Estoque & Equipamentos** do EventPro ERP: inventário operacional (categorias e equipamentos), vínculo planejado de quantidades a orçamentos (`QuoteEquipment`), UI de gestão e **disponibilidade calculada dinamicamente** a partir do estoque e dos períodos dos eventos — sem persistir quantidades disponíveis, sem alterar `EquipmentStatus` automaticamente, sem reservas efetivas e sem integrar Agenda.

**Branch:** `cursor/task-028-estoque`

**Origem:** necessidade do MVP de controlar o inventário físico da empresa de eventos e planejar uso por orçamento/evento, distinguindo o **Catálogo comercial** (itens vendáveis) do **Estoque operacional** (ativos físicos com quantidade e status).

## Arquitetura do fluxo

```text
UI (EquipmentScreen, detalhe, categorias, NewEquipment, QuoteEquipmentScreen)
      │
      ▼
Providers / Notifiers (Riverpod)
  equipmentProvider / equipmentCategoryProvider
  equipmentFiltersProvider → filteredEquipmentProvider
  quoteEquipmentProvider (family por quoteId)
  equipmentAvailabilityProvider / equipmentAvailabilitySummaryProvider
      │
      ▼
Services (casos de uso — regras de negócio)
  EquipmentService / EquipmentCategoryService
  QuoteEquipmentService
  EquipmentAvailabilityService
      │
      ├─► Calculators / filtros puros (sem I/O)
      │     EquipmentListFilter
      │     EquipmentEventPeriodResolver
      │     EquipmentAvailabilityCalculator
      │
      └─► Repositories (somente leitura/escrita)
            DriftEquipmentRepository
            DriftEquipmentCategoryRepository
            DriftQuoteEquipmentRepository
            (+ QuoteRepository para existência / períodos)
                  │
                  ▼
            DAOs → SQLite (schemaVersion 6)
```

- **Domínio puro (CP-A):** entidades, enums, validadores e contratos de repositório.
- **Persistência (CP-B / CP-D):** tabelas Drift, DAOs, mappers, migrações v4→v5 e v5→v6.
- **Serviços (CP-C / CP-D / CP-F):** regras fora de repositórios/DAOs; disponibilidade em calculadora testável.
- **Providers + UI (CP-E):** orquestração e apresentação — **nenhuma regra de estoque na UI**.
- **Disponibilidade (CP-F):** computada em memória; **nunca** persistida como coluna.
- **Carregamento:** sob demanda via `AsyncNotifier` / `FutureProvider` — **não** hidratado no `appBootstrapProvider` nesta task.

## Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Fundação do domínio (entidades, enums, validadores, contratos) | `0efc7b1` | ✅ Concluído |
| B | Persistência Drift — categorias/equipamentos, migração v4→v5 | `5f22264` | ✅ Concluído |
| C | Casos de uso — EquipmentService / EquipmentCategoryService | `d94aeef` | ✅ Concluído |
| D | QuoteEquipment + serviço + migração v5→v6 | `76a14ba` | ✅ Concluído |
| E | UI, providers, filtros e associação a orçamentos | `e4328f8` | ✅ Concluído |
| F | Disponibilidade dinâmica (calculator + service + providers) | `cebe010` | ✅ Concluído |
| G | Documentação final — este documento, `docs/business-rules/equipment.md`, revisão de `ARCHITECTURE.md`/`PROJECT.md`/`TASKS.md`/`docs/roadmap.md` | *(pendente de aprovação/commit)* | ✅ Concluído |

**TASK-028 encerrada.** Histórico completo dos checkpoints abaixo.

### Checkpoint A — Fundação do domínio ✅

- `Equipment`, `EquipmentCategory`, `EquipmentStatus` (`available` / `reserved` / `maintenance` / `inactive`)
- Validadores e contratos `EquipmentRepository` / `EquipmentCategoryRepository`
- Sem Drift, providers ou UI

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com **1188** testes passando.

**Commit:** `0efc7b1` — `feat(equipment): create inventory equipment domain foundation`

### Checkpoint B — Persistência Drift ✅

- Tabelas `equipment_categories` e `equipment`
- DAOs, mappers e `Drift*Repository`
- `schemaVersion` **4 → 5**; `onUpgrade` cria as tabelas de inventário

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com **1202** testes passando.

**Commit:** `5f22264` — `feat(equipment): persist equipment categories and items with Drift`

### Checkpoint C — Casos de uso ✅

- `EquipmentService` / `EquipmentCategoryService` com result objects
- Regras: categoria existe/ativa; exclusão de categoria bloqueada se em uso; relógio injetável
- Schema, providers e UI **inalterados**

**Verificação:** `flutter analyze` sem erros/warnings (infos de estilo); `flutter test` com **1224** testes passando.

**Commit:** `d94aeef` — `feat(equipment): implement equipment and category use cases`

### Checkpoint D — Integração com Orçamentos (`quote_equipment`) ✅

- Modelo `QuoteEquipment` / `QuoteEquipmentSummary`
- Tabela `quote_equipment` (`schemaVersion` **5 → 6**)
- FKs: `quoteId` → `quotes` **CASCADE**; `equipmentId` → `equipment` **RESTRICT**
- `QuoteEquipmentService` (add / updateQuantity / remove / list / summary)
- **Não** calcula disponibilidade, **não** reserva estoque, **não** altera `EquipmentStatus`

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com **1241** testes passando.

**Commit:** `76a14ba` — `feat(equipment): link equipment quantities to quotes without stock reservation`

### Checkpoint E — UI e providers ✅

- Providers Riverpod (repos, services, clock, equipment/categories, filtros, quote equipment family)
- Telas: lista Estoque, detalhe, formulário, categorias; `QuoteEquipmentScreen`; módulo no Dashboard
- Seção em detalhe do orçamento para gerenciar equipamentos
- Schema **inalterado** (permanece v6)

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com **1259** testes passando.

**Commit:** `e4328f8` — `feat(equipment): add inventory UI with providers and quote association`

### Checkpoint F — Disponibilidade dinâmica ✅

- Modelos `EquipmentAvailability`, `EquipmentAvailabilitySummary`, `EquipmentReservationConflict`
- `EquipmentEventPeriodResolver` + `EquipmentAvailabilityCalculator` + `EquipmentAvailabilityService`
- Providers `equipmentAvailabilityProvider` / `equipmentAvailabilitySummaryProvider`
- Sem novas tabelas/colunas; sem mutation de `EquipmentStatus`; sem UI neste checkpoint

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com **1275** testes passando.

**Commit:** `cebe010` — `feat(equipment): compute dynamic quote equipment availability without persistence`

### Checkpoint G — Documentação final ✅

- `docs/tasks/TASK-028.md` e `docs/business-rules/equipment.md` criados
- `ARCHITECTURE.md`, `PROJECT.md`, `TASKS.md` e `docs/roadmap.md` atualizados
- Nenhuma alteração em `lib/`, `test/`, schema, providers ou UI — checkpoint exclusivamente documental

**Verificação:** `flutter analyze` e `flutter test` com **1275** testes (suíte inalterada).

**Commit:** *(pendente de aprovação/commit)*

## Arquivos principais da task

```text
lib/features/equipment/
  models/          # Equipment, Category, Status, QuoteEquipment, Availability*
  data/
    mappers/
    repositories/  # interfaces + Drift*
  utils/           # validators, services, filters, calculators, period resolver
  providers/
  widgets/
  *_screen.dart

lib/core/database/
  tables.dart                    # Equipments, EquipmentCategories, QuoteEquipmentItems
  app_database.dart              # schemaVersion 6, onUpgrade v4→v5 e v5→v6
  daos/equipment*_dao.dart
  daos/quote_equipment_dao.dart

test/features/equipment/         # unitários, providers, widgets, fakes
test/core/database/
  equipment_migration_test.dart
  quote_equipment_migration_test.dart
  legacy_schema/legacy_*_v4|v5*
```

## Testes e verificação

| Checkpoint | Testes totais |
|---|---|
| CP-A | 1188 |
| CP-B | 1202 |
| CP-C | 1224 |
| CP-D | 1241 |
| CP-E | 1259 |
| CP-F | 1275 |
| CP-G | 1275 (inalterado — checkpoint documental) |

## Lições aprendidas

1. **Separar Catálogo de Estoque** evita misturar preço comercial com inventário físico; o vínculo com orçamento é planejado (`QuoteEquipment`), não uma linha de catálogo.
2. **Disponibilidade como função** (igual `AgendaOccupancy` / resumos financeiros) evita colunas derivadas (`availableQuantity`, etc.) que ficariam stale.
3. **`EquipmentStatus` cadastral ≠ disponibilidade** — status operacional manual permanece independente do cálculo de pico de demanda.
4. **Período civil local** no módulo de equipamentos (sem acoplar Agenda) mantém a regra de overlap testável e evita “integrar Agenda” no inventário.
5. **Providers só orquestram** serviços; UI só apresenta Result Objects — padrão reforçado desde TASK-027.

## Fora de escopo (mantido)

- Reservas efetivas / bloqueio automático de estoque
- Integração com Agenda (ocupação, conflitos de agenda, recursos)
- Gráficos e exportações
- Leitura por QR Code / RFID
- Rastreamento em tempo real
- Manutenção preventiva
- Logística de retirada / devolução
- Hidratação do Estoque no bootstrap do app

## Critérios de aceite (TASK-028)

- [x] Domínio, persistência (schema v6), serviços, UI e disponibilidade documentados
- [x] Integração Quote ↔ Equipment sem reserva automática
- [x] Disponibilidade dinâmica sem persistir quantidades derivadas
- [x] `EquipmentStatus` independente da disponibilidade
- [x] Suíte em **1275** testes no encerramento do CP-F/CP-G
- [x] Documentação oficial em `docs/tasks/` e `docs/business-rules/`
- [x] CP-G sem alteração de `lib/` nem `test/`

Regras detalhadas: `docs/business-rules/equipment.md`.
