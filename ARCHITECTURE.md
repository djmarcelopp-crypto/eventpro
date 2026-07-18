# Arquitetura — EventPro ERP

Documentação oficial da arquitetura do EventPro ERP. Descreve a estrutura atual do projeto, incluindo a camada de persistência local com Drift/SQLite (TASK-024), o módulo de Agenda com ocupação computada (TASK-025), a Agenda Inteligente — consultas de disponibilidade em português, deterministas e sem persistência (TASK-026) —, o módulo Financeiro com categorias, lançamentos, resumos e relatórios por período (TASK-027), o módulo Estoque & Equipamentos com inventário, vínculo a orçamentos e disponibilidade dinâmica (TASK-028), o módulo Equipe & Escalas com roster, vínculo a orçamentos e disponibilidade dinâmica (TASK-029), o módulo Logística & Transporte com frota, vínculo a orçamentos e disponibilidade logística dinâmica (TASK-030), o módulo Contratos & Assinaturas com modelos, contratos vinculados a orçamentos e fluxo interno de status (TASK-031) e o módulo Faturamento & Documentos Fiscais com faturas/itens, totais no serviço e fluxo interno de status (TASK-032).

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
| Estoque & Equipamentos | `equipment/` | ✅ Drift — `equipment_categories` + `equipment` (TASK-028 CP-B, schema v5); `quote_equipment` (CP-D, schema v6); disponibilidade **computada** (CP-F), nunca persistida; carregamento sob demanda |
| Equipe & Escalas | `team/` | ✅ Drift — `team_roles` + `team_members` (TASK-029 CP-B, schema v7); `quote_team_members` (CP-D, schema v8); disponibilidade **computada** (CP-F), nunca persistida; carregamento sob demanda |
| Logística & Transporte | `logistics/` | ✅ Drift — `vehicle_types` + `vehicles` (TASK-030 CP-B, schema v9); `quote_vehicles` (CP-D, schema v10); disponibilidade **computada** (CP-F), nunca persistida; carregamento sob demanda |
| Contratos & Assinaturas | `contracts/` | ✅ Drift — `contract_templates` + `contracts` (TASK-031 CP-B, schema v11); fluxo contratual interno (CP-F); sem PDF/assinatura externa; carregamento sob demanda |
| Faturamento & Documentos Fiscais | `billing/` | ✅ Drift — `invoices` + `invoice_items` (TASK-032 CP-B, schema v12); totais/numeração no serviço; matriz `InvoiceStatusTransitions`; workflow consulta a matriz (CP-F); resumo financeiro derivado (sem escrever Financeiro); sem PDF/NF-e/banco; carregamento sob demanda |

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
| `equipmentProvider` | Estoque | `AsyncNotifierProvider` | Inventário; load sob demanda via serviço (TASK-028 CP-E) |
| `equipmentCategoryProvider` | Estoque | `AsyncNotifierProvider` | Categorias de equipamento |
| `equipmentFiltersProvider` / `filteredEquipmentProvider` | Estoque | `Notifier` / `Provider` | Filtros de lista (categoria, status, nome) |
| `quoteEquipmentProvider` | Estoque | `AsyncNotifierProvider.family` | Linhas de equipamento por `quoteId` |
| `equipmentAvailabilityProvider` | Estoque | `FutureProvider` | Disponibilidade **computada** (TASK-028 CP-F) |
| `equipmentAvailabilitySummaryProvider` | Estoque | `FutureProvider` | Contagens fully / partial / unavailable |
| `teamMemberProvider` | Equipe | `AsyncNotifierProvider` | Roster; load sob demanda via serviço (TASK-029 CP-E) |
| `teamRoleProvider` | Equipe | `AsyncNotifierProvider` | Funções da equipe |
| `teamFiltersProvider` / `filteredTeamMembersProvider` | Equipe | `Notifier` / `Provider` | Filtros de lista (função, status, nome) |
| `quoteTeamProvider` | Equipe | `AsyncNotifierProvider.family` | Linhas de equipe por `quoteId` |
| `teamAvailabilityProvider` | Equipe | `FutureProvider` | Disponibilidade **computada** (TASK-029 CP-F) |
| `vehicleProvider` | Logística | `AsyncNotifierProvider` | Frota; load sob demanda via serviço (TASK-030 CP-E) |
| `vehicleTypeProvider` | Logística | `AsyncNotifierProvider` | Tipos de veículo |
| `quoteVehicleProvider` | Logística | `AsyncNotifierProvider.family` | Linhas de logística por `quoteId` |
| `vehicleAvailabilityProvider` | Logística | `FutureProvider` | Disponibilidade **computada** (TASK-030 CP-F) |
| `logisticsPlanSummaryProvider` | Logística | `FutureProvider` | Resumo de planejamento + frete planejado |
| `contractProvider` | Contratos | `AsyncNotifierProvider` | Contratos; load sob demanda via serviço (TASK-031 CP-E) |
| `contractTemplateProvider` | Contratos | `AsyncNotifierProvider` | Modelos de contrato |
| `quoteContractProvider` | Contratos | `AsyncNotifierProvider.family` | Contratos por `quoteId` |
| `contractListSummaryProvider` | Contratos | `Provider` | Contagens para listagem/dashboard |
| `contractWorkflowServiceProvider` | Contratos | `Provider` | Máquina de estados contratual (TASK-031 CP-F) |
| `contractWorkflowSummaryProvider` | Contratos | `Provider.family` | Próximos status permitidos por contrato |
| `invoiceProvider` | Faturamento | `AsyncNotifierProvider` | Faturas; load sob demanda via serviço (TASK-032 CP-E) |
| `quoteInvoiceProvider` | Faturamento | `AsyncNotifierProvider.family` | Faturas por `quoteId` |
| `invoiceListSummaryProvider` | Faturamento | `Provider` | Contagens/totais para listagem/dashboard |
| `invoiceFinancialSummaryProvider` | Faturamento | `FutureProvider.family` | Resumo financeiro derivado por orçamento |
| `invoiceWorkflowServiceProvider` | Faturamento | `Provider` | Coordena fluxo; consulta `InvoiceStatusTransitions` (TASK-032 CP-F) |
| `invoiceWorkflowSummaryProvider` | Faturamento | `Provider.family` | Flags de ação / próximo status / motivo de bloqueio |
| `teamAvailabilitySummaryProvider` | Equipe | `FutureProvider` | Totais disponíveis / indisponíveis / conflitos / percentual |
| `appBootstrapProvider` | Global | `AsyncNotifierProvider<void>` | Orquestra a hidratação dos cinco notifiers no startup (TASK-024 CP-F; estendido na TASK-025 CP-E) — **não** inclui Financeiro, Estoque, Equipe, Contratos nem Faturamento nesta fase |

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
| `EquipmentCategoryRepository` | `DriftEquipmentCategoryRepository` | `EquipmentCategoriesDao` |
| `EquipmentRepository` | `DriftEquipmentRepository` | `EquipmentsDao` |
| `QuoteEquipmentRepository` | `DriftQuoteEquipmentRepository` | `QuoteEquipmentDao` |

