# TASKS — EventPro ERP

Registro da task ativa. Tasks concluídas permanecem documentadas em `docs/tasks/`.

---

## TASK-029 — Equipe & Escalas

**Branch:** `cursor/task-029-equipe`

**Objetivo:** Criar o módulo Equipe & Escalas — roster operacional (funções e colaboradores), vínculo planejado com orçamentos (`quote_team_members`), UI de gestão e disponibilidade calculada dinamicamente — sem check-in/out, sem folha, sem alterar `TeamMemberStatus` automaticamente e sem agenda visual.

### Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Fundação do domínio (entidades, enums, validadores, contratos) | `d3af1ba` | ✅ Concluído |
| B | Persistência Drift — roles/membros, migração v6→v7 | `28dccef` | ✅ Concluído |
| C | Casos de uso — TeamMemberService / TeamRoleService | `b7cee40` | ✅ Concluído |
| D | QuoteTeamMember + serviço + migração v7→v8 | `a1e16fd` | ✅ Concluído |
| E | UI, providers, dashboard e seção em orçamentos | `c80349c` | ✅ Concluído |
| F | Disponibilidade dinâmica (calculator + service + providers) | `564d196` | ✅ Concluído |
| G | Documentação final — `docs/tasks/TASK-029.md`, `docs/business-rules/team.md`, revisão de `ARCHITECTURE.md` | *(pendente de commit)* | ✅ Concluído |

**TASK-029 encerrada.** Histórico completo consolidado em `docs/tasks/TASK-029.md`.

### CP-A — concluído

**Escopo entregue:**

- `TeamMember`, `TeamRole`, `TeamMemberStatus`, validadores, contratos de repositório
- Sem Drift, providers ou UI

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 1298 testes passando.

**Fora de escopo do CP-A (mantido):** persistência, providers, telas, QuoteTeam, disponibilidade.

**Commit:** `d3af1ba` — `feat(team): create team members and roles domain foundation`

### CP-B — concluído

**Escopo entregue:**

- Tabelas `team_roles` e `team_members`; DAOs; mappers; `Drift*Repository`
- `schemaVersion` 6→7; migração real testada

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 1309 testes passando.

**Fora de escopo do CP-B (mantido):** providers, telas, QuoteTeam, disponibilidade.

**Commit:** `28dccef` — `feat(team): persist team roles and members with Drift schema v7`

### CP-C — concluído

**Escopo entregue:**

- `TeamMemberService` / `TeamRoleService` com result objects
- Regras de função (existe/ativa; nome único; exclusão bloqueada se em uso)
- Schema, providers e UI inalterados

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com 1333 testes passando.

**Fora de escopo do CP-C (mantido):** providers, telas, schema, QuoteTeam, disponibilidade.

**Commit:** `b7cee40` — `feat(team): implement team member and role use cases`

### CP-D — concluído

**Escopo entregue:**

- `QuoteTeamMember` / `QuoteTeamSummary` / `QuoteTeamService`
- Tabela `quote_team_members` (schema 7→8); FKs CASCADE/RESTRICT
- Sem disponibilidade, sem check-in, sem alteração de `TeamMemberStatus`

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com 1351 testes passando.

**Fora de escopo do CP-D (mantido):** providers, UI, Agenda visual, cálculo de disponibilidade.

**Commit:** `a1e16fd` — `feat(team): link team members to quotes with Drift schema v8`

### CP-E — concluído

**Escopo entregue:**

- Providers Riverpod, telas Equipe/funções/formulário/detalhe, associação a orçamentos
- Módulo no Dashboard; filtros por função/status/nome
- Schema inalterado (permanece v8)

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com 1367 testes passando.

**Fora de escopo do CP-E (mantido):** disponibilidade, check-in, Agenda visual, folha.

**Commit:** `c80349c` — `feat(team): add team UI with providers, dashboard and quote section`

### CP-F — concluído

**Escopo entregue:**

- `TeamAvailabilityCalculator` / `TeamAvailabilityService` + modelos de conflito/resumo
- Providers de disponibilidade; sem persistir estado derivado; sem mutar `TeamMemberStatus`

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com 1386 testes passando.

**Fora de escopo do CP-F (mantido):** UI dedicada de disponibilidade, check-in, Agenda visual, schema.

**Commit:** `564d196` — `feat(team): compute dynamic team availability from quote schedules`

### CP-G — concluído

**Escopo entregue:**

- `docs/tasks/TASK-029.md` e `docs/business-rules/team.md` criados
- `ARCHITECTURE.md`, `PROJECT.md`, este documento e `docs/roadmap.md` atualizados
- Nenhuma alteração em `lib/`, `test/`, schema, providers ou UI — checkpoint exclusivamente documental

**Verificação:** `flutter analyze` e `flutter test` com 1386 testes passando (suíte inalterada).

**Commit:** *(pendente de commit)*

### TASK-029 — encerrada

Todos os checkpoints (A–G) concluídos. Documento final: `docs/tasks/TASK-029.md`. Encerramento aguardando aprovação do PO/CTO para commit e push; merge na `main` permanece de responsabilidade externa (fluxo de PR), conforme `CLAUDE.md`.

**Último commit de código:** `564d196`

---

## TASK-028 — Estoque & Equipamentos

**Branch:** `cursor/task-028-estoque`

