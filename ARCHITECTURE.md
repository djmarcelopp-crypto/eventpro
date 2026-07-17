# Arquitetura — EventPro ERP

Documentação oficial da arquitetura do EventPro ERP. Descreve a estrutura atual do projeto, incluindo a camada de persistência local com Drift/SQLite (TASK-024), o módulo de Agenda com ocupação computada (TASK-025), a Agenda Inteligente — consultas de disponibilidade em português, deterministas e sem persistência (TASK-026) — e o módulo Financeiro com categorias, lançamentos, resumos e relatórios por período (TASK-027).

---

## 1. Propósito

Arquitetura pragmática de Clean Architecture adaptada ao MVP: separação de responsabilidades onde faz sentido, sem abstrações prematuras. Objetivo: entrega rápida, código legível e base preparada para evolução.

**Stack:** Flutter · Dart · Material 3 · Riverpod · GoRouter · Drift · SQLite

---

## 2. Arquitetura em camadas

```text
┌─────────────────────────────────────────────────────────┐
│  Presentation (Screens, Widgets)                         │
│  Riverpod Notifiers / Providers                         │
├─────────────────────────────────────────────────────────┤
│  Domain (Models, regras de negócio, validators)         │
├─────────────────────────────────────────────────────────┤
│  Data (Repositories, Mappers, Services)                 │
├─────────────────────────────────────────────────────────┤
│  Drift DAOs → SQLite                                    │
└─────────────────────────────────────────────────────────┘
```

### Responsabilidades por camada

| Camada | Responsabilidade | Localização |
|--------|------------------|-------------|
| **Presentation** | Telas, widgets, interação do usuário | `lib/features/*/`, `lib/app/` |
| **State** | Estado da UI, orquestração de ações | `lib/features/*/providers/` |
| **Domain** | Modelos, enums, validadores, regras | `lib/features/*/models/`, `utils/` |
| **Data** | Repositórios, mappers, serviços externos | `lib/features/*/data/` |
| **Database** | Schema, DAOs, conversores | `lib/core/database/` |
| **Core** | Tema, widgets compartilhados, lookup, mídia | `lib/core/` |

---

## 3. Features

Organização **feature-first**: cada módulo do MVP vive em `lib/features/`.

| Feature | Pasta | Estado da persistência |
|---------|-------|------------------------|
| Dashboard | `dashboard/` | Sem persistência |
| Clientes | `clients/` | ✅ Drift (TASK-024 CP-B) |
| Catálogo | `catalog/` | ✅ Drift (TASK-024 CP-D) |
| Orçamentos | `quotes/` | ✅ Drift (TASK-024 CP-E) |
| Configurações | `settings/` | ✅ Drift (TASK-024 CP-C) |
| Agenda | `agenda/` | ✅ Drift para bloqueios manuais (TASK-025 CP-A/B); ocupação de orçamentos é **computada**, nunca persistida (CP-C); Agenda Inteligente (TASK-026) é um pipeline Dart puro sem persistência própria, consumindo a ocupação já computada |
| Financeiro | `financial/` | ✅ Drift — `financial_categories` + `financial_entries` (TASK-027 CP-B); `quoteId` opcional desde schema v4 (CP-D); carregamento sob demanda (não hidratado no bootstrap) |

### Estrutura interna de uma feature (quando complexa)

```text
lib/features/<feature>/
  <feature>_screen.dart          # telas principais
  providers/                     # Notifiers e providers Riverpod
  models/                        # entidades de domínio
  data/
    repositories/                # interface + Drift*Repository
    mappers/                     # domain ↔ Drift row
    services/                    # storage, APIs, pickers
  widgets/                       # componentes da feature
  utils/                         # helpers, formatters, coordinators
```

Features simples podem manter arquivos na raiz da pasta sem subpastas extras.

---

## 4. Providers (Riverpod)

Riverpod gerencia estado da UI, injeção de dependências e compartilhamento entre telas.

### Padrão adotado

```text
appDatabaseProvider
       ↓
<feature>RepositoryProvider  →  Drift*Repository
       ↓
<feature>Provider (Notifier)  →  estado em memória + escrita no repositório
```