`AgendaOccupancy` **não** possui repository, DAO ou mapper — é sempre computado (seção 7). Agregações financeiras (`FinancialGlobalSummary`, `FinancialEventSummary`, `FinancialPeriodReport`) e de estoque (`EquipmentAvailability`, `EquipmentAvailabilitySummary`) também **não** são persistidas — são calculadas em utils/services.

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
- `schemaVersion`: **12** (v1 TASK-024; v2 TASK-025 `agenda_blocks`; v3–v4 TASK-027 financeiro; v5–v6 TASK-028 estoque; v7–v8 TASK-029 equipe; v9–v10 TASK-030 logística; v11 TASK-031 contratos; v12 TASK-032 faturamento).
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
    equipment_categories_dao.dart
    equipments_dao.dart
    quote_equipment_dao.dart
    team_roles_dao.dart
    team_members_dao.dart
    quote_team_members_dao.dart
    vehicle_types_dao.dart
    vehicles_dao.dart
    quote_vehicles_dao.dart
    contract_templates_dao.dart
    contracts_dao.dart
    invoices_dao.dart
    invoice_items_dao.dart
```

### Tabelas (schema v12)

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
| `equipment_categories` | Estoque | ✅ | v5 (TASK-028 CP-B) |
| `equipment` | Estoque | ✅ | v5 (TASK-028 CP-B) |
| `quote_equipment` | Estoque ↔ Orçamentos | ✅ | v6 (TASK-028 CP-D) |
| `team_roles` | Equipe | ✅ | v7 (TASK-029 CP-B) |
| `team_members` | Equipe | ✅ | v7 (TASK-029 CP-B) |
| `quote_team_members` | Equipe ↔ Orçamentos | ✅ | v8 (TASK-029 CP-D) |
| `vehicle_types` | Logística | ✅ | v9 (TASK-030 CP-B) |
| `vehicles` | Logística | ✅ | v9 (TASK-030 CP-B) |
| `quote_vehicles` | Logística ↔ Orçamentos | ✅ | v10 (TASK-030 CP-D) |
| `contract_templates` | Contratos | ✅ | v11 (TASK-031 CP-B) |
| `contracts` | Contratos ↔ Orçamentos | ✅ | v11 (TASK-031 CP-B) |
| `invoices` | Faturamento ↔ Orçamentos | ✅ | v12 (TASK-032 CP-B) |
| `invoice_items` | Faturamento | ✅ | v12 (TASK-032 CP-B) |

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

**Migrações seguintes (TASK-027 / TASK-028):**

- **v2 → v3 (TASK-027 CP-B):** cria `financial_categories` e `financial_entries` (`from <= 2 && to >= 3`); snapshot legado `LegacyAppDatabaseV2`; testes de migração real (incluindo salto v1→v3).
- **v3 → v4 (TASK-027 CP-D):** adiciona `quote_id` em `financial_entries` com `from == 3` **estrito** — salto v1/v2→v4 cria a tabela já com a coluna via `createTable` atual, evitando "duplicate column"; snapshot legado `LegacyAppDatabaseV3`.
- **v4 → v5 (TASK-028 CP-B):** cria `equipment_categories` e `equipment` (`from <= 4 && to >= 5`); snapshot legado v4.
- **v5 → v6 (TASK-028 CP-D):** cria `quote_equipment` (`from <= 5 && to >= 6`); FKs CASCADE (quote) / RESTRICT (equipment); snapshot legado v5.
- **v6 → v7 (TASK-029 CP-B):** cria `team_roles` e `team_members` (`from <= 6 && to >= 7`); snapshot legado v6.
- **v7 → v8 (TASK-029 CP-D):** cria `quote_team_members` (`from <= 7 && to >= 8`); FKs CASCADE (quote) / RESTRICT (member, role); snapshot legado v7.
- **v8 → v9 (TASK-030 CP-B):** cria `vehicle_types` e `vehicles` (`from <= 8 && to >= 9`); snapshot legado v8.
- **v9 → v10 (TASK-030 CP-D):** cria `quote_vehicles` (`from <= 9 && to >= 10`); FKs CASCADE (quote) / RESTRICT (vehicle, driver); snapshot legado v9.
- **v10 → v11 (TASK-031 CP-B):** cria `contract_templates` e `contracts` (`from <= 10 && to >= 11`); FK quote **RESTRICT**; FK template **SET NULL**; snapshot legado v10.
- **v11 → v12 (TASK-032 CP-B):** cria `invoices` e `invoice_items` (`from <= 11 && to >= 12`); FK quote **RESTRICT**; FK items→invoice **CASCADE**; snapshot legado v11.

**Quando `schemaVersion` precisar avançar novamente (v12 → v13+), seguir o mesmo checklist:**

1. **Snapshot do schema anterior** — antes de alterar `tables.dart`, gerar um snapshot do schema vigente (ex.: `dart run drift_dev schema dump`) para servir de fixture real de "banco legado" nos testes de migração.
2. **Alteração incremental** — mudar `tables.dart` e incrementar `schemaVersion` em uma unidade por vez (nunca saltar versões).
3. **`onUpgrade` explícito** — implementar `onUpgrade` no `MigrationStrategy` tratando explicitamente o par `(from, to)` da transição real (ex.: `from == 1 && to == 2`), sem cobrir hipoteticamente versões que não existem; ao adicionar colunas em tabelas criadas em saltos, preferir condições `from == N` estritas quando o `createTable` da versão atual já inclui a coluna.
4. **Teste de migração real** — escrever um teste que abre o snapshot da versão anterior (passo 1), aplica a migração e confirma: dados antigos preservados, novas colunas/tabelas com defaults corretos, nenhuma perda de linhas.
5. **Testes de compatibilidade e constraints** — reexecutar os testes de `test/core/database/app_database_test.dart` (reabertura, cascades, PKs, `PRAGMA integrity_check`) contra o banco pós-migração.
6. **Suíte completa** — `flutter analyze` e `flutter test` completos antes de considerar a migração concluída.
7. **Documentar** — registrar a migração em `TASKS.md`/`docs/tasks/` com o motivo da mudança e o par de versões tratado.

Checklist validado na prática na TASK-025 CP-A, reaplicado na TASK-027 CP-B/CP-D, TASK-028 CP-B/CP-D, TASK-029 CP-B/CP-D, TASK-030 CP-B/CP-D, TASK-031 CP-B e TASK-032 CP-B; deve continuar sendo seguido em toda migração futura.

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

### Estoque & Equipamentos — inventário e disponibilidade (TASK-028)

```text
UI (EquipmentScreen, categorias, QuoteEquipmentScreen)
      │
      ▼
