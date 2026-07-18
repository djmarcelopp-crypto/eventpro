# TASK-031 — Contratos & Assinaturas

## Objetivo

Criar o módulo **Contratos & Assinaturas** do EventPro ERP: modelos reutilizáveis (`ContractTemplate`), contratos vinculados a orçamentos (`Contract`), UI de gestão, integração no detalhe do orçamento e dashboard, e **máquina de estados contratual interna** — sem PDF, sem assinatura digital externa e sem integrações de terceiros nesta task.

**Branch:** `cursor/task-031-contratos`

**Origem:** necessidade do MVP de registrar o ciclo de vida contratual a partir do orçamento (rascunho → gerado → enviado → assinado), com cancelamento e expiração controlados, preparando o terreno para PDF/assinatura em fases futuras.

## Arquitetura do fluxo

```text
UI (ContractsScreen, detalhe, templates, QuoteContractsScreen)
      │
      ▼
Providers / Notifiers (Riverpod)
  contractProvider / contractTemplateProvider
  contractFiltersProvider → filteredContractsProvider
  quoteContractProvider (family por quoteId)
  contractListSummaryProvider
  contractWorkflowServiceProvider / contractWorkflowSummaryProvider
      │
      ▼
Services (casos de uso — regras de negócio)
  ContractService / ContractTemplateService
  QuoteContractService
  ContractWorkflowService
      │
      └─► Repositories (somente leitura/escrita)
            DriftContractRepository
            DriftContractTemplateRepository
            (+ QuoteRepository para existência)
                  │
                  ▼
            DAOs → SQLite (schemaVersion 11)
```

- **Domínio puro (CP-A):** entidades, enums, validadores e contratos de repositório.
- **Persistência (CP-B):** tabelas Drift, DAOs, mappers, migração v10→v11.
- **Serviços (CP-C / CP-D):** regras fora de repositórios/DAOs; vínculo com orçamento sem UI.
- **Providers + UI (CP-E):** orquestração e apresentação — **nenhuma regra contratual na UI**.
- **Fluxo (CP-F):** matriz de transições e resumo de workflow; sem PDF/assinatura externa.
- **Carregamento:** sob demanda via `AsyncNotifier` — **não** hidratado no `appBootstrapProvider` nesta task.

## Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Fundação do domínio (entidades, enums, validadores, contratos) | *(pendente)* | ✅ Concluído |
| B | Persistência Drift — templates/contratos, migração v10→v11 | *(pendente)* | ✅ Concluído |
| C | Casos de uso — ContractService / ContractTemplateService | *(pendente)* | ✅ Concluído |
| D | QuoteContractSummary + QuoteContractService | *(pendente)* | ✅ Concluído |
| E | UI, providers, dashboard e seção em orçamentos | *(pendente)* | ✅ Concluído |
| F | Fluxo contratual interno (workflow + summary + providers) | *(pendente)* | ✅ Concluído |
| G | Documentação final — este documento, `docs/business-rules/contracts.md`, revisão de `ARCHITECTURE.md`/`PROJECT.md`/`TASKS.md`/`docs/roadmap.md` | *(pendente)* | ✅ Concluído |

**TASK-031 implementada nesta branch.** Commits aguardam aprovação do PO/CTO (trabalho ainda não versionado).

### Checkpoint A — Fundação do domínio ✅

- `Contract`, `ContractTemplate`, `ContractStatus`, `ContractSignatureStatus`
- Validadores e contratos `ContractRepository` / `ContractTemplateRepository`
- Sem Drift, providers ou UI

**Verificação:** `flutter analyze` (infos pré-existentes); `flutter test` com **1486** testes passando.

### Checkpoint B — Persistência Drift ✅

- Tabelas `contract_templates` e `contracts`
- DAOs, mappers e `Drift*Repository`
- `schemaVersion` **10 → 11**; FK quote **RESTRICT**; FK template **SET NULL**
- Snapshot legado v10

**Verificação:** `flutter test` com **1491** testes passando.

### Checkpoint C — Casos de uso ✅

- `ContractService` / `ContractTemplateService` com result objects
- Número automático `CTR-YYYY-####`; relógio injetável
- Transições básicas de status; sem PDF/assinatura

**Verificação:** `flutter test` com **1504** testes passando.

### Checkpoint D — Integração com Orçamentos ✅