### Providers globais (`lib/core/`)

| Provider | Função |
|----------|--------|
| `appDatabaseProvider` | Instância singleton de `AppDatabase` (Drift) |

### Providers por feature (exemplos)

| Provider | Feature | Tipo | Estado |
|----------|---------|------|--------|
| `clientsProvider` | Clientes | `Notifier<List<Client>>` | Memória + escrita SQLite + hidratado no startup |
| `clientRepositoryProvider` | Clientes | `Provider<ClientRepository>` | — |
| `companyProfileProvider` | Settings | `Notifier<CompanyProfile?>` | Memória + escrita SQLite + hidratado no startup |
| `companyProfileRepositoryProvider` | Settings | `Provider<CompanyProfileRepository>` | — |
| `catalogProvider` | Catálogo | `Notifier<List<CatalogItem>>` | Memória + escrita SQLite + hidratado no startup |
| `catalogRepositoryProvider` | Catálogo | `Provider<CatalogRepository>` | — |
| `quotesProvider` | Orçamentos | `Notifier<List<Quote>>` | Memória + escrita SQLite + hidratado no startup |
| `quoteRepositoryProvider` | Orçamentos | `Provider<QuoteRepository>` | — |
| `agendaBlocksProvider` | Agenda | `AsyncNotifier<List<AgendaBlock>>` | Memória + escrita SQLite + hidratado no startup (TASK-025 CP-B/E) |
| `agendaBlockRepositoryProvider` | Agenda | `Provider<AgendaBlockRepository>` | — |
| `agendaOccupancyProvider` | Agenda | `Provider<AsyncValue<List<AgendaOccupancy>>>` | **Computado** — combina `quotesProvider` + `agendaBlocksProvider`; sem estado próprio, sem persistência (TASK-025 CP-C) |
| `financialEntriesProvider` | Financeiro | `AsyncNotifierProvider` | Memória + escrita SQLite via serviços; load sob demanda no `build()` (TASK-027 CP-E) |
| `financialCategoriesProvider` | Financeiro | `AsyncNotifierProvider` | Idem para categorias |
| `financialEntryFiltersProvider` | Financeiro | `NotifierProvider` | Filtros da lista (período, kind, status) |
| `financialFilteredEntriesProvider` | Financeiro | `Provider` | Lista após filtros |
| `financialGlobalSummaryProvider` | Financeiro | `Provider` | Resumo global da lista filtrada (calculator puro) |
| `financialReportQueryProvider` | Financeiro | `NotifierProvider` | Preset/período do relatório |
| `financialPeriodReportProvider` | Financeiro | `Provider` | Relatório por período (lista completa + query) |
| `appBootstrapProvider` | Global | `AsyncNotifierProvider<void>` | Orquestra a hidratação dos cinco notifiers no startup (TASK-024 CP-F; estendido na TASK-025 CP-E) — **não** inclui Financeiro nesta fase |

### Regras

- Notifiers expõem métodos `async` que persistem via repository e atualizam `state`.
- `build()` retorna estado inicial vazio; a hidratação real ocorre via `appBootstrapProvider` no gate da `SplashScreen` (CP-F).
- Nenhum código externo escreve em `notifier.state` diretamente — hidratação usa o método público `hydrate(...)` de cada notifier.
- `Notifier` (síncrono) é o padrão para estado hidratável; `AsyncNotifier` (ex.: `AgendaBlocksNotifier`) exige aguardar `provider.future` (resolução do `build()`) **antes** de chamar `hydrate()` no bootstrap, para evitar que o `build()` assíncrono sobrescreva o estado hidratado por uma corrida de microtasks.
- Providers de serviço (lookup CNPJ/CEP, imagens, PDF) ficam isolados por feature ou em `core/`.

---

## 5. Repositories

Camada de abstração entre domínio e banco. Cada feature persistida segue o mesmo padrão:

```text
<Feature>Repository          # interface abstrata
Drift<Feature>Repository     # implementação usando AppDatabase + DAO
<Feature>Mapper              # conversão domain ↔ Drift Companion/Row
```

### Repositories implementados