**Objetivo:** Criar o módulo Estoque & Equipamentos — inventário operacional (categorias e equipamentos), vínculo planejado com orçamentos (`quote_equipment`), UI de gestão e disponibilidade calculada dinamicamente — sem reservas efetivas, sem alterar `EquipmentStatus` automaticamente e sem integrar Agenda.

### Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Fundação do domínio (entidades, enums, validadores, contratos) | `0efc7b1` | ✅ Concluído |
| B | Persistência Drift — categorias/equipamentos, migração v4→v5 | `5f22264` | ✅ Concluído |
| C | Casos de uso — EquipmentService / EquipmentCategoryService | `d94aeef` | ✅ Concluído |
| D | QuoteEquipment + serviço + migração v5→v6 | `76a14ba` | ✅ Concluído |
| E | UI, providers, filtros e associação a orçamentos | `e4328f8` | ✅ Concluído |
| F | Disponibilidade dinâmica (calculator + service + providers) | `cebe010` | ✅ Concluído |
| G | Documentação final — `docs/tasks/TASK-028.md`, `docs/business-rules/equipment.md`, revisão de `ARCHITECTURE.md` | *(pendente de commit)* | ✅ Concluído |

**TASK-028 encerrada.** Histórico completo consolidado em `docs/tasks/TASK-028.md`.

### CP-A — concluído

**Escopo entregue:**

- `Equipment`, `EquipmentCategory`, `EquipmentStatus`, validadores, contratos de repositório
- Sem Drift, providers ou UI

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 1188 testes passando.

**Fora de escopo do CP-A (mantido):** persistência, providers, telas, QuoteEquipment, disponibilidade.

**Commit:** `0efc7b1` — `feat(equipment): create inventory equipment domain foundation`

### CP-B — concluído

**Escopo entregue:**

- Tabelas `equipment_categories` e `equipment`; DAOs; mappers; `Drift*Repository`
- `schemaVersion` 4→5; migração real testada

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 1202 testes passando.

**Fora de escopo do CP-B (mantido):** providers, telas, QuoteEquipment, disponibilidade.

**Commit:** `5f22264` — `feat(equipment): persist equipment categories and items with Drift`

### CP-C — concluído

**Escopo entregue:**

- `EquipmentService` / `EquipmentCategoryService` com result objects
- Regras de categoria (existe/ativa; exclusão bloqueada se em uso)
- Schema, providers e UI inalterados

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com 1224 testes passando.

**Fora de escopo do CP-C (mantido):** providers, telas, schema, QuoteEquipment, disponibilidade.

**Commit:** `d94aeef` — `feat(equipment): implement equipment and category use cases`

### CP-D — concluído

**Escopo entregue:**

- `QuoteEquipment` / `QuoteEquipmentSummary` / `QuoteEquipmentService`
- Tabela `quote_equipment` (schema 5→6); FKs CASCADE/RESTRICT
- Sem disponibilidade, sem reserva, sem alteração de `EquipmentStatus`

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com 1241 testes passando.

**Fora de escopo do CP-D (mantido):** providers, UI, Agenda, cálculo de disponibilidade.

**Commit:** `76a14ba` — `feat(equipment): link equipment quantities to quotes without stock reservation`

### CP-E — concluído

**Escopo entregue:**

- Providers Riverpod, telas Estoque/categorias/formulário/detalhe, associação a orçamentos
- Módulo no Dashboard; filtros por categoria/status/nome
- Schema inalterado (permanece v6)

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com 1259 testes passando.

**Fora de escopo do CP-E (mantido):** disponibilidade, reservas, Agenda, gráficos.

**Commit:** `e4328f8` — `feat(equipment): add inventory UI with providers and quote association`

### CP-F — concluído

**Escopo entregue:**

- `EquipmentAvailabilityCalculator` / `EquipmentAvailabilityService` + modelos de conflito/resumo
- Providers de disponibilidade; sem persistir quantidades derivadas; sem UI neste CP

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com 1275 testes passando.

**Fora de escopo do CP-F (mantido):** UI de disponibilidade, reservas efetivas, Agenda, schema.

**Commit:** `cebe010` — `feat(equipment): compute dynamic quote equipment availability without persistence`

### CP-G — concluído

**Escopo entregue:**

- `docs/tasks/TASK-028.md` e `docs/business-rules/equipment.md` criados
- `ARCHITECTURE.md`, `PROJECT.md`, este documento e `docs/roadmap.md` atualizados
- Nenhuma alteração em `lib/`, `test/`, schema, providers ou UI — checkpoint exclusivamente documental

**Verificação:** `flutter analyze` e `flutter test` com 1275 testes passando (suíte inalterada).

**Commit:** *(pendente de commit)*

### TASK-028 — encerrada

Todos os checkpoints (A–G) concluídos. Documento final: `docs/tasks/TASK-028.md`. Encerramento aguardando aprovação do PO/CTO para commit e push; merge na `main` permanece de responsabilidade externa (fluxo de PR), conforme `CLAUDE.md`.

**Último commit de código:** `cebe010`

---

## TASK-027 — Financeiro

**Branch:** `cursor/task-027-financeiro`

**Objetivo:** Criar o módulo Financeiro — categorias e lançamentos de receita/despesa persistidos localmente, regras de negócio testáveis, vínculo opcional com `Quote.id`, resumo global, filtros e relatórios por período — sem gráficos, sem exportações e sem alterar Agenda nem Orçamentos.

### Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Fundação do domínio (entidades, enums, validadores, contratos) | `da2867f` | ✅ Concluído |
| B | Persistência Drift — tabelas, DAOs, mappers, migração v2→v3 | `0ac8239` | ✅ Concluído |
| C | Casos de uso — categorias, lançamentos, status × paidAt | `839afae` | ✅ Concluído |
| D | Vínculo `quoteId` + resumo por orçamento (schema v3→v4) | `cb72215` | ✅ Concluído |
| E | UI, providers, resumo global e filtros | `0923014` | ✅ Concluído |
| F | Relatórios por período (reuso de filtros/calculadoras) | `936e952` | ✅ Concluído |
| G | Documentação final — `docs/tasks/TASK-027.md`, `docs/business-rules/financial.md`, revisão de `ARCHITECTURE.md` | *(pendente de commit)* | ✅ Concluído |

**TASK-027 encerrada.** Histórico completo consolidado em `docs/tasks/TASK-027.md`.

### CP-A — concluído

**Escopo entregue:**

- `FinancialEntry` (entidade única) + `FinancialFlowKind` (`income`/`expense`) + `FinancialEntryStatus` (`pending`/`paid`)
- `FinancialCategory`, validadores de campos, contratos abstratos de repositório
- Sem Drift, providers ou UI

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 1048 testes passando.

**Fora de escopo do CP-A (mantido):** persistência, providers, telas, integração Agenda/Orçamentos.

**Commit:** `da2867f` — `feat(financial): create financial domain foundation`

### CP-B — concluído

**Escopo entregue:**

- Tabelas `financial_categories` e `financial_entries`; DAOs; mappers; `Drift*Repository`
- `schemaVersion` 2→3; migração real testada (v2→v3 e salto v1→v3)

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 1071 testes passando.

**Fora de escopo do CP-B (mantido):** providers, telas, regras de negócio além da persistência, integração com Orçamentos.

**Commit:** `0ac8239` — `feat(financial): persist financial categories and entries with Drift`

### CP-C — concluído

**Escopo entregue:**

- `FinancialEntryService` / `FinancialCategoryService` com result objects
- Regras de categoria (existe/ativa/kind) e status × `paidAt` com relógio injetável
- Schema, providers e UI inalterados

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com 1100 testes passando.

**Fora de escopo do CP-C (mantido):** providers, telas, schema, dashboard/relatórios, integração Agenda/Orçamentos.

**Commit:** `839afae` — `feat(financial): implement financial entry and category use cases`

### CP-D — concluído

**Escopo entregue:**

- Coluna opcional `quote_id` (schema 3→4); FK `SET NULL`; `listByQuoteId`
- `FinancialEventSummaryCalculator` / `FinancialEventSummaryService` (receita, despesa, lucro)

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com 1123 testes passando.

**Fora de escopo do CP-D (mantido):** providers, telas, alteração de regras de Agenda/Orçamentos.

**Commit:** `cb72215` — `feat(financial): link entries to quotes and compute event summaries`

### CP-E — concluído

**Escopo entregue:**

- Providers Riverpod, telas Financeiro/categorias/formulário/detalhe, módulo no Dashboard
- Resumo global (`FinancialGlobalSummaryCalculator`) e filtros de lista
- Schema inalterado (permanece v4)

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com 1146 testes passando.

**Fora de escopo do CP-E (mantido):** gráficos, exportações, relatórios por período (CP-F), schema.

**Commit:** `0923014` — `feat(financial): add financial module UI with summary and filters`

### CP-F — concluído

**Escopo entregue:**

- Relatórios: mês atual, ano atual, período personalizado
- Indicadores, categorias ordenadas, evolução mensal tabular
- Reuso integral de `FinancialEntryFilter` + `FinancialGlobalSummaryCalculator`
- `FinancialReportPanel` na tela Financeiro

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com 1163 testes passando.

**Fora de escopo do CP-F (mantido):** gráficos, PDF/Excel/CSV, schema/migração, Agenda/Orçamentos, documentação.

**Commit:** `936e952` — `feat(financial): add period reports reusing existing summary calculators`

### CP-G — concluído

**Escopo entregue:**

- `docs/tasks/TASK-027.md` e `docs/business-rules/financial.md` criados
- `ARCHITECTURE.md`, `PROJECT.md`, este documento e `docs/roadmap.md` atualizados
- Nenhuma alteração em `lib/`, `test/`, schema, providers ou UI — checkpoint exclusivamente documental

**Verificação:** `flutter analyze` e `flutter test` com 1163 testes passando (suíte inalterada).

**Commit:** *(pendente de commit)*

### TASK-027 — encerrada

Todos os checkpoints (A–G) concluídos. Documento final: `docs/tasks/TASK-027.md`. Encerramento aguardando aprovação do PO/CTO para commit e push; merge na `main` permanece de responsabilidade externa (fluxo de PR), conforme `CLAUDE.md`.

**Último commit de código:** `936e952`

---

## TASK-026 — Agenda Inteligente e Análise de Disponibilidade

**Branch:** `cursor/task-026-agenda-inteligente`

