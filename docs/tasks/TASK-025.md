# TASK-025 — Agenda

## Objetivo

Criar o módulo de Agenda, combinando **propostas** e **eventos confirmados** derivados dos Orçamentos existentes com **bloqueios manuais** persistidos localmente, sem duplicar dados, preparando a base para futura Agenda Inteligente, Financeiro, Contratos, Equipe, Fornecedores e Evento 360°.

**Branch:** `cursor/task-025-agenda`

## Checkpoints

### Checkpoint A — Migração v1→v2 e tabela `AgendaBlocks` ✅

- Tabela `AgendaBlocks` (`id`, `title`, `notes?`, `start`, `end`, `createdAt`, `updatedAt`), índices `idx_agenda_blocks_start` e `idx_agenda_blocks_end`
- `schemaVersion` avança de `1` para `2` — **primeira migração real do projeto**
- `onUpgrade` explícito somente para o par `(from == 1, to >= 2)`, criando apenas `agendaBlocks`; nenhuma tabela existente é alterada
- Snapshot genuíno do schema v1 congelado em `test/core/database/legacy_schema/` (`LegacyAppDatabaseV1`), com `tableName` de cada tabela legada sobrescrito para bater com os nomes físicos originais
- `test/core/database/agenda_migration_test.dart`: grava um banco v1 completo (clientes, catálogo, componentes de pacote, perfil da empresa, orçamento com todos os snapshots, itens, componentes, histórico, sequência de numeração), reabre com o `AppDatabase` v2 e confirma que **todos** os dados são preservados, `agenda_blocks` é criada vazia, `PRAGMA integrity_check` retorna `ok`, e um novo bloqueio pode ser inserido após a migração

**Desvio técnico registrado:** `dart run drift_dev schema dump` não funcionou nesta versão do `drift_dev` (incompatibilidade com `drift 2.34.2`); o snapshot v1 foi construído manualmente copiando `tables.dart` para `legacy_tables_v1.dart`/`legacy_app_database_v1.dart`, aprovado explicitamente pelo PO/CTO como alternativa válida.

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 806 testes passando.

**Commit:** `34d1ac8` — `feat(agenda): add AgendaBlocks table with real v1 to v2 migration`

### Checkpoint B — Repository, DAO, Mapper e Notifier ✅

- `AgendaBlocksDao` (`getAllOrdered` ordenado por `start`, `getById`, `insertRow`, `updateRow`, `deleteById`)
- `AgendaBlockMapper` (domínio ↔ Drift `AgendaBlockRow`/`AgendaBlocksCompanion`)
- `AgendaBlockRepository` / `DriftAgendaBlockRepository`, registrados via `agendaBlockRepositoryProvider`
- `AgendaBlocksNotifier` (`AsyncNotifier<List<AgendaBlock>>`): `addBlock`/`updateBlock`/`deleteBlock` assíncronos, retornando `bool`; método público `hydrate(...)` (sem escrita externa em `state`)
- `AgendaBlockValidator`: título, início e fim obrigatórios; fim posterior ao início
- `FakeAgendaBlockRepository` e `agendaBlockRepositoryOverrides()` para testes
- **Correção de bug real encontrada pelos testes:** `AgendaBlocksDao.updateRow` usava `.then((_) => true)`, mascarando o retorno booleano do Drift e impedindo a detecção de update em id inexistente; corrigido para `return update(agendaBlocks).replace(row);`. Bug equivalente identificado (mas fora de escopo) em `ClientsDao`/`QuotesDao`.

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 841 testes passando.

**Fora de escopo do CP-B (mantido):** telas, rotas, bootstrap, `agendaOccupancyProvider`, documentação.

**Commit:** `ba7bf74` — `feat(agenda): persist manual agenda blocks`

### Checkpoint C — Ocupação computada e conflitos ✅