Providers (equipment / categories / filters / quoteEquipment / availability)
      │
      ▼
Services (Equipment / Category / QuoteEquipment / Availability)
      │
      ├─► Calculators / Filter / PeriodResolver puros
      └─► Drift repositories → DAOs → SQLite (v6)
```

- Inventário operacional distinto do Catálogo comercial.
- `QuoteEquipment` planeja quantidades por orçamento — **não** reserva estoque nem altera `EquipmentStatus`.
- Disponibilidade = pico concorrente sobre períodos de eventos (`draft`/`sent`/`approved`); resultado **nunca** persistido.
- Detalhes em `docs/business-rules/equipment.md` e `docs/tasks/TASK-028.md`.

### Equipe & Escalas — roster e disponibilidade (TASK-029)

```text
UI (TeamScreen, funções, QuoteTeamScreen)
      │
      ▼
Providers (members / roles / filters / quoteTeam / availability)
      │
      ▼
Services (TeamMember / TeamRole / QuoteTeam / Availability)
      │
      ├─► Calculators / Filter / PeriodResolver puros
      └─► Drift repositories → DAOs → SQLite (v8)
```

- Roster operacional (`TeamRole` + `TeamMember`) com `TeamMemberStatus` cadastral.
- `QuoteTeamMember` planeja equipe por orçamento com snapshot de função/diária — **não** cria check-in/folha nem altera `TeamMemberStatus`.
- Disponibilidade = overlap de períodos entre orçamentos consumidores (`draft`/`sent`/`approved`); resultado **nunca** persistido.
- Detalhes em `docs/business-rules/team.md` e `docs/tasks/TASK-029.md`.

### Logística & Transporte — frota e disponibilidade (TASK-030)

```text
UI (VehiclesScreen, tipos, QuoteVehiclesScreen)
      │
      ▼
