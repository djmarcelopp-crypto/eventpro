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
| **D** | **Catálogo e pacotes — DAO, repository, mapper, `CatalogNotifier` async** | — | **🔄 Atual** |
| E | Orçamentos — grafo completo, sequência de números | — | ⏳ Pendente |
| F | Bootstrap e hidratação — carregar SQLite no startup | — | ⏳ Pendente |
| G | Hardening e migrações de schema | — | ⏳ Pendente |
| H | Documentação — `docs/tasks/TASK-024.md`, business-rules | — | ⏳ Pendente |

### Checkpoint atual: CP-D

**Escopo:**

- `CatalogDao` com transações para itens e componentes de pacote
- `CatalogRepository` / `DriftCatalogRepository`
- `CatalogItemMapper` (preço em centavos, enums, snapshots de componentes)
- Refatorar `CatalogNotifier` para operações async com escrita SQLite
- Ajustar telas e coordinator de exclusão para `await`
- Testes de mapper, repository e notifier

**Fora de escopo do CP-D:**

- Hidratação no startup (CP-F)
- Persistência de orçamentos (CP-E)
- Atualização de `docs/business-rules/catalog.md` (CP-H)
- Migrações de schema

**Último commit:** `0fc0e89`
