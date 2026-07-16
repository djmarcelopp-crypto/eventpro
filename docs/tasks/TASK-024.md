# TASK-024 — Persistência local com Drift

## Objetivo

Substituir o estado volátil em memória (Clientes, Catálogo, Configurações e Orçamentos) por persistência local em SQLite via Drift, mantendo compatibilidade com o comportamento atual da UI, hidratando automaticamente os dados no startup e encerrando a task com uma base de hardening e documentação consistente.

**Branch:** `cursor/task-024-local-persistence`

## Checkpoints

### Checkpoint A — Infraestrutura Drift ✅

- Tabelas de todo o schema v1 definidas de uma só vez em `tables.dart` (`Clients`, `CatalogItems`, `CatalogPackageComponents`, `CompanyProfiles`, `Quotes` + snapshots + linhas + histórico + sequências)
- `AppDatabase` (`@DriftDatabase`), `schemaVersion = 1`, `PRAGMA foreign_keys = ON` via `beforeOpen`
- `database_path.dart` — resolução do caminho do arquivo SQLite por plataforma
- Testes de lifecycle (abrir, gravar, fechar, reabrir arquivo físico)

**Commit:** `a5de3a0` — `feat(database): adiciona infraestrutura local com Drift`

### Checkpoint B — Persistência de Clientes ✅

- `ClientsDao`, `ClientRepository` / `DriftClientRepository`, `ClientMapper`
- `ClientsNotifier` refatorado para `addClient`/`updateClient`/`deleteClient` assíncronos
- `FakeClientRepository` e `clientRepositoryOverrides()` para testes

**Commit:** `c39e65d` — `feat(clients): persist clients locally with Drift`

### Checkpoint C — Persistência de Configurações da Empresa ✅

- `CompanyProfilesDao`, `CompanyProfileRepository` / `DriftCompanyProfileRepository`, mapper
- `CompanyProfileNotifier.save()` assíncrono, persistindo o perfil único da empresa
- `FakeCompanyProfileRepository` e `companyProfileRepositoryOverrides()`

**Commit:** `0fc0e89` — `feat(settings): persist company profile locally with Drift`

### Checkpoint D — Persistência de Catálogo e Pacotes ✅

**Escopo entregue:**

- `CatalogDao` com transações para itens e componentes de pacote (`insertItemWithComponents`, `updateItemWithComponents`, `deleteById`)
- `CatalogRepository` / `DriftCatalogRepository` registrados via `catalogRepositoryProvider`
- `CatalogItemMapper` (preço em centavos, enums, snapshots de componentes)
- `CatalogNotifier` refatorado para `addItem`/`updateItem`/`deleteItem` assíncronos, delegando à camada de persistência e preservando o padrão de geração de ID na UI (compatível com o fluxo de imagens)
- Telas (`new_catalog_item_screen.dart`, `catalog_item_detail_screen.dart`) e `CatalogItemDeletionCoordinator` ajustados para `await`, com feedback de erro em caso de falha de persistência
- Testes novos: `CatalogItemMapper`, `DriftCatalogRepository` (CRUD, transações, FK cascade/restrict), `CatalogNotifier` (sucesso e falha)
- `FakeCatalogRepository` e `catalogRepositoryOverrides()` propagados a todos os testes que tocam o catálogo

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 769 testes passando.

**Fora de escopo do CP-D (mantido):** hidratação no startup (CP-F), persistência de orçamentos (CP-E), migrações de schema.

**Commit:** `c0beb73` — `feat(catalog): persist catalog items locally with Drift`

### Checkpoint E — Persistência de Orçamentos ✅

**Escopo entregue:**

- `QuotesDao` com `insertQuoteGraph`/`updateQuoteGraph` transacionais, cobrindo quote, snapshots (cliente, evento, empresa), itens, componentes de pacote e histórico de status
- Reserva atômica do número sequencial `ORC-AAAA-NNNN` (`QuoteNumberSequences`) dentro da mesma transação de inserção — sequência não avança em caso de falha
- `QuoteMapper` (conversão domínio ↔ Drift, IDs UUID v7 para coleções filhas, datas civis e timestamps)
- `QuoteRepository` / `DriftQuoteRepository`; `insert()` retorna `Future<Quote>` com o número definitivo gerado pelo banco
- Estratégia de apagar e reinserir para `QuoteLineItems`, `QuoteLinePackageComponents` e `QuoteStatusHistory` em updates, preservando `id`, `number`, `createdAt` e `companySnapshot`
- `QuotesNotifier` refatorado para `addQuote`/`updateQuote`/`transitionStatus` assíncronos, retornando `false` para a UI em caso de falha
- Remoção do `QuoteNumberGenerator` (código morto substituído pela sequência persistida no SQLite)
- Testes novos: `QuoteMapper` (14 testes), `DriftQuoteRepository` (11 testes, incluindo atomicidade da sequência e do grafo)

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 790 testes passando.