| Interface | Implementação | DAO |
|-----------|---------------|-----|
| `ClientRepository` | `DriftClientRepository` | `ClientsDao` |
| `CompanyProfileRepository` | `DriftCompanyProfileRepository` | `CompanyProfilesDao` |
| `CatalogRepository` | `DriftCatalogRepository` | `CatalogDao` |
| `QuoteRepository` | `DriftQuoteRepository` | `QuotesDao` |
| `AgendaBlockRepository` | `DriftAgendaBlockRepository` | `AgendaBlocksDao` |
| `FinancialCategoryRepository` | `DriftFinancialCategoryRepository` | `FinancialCategoriesDao` |
| `FinancialEntryRepository` | `DriftFinancialEntryRepository` | `FinancialEntriesDao` |

`AgendaOccupancy` **não** possui repository, DAO ou mapper — é sempre computado (seção 7). Agregações financeiras (`FinancialGlobalSummary`, `FinancialEventSummary`, `FinancialPeriodReport`) também **não** são persistidas — são calculadas em utils/services.

### Contrato típico

```dart
abstract class ClientRepository {
  Future<List<Client>> listAll();
  Future<Client?> findById(String id);
  Future<void> insert(Client client);
  Future<void> update(Client client);
  Future<void> delete(String id);
}
```

Operações de pacotes (catálogo) usam transações no DAO (`CatalogDao`) para garantir atomicidade entre item e componentes. O mesmo padrão é aplicado ao grafo completo de orçamentos (`QuotesDao`).

---

## 6. Drift e SQLite

### Visão geral

- **Drift** é a camada ORM/type-safe sobre **SQLite**.
- Banco local: arquivo `eventpro.sqlite` (path resolvido por `database_path.dart`).
- `schemaVersion`: **4** (v1 TASK-024; v2 TASK-025 `agenda_blocks`; v3 TASK-027 tabelas financeiras; v4 TASK-027 coluna `quote_id` em `financial_entries`).
- FKs habilitadas via `PRAGMA foreign_keys = ON`.

### Estrutura em `lib/core/database/`

```text
lib/core/database/
  app_database.dart       # @DriftDatabase, factory open(), migrations
  app_database.g.dart     # código gerado (build_runner)
  tables.dart             # definição de todas as tabelas
  database_provider.dart  # appDatabaseProvider
  database_path.dart      # caminho do arquivo SQLite
  converters/
    timestamp_converter.dart
    civil_date_converter.dart
  daos/
    clients_dao.dart
    company_profiles_dao.dart
    catalog_dao.dart
    quotes_dao.dart
    agenda_blocks_dao.dart
    financial_categories_dao.dart
    financial_entries_dao.dart
```

### Tabelas (schema v4)

| Tabela | Feature | Status DAO | Desde |
|--------|---------|------------|-------|
| `clients` | Clientes | ✅ | v1 |
| `company_profile` | Settings | ✅ | v1 |
| `catalog_items` | Catálogo | ✅ | v1 |
| `catalog_package_components` | Catálogo | ✅ | v1 |
| `quotes` + snapshots + lines + history + sequences | Orçamentos | ✅ | v1 |
| `agenda_blocks` | Agenda | ✅ | v2 (TASK-025 CP-A) |
| `financial_categories` | Financeiro | ✅ | v3 (TASK-027 CP-B) |
| `financial_entries` | Financeiro | ✅ | v3 (TASK-027 CP-B); coluna `quote_id` em v4 (CP-D) |

### Geração de código

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Política de Migrações Futuras (TASK-024 CP-G, validada na prática pela TASK-025 CP-A)

**Histórico:** `tables.dart` foi criado por completo no CP-A da TASK-024 com as 12 tabelas do schema v1. Do CP-B ao CP-F daquela task, apenas DAOs foram adicionados — nenhuma tabela, coluna ou índice mudou, e por isso `onUpgrade` não foi implementado na TASK-024 (não havia versão real para migrar).

**Primeira migração real (TASK-025 CP-A):** `schemaVersion` avançou de `1` para `2` para adicionar a tabela `agenda_blocks` (Agenda). O checklist abaixo — até então apenas um guia de processo — foi seguido e validado:

1. Snapshot real do schema v1 congelado em `test/core/database/legacy_schema/` (`LegacyAppDatabaseV1`), usado como fixture de "banco legado" no teste de migração.
2. `onUpgrade` explícito somente para o par real `(from == 1, to >= 2)`, criando apenas `agendaBlocks` — nenhuma tabela existente foi alterada.
3. `test/core/database/agenda_migration_test.dart`: abre o snapshot v1 populado, aplica a migração, confirma que **nenhum dado anterior foi perdido** e que `agenda_blocks` é criada vazia.
4. Testes de compatibilidade e constraints (`app_database_test.dart`) reexecutados e estendidos com os testes próprios de `agenda_blocks` (TASK-025 CP-F).
5. `flutter analyze` e `flutter test` completos antes de considerar a migração concluída.
6. Migração registrada em `TASKS.md`/`docs/tasks/TASK-025.md`.

**Desvio documentado:** `dart run drift_dev schema dump` não funcionou nesta versão do `drift_dev` (incompatibilidade com `drift 2.34.2`); o snapshot do passo 1 foi construído manualmente copiando `tables.dart` e sobrescrevendo `tableName` de cada tabela legada para bater com os nomes físicos originais — aprovado explicitamente pelo PO/CTO como alternativa válida quando a ferramenta de dump automático não está disponível.

**Migrações seguintes (TASK-027):**

- **v2 → v3 (CP-B):** cria `financial_categories` e `financial_entries` (`from <= 2 && to >= 3`); snapshot legado `LegacyAppDatabaseV2`; testes de migração real (incluindo salto v1→v3).
- **v3 → v4 (CP-D):** adiciona `quote_id` em `financial_entries` com `from == 3` **estrito** — salto v1/v2→v4 cria a tabela já com a coluna via `createTable` atual, evitando "duplicate column"; snapshot legado `LegacyAppDatabaseV3`.

**Quando `schemaVersion` precisar avançar novamente (v4 → v5+), seguir o mesmo checklist:**

1. **Snapshot do schema anterior** — antes de alterar `tables.dart`, gerar um snapshot do schema vigente (ex.: `dart run drift_dev schema dump`) para servir de fixture real de "banco legado" nos testes de migração.
2. **Alteração incremental** — mudar `tables.dart` e incrementar `schemaVersion` em uma unidade por vez (nunca saltar versões).
3. **`onUpgrade` explícito** — implementar `onUpgrade` no `MigrationStrategy` tratando explicitamente o par `(from, to)` da transição real (ex.: `from == 1 && to == 2`), sem cobrir hipoteticamente versões que não existem; ao adicionar colunas em tabelas criadas em saltos, preferir condições `from == N` estritas quando o `createTable` da versão atual já inclui a coluna.
4. **Teste de migração real** — escrever um teste que abre o snapshot da versão anterior (passo 1), aplica a migração e confirma: dados antigos preservados, novas colunas/tabelas com defaults corretos, nenhuma perda de linhas.
5. **Testes de compatibilidade e constraints** — reexecutar os testes de `test/core/database/app_database_test.dart` (reabertura, cascades, PKs, `PRAGMA integrity_check`) contra o banco pós-migração.
6. **Suíte completa** — `flutter analyze` e `flutter test` completos antes de considerar a migração concluída.
7. **Documentar** — registrar a migração em `TASKS.md`/`docs/tasks/` com o motivo da mudança e o par de versões tratado.

Checklist validado na prática na TASK-025 CP-A e reaplicado na TASK-027 CP-B/CP-D; deve continuar sendo seguido em toda migração futura.

---

## 7. Fluxo de dados

### Escrita (padrão adotado por Clientes, Catálogo, Configurações e Orçamentos)

```text
Usuário → Screen → Notifier.method() async
                        │
                        ├─► Repository.insert/update/delete()
                        │         │
                        │         └─► DAO → SQLite
                        │
                        └─► state = novo estado em memória
```

### Leitura na sessão atual

- Notifiers servem estado da memória (`state`).
- `findById` e listagens leem do `state`, não do banco diretamente.