**Objetivo:** Permitir que o usuário pergunte, em português simples, sobre a disponibilidade da Agenda e receba uma resposta textual determinística — sem IA/LLM, sem rede, sem persistência nova. Toda a interpretação, análise e resposta são construídas por regras deterministas em Dart puro, operando exclusivamente sobre `AgendaOccupancy` (já existente, TASK-025 CP-C).

### Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Motor puro de análise de disponibilidade (`AgendaAvailabilityAnalyzer`) | `f058d00` | ✅ Concluído |
| B | Serviço de consulta por dia/intervalo/semana/mês (`AgendaAvailabilityQueryService`) | `fe0129f` | ✅ Concluído |
| C | Interpretação determinística de frases em português (`AgendaAvailabilityRequestParser`) | `49b4c66` | ✅ Concluído |
| D | Resposta textual determinística (`AgendaAvailabilityResponseFormatter`/`AgendaAvailabilityAssistantService`) | `52f3a2e` | ✅ Concluído |
| E | Integração com a interface da Agenda (`AgendaAvailabilityQueryCard`) | `bffb6db` | ✅ Concluído |
| F | Hardening — testes ponta a ponta, virada de mês/ano, meia-noite, ausência de efeitos colaterais | `fd73d84` | ✅ Concluído |
| G | Documentação final — `docs/tasks/TASK-026.md`, `docs/business-rules/agenda-inteligente.md`, revisão de `ARCHITECTURE.md` | *(pendente de commit)* | ✅ Concluído |

**TASK-026 encerrada.** Histórico completo consolidado em `docs/tasks/TASK-026.md`.

### CP-A — concluído

**Escopo entregue:**

- `AgendaAvailabilityAnalyzer`: motor puro, analisa `List<AgendaOccupancy>` contra um dia/intervalo e classifica `free`/`partial`/`busy`, com intervalos livres e conflitos
- `AgendaAvailabilityResult`, `AgendaAvailabilityStatus`, `AgendaFreeInterval`, `AgendaOccupancyConflict` — novos modelos, sem persistência
- Regra de bordas (intervalos que se tocam não geram falso conflito) e recorte correto de eventos que atravessam a meia-noite

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 924 testes passando.

**Fora de escopo do CP-A (mantido):** consultas de múltiplos dias, interpretação de linguagem natural, resposta textual, UI.

**Commit:** `f058d00` — `feat(agenda): analyze agenda availability`

### CP-B — concluído

**Escopo entregue:**

- `AgendaQuery`: consulta estruturada resolvida em intervalo de datas civis (`day`, `dateRange`, `week`, `month`)
- `AgendaAvailabilityQueryService`: itera os dias da `AgendaQuery`, chama o Analyzer por dia e agrega — nenhuma regra de disponibilidade é reimplementada
- `AgendaDailyAvailability`, `AgendaAvailabilitySummary`, `AgendaQueryResult`; conflitos agregados deduplicados por par

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 941 testes passando.

**Fora de escopo do CP-B (mantido):** interpretação de linguagem natural, resposta textual, UI, IA/LLM.

**Commit:** `fe0129f` — `feat(agenda): query agenda availability by day, range, week and month`

### CP-C — concluído

**Escopo entregue:**

- `AgendaAvailabilityRequestParser`: interpretador baseado em regras (regex/palavras-chave), sem LLM/rede; converte frase em português em `AgendaAvailabilityRequest` ou erro estruturado
- `AgendaAvailabilityIntent`, `AgendaAvailabilityParseResult`/`AgendaAvailabilityParseError` (`ambiguous`/`unsupported`)
- Suporta hoje/amanhã/dia da semana/data explícita/intervalo de datas/semana atual-próxima/mês atual-nomeado/intervalo de horário; relógio injetável para determinismo em teste
- Decisão de design aprovada: mês nomeado sem ano resolve sempre para o ano do relógio injetado

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 965 testes passando.

**Fora de escopo do CP-C (mantido):** resposta textual, UI, IA/LLM, voz, chat.

**Commit:** `49b4c66` — `feat(agenda): parse structured availability requests`

### CP-D — concluído

**Escopo entregue:**

- `AgendaAvailabilityResponseFormatter`: converte resultados já computados em texto PT-BR determinístico — nenhuma regra de disponibilidade recalculada
- `AgendaAvailabilityResponse`/`AgendaAvailabilityResponseKind` (`success`/`ambiguous`/`unsupported`)
- `AgendaAvailabilityAssistantService`: orquestra parser → analyzer/query service → formatter em um único método `ask({phrase, occupancies})`
- Singular/plural, datas/horários formatados, rótulos de período contextuais; erros nunca expõem dado real de disponibilidade

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 994 testes passando.

**Fora de escopo do CP-D (mantido):** UI, IA/LLM, rede, Riverpod, SQLite, chat.

**Commit:** `52f3a2e` — `feat(agenda): generate deterministic availability responses`

### CP-E — concluído

**Escopo entregue:**

- `AgendaAvailabilityQueryCard`: campo de pergunta, botão "Consultar" e resposta textual, inserido no topo do corpo da `AgendaScreen`, acima da lista/estado vazio existente
- Reaproveita `agendaBlockClockProvider` já existente — nenhum provider novo criado; recebe `AgendaOccupancy` já computada, sem leitura/duplicação adicional
- Proteção contra duplo clique (`await Future<void>.delayed(Duration.zero)` + guard `_isQuerying`); resposta limpa ao alterar a pergunta
- Ajuste necessário em teste pré-existente (`ensureVisible` antes do tap no botão "Novo bloqueio", que ficou fora da viewport após o novo card)

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 1002 testes passando.