- `AgendaEventIntervalResolver`: converte `QuoteEventSnapshot` (data civil + `startTime`/`endTime` opcionais) em intervalo `DateTime` local, sem conversão de fuso — sem data não ocupa; sem horário assume `00:00`/`23:59`; fim não posterior ao início avança um dia (evento que atravessa a madrugada)
- `AgendaOccupancy` (modelo somente leitura, nunca persistido): `fromQuote` (mapeia `QuoteStatus` para `proposal`/`confirmed`, ignora `rejected`/`cancelled`) e `fromBlock`
- `AgendaOverlapChecker`: verificador puro (sem Riverpod) de sobreposição de intervalos, regra "half-open"
- `agendaOccupancyProvider`: `Provider` computado, combina `ref.watch(quotesProvider)` + `ref.watch(agendaBlocksProvider)`, ordena por `start`; sem persistência, sem duplicação de dados
- Testes cobrindo conversão de horários, virada de madrugada, ausência de data/horário, regra de status, conflitos (bloco×bloco, bloco×orçamento, orçamento×orçamento, sem conflito) e o provider computado

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 871 testes passando.

**Fora de escopo do CP-C (mantido):** telas, rotas, bootstrap, documentação.

**Commit:** `565cfdf` — `feat(agenda): compute agenda occupancy and conflicts`

### Checkpoint D — Interface e rotas ✅

- `AgendaScreen`: consome `agendaOccupancyProvider`; lista ordenada por data/hora; distingue visualmente Proposta/Confirmado/Bloqueio; estados de loading/vazio/erro (com retry); botão "Novo bloqueio"
- `NewAgendaBlockScreen`: formulário único para criação e edição (`blockId` opcional); `AgendaBlockValidator`; proteção contra duplo clique; sem navegação em caso de falha
- `AgendaBlockDetailScreen`: exibe bloqueio, ações de editar e excluir (com confirmação)
- Rotas `/agenda`, `/agenda/new`, `/agenda/:id`, `/agenda/:id/edit`; módulo "Agenda" adicionado ao Dashboard
- Ocupações originadas de orçamento abrem a rota já existente `/quotes/:id` — nenhuma duplicação de dados/tela
- `agenda_test_helpers.dart`, `agenda_occupancy_presenter.dart`, `agenda_block_feedback.dart` e widgets dedicados (`agenda_empty_state.dart`, `agenda_occupancy_list_item.dart`)
- 25 testes de widget novos (`AgendaScreen`, `NewAgendaBlockScreen`, `AgendaBlockDetailScreen`)
- Correção de regressão em `settings_checkpoint_b_test.dart`/`settings_checkpoint_c_test.dart` (card "Configurações" saiu da área visível após o novo módulo no Dashboard)

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 894 testes passando.

**Fora de escopo do CP-D (mantido):** bootstrap (CP-E), documentação.

**Commit:** `e821995` — `feat(agenda): add agenda user interface`

### Checkpoint E — Bootstrap e hidratação no startup ✅

- `appBootstrapProvider` passa a carregar `agendaBlockRepositoryProvider.listAll()` em paralelo com os demais repositories (`Future.wait`)
- `agendaBlocksProvider.notifier.hydrate(...)` chamado somente após todas as leituras concluírem — nenhum provider é hidratado parcialmente em caso de falha
- Cuidado técnico específico: `AgendaBlocksNotifier` é o único `AsyncNotifier` entre os hidratados; o bootstrap aguarda `agendaBlocksProvider.future` (resolução do `build()` trivial) antes de chamar `hydrate()`, evitando que o `build()` assíncrono sobrescreva o estado recém-hidratado por uma corrida de microtasks
- Helpers que constroem o `EventProApp` completo (`widget_test.dart`, `quote_e2e_helpers.dart`, `settings_checkpoint_b_test.dart`, `settings_checkpoint_c_test.dart`) atualizados com o override do repositório da Agenda — sem isso, o bootstrap real tentaria abrir o banco físico nesses testes
- Testes novos em `app_bootstrap_provider_test.dart`: bootstrap hidrata os cinco providers; falha no repository da Agenda coloca o bootstrap em erro; retry após falha na Agenda hidrata com sucesso

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 896 testes passando.

**Fora de escopo do CP-E (mantido):** UI, rotas, schema, DAO, mapper, repository, documentação.

**Commit:** `67583e2` — `feat(agenda): hydrate agenda blocks on startup`

### Checkpoint F — Hardening ✅

- Revisão confirmou que a migração v1→v2 (CP-A) e a preservação de dados legados continuam íntegras — nenhuma alteração necessária
- 4 testes novos em `test/core/database/app_database_test.dart`: PK duplicada em `agenda_blocks`; rejeição de `NULL` em `title`/`start`/`end` via SQL bruto (`customStatement`, contornando a segurança de tipos do Dart); existência **e uso efetivo** de `idx_agenda_blocks_start`/`idx_agenda_blocks_end` (via `EXPLAIN QUERY PLAN`); `AgendaBlocksDao.getAllOrdered` ordenando corretamente com inserção embaralhada
- Nenhum defeito real encontrado — nenhuma alteração em `lib/` neste checkpoint

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 900 testes passando.