- `QuoteContractSummary` / `QuoteContractService`
- Geração, cancelamento e consulta de status por orçamento
- Sem UI neste checkpoint

**Verificação:** `flutter test` com **1508** testes passando.

### Checkpoint E — UI e providers ✅

- Providers Riverpod (repos, services, clock, contracts/templates, filtros, quote contract family, list summary)
- Telas: listagem/consulta/cancelamento de contratos; CRUD/ativação de templates; `QuoteContractsScreen`
- Módulo e resumo no Dashboard (rascunho / enviados / assinados / expirados)
- Seção em detalhe do orçamento; schema **inalterado** (permanece v11)
- Dashboard: atalhos de módulos **antes** dos resumos (Equipe/Logística/Contratos)

**Verificação:** `flutter test` com **1522** testes passando.

### Checkpoint F — Fluxo contratual ✅

- `ContractWorkflowService` + `ContractWorkflowSummary`
- Happy path: `draft → generated → sent → signed`
- Cancelamento e expiração com bloqueios (sem assinar após cancelar; sem cancelar/expirar após assinar; sem regressão)
- Providers de workflow; sem PDF, sem assinatura digital, sem integração externa

**Verificação:** `flutter test` com **1536** testes passando.

### Checkpoint G — Documentação final ✅

- `docs/tasks/TASK-031.md` e `docs/business-rules/contracts.md` criados
- `ARCHITECTURE.md`, `PROJECT.md`, `TASKS.md` e `docs/roadmap.md` atualizados
- Nenhuma alteração em `lib/` / `test/` neste checkpoint — exclusivamente documental

**Verificação:** `flutter analyze` e `flutter test` com **1536** testes (suíte inalterada).

## Arquivos principais da task

```text
lib/features/contracts/
  models/          # Contract, Template, Status, SignatureStatus, Summary*, Workflow*
  data/
    mappers/
    repositories/  # interfaces + Drift*
  utils/           # validators, services, filters, workflow
  providers/
  widgets/
  *_screen.dart

lib/core/database/
  tables.dart                    # ContractTemplates, Contracts
  app_database.dart              # schemaVersion 11, onUpgrade v10→v11
  daos/contract*_dao.dart

test/features/contracts/         # unitários, providers, widgets, fakes
test/core/database/
  contract_migration_test.dart
  legacy_schema/legacy_*_v10*
```

## Testes e verificação

| Checkpoint | Testes totais |
|---|---|
| CP-A | 1486 |
| CP-B | 1491 |
| CP-C | 1504 |
| CP-D | 1508 |
| CP-E | 1522 |
| CP-F | 1536 |
| CP-G | 1536 (inalterado — checkpoint documental) |

## Lições aprendidas

1. **UI sem regras** — transições e bloqueios ficam em `ContractService` / `ContractWorkflowService`; telas só orquestram Result Objects.
2. **Workflow explícito** — `ContractWorkflowService` centraliza a matriz de estados mesmo quando a persistência já existe no `ContractService`.
3. **FK quote RESTRICT** — contrato não some com exclusão acidental de orçamento; template usa **SET NULL**.
4. **Dashboard: módulos primeiro** — resumos densos abaixo dos atalhos evitam regressão de hit-test em viewports curtas.
5. **`ContractSignatureStatus` no domínio** — preparado para fase futura; ainda **não** é coluna em `Contract`.
6. **Matriz única de status** — `ContractWorkflowService` valida/coordena; `ContractService` só persiste (`apply*`), sem segunda matriz.

## Fora de escopo (mantido)

- Geração de PDF do contrato
- Assinatura digital / provedores externos
- Envio automático por e-mail/WhatsApp
- Hidratação do módulo Contratos no bootstrap do app
- Persistência de `ContractSignatureStatus` como campo do contrato
- UI dedicada de auditoria de assinaturas

## Critérios de aceite (TASK-031)

- [x] Domínio, persistência (schema v11), serviços, UI e fluxo contratual documentados
- [x] Transições válidas e bloqueios (cancelamento/assinatura/expiração/regressão) cobertos por testes
- [x] Integração com orçamento e dashboard sem regras na UI
- [x] Sem PDF/assinatura externa nesta task
- [x] Testes passando em cada checkpoint; documentação alinhada à arquitetura