**Fora de escopo do CP-E (mantido):** IA/LLM, rede, persistência nova, schema, DAO, repository, bootstrap.

**Commit:** `bffb6db` — `feat(agenda): add intelligent availability queries to agenda`

### CP-F — concluído

**Escopo entregue:**

- Revisão do fluxo completo (frase → parser → analyzer/query service → formatter → assistant service → UI) — nenhum defeito real encontrado, nenhuma alteração em `lib/`
- 11 testes de integração ponta a ponta (`agenda_availability_end_to_end_test.dart`): relógio injetável, virada de ano/mês, meia-noite, conflito singular/plural, determinismo, imutabilidade da lista de ocupações
- 3 testes de hardening de widget: sem leitura/escrita adicional no repositório, sem alteração do estado hidratado, acessibilidade básica do campo/botão/resposta

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 1016 testes passando.

**Fora de escopo do CP-F (mantido):** schema, banco, DAO, repository, bootstrap, rotas, regras de negócio já aprovadas, documentação.

**Commit:** `fd73d84` — `test(agenda): harden intelligent availability query pipeline`

### CP-G — concluído

**Escopo entregue:**

- `docs/tasks/TASK-026.md` criado, consolidando os 7 checkpoints (A–G)
- `docs/business-rules/agenda-inteligente.md` criado, documentando o pipeline, as regras `free`/`partial`/`busy`, a interpretação de frases, o relógio injetável e os itens fora de escopo
- `ARCHITECTURE.md` atualizado: seção do pipeline determinístico da Agenda Inteligente, sem novas tabelas/providers de persistência
- `PROJECT.md` e este documento atualizados com o encerramento da TASK-026
- `docs/roadmap.md` atualizado: item promovido parcialmente, com o recorte que permanece futuro
- Nenhuma alteração em `lib/`, `test/`, schema, providers, repositories, DAOs ou UI — checkpoint exclusivamente documental

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 1016 testes passando (suíte inalterada).

**Commit:** *(pendente de commit)*

### TASK-026 — encerrada

Todos os checkpoints (A–G) concluídos. Documento final consolidado: `docs/tasks/TASK-026.md`. Encerramento aguardando aprovação do PO/CTO para commit e push; merge na `main` permanece de responsabilidade externa (fluxo de PR), conforme `CLAUDE.md`.

**Último commit:** `fd73d84`

---

## TASK-025 — Agenda

**Branch:** `cursor/task-025-agenda`

**Objetivo:** Criar o módulo de Agenda, combinando propostas e eventos confirmados derivados dos Orçamentos existentes com bloqueios manuais persistidos localmente, sem duplicar dados, preparando a base para futura Agenda Inteligente, Financeiro, Contratos, Equipe, Fornecedores e Evento 360°.

### Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Migração real de schema v1→v2 — tabela `AgendaBlocks`, snapshot do schema legado, teste de migração | `34d1ac8` | ✅ Concluído |
| B | Repository, DAO, Mapper e Notifier — bloqueios manuais persistidos | `ba7bf74` | ✅ Concluído |
| C | Ocupação computada (`AgendaOccupancy`) e detecção de conflitos (`AgendaOverlapChecker`) | `565cfdf` | ✅ Concluído |
| D | Interface e rotas — `AgendaScreen`, formulário de bloqueio, detalhes, módulo no Dashboard | `e821995` | ✅ Concluído |
| E | Bootstrap e hidratação — `AgendaBlocks` no `appBootstrapProvider` | `67583e2` | ✅ Concluído |
| F | Hardening — constraints reais, índices, ordenação, integridade | `0a56c0e` | ✅ Concluído |
| G | Documentação final — `docs/tasks/TASK-025.md`, `docs/business-rules/agenda.md`, revisão de `ARCHITECTURE.md` | *(pendente de commit)* | ✅ Concluído |

**TASK-025 encerrada.** Histórico completo dos checkpoints preservado abaixo e consolidado em `docs/tasks/TASK-025.md`.

### CP-A — concluído

**Escopo entregue:**

- Tabela `AgendaBlocks` (`id`, `title`, `notes?`, `start`, `end`, `createdAt`, `updatedAt`), índices `idx_agenda_blocks_start`/`idx_agenda_blocks_end`
- `schemaVersion` 1 → 2 — primeira migração real do projeto; `onUpgrade` explícito somente para `(from == 1, to >= 2)`, criando apenas `agendaBlocks`
- Snapshot genuíno do schema v1 (`test/core/database/legacy_schema/LegacyAppDatabaseV1`), com `tableName` sobrescrito para bater com os nomes físicos originais
- `test/core/database/agenda_migration_test.dart`: grava banco v1 completo, reabre com `AppDatabase` v2, confirma preservação total dos dados e `PRAGMA integrity_check` ok

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 806 testes passando.

**Desvio registrado:** `dart run drift_dev schema dump` incompatível com a versão instalada de `drift_dev`; snapshot v1 construído manualmente, aprovado pelo PO/CTO.

**Fora de escopo do CP-A (mantido):** repository, DAO em uso pela UI, telas, bootstrap, documentação.

