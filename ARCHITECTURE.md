# Arquitetura — EventPro ERP

Documentação oficial da arquitetura do EventPro ERP. Descreve a estrutura atual do projeto, incluindo a camada de persistência local com Drift/SQLite (TASK-024).

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
| Clientes | `clients/` | ✅ Drift (CP-B) |
| Catálogo | `catalog/` | ⏳ Em memória — CP-D pendente |
| Orçamentos | `quotes/` | ⏳ Em memória — CP-E pendente |
| Configurações | `settings/` | ✅ Drift (CP-C) |

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
| `clientsProvider` | Clientes | `Notifier<List<Client>>` | Memória + escrita SQLite |
| `clientRepositoryProvider` | Clientes | `Provider<ClientRepository>` | — |
| `companyProfileProvider` | Settings | `Notifier<CompanyProfile?>` | Memória + escrita SQLite |
| `companyProfileRepositoryProvider` | Settings | `Provider<CompanyProfileRepository>` | — |
| `catalogProvider` | Catálogo | `Notifier<List<CatalogItem>>` | Memória (CP-D pendente) |
| `quotesProvider` | Orçamentos | `Notifier<List<Quote>>` | Memória (CP-E pendente) |

### Regras

- Notifiers expõem métodos `async` que persistem via repository e atualizam `state`.
- `build()` retorna estado inicial vazio até CP-F (hidratação no startup).
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

Operações de pacotes (catálogo) usarão transações no DAO para garantir atomicidade entre item e componentes.

---

## 6. Drift e SQLite

### Visão geral

- **Drift** é a camada ORM/type-safe sobre **SQLite**.
- Banco local: arquivo `eventpro.sqlite` (path resolvido por `database_path.dart`).
- `schemaVersion`: **1** (TASK-024 CP-A).
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
    # catalog_dao.dart — CP-D
    # quotes_dao.dart  — CP-E
```

### Tabelas (schema v1)

| Tabela | Feature | Status DAO |
|--------|---------|------------|
| `clients` | Clientes | ✅ |
| `company_profile` | Settings | ✅ |
| `catalog_items` | Catálogo | Schema pronto — DAO CP-D |
| `catalog_package_components` | Catálogo | Schema pronto — DAO CP-D |
| `quotes` + snapshots + lines + history + sequences | Orçamentos | Schema pronto — DAO CP-E |

### Geração de código

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 7. Fluxo de dados

### Escrita (padrão CP-B/C — em uso)

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

### Hidratação no startup (CP-F — pendente)

```text
main() → bootstrap async
           │
           └─► Repository.listAll() → Notifier.state = dados do SQLite
```

Até CP-F, reiniciar o app exibe listas vazias mesmo com dados persistidos no disco.

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

test/                           # espelha lib/features/ e lib/core/
docs/
  business-rules/               # regras por módulo
  tasks/                        # histórico TASK-001 … TASK-022
```

### Navegação (GoRouter)

- Rotas nomeadas centralizadas em `lib/app/router/app_router.dart`.
- Cada fluxo principal (clientes, catálogo, orçamentos, settings) tem rota dedicada.
- Deep links e parâmetros de rota seguem convenção snake_case nos paths.

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
- Migrações de schema → incrementar `schemaVersion` no CP-G com plano documentado.
- Integrações externas → encapsuladas em `data/services/`, sem acoplar telas ao provider concreto.
