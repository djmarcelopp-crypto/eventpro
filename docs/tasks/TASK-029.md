# TASK-029 — Equipe & Escalas

## Objetivo

Criar o módulo **Equipe & Escalas** do EventPro ERP: cadastro de funções (`TeamRole`) e colaboradores (`TeamMember`), vínculo planejado de equipe a orçamentos (`QuoteTeamMember`), UI de gestão e **disponibilidade calculada dinamicamente** a partir dos períodos dos eventos — sem persistir disponibilidade, sem alterar `TeamMemberStatus` automaticamente, sem check-in/out, folha, apontamento de horas ou agenda visual.

**Branch:** `cursor/task-029-equipe`

**Origem:** necessidade do MVP de controlar o roster operacional da empresa de eventos e planejar alocação por orçamento/evento, distinguindo o **estado cadastral do colaborador** (`TeamMemberStatus`) da **disponibilidade derivada** dos orçamentos consumidores.

## Arquitetura do fluxo

```text
UI (TeamScreen, detalhe, NewTeamMember, TeamRoles, QuoteTeamScreen)
      │
      ▼
Providers / Notifiers (Riverpod)
  teamMemberProvider / teamRoleProvider
  teamFiltersProvider → filteredTeamMembersProvider
  quoteTeamProvider (family por quoteId)
  teamAvailabilityProvider / teamAvailabilitySummaryProvider
      │
      ▼
Services (casos de uso — regras de negócio)
  TeamMemberService / TeamRoleService
  QuoteTeamService
  TeamAvailabilityService
      │
      ├─► Calculators / filtros / resolvers puros (sem I/O)
      │     TeamListFilter
      │     TeamEventPeriodResolver
      │     TeamAvailabilityCalculator
      │
      └─► Repositories (somente leitura/escrita)
            DriftTeamMemberRepository
            DriftTeamRoleRepository
            DriftQuoteTeamRepository
            (+ QuoteRepository para existência / períodos)
                  │
                  ▼
            DAOs → SQLite (schemaVersion 8)
```

- **Domínio puro (CP-A):** entidades, enums, validadores e contratos de repositório.
- **Persistência (CP-B / CP-D):** tabelas Drift, DAOs, mappers, migrações v6→v7 e v7→v8.
- **Serviços (CP-C / CP-D / CP-F):** regras fora de repositórios/DAOs; disponibilidade em calculadora testável.
- **Providers + UI (CP-E):** orquestração e apresentação — **nenhuma regra de escala na UI**.
- **Disponibilidade (CP-F):** computada em memória; **nunca** persistida como coluna/tabela.
- **Carregamento:** sob demanda via `AsyncNotifier` / `FutureProvider` — **não** hidratado no `appBootstrapProvider` nesta task.

## Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Fundação do domínio (entidades, enums, validadores, contratos) | `d3af1ba` | ✅ Concluído |
| B | Persistência Drift — roles/membros, migração v6→v7 | `28dccef` | ✅ Concluído |
| C | Casos de uso — TeamMemberService / TeamRoleService | `b7cee40` | ✅ Concluído |
| D | QuoteTeamMember + serviço + migração v7→v8 | `a1e16fd` | ✅ Concluído |
| E | UI, providers, dashboard e seção em orçamentos | `c80349c` | ✅ Concluído |
| F | Disponibilidade dinâmica (calculator + service + providers) | `564d196` | ✅ Concluído |
| G | Documentação final — este documento, `docs/business-rules/team.md`, revisão de `ARCHITECTURE.md`/`PROJECT.md`/`TASKS.md`/`docs/roadmap.md` | *(pendente de aprovação/commit)* | ✅ Concluído |

**TASK-029 encerrada.** Histórico completo dos checkpoints abaixo.

### Checkpoint A — Fundação do domínio ✅

- `TeamMember`, `TeamRole`, `TeamMemberStatus` (`active` / `unavailable` / `inactive`)
- Validadores e contratos `TeamMemberRepository` / `TeamRoleRepository`
- Sem Drift, providers ou UI

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com **1298** testes passando.

**Commit:** `d3af1ba` — `feat(team): create team members and roles domain foundation`

### Checkpoint B — Persistência Drift ✅

- Tabelas `team_roles` e `team_members`
- DAOs, mappers e `Drift*Repository`
- `schemaVersion` **6 → 7**; `onUpgrade` cria as tabelas de equipe

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com **1309** testes passando.

**Commit:** `28dccef` — `feat(team): persist team roles and members with Drift schema v7`

### Checkpoint C — Casos de uso ✅

- `TeamMemberService` / `TeamRoleService` com result objects
- Regras: função existe/ativa; exclusão de função bloqueada se em uso; nome de função único (case-insensitive); relógio injetável
- Schema, providers e UI **inalterados**

**Verificação:** `flutter analyze` sem erros/warnings (infos de estilo pré-existentes); `flutter test` com **1333** testes passando.

**Commit:** `b7cee40` — `feat(team): implement team member and role use cases`

### Checkpoint D — Integração com Orçamentos (`quote_team_members`) ✅