Providers (vehicles / types / filters / quoteVehicle / availability)
      │
      ▼
Services (Vehicle / VehicleType / QuoteVehicle / Availability)
      │
      ├─► Calculators / Filter / PeriodResolver puros
      └─► Drift repositories → DAOs → SQLite (v10)
```

- Frota operacional (`VehicleType` + `Vehicle`) com `VehicleStatus` cadastral.
- `QuoteVehicle` planeja transporte por orçamento (motorista opcional, frete, saída/retorno) — **não** cria GPS/rotas nem altera `VehicleStatus`.
- Disponibilidade = elegibilidade operacional + overlap de períodos logísticos (`draft`/`sent`/`approved`); resultado **nunca** persistido.
- Detalhes em `docs/business-rules/logistics.md` e `docs/tasks/TASK-030.md`.

### Contratos & Assinaturas — ciclo de vida (TASK-031)

```text
UI (ContractsScreen, templates, QuoteContractsScreen)
      │
      ▼
Providers (contracts / templates / filters / quoteContract / workflow)
      │
      ▼
Services (Contract / ContractTemplate / QuoteContract / Workflow)
      │
      └─► Drift repositories → DAOs → SQLite (v11)
```

- Modelos (`ContractTemplate`) e contratos (`Contract`) vinculados a orçamentos.
- Fluxo interno: `draft → generated → sent → signed`, com `cancelled` / `expired` controlados por `ContractWorkflowService` (**única fonte** da matriz de `ContractStatus`).
- `ContractService` persiste mudanças já autorizadas (`apply*`) — sem segunda matriz de transições.
- **Não** gera PDF nem integra assinatura digital nesta task.
- Detalhes em `docs/business-rules/contracts.md` e `docs/tasks/TASK-031.md`.

### Faturamento & Documentos Fiscais — ciclo de vida (TASK-032)

```text
UI (InvoicesScreen, detalhe, QuoteInvoicesScreen)
      │
      ▼
Providers (invoices / filters / quoteInvoice / financialSummary / workflow)
      │
      ▼