**Fora de escopo do CP-E (mantido):** hidratação da lista de orçamentos no startup (CP-F), exclusão de orçamento, migrações de schema.

**Commit:** `4e4e28a` — `feat(quotes): persist quotes locally with Drift`

### Checkpoint F — Bootstrap e Hidratação no Startup ✅

**Escopo entregue:**

- Método público `hydrate(...)` em `ClientsNotifier`, `CompanyProfileNotifier`, `CatalogNotifier` e `QuotesNotifier` — substitui o `state` sem exigir escrita externa
- `AppBootstrapNotifier` / `appBootstrapProvider` (`AsyncNotifier<void>`) — carrega os quatro repositories em paralelo (`Future.wait`) e só hidrata os notifiers após todas as leituras concluírem
- Gate exclusivo na `SplashScreen` (`ConsumerWidget`): estado `loading` desabilita o botão "Entrar", `error` exibe mensagem com ação "Tentar novamente" (`ref.invalidate`), `data` libera o fluxo normal
- `main.dart` e `app_router.dart` mantidos sem alterações
- Testes novos: `AppBootstrapProvider` (sucesso, falha, retry) e `hydrate()` unitário nos quatro notifiers

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 798 testes passando.

**Fora de escopo do CP-F (mantido):** migrações de schema (CP-G), exclusão de orçamento, observação de lifecycle do app (`WidgetsBindingObserver`) para fechamento da conexão SQLite.

**Commit:** `e424d1f` — `feat(app): hydrate persisted data on startup`

### Checkpoint G — Hardening e Migrações de Schema ✅

**Escopo entregue:**

- Auditoria do histórico real do schema (`git log` em `tables.dart`/`app_database.dart`): confirmado que todas as 12 tabelas foram criadas de uma só vez no CP-A e nunca mudaram — não existe versão de schema anterior real para migrar
- Política de Migrações Futuras documentada em `ARCHITECTURE.md`: checklist de 7 passos para quando a primeira migração real acontecer
- `onUpgrade` **não implementado** nesta task — decisão explícita e documentada, não lacuna esquecida, por não haver versão real para migrar
- 5 testes novos em `test/core/database/app_database_test.dart`: PK composta duplicada em `CatalogPackageComponents`; cascade isolado de `QuoteLineItem` para `QuoteLinePackageComponents`; reabertura do arquivo físico preservando um grafo completo de dados; `PRAGMA integrity_check` após operações complexas; auditoria dos índices declarados via `sqlite_master`
- `schemaVersion` permanece `1`; `tables.dart`, `main.dart` e `app_router.dart` sem alterações

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 803 testes passando.

**Fora de escopo do CP-G (mantido):** `onUpgrade` real (sem versão futura concreta para migrar), fechamento do banco pelo lifecycle do app (`appDatabaseProvider` continua responsável via `ref.onDispose`), exclusão de orçamento.

**Commit:** `c79526d` — `test(database): harden schema integrity and migration policy`

### Checkpoint H — Documentação Final e Encerramento ✅

**Escopo entregue:**

- Este documento (`docs/tasks/TASK-024.md`), consolidando os 8 checkpoints
- Revisão de consistência em `docs/business-rules/clients.md`, `catalog.md`, `settings.md` e `quotes.md`: remoção de afirmações obsoletas de persistência em memória
- Revisão de consistência em `ARCHITECTURE.md`: tabelas de Features, Providers, Repositories e schema atualizadas para refletir CP-D/CP-E/CP-F concluídos (não mais "pendentes")
- `PROJECT.md` e `TASKS.md` atualizados com o encerramento da TASK-024
- Nenhuma alteração em `lib/` ou `test/` — checkpoint exclusivamente documental

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 803 testes passando (suíte inalterada, sem regressão).

**Commit:** *(pendente de commit)*

## Arquivos principais da task