**Fora de escopo do CP-F (mantido):** UI, rotas, providers, repository, mapper, bootstrap, schema, documentação.

**Commit:** `0a56c0e` — `test(agenda): harden agenda database integrity`

### Checkpoint G — Documentação final e encerramento ✅

**Escopo entregue:**

- Este documento (`docs/tasks/TASK-025.md`), consolidando os 7 checkpoints (A–G)
- `docs/business-rules/agenda.md` criado, documentando `AgendaBlock`, `AgendaOccupancy`, regra de status → ocupação, conversão de horários, `AgendaOverlapChecker`, integração com Orçamentos, rotas e itens deliberadamente fora de escopo
- `ARCHITECTURE.md` atualizado: Agenda nas tabelas de Features, Providers e Repositories; `schemaVersion` 1 → 2; tabela `agenda_blocks` no schema; seção de Política de Migrações Futuras atualizada com a primeira migração real aplicada; fluxo de dados com a ocupação computada
- `PROJECT.md` e `TASKS.md` atualizados com o encerramento da TASK-025
- Nenhuma alteração em `lib/`, `test/`, schema, providers, repositories, DAOs ou UI — checkpoint exclusivamente documental

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 900 testes passando (suíte inalterada).

**Commit:** *(pendente de aprovação/commit)*

## Arquivos principais da task

```
lib/core/database/
  tables.dart                         # AgendaBlocks (schemaVersion 2)
  app_database.dart                   # onUpgrade v1 → v2
  daos/agenda_blocks_dao.dart

lib/features/agenda/
  agenda_screen.dart
  new_agenda_block_screen.dart
  agenda_block_detail_screen.dart
  agenda_block_feedback.dart
  models/agenda_block.dart
  models/agenda_occupancy.dart
  data/repositories/ (interface + DriftAgendaBlockRepository)
  data/mappers/agenda_block_mapper.dart
  providers/ (agenda_block_repository_provider, agenda_blocks_provider,
              agenda_occupancy_provider, agenda_block_clock_provider)
  utils/ (agenda_block_validator, agenda_event_interval_resolver,
          agenda_overlap_checker, agenda_occupancy_presenter)
  widgets/ (agenda_empty_state, agenda_occupancy_list_item)

lib/app/providers/app_bootstrap_provider.dart   # + AgendaBlocks
lib/app/router/app_router.dart                  # /agenda, /agenda/new, /agenda/:id[/edit]
lib/features/dashboard/                         # módulo Agenda

test/core/database/legacy_schema/               # snapshot real do schema v1
test/core/database/agenda_migration_test.dart
test/core/database/app_database_test.dart       # + hardening da Agenda
test/features/agenda/                           # espelha lib/features/agenda/
```

## Testes e verificação

| Checkpoint | Testes totais |
|---|---|
| CP-A | 806 |
| CP-B | 841 |
| CP-C | 871 |
| CP-D | 894 |
| CP-E | 896 |
| CP-F | 900 |
| CP-G | 900 (inalterado — checkpoint documental) |

Todos os checkpoints executaram `flutter analyze` (sem apontamentos) e `flutter test` completo antes do commit, conforme `CLAUDE.md`.

## Fora de escopo geral da TASK-025 (evolução futura)

- **Agenda Inteligente e Análise de Disponibilidade** — ideia registrada em `docs/roadmap.md`, anterior a esta task; sem implementação
- **`AgendaResourceReservations`** (reserva de equipe/equipamentos) — schema deliberadamente não criado; sem DAO, UI ou modelo de recursos definido
- **`AgendaEventSchedules`** (granularidade de montagem/execução/desmontagem por evento) — não criado; a ocupação de orçamentos já é integralmente derivada do `QuoteEventSnapshot` existente
- **Bloqueio automático de conflitos** — `AgendaOverlapChecker` detecta, mas não impede, sobreposição
- **Financeiro, Contratos, Equipe, Fornecedores, Evento 360°** — a Agenda foi desenhada com pontos de extensão (`sourceQuoteId`/`sourceBlockId`), mas nenhuma integração real existe nesta fase
- Exclusão de orçamento (herdado da TASK-024, ainda não implementado)
- Sincronização online/Firebase