### Hidratação no startup (TASK-024 CP-F; estendido na TASK-025 CP-E)

```text
SplashScreen → appBootstrapProvider (AsyncNotifier)
           │
           └─► Future.wait(Repository.listAll() × 5)
                     │
                     └─► Notifier.hydrate(dados do SQLite)
```

Ao abrir o app, a `SplashScreen` aguarda o `appBootstrapProvider` (estado `loading`/`error`/`data`) antes de liberar a navegação — reiniciar o app não perde mais dados persistidos.

### Ocupação computada da Agenda (TASK-025 CP-C)

Diferente das demais features, a ocupação de orçamentos na Agenda **não é escrita nem hidratada** — é recomputada a cada leitura:

```text
agendaOccupancyProvider (Provider, sem estado próprio)
           │
           ├─► ref.watch(quotesProvider)        → propostas/confirmados (deriva de QuoteEventSnapshot)
           └─► ref.watch(agendaBlocksProvider)   → bloqueios manuais (persistidos)
                     │
                     └─► List<AgendaOccupancy> ordenada por start
```

- Nenhuma tabela, DAO, repository ou mapper para `AgendaOccupancy`.
- Qualquer mudança em um orçamento (status, evento) reflete na Agenda na próxima leitura do provider, sem sincronização manual.
- Somente `AgendaBlock` (bloqueio manual) segue o fluxo de escrita padrão (Notifier → Repository → DAO → SQLite).

### Agenda Inteligente — pipeline determinístico de disponibilidade (TASK-026)

Consultas de disponibilidade em português ("Tenho agenda livre hoje?") são resolvidas por uma cadeia de camadas **Dart puras** (sem Flutter, Riverpod, SQLite ou I/O), consumindo apenas a lista de `AgendaOccupancy` já computada pelo `agendaOccupancyProvider` — nenhum dado novo é lido, escrito ou persistido:

```text
Frase em português
      │
      ▼
AgendaAvailabilityRequestParser        (interpretação por regex/palavras-chave)
      │
      ├─ 1 dia/horário  → AgendaAvailabilityAnalyzer       (motor puro: free/partial/busy)
      └─ semana/mês/… → AgendaAvailabilityQueryService   (agrega o Analyzer dia a dia)
                              │
                              ▼
                  AgendaAvailabilityResponseFormatter      (texto PT-BR determinístico)
                              │
                              ▼
                  AgendaAvailabilityAssistantService       (orquestra as camadas acima)
                              │
                              ▼
                  AgendaAvailabilityQueryCard (widget na AgendaScreen)
```

- **Sem IA/LLM, sem rede, sem persistência nova** — todo o pipeline é determinístico: a mesma frase, com os mesmos dados, sempre produz a mesma resposta.
- **Sem provider novo:** a integração com a UI (`AgendaAvailabilityQueryCard`, um `ConsumerStatefulWidget`) reaproveita o `agendaBlockClockProvider` já existente (criado na TASK-025 para timestamps de `AgendaBlock`) para injetar o relógio no parser, em vez de criar um provider de relógio dedicado.
- Detalhes de regras (status `free`/`partial`/`busy`, conflitos, interpretação de frases, erros estruturados) em `docs/business-rules/agenda-inteligente.md`.

### Financeiro — domínio, serviços e relatórios (TASK-027)

```text
UI (telas + FinancialReportPanel)
      │
      ▼
Providers (entries/categories/filters/report query)
      │
      ▼
Services (Entry/Category/EventSummary/PeriodReport)
      │
      ├─► Calculators / Filter puros
      └─► Drift repositories → DAOs → SQLite (v4)
```

- Entidade única `FinancialEntry` + `FinancialFlowKind`; categorias tipadas; status × `paidAt` normalizados no serviço.
- Vínculo opcional `quoteId` → `Quotes.id` (`ON DELETE SET NULL`), sem duplicar dados do evento.
- Resumo global e relatório por período **reutilizam** `FinancialGlobalSummaryCalculator` / `FinancialEntryFilter` — a UI não recalcula dinheiro.
- Evolução mensal é estrutura tabular pronta para gráficos futuros (sem biblioteca de charts nesta task).
- Detalhes em `docs/business-rules/financial.md` e `docs/tasks/TASK-027.md`.

