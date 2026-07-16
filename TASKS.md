# TASKS — EventPro ERP

Registro da task ativa. Tasks concluídas permanecem documentadas em `docs/tasks/`.

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
| F | Bootstrap e hidratação — `AppBootstrapProvider`, `hydrate()` nos quatro notifiers, gate na `SplashScreen` | *(pendente de commit)* | ✅ Concluído |
| **G** | **Hardening e migrações de schema** | — | **🔄 Atual** |
| H | Documentação — `docs/tasks/TASK-024.md`, business-rules | — | ⏳ Pendente |

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

### CP-F — concluído (pendente de commit)

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

**Commit:** *(pendente de commit)*

### Checkpoint atual: CP-G

Hardening e migrações de schema. Plano técnico a ser apresentado antes de qualquer implementação.

**Último commit:** `4e4e28a`