```
lib/core/database/
  app_database.dart / app_database.g.dart
  tables.dart
  database_path.dart
  converters/
  daos/
    clients_dao.dart
    company_profiles_dao.dart
    catalog_dao.dart
    quotes_dao.dart
lib/features/<clients|catalog|settings|quotes>/data/
  repositories/ (interface + Drift*Repository)
  mappers/
lib/app/providers/app_bootstrap_provider.dart
lib/app/splash_screen.dart

test/core/database/app_database_test.dart
test/app/providers/app_bootstrap_provider_test.dart
test/features/<feature>/data/... (mappers, repositories)
test/features/<feature>/fakes/ (Fake*Repository, *_repository_test_overrides.dart)
```

## Testes e verificação

| Checkpoint | Testes totais |
|---|---|
| CP-D | 769 |
| CP-E | 790 |
| CP-F | 798 |
| CP-G | 803 |
| CP-H | 803 (inalterado — checkpoint documental) |

Todos os checkpoints executaram `flutter analyze` (sem apontamentos) e `flutter test` completo antes do commit, conforme `CLAUDE.md`.

## Fora de escopo geral da TASK-024 (evolução futura)

- Exclusão de orçamento
- `onUpgrade` real de schema (sem uma versão concreta futura para migrar)
- Observação de lifecycle do app (`WidgetsBindingObserver`) para fechamento da conexão SQLite — `appDatabaseProvider` permanece responsável via `ref.onDispose`
- Sincronização online/Firebase (fora do escopo do MVP local)
- Agenda Inteligente e Análise de Disponibilidade — registrada em `docs/roadmap.md`, sem task associada

## Lições Aprendidas

### Padrão Repository + DAO + Mapper

Separar claramente **DAO** (acesso bruto ao SQLite via Drift), **Mapper** (conversão domínio ↔ Drift Companion/Row) e **Repository** (contrato de domínio consumido pelos Notifiers) permitiu repetir o mesmo padrão em quatro features (Clientes, Configurações, Catálogo, Orçamentos) sem duplicar decisões de design a cada checkpoint. O contrato do `Repository` isolou completamente os Notifiers de detalhes do Drift, o que tornou trivial criar `Fake*Repository` para os testes sem tocar em SQLite real.

### Bootstrap e hidratação centralizados

Concentrar a hidratação em um único `AppBootstrapProvider` (em vez de cada feature se hidratar independentemente) evitou condições de corrida entre providers e criou um ponto único de tratamento de erro/retry na `SplashScreen`. O padrão `hydrate()` público nos Notifiers (em vez de escrita direta em `notifier.state` a partir de fora) preservou o encapsulamento do estado mesmo durante o bootstrap — uma regra que valeu a pena impor desde o início do CP-F.

### Drift como camada de persistência

Transações do Drift (`batch`, `transaction`) foram essenciais para garantir atomicidade em operações que tocam múltiplas tabelas relacionadas (grafo de orçamento, item de catálogo + componentes de pacote). Definir o schema completo de uma vez no CP-A (em vez de crescê-lo incrementalmente por checkpoint) evitou qualquer necessidade real de migração de schema durante toda a task — uma decisão que só foi possível avaliar corretamente no CP-G, auditando o histórico real do `tables.dart`.

### Importância dos testes

Cada checkpoint exigiu adaptar a suíte de testes existente para o novo comportamento assíncrono (`async`/`await` em Notifiers) antes de adicionar testes novos — a suíte cresceu de forma constante (769 → 803) sem nunca regredir. Testes de constraints reais do SQLite (UNIQUE, FK cascade/restrict, PK composta) e de integridade física (`PRAGMA integrity_check`, auditoria de índices via `sqlite_master`) só fizeram sentido depois que a persistência real existia — não são substituíveis por testes de fake repository.

### Padrões arquiteturais definidos para futuras tasks

- Toda nova feature persistida deve seguir exatamente: `<Feature>Dao` → `<Feature>Repository`/`Drift<Feature>Repository` → `<Feature>Mapper` → `<Feature>Notifier` assíncrono.
- Nenhum Notifier deve expor escrita direta em `state` para código externo; hidratação e testes devem usar métodos públicos dedicados (`hydrate()`).
- Bootstrap de dados no startup é responsabilidade de um único provider orquestrador, nunca de múltiplos pontos de entrada.
- Mudança de schema só deve ocorrer com uma versão real e testável para migrar — nunca especulativamente.
- Todo checkpoint fecha com `flutter analyze` + `flutter test` completos e é reportado antes do commit.