**Commit:** `34d1ac8` — `feat(agenda): add AgendaBlocks table with real v1 to v2 migration`

### CP-B — concluído

**Escopo entregue:**

- `AgendaBlocksDao`, `AgendaBlockMapper`, `AgendaBlockRepository`/`DriftAgendaBlockRepository`, `agendaBlockRepositoryProvider`
- `AgendaBlocksNotifier` (`AsyncNotifier`) com `addBlock`/`updateBlock`/`deleteBlock` assíncronos e `hydrate(...)` público
- `AgendaBlockValidator` (título, início e fim obrigatórios; fim posterior ao início)
- `FakeAgendaBlockRepository` e `agendaBlockRepositoryOverrides()`
- Correção de bug real: `AgendaBlocksDao.updateRow` mascarava o retorno booleano do Drift (`.then((_) => true)`); corrigido para propagar o resultado real de `update(...).replace(row)`

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 841 testes passando.

**Fora de escopo do CP-B (mantido):** telas, rotas, bootstrap, `agendaOccupancyProvider`, documentação.

**Commit:** `ba7bf74` — `feat(agenda): persist manual agenda blocks`

### CP-C — concluído

**Escopo entregue:**

- `AgendaEventIntervalResolver`: converte `QuoteEventSnapshot` em intervalo `DateTime` local, preservando data civil e horário; fallback `00:00`/`23:59`; virada de dia quando `end <= start`
- `AgendaOccupancy` (nunca persistido): `fromQuote` (status → `proposal`/`confirmed`, ignora `rejected`/`cancelled`) e `fromBlock`
- `AgendaOverlapChecker`: verificador puro (sem Riverpod) de sobreposição "half-open"
- `agendaOccupancyProvider`: `Provider` computado combinando `quotesProvider` + `agendaBlocksProvider`, ordenado por `start`

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 871 testes passando.

**Fora de escopo do CP-C (mantido):** telas, rotas, bootstrap, documentação.

**Commit:** `565cfdf` — `feat(agenda): compute agenda occupancy and conflicts`

### CP-D — concluído

**Escopo entregue:**

- `AgendaScreen` (lista, distinção visual Proposta/Confirmado/Bloqueio, loading/vazio/erro, botão "Novo bloqueio")
- `NewAgendaBlockScreen` (criação e edição, `AgendaBlockValidator`, proteção contra duplo clique)
- `AgendaBlockDetailScreen` (editar, excluir com confirmação)
- Rotas `/agenda`, `/agenda/new`, `/agenda/:id`, `/agenda/:id/edit`; módulo Agenda no Dashboard
- Ocupações de orçamento abrem `/quotes/:id` já existente — sem duplicação de dados
- 25 testes de widget novos; correção de regressão em `settings_checkpoint_b_test.dart`/`settings_checkpoint_c_test.dart`

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 894 testes passando.

**Fora de escopo do CP-D (mantido):** bootstrap (CP-E), documentação.

**Commit:** `e821995` — `feat(agenda): add agenda user interface`

### CP-E — concluído

**Escopo entregue:**

- `appBootstrapProvider` passa a carregar `AgendaBlockRepository` em paralelo com os demais e hidratar `agendaBlocksProvider` somente após todas as leituras concluírem
- Aguarda `agendaBlocksProvider.future` antes de `hydrate()`, evitando corrida de microtasks entre o `build()` assíncrono do notifier e a hidratação
- Helpers que constroem o `EventProApp` completo atualizados com o override do repositório da Agenda
- Testes novos: bootstrap hidrata os cinco providers; falha no repository da Agenda coloca o bootstrap em erro; retry após falha na Agenda hidrata com sucesso

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 896 testes passando.

**Fora de escopo do CP-E (mantido):** UI, rotas, schema, DAO, mapper, repository, documentação.

**Commit:** `67583e2` — `feat(agenda): hydrate agenda blocks on startup`

### CP-F — concluído

**Escopo entregue:**

- Revisão confirmando que a migração v1→v2 e a preservação de dados legados continuam íntegras
- 4 testes novos em `app_database_test.dart`: PK duplicada em `agenda_blocks`; rejeição de `NULL` em colunas obrigatórias via SQL bruto; existência e uso efetivo dos índices (`EXPLAIN QUERY PLAN`); ordenação por `start` no `AgendaBlocksDao`
- Nenhum defeito real encontrado — nenhuma alteração em `lib/`

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 900 testes passando.

**Fora de escopo do CP-F (mantido):** UI, rotas, providers, repository, mapper, bootstrap, schema, documentação.

**Commit:** `0a56c0e` — `test(agenda): harden agenda database integrity`

### CP-G — concluído

**Escopo entregue:**

- `docs/tasks/TASK-025.md` criado, consolidando os 7 checkpoints (A–G) com commit, escopo entregue e verificação de cada um, incluindo a seção "Lições Aprendidas"
- `docs/business-rules/agenda.md` criado, documentando `AgendaBlock`, `AgendaOccupancy`, regra de status → ocupação, conversão de horários, conflitos, integração com Orçamentos e itens fora de escopo
- `ARCHITECTURE.md` atualizado: Agenda nas tabelas de Features/Providers/Repositories, `schemaVersion` 2, tabela `agenda_blocks`, Política de Migrações Futuras com a primeira migração real aplicada, fluxo de ocupação computada
- `PROJECT.md` e este documento atualizados com o encerramento da TASK-025
- Nenhuma alteração em `lib/`, `test/`, schema, providers, repositories, DAOs ou UI — checkpoint exclusivamente documental

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 900 testes passando (suíte inalterada).