### Imagens e arquivos

- Referências (`imageReference`, `logoReference`) ficam no SQLite.
- Arquivos binários em storage local (`local_*_storage_service.dart`).
- Fluxo: stage → commit → referência salva no banco.

---

## 8. Organização das pastas

```text
lib/
  main.dart
  app/
    router/app_router.dart      # GoRouter — rotas centralizadas
    splash_screen.dart
  core/
    database/                   # Drift, DAOs, tabelas, providers
    theme/                      # Premium Dark
    widgets/                    # AppCard, AppTextField, PrimaryButton
    lookup/                     # CNPJ/CEP via BrasilAPI
    validation/                 # CPF, CNPJ, telefone, e-mail
    formatting/                 # máscaras brasileiras
    media/                      # picker, storage, validação de imagem
  features/
    dashboard/
    clients/
    catalog/
    quotes/
    settings/
    agenda/
    financial/

test/                           # espelha lib/features/ e lib/core/
docs/
  business-rules/               # regras por módulo
  tasks/                        # histórico TASK-001 … TASK-027
```

### Navegação (GoRouter)

- Rotas nomeadas centralizadas em `lib/app/router/app_router.dart`.
- Cada fluxo principal (clientes, catálogo, orçamentos, settings, agenda, financeiro) tem rota dedicada.
- Deep links e parâmetros de rota seguem convenção snake_case nos paths.
- Ocupações da Agenda originadas de orçamento **não** têm rota própria — abrem a rota já existente de detalhes do orçamento (`/quotes/:id`).
- Financeiro: `/financial`, `/financial/new`, `/financial/categories`, `/financial/:id`, `/financial/:id/edit`.

---

## 9. Princípios e convenções

- **Feature First** — código agrupado por funcionalidade.
- **Simplicidade** — camadas `presentation/domain/data` só quando a feature cresce.
- **snake_case** para arquivos; **PascalCase** para classes; **camelCase** para membros.
- Testes espelham a estrutura de `lib/` em `test/`.
- Firebase e sync online — **postergados**; arquitetura atual não depende deles.

---

## 10. Testes

| Tipo | Escopo |
|------|--------|
| Unitários | Mappers, validators, calculators, policies |
| Widget | Telas e componentes principais |
| Integração | Repositories Drift com banco in-memory (`AppDatabase.forTesting`) |
| E2E parcial | Fluxos de orçamento com helpers dedicados |

Sempre executar `flutter analyze` e `flutter test` após implementação (ver `CLAUDE.md`).

---

## 11. Evolução

- Novas features → nova pasta em `lib/features/`.
- Nova persistência → seguir padrão Repository + DAO + Mapper + Notifier async.
- Dado que é **função** de outras entidades já persistidas (ex.: `AgendaOccupancy` a partir de Orçamentos + Agenda) → computar via `Provider`, não criar tabela própria.
- Migrações de schema → seguir a Política de Migrações Futuras (seção 6); migrações reais: TASK-025 CP-A (v1 → v2), TASK-027 CP-B (v2 → v3) e CP-D (v3 → v4).
- Integrações externas → encapsuladas em `data/services/`, sem acoplar telas ao provider concreto.
- Evoluções previstas para a Agenda (IA/LLM na Agenda Inteligente, voz, Recursos, Contratos/Equipe/Fornecedores/Evento 360°) — ver `docs/business-rules/agenda.md` e `docs/business-rules/agenda-inteligente.md` (seções "Fora de escopo") e `docs/roadmap.md`.
- Evoluções do Financeiro (gráficos, exportações, multi-moeda, conciliação, fiscal, dashboards avançados) — ver `docs/business-rules/financial.md` e `docs/roadmap.md`.
- Lógica de negócio determinística e complexa (ex.: Agenda Inteligente, calculadoras financeiras) → construir em camadas Dart puras, testáveis isoladamente, **antes** de qualquer integração com UI/Riverpod; toda lógica dependente de "agora" deve receber relógio injetável desde o primeiro componente que o usa.