Services (Invoice / QuoteInvoice / FinancialSummary / Workflow)
      │  Workflow consulta InvoiceStatusTransitions (matriz única)
      └─► Drift repositories → DAOs → SQLite (v12)
```

- Faturas (`Invoice`) e itens (`InvoiceItem`) vinculados a orçamentos.
- Fluxo interno: `draft → issued → paid`, com `cancelled` controlado.
- **Matriz única:** `InvoiceStatusTransitions`; `InvoiceWorkflowService` coordena e resume para a UI sem segunda matriz.
- Totais e numeração (`INV-YYYY-####`) sempre no `InvoiceService`.
- `InvoiceFinancialSummary` é visão derivada — **não** escreve no módulo Financeiro.
- **Não** gera PDF, NF-e/NFS-e, boleto, PIX nem integra bancos nesta task.
- Detalhes em `docs/business-rules/billing.md` e `docs/tasks/TASK-032.md`.

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
    equipment/
    team/
    logistics/
    contracts/
    billing/

test/                           # espelha lib/features/ e lib/core/
docs/
  business-rules/               # regras por módulo
  tasks/                        # histórico TASK-001 … TASK-032
```

### Navegação (GoRouter)

- Rotas nomeadas centralizadas em `lib/app/router/app_router.dart`.
- Cada fluxo principal (clientes, catálogo, orçamentos, settings, agenda, financeiro, estoque, equipe, logística, contratos, faturamento) tem rota dedicada.
- Deep links e parâmetros de rota seguem convenção snake_case nos paths.
- Ocupações da Agenda originadas de orçamento **não** têm rota própria — abrem a rota já existente de detalhes do orçamento (`/quotes/:id`).
- Financeiro: `/financial`, `/financial/new`, `/financial/categories`, `/financial/:id`, `/financial/:id/edit`.
- Estoque: `/equipment`, `/equipment/new`, `/equipment/categories`, `/equipment/:id`, `/equipment/:id/edit`; associação: `/quotes/:id/equipment`.
- Equipe: `/team`, `/team/new`, `/team/roles`, `/team/:id`, `/team/:id/edit`; associação: `/quotes/:id/team`.
- Logística: `/vehicles`, `/vehicles/new`, `/vehicles/types`, `/vehicles/:id`, `/vehicles/:id/edit`; associação: `/quotes/:id/vehicles`.
- Contratos: `/contracts`, `/contracts/templates`, `/contracts/:id`; associação: `/quotes/:id/contracts`.
- Faturamento: `/invoices`, `/invoices/new`, `/invoices/:id`; associação: `/quotes/:id/invoices`.

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
- Migrações de schema → seguir a Política de Migrações Futuras (seção 6); migrações reais: TASK-025 CP-A (v1 → v2), TASK-027 CP-B (v2 → v3) e CP-D (v3 → v4), TASK-028 CP-B (v4 → v5) e CP-D (v5 → v6), TASK-029 CP-B (v6 → v7) e CP-D (v7 → v8), TASK-030 CP-B (v8 → v9) e CP-D (v9 → v10), TASK-031 CP-B (v10 → v11), TASK-032 CP-B (v11 → v12).
- Integrações externas → encapsuladas em `data/services/`, sem acoplar telas ao provider concreto.
- Evoluções previstas para a Agenda (IA/LLM na Agenda Inteligente, voz, Recursos, Contratos/Fornecedores/Evento 360°) — ver `docs/business-rules/agenda.md` e `docs/business-rules/agenda-inteligente.md` (seções "Fora de escopo") e `docs/roadmap.md`.
- Evoluções do Financeiro (gráficos, exportações, multi-moeda, conciliação, fiscal, dashboards avançados) — ver `docs/business-rules/financial.md` e `docs/roadmap.md`.
- Evoluções do Estoque (reservas efetivas, Agenda, QR/RFID, logística, manutenção preventiva) — ver `docs/business-rules/equipment.md` e `docs/roadmap.md`.
- Evoluções da Equipe (check-in/out, horas, folha, agenda visual, permissões, logística, comunicação) — ver `docs/business-rules/team.md` e `docs/roadmap.md`.
- Lógica de negócio determinística e complexa (ex.: Agenda Inteligente, calculadoras financeiras, disponibilidade de equipamentos/equipe/frota) → construir em camadas Dart puras, testáveis isoladamente, **antes** de qualquer integração com UI/Riverpod; toda lógica dependente de "agora" deve receber relógio injetável desde o primeiro componente que o usa.