**Commit:** *(pendente de commit)*

### TASK-025 — encerrada

Todos os checkpoints (A–G) concluídos. Documento final consolidado: `docs/tasks/TASK-025.md`. Encerramento aguardando aprovação do PO/CTO para commit e push; merge na `main` permanece de responsabilidade externa (fluxo de PR), conforme `CLAUDE.md`.

**Último commit:** `0a56c0e`

---

## TASK-024 — Persistência local com Drift

**Branch:** `cursor/task-024-local-persistence`

**Objetivo:** Substituir o estado volátil em memória por persistência local SQLite via Drift, mantendo compatibilidade com o comportamento atual da UI e preparando hidratação futura no startup.

### Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Infraestrutura Drift — tabelas, `AppDatabase`, schema v1, FKs, testes de lifecycle | `a5de3a0` | ✅ Concluído |
| B | Clientes — `ClientsDao`, `DriftClientRepository`, mapper, provider async | `c39e65d` | ✅ Concluído |
| C | Settings — `CompanyProfilesDao`, `DriftCompanyProfileRepository`, mapper, save async | `0fc0e89` | ✅ Concluído |
| D | Catálogo e pacotes — DAO, repository, mapper, `CatalogNotifier` async | `c0beb73` | ✅ Concluído |
| E | Orçamentos — grafo completo, sequência de números, `QuotesNotifier` async | `4e4e28a` | ✅ Concluído |
| F | Bootstrap e hidratação — `AppBootstrapProvider`, `hydrate()` nos quatro notifiers, gate na `SplashScreen` | `e424d1f` | ✅ Concluído |
| G | Hardening — política de migrações futuras, testes de integridade e compatibilidade | `c79526d` | ✅ Concluído |
| H | Documentação final — `docs/tasks/TASK-024.md`, revisão de `business-rules/` e `ARCHITECTURE.md` | *(pendente de commit)* | ✅ Concluído |

**TASK-024 encerrada.** Histórico completo dos checkpoints preservado abaixo e consolidado em `docs/tasks/TASK-024.md`.

### CP-D — concluído

**Escopo entregue:**

- `CatalogDao` com transações para itens e componentes de pacote (`insertItemWithComponents`, `updateItemWithComponents`, `deleteById`)
- `CatalogRepository` / `DriftCatalogRepository` registrados via `catalogRepositoryProvider`
- `CatalogItemMapper` (preço em centavos, enums, snapshots de componentes)
- `CatalogNotifier` refatorado para `addItem`/`updateItem`/`deleteItem` assíncronos, delegando à camada de persistência e preservando o padrão de geração de ID na UI (compatível com o fluxo de imagens)
- Telas (`new_catalog_item_screen.dart`, `catalog_item_detail_screen.dart`) e `CatalogItemDeletionCoordinator` ajustados para `await`, com feedback de erro em caso de falha de persistência
- Testes novos: `CatalogItemMapper`, `DriftCatalogRepository` (CRUD, transações, FK cascade/restrict), `CatalogNotifier` (sucesso e falha)
- `FakeCatalogRepository` e `catalogRepositoryOverrides()` propagados a todos os testes que tocam o catálogo (`widget_test.dart`, `quote_e2e_helpers.dart` e specs de catálogo)

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 769 testes passando.

**Fora de escopo do CP-D (mantido):**

- Hidratação no startup (CP-F)
- Persistência de orçamentos (CP-E)
- Atualização de `docs/business-rules/catalog.md` (CP-H)
- Migrações de schema

**Commit:** `c0beb73` — `feat(catalog): persist catalog items locally with Drift`

### CP-E — concluído

**Escopo entregue:**

- `QuotesDao` com `insertQuoteGraph`/`updateQuoteGraph` transacionais, cobrindo quote, snapshots (cliente, evento, empresa), itens, componentes de pacote e histórico de status
- Reserva atômica do número sequencial `ORC-AAAA-NNNN` (`QuoteNumberSequences`) dentro da mesma transação de inserção — sequência não avança em caso de falha
- `QuoteMapper` (conversão domínio ↔ Drift, IDs UUID v7 para coleções filhas, datas civis e timestamps)
- `QuoteRepository` / `DriftQuoteRepository` registrados via `quoteRepositoryProvider`; `insert()` retorna `Future<Quote>` com o número definitivo gerado pelo banco
- Estratégia de apagar e reinserir para `QuoteLineItems`, `QuoteLinePackageComponents` e `QuoteStatusHistory` em updates, preservando `id`, `number`, `createdAt` e `companySnapshot` conforme a regra atual
- `QuotesNotifier` refatorado para `addQuote`/`updateQuote`/`transitionStatus` assíncronos, delegando à camada de persistência e retornando `false` para a UI em caso de falha
- Remoção do `QuoteNumberGenerator` (código morto substituído pela sequência persistida no SQLite)
- Telas (`new_quote_screen.dart`, `quote_detail_screen.dart`) ajustadas para `await`, com feedback de erro e rollback de logo copiado em caso de falha de persistência
- Testes novos: `QuoteMapper` (14 testes), `DriftQuoteRepository` (11 testes, incluindo atomicidade da sequência e do grafo)
- `FakeQuoteRepository` e `quoteRepositoryOverrides()` propagados a todos os testes que tocam orçamentos (`widget_test.dart`, `quote_e2e_helpers.dart`, specs de notifier, PDF e catálogo)

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 790 testes passando.