- Modelo `QuoteTeamMember` / `QuoteTeamSummary`
- Tabela `quote_team_members` (`schemaVersion` **7 → 8**)
- FKs: `quoteId` → `quotes` **CASCADE**; `teamMemberId` / `roleId` → roster **RESTRICT**
- `QuoteTeamService` (add / remove / list / summary) com snapshot de `roleId` e `dailyRate`
- **Não** calcula disponibilidade, **não** cria escala visual, **não** altera `TeamMemberStatus`

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com **1351** testes passando.

**Commit:** `a1e16fd` — `feat(team): link team members to quotes with Drift schema v8`

### Checkpoint E — UI e providers ✅

- Providers Riverpod (repos, services, clock, members/roles, filtros, quote team family)
- Telas: lista Equipe, detalhe, formulário, funções; `QuoteTeamScreen`; módulo no Dashboard
- Seção em detalhe do orçamento para gerenciar equipe do evento
- Schema **inalterado** (permanece v8)

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com **1367** testes passando.

**Commit:** `c80349c` — `feat(team): add team UI with providers, dashboard and quote section`

### Checkpoint F — Disponibilidade dinâmica ✅

- Modelos `TeamAvailability`, `TeamAvailabilitySummary`, `TeamScheduleConflict`, `TeamConsumingQuote`, `TeamEventPeriod`
- `TeamEventPeriodResolver` + `TeamAvailabilityCalculator` + `TeamAvailabilityService`
- Providers `teamAvailabilityProvider` / `teamAvailabilitySummaryProvider`
- Sem novas tabelas/colunas; sem mutation de `TeamMemberStatus`; sem agenda visual neste checkpoint

**Verificação:** `flutter analyze` sem erros/warnings (infos de estilo pré-existentes); `flutter test` com **1386** testes passando.

**Commit:** `564d196` — `feat(team): compute dynamic team availability from quote schedules`

### Checkpoint G — Documentação final ✅

- `docs/tasks/TASK-029.md` e `docs/business-rules/team.md` criados
- `ARCHITECTURE.md`, `PROJECT.md`, `TASKS.md` e `docs/roadmap.md` atualizados
- Nenhuma alteração em `lib/`, `test/`, schema, providers ou UI — checkpoint exclusivamente documental

**Verificação:** `flutter analyze` e `flutter test` com **1386** testes (suíte inalterada).

**Commit:** *(pendente de aprovação/commit)*

## Arquivos principais da task

```text
lib/features/team/
  models/          # TeamMember, TeamRole, Status, QuoteTeam*, Availability*
  data/
    mappers/
    repositories/  # interfaces + Drift*
  utils/           # validators, services, filters, calculators, period resolver
  providers/
  widgets/
  *_screen.dart

lib/core/database/
  tables.dart                    # TeamRoles, TeamMembers, QuoteTeamMembers
  app_database.dart              # schemaVersion 8, onUpgrade v6→v7 e v7→v8
  daos/team_*_dao.dart
  daos/quote_team_members_dao.dart

test/features/team/              # unitários, providers, widgets, fakes
test/core/database/
  team_migration_test.dart
  quote_team_migration_test.dart
  legacy_schema/legacy_*_v6|v7*
```

## Testes e verificação

| Checkpoint | Testes totais |
|---|---|
| CP-A | 1298 |
| CP-B | 1309 |
| CP-C | 1333 |
| CP-D | 1351 |
| CP-E | 1367 |
| CP-F | 1386 |
| CP-G | 1386 (inalterado — checkpoint documental) |

## Lições aprendidas

1. **`TeamMemberStatus` ≠ disponibilidade** — o status operacional cadastral permanece independente do cálculo de conflitos de escala (mesmo padrão de `EquipmentStatus` na TASK-028).
2. **Disponibilidade como função** evita colunas derivadas que ficariam stale; o resultado vive só em memória via calculator/service/providers.
3. **Snapshot em `QuoteTeamMember`** (`roleId`, `dailyRate`) protege o custo histórico do orçamento quando o roster muda depois.
4. **Capacidade 1 por colaborador** simplifica o overlap (pares de períodos) em relação ao pico concorrente de quantidades do estoque.
5. **Providers só orquestram** serviços; UI só apresenta Result Objects — padrão reforçado desde TASK-027/028.

## Fora de escopo (mantido)

- Check-in / check-out
- Apontamento de horas
- Folha de pagamento
- Permissões e autenticação
- Agenda visual de escalas
- Logística de equipes
- Comunicação interna da equipe
- Hidratação do módulo Equipe no bootstrap do app
- Alteração automática de `TeamMemberStatus` a partir de orçamentos
- Persistência da disponibilidade calculada

## Critérios de aceite (TASK-029)

- [x] Domínio, persistência (schema v8), serviços, UI e disponibilidade documentados
- [x] Integração Quote ↔ Team sem criar escala automática nem mutar status
- [x] Disponibilidade dinâmica sem persistir estado derivado
- [x] `TeamMemberStatus` independente da disponibilidade calculada
- [x] Suíte em **1386** testes no encerramento do CP-F/CP-G
- [x] Documentação oficial em `docs/tasks/` e `docs/business-rules/`
- [x] CP-G sem alteração de `lib/` nem `test/`

Regras detalhadas: `docs/business-rules/team.md`.