## Lições Aprendidas

### Dados derivados vs. dados persistidos

A decisão de **não** criar uma tabela para `AgendaOccupancy` — e sempre derivá-la em tempo real a partir de `quotesProvider` + `agendaBlocksProvider` — eliminou por completo o risco de dessincronização entre Orçamentos e Agenda. Qualquer mudança de status de um orçamento aparece na Agenda na próxima leitura do provider, sem nenhum código de sincronização. O custo (recomputar a lista a cada leitura) é irrelevante na escala do MVP e o ganho de simplicidade/consistência foi decisivo. Esse padrão — "computar em vez de persistir" quando o dado de origem já existe e é barato de reler — deve ser considerado por padrão antes de criar uma nova tabela para dados que são função de outras entidades já persistidas.

### Migração real de schema, finalmente testável

A TASK-024 CP-G documentou uma *política* de migração futura sem poder testá-la, por não existir uma versão anterior real. A TASK-025 CP-A foi a primeira oportunidade de aplicá-la de fato: snapshot genuíno do schema v1 (`LegacyAppDatabaseV1`), `onUpgrade` explícito só para o par de versões real, e teste de migração contra um banco v1 populado. O único obstáculo foi uma incompatibilidade de versão do `drift_dev` com a ferramenta de dump de schema, contornada com um snapshot manual — aprovado explicitamente pelo PO/CTO como desvio documentado, não como lacuna.

### Testes revelando bugs em código já existente

O teste de `update` para bloqueio inexistente (CP-B) expôs que `AgendaBlocksDao.updateRow` mascarava o retorno booleano do Drift com `.then((_) => true)`, sempre reportando sucesso mesmo quando nenhuma linha era afetada. Esse é exatamente o tipo de defeito que só aparece com um teste que assume a falha como caminho esperado — reforça a prática (herdada da TASK-024) de sempre testar explicitamente os caminhos de erro de update/delete, não apenas o caminho feliz. O mesmo padrão de bug foi identificado, mas deliberadamente não corrigido, em `ClientsDao`/`QuotesDao` — fora do escopo desta task, registrado para correção futura.

### Notifiers assíncronos exigem cuidado extra no bootstrap

`AgendaBlocksNotifier` foi o primeiro `AsyncNotifier` hidratado pelo `appBootstrapProvider` (os quatro notifiers da TASK-024 são `Notifier` síncronos). A hidratação direta (`ref.read(provider.notifier).hydrate(...)`) sem aguardar o `build()` trivial primeiro criava uma corrida de microtasks em que o resultado do `build()` podia sobrescrever o estado recém-hidratado. A correção (`await ref.read(provider.future)` antes de `hydrate()`) é um padrão que deve ser repetido em qualquer futuro `AsyncNotifier` hidratado pelo bootstrap.

### Escopo disciplinado evita schema especulativo

A decisão de replanejamento de criar **somente** `AgendaBlocks` no CP-A — postergando `AgendaEventSchedules` e `AgendaResourceReservations` — evitou desenhar tabelas para DAOs, UI e modelos de recursos que ainda não existem. Combinado com a estratégia de derivar `AgendaOccupancy` dos orçamentos existentes, a primeira versão da Agenda entregou valor completo (propostas + confirmados + bloqueios, com detecção de conflito disponível) sem nenhuma tabela ou código especulativo para funcionalidades futuras.

### Padrões arquiteturais confirmados (e estendidos) para futuras tasks

- O padrão `Dao → Repository/Drift*Repository → Mapper → Notifier` (TASK-024) se repetiu sem alteração para a Agenda, confirmando que é o padrão-base do projeto para qualquer nova entidade persistida.
- Dados que são **função** de outras entidades já persistidas (ocupação da Agenda a partir de orçamentos) devem ser **computados via `Provider`**, não persistidos em tabela própria.
- Verificadores de regra pura (ex.: `AgendaOverlapChecker`) devem ser implementados sem Riverpod e sem I/O, testáveis isoladamente.
- Toda migração real de schema deve seguir o checklist da Política de Migrações Futuras (`ARCHITECTURE.md`), agora validado na prática pela primeira vez.