**Fora de escopo do CP-E (mantido):**

- Hidratação da lista de orçamentos no startup (CP-F)
- Exclusão de orçamento
- Migrações de schema

**Commit:** `4e4e28a` — `feat(quotes): persist quotes locally with Drift`

### CP-F — concluído

**Escopo entregue:**

- Método público `hydrate(...)` em `ClientsNotifier`, `CompanyProfileNotifier`, `CatalogNotifier` e `QuotesNotifier` — substitui o `state` sem exigir escrita externa
- `AppBootstrapNotifier` / `appBootstrapProvider` (`AsyncNotifier<void>`) — carrega os quatro repositories em paralelo (`Future.wait`) e só hidrata os notifiers após todas as leituras concluírem
- Gate exclusivo na `SplashScreen` (`ConsumerWidget`): estado `loading` desabilita o botão "Entrar", `error` exibe mensagem com ação "Tentar novamente" (`ref.invalidate`), `data` libera o fluxo normal
- `main.dart` e `app_router.dart` mantidos sem alterações
- Helpers de teste (`widget_test.dart`, `settings_checkpoint_b_test.dart`, `settings_checkpoint_c_test.dart`) atualizados com os quatro overrides de repository, necessários porque a splash agora aciona todos eles
- Testes novos: `AppBootstrapProvider` (sucesso, falha, retry) e `hydrate()` unitário nos quatro notifiers
- Última escrita externa em `notifier.state` (em `quote_e2e_helpers.dart`, remanescente do CP-D/E) substituída por `hydrate(...)`

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 798 testes passando.

**Fora de escopo do CP-F (mantido):**

- Migrações de schema (CP-G)
- Exclusão de orçamento
- Observação de lifecycle do app (`WidgetsBindingObserver`) para fechamento da conexão SQLite

**Commit:** `e424d1f` — `feat(app): hydrate persisted data on startup`

### CP-G — concluído

**Escopo entregue:**

- Auditoria do histórico real do schema (`git log` em `tables.dart`/`app_database.dart`): confirmado que todas as 12 tabelas foram criadas de uma só vez no CP-A e nunca mudaram — não existe versão de schema anterior real para migrar
- Política de Migrações Futuras documentada em `ARCHITECTURE.md` (seção 6): checklist de 7 passos para quando a primeira migração real acontecer (snapshot do schema anterior, incremento único de versão, `onUpgrade` explícito por par `from/to`, teste contra o snapshot legado, testes de compatibilidade, suíte completa, documentação)
- `onUpgrade` **não implementado** nesta task — decisão explícita e documentada, não lacuna esquecida, por não haver versão real para migrar
- 5 testes novos em `test/core/database/app_database_test.dart`: PK composta duplicada em `CatalogPackageComponents`; cascade isolado de `QuoteLineItem` para `QuoteLinePackageComponents`; reabertura do arquivo físico preservando um grafo completo de dados; `PRAGMA integrity_check` após operações complexas; auditoria dos índices declarados via `sqlite_master`
- `schemaVersion` permanece `1`; `tables.dart`, `main.dart` e `app_router.dart` sem alterações

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 803 testes passando.

**Fora de escopo do CP-G (mantido):**

- `onUpgrade` real (sem uma versão futura concreta para migrar)
- Fechamento do banco pelo lifecycle do app (`WidgetsBindingObserver`) — `appDatabaseProvider` continua responsável via `ref.onDispose`
- Exclusão de orçamento
- Documentação final da task (CP-H)

**Commit:** *(pendente de commit)*

### CP-H — concluído

**Escopo entregue:**

- `docs/tasks/TASK-024.md` criado, consolidando os 8 checkpoints (A–H) com commit, escopo entregue e verificação de cada um, incluindo a seção "Lições Aprendidas"
- Revisão de consistência em `docs/business-rules/clients.md`, `catalog.md`, `settings.md` e `quotes.md`: remoção de afirmações obsoletas de persistência em memória (todas as quatro features já persistem em SQLite e são hidratadas no startup)
- Revisão de consistência em `ARCHITECTURE.md`: tabelas de Features, Providers e Repositories atualizadas (Catálogo e Orçamentos deixam de aparecer como "pendentes"); seção de hidratação atualizada de "CP-F — pendente" para "concluído"
- `PROJECT.md` atualizado com o encerramento da TASK-024
- Nenhuma alteração em `lib/` ou `test/` — checkpoint exclusivamente documental

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 803 testes passando (suíte inalterada).

**Commit:** *(pendente de commit)*

### TASK-024 — encerrada

Todos os checkpoints (A–H) concluídos. Documento final consolidado: `docs/tasks/TASK-024.md`. Encerramento aguardando aprovação do PO/CTO para commit e push; merge na `main` permanece de responsabilidade externa (fluxo de PR), conforme `CLAUDE.md`.

**Último commit:** `c79526d`
