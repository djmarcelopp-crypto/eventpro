# EventPro ERP

## Visão Geral

O **EventPro ERP** é uma plataforma profissional para gerenciamento de empresas de eventos.

O objetivo é centralizar toda a operação da empresa em um único sistema.

---

## Empresa

DJ Marcelo PP Festas e Eventos

---

## Equipe

| Papel | Responsável |
|-------|-------------|
| Product Owner | Marcelo PP |
| CTO | ChatGPT |
| Software Engineer | Claude |

---

## Stack

| Camada | Tecnologia |
|--------|------------|
| Frontend | Flutter |
| Estado | Riverpod |
| Navegação | GoRouter |
| Persistência local | Drift |
| Banco local | SQLite |

### Integrações futuras (fora do escopo atual)

- Firebase (Auth, Firestore, Storage) — planejado para fase posterior
- Sincronização online/offline — planejado para fase posterior

---

## Status do Projeto

### TASK-024 — Persistência local com Drift

| Checkpoint | Descrição | Status |
|------------|-----------|--------|
| **CP-A** | Infraestrutura Drift (tabelas, `AppDatabase`, schema v1) | ✅ Concluído |
| **CP-B** | Persistência de clientes | ✅ Concluído |
| **CP-C** | Persistência de configurações da empresa | ✅ Concluído |
| **CP-D** | Persistência de catálogo e pacotes | ✅ Concluído |
| **CP-E** | Persistência de orçamentos | ✅ Concluído |
| **CP-F** | Bootstrap e hidratação no startup | ✅ Concluído |
| **CP-G** | Hardening e migrações | ✅ Concluído |
| **CP-H** | Documentação final da task | ✅ Concluído |

**TASK-024 encerrada.** Documento final: `docs/tasks/TASK-024.md`.

### TASK-025 — Agenda

| Checkpoint | Descrição | Status |
|------------|-----------|--------|
| **CP-A** | Migração real de schema v1→v2 e tabela `AgendaBlocks` | ✅ Concluído |
| **CP-B** | Repository, DAO, Mapper e Notifier de bloqueios manuais | ✅ Concluído |
| **CP-C** | Ocupação computada (`AgendaOccupancy`) e detecção de conflitos | ✅ Concluído |
| **CP-D** | Interface e rotas da Agenda | ✅ Concluído |
| **CP-E** | Bootstrap e hidratação no startup | ✅ Concluído |
| **CP-F** | Hardening da integridade do banco | ✅ Concluído |
| **CP-G** | Documentação final da task | ✅ Concluído |

**TASK-025 encerrada.** Documento final: `docs/tasks/TASK-025.md`.

### TASK-026 — Agenda Inteligente e Análise de Disponibilidade

| Checkpoint | Descrição | Status |
|------------|-----------|--------|
| **CP-A** | Motor puro de análise de disponibilidade (`AgendaAvailabilityAnalyzer`) | ✅ Concluído |
| **CP-B** | Serviço de consulta por dia/intervalo/semana/mês | ✅ Concluído |
| **CP-C** | Interpretação determinística de frases em português | ✅ Concluído |
| **CP-D** | Resposta textual determinística | ✅ Concluído |
| **CP-E** | Integração com a interface da Agenda | ✅ Concluído |
| **CP-F** | Hardening do pipeline completo | ✅ Concluído |
| **CP-G** | Documentação final da task | ✅ Concluído |

**TASK-026 encerrada.** Documento final: `docs/tasks/TASK-026.md`.

### TASK-027 — Financeiro

| Checkpoint | Descrição | Status |
|------------|-----------|--------|
| **CP-A** | Fundação do domínio (entidades, enums, validadores, contratos) | ✅ Concluído |
| **CP-B** | Persistência Drift — tabelas, DAOs, mappers, migração v2→v3 | ✅ Concluído |
| **CP-C** | Casos de uso — categorias, lançamentos, status × paidAt | ✅ Concluído |
| **CP-D** | Vínculo `quoteId` + resumo por orçamento (schema v3→v4) | ✅ Concluído |
| **CP-E** | UI, providers, resumo global e filtros | ✅ Concluído |
| **CP-F** | Relatórios por período (reuso de filtros/calculadoras) | ✅ Concluído |
| **CP-G** | Documentação final da task | ✅ Concluído |

**TASK-027 encerrada.** Documento final: `docs/tasks/TASK-027.md`. Regras: `docs/business-rules/financial.md`.

### TASK-028 — Estoque & Equipamentos

| Checkpoint | Descrição | Status |
|------------|-----------|--------|
| **CP-A** | Fundação do domínio (entidades, enums, validadores, contratos) | ✅ Concluído |
| **CP-B** | Persistência Drift — categorias/equipamentos, migração v4→v5 | ✅ Concluído |
| **CP-C** | Casos de uso — EquipmentService / EquipmentCategoryService | ✅ Concluído |
| **CP-D** | QuoteEquipment + serviço + migração v5→v6 | ✅ Concluído |
| **CP-E** | UI, providers, filtros e associação a orçamentos | ✅ Concluído |
| **CP-F** | Disponibilidade dinâmica (calculator + service + providers) | ✅ Concluído |
| **CP-G** | Documentação final da task | ✅ Concluído |

**TASK-028 encerrada.** Documento final: `docs/tasks/TASK-028.md`. Regras: `docs/business-rules/equipment.md`.

### TASK-029 — Equipe & Escalas

| Checkpoint | Descrição | Status |
|------------|-----------|--------|
| **CP-A** | Fundação do domínio (entidades, enums, validadores, contratos) | ✅ Concluído |
| **CP-B** | Persistência Drift — roles/membros, migração v6→v7 | ✅ Concluído |
| **CP-C** | Casos de uso — TeamMemberService / TeamRoleService | ✅ Concluído |
| **CP-D** | QuoteTeamMember + serviço + migração v7→v8 | ✅ Concluído |
| **CP-E** | UI, providers, dashboard e seção em orçamentos | ✅ Concluído |
| **CP-F** | Disponibilidade dinâmica (calculator + service + providers) | ✅ Concluído |
| **CP-G** | Documentação final da task | ✅ Concluído |

**TASK-029 encerrada.** Documento final: `docs/tasks/TASK-029.md`. Regras: `docs/business-rules/team.md`.

### TASK-030 — Logística & Transporte

| Checkpoint | Descrição | Status |
|------------|-----------|--------|
| **CP-A** | Fundação do domínio (entidades, enums, validadores, contratos) | ✅ Concluído |
| **CP-B** | Persistência Drift — tipos/veículos, migração v8→v9 | ✅ Concluído |
| **CP-C** | Casos de uso — VehicleService / VehicleTypeService | ✅ Concluído |
| **CP-D** | QuoteVehicle + serviço + migração v9→v10 | ✅ Concluído |
| **CP-E** | UI, providers, dashboard e seção em orçamentos | ✅ Concluído |
| **CP-F** | Disponibilidade logística dinâmica (calculator + service + providers) | ✅ Concluído |
| **CP-G** | Documentação final da task | ✅ Concluído |

**TASK-030 implementada.** Documento final: `docs/tasks/TASK-030.md`. Regras: `docs/business-rules/logistics.md`.

### TASK-031 — Contratos & Assinaturas

| Checkpoint | Descrição | Status |
|------------|-----------|--------|
| **CP-A…G** | Domínio → persistência v11 → serviços → UI → workflow → docs | ✅ Concluído |

**TASK-031 implementada.** Documento final: `docs/tasks/TASK-031.md`. Regras: `docs/business-rules/contracts.md`.

### TASK-032 — Faturamento & Documentos Fiscais

| Checkpoint | Descrição | Status |
|------------|-----------|--------|
| **CP-A** | Fundação do domínio (entidades, enums, validadores, contratos) | ✅ Concluído |
| **CP-B** | Persistência Drift — invoices/items, migração v11→v12 | ✅ Concluído |
| **CP-C** | Casos de uso — InvoiceService (numeração, totais, transições) | ✅ Concluído |
| **CP-D** | QuoteInvoiceSummary + QuoteInvoiceService | ✅ Concluído |
| **Gate** | Numeração, totais, matriz única, finance desacoplado | ✅ Concluído |
| **CP-E** | UI, providers, dashboard e seção em orçamentos | ✅ Concluído |
| **CP-F** | Fluxo de faturamento (workflow + summary + providers) | ✅ Concluído |
| **CP-G** | Documentação final da task | ✅ Concluído |

**TASK-032 implementada.** Documento final: `docs/tasks/TASK-032.md`. Regras: `docs/business-rules/billing.md`. Commits aguardam aprovação do PO/CTO.

### Branch e commit atuais

| Campo | Valor |
|-------|-------|
| Branch | `cursor/task-032-faturamento` |
| Último commit | *(base da branch — TASK-031 tip)* |
| Alterações locais | TASK-032 CP-A…G (+ gate Bloco 1) implementados e verificados — **sem commit** (aguardando PO/CTO) |
| Próximo checkpoint | Nenhum — aguardando versionamento e definição da próxima task pelo Product Owner |

---

## Plataformas

- Windows (prioridade MVP)
- Web (segunda prioridade)
- macOS
- Android
- iPhone

---

## Objetivos do Produto

O sistema deverá possuir:

- Cadastro de clientes
- Cadastro de equipamentos, serviços e pacotes (catálogo)
- Orçamentos com geração de PDF
- Configurações da empresa
- Dashboard
- Agenda (propostas, confirmados e bloqueios manuais)
- Financeiro (categorias, lançamentos, resumos e relatórios por período — TASK-027)
- Estoque & Equipamentos (inventário operacional, vínculo a orçamentos e disponibilidade dinâmica — TASK-028)
- Equipe & Escalas (roster, vínculo a orçamentos e disponibilidade dinâmica — TASK-029)
- Logística & Transporte (frota, vínculo a orçamentos e disponibilidade logística dinâmica — TASK-030)
- Contratos & Assinaturas (modelos, contratos por orçamento e fluxo interno de status — TASK-031; PDF/assinatura digital — fases futuras)
- Faturamento & Documentos Fiscais (faturas/itens por orçamento, totais e fluxo interno — TASK-032; PDF/NF-e/boleto/PIX/bancos — fases futuras)
- Gráficos/exportações financeiras avançadas, reservas efetivas de estoque, check-in/folha de equipe, GPS/rotas e IA — **fases futuras**

---

## MVP em andamento

Funcionalidades entregues ou em desenvolvimento no MVP:

- Dashboard
- Clientes (persistência local — TASK-024 CP-B)
- Catálogo: equipamentos, serviços e pacotes (persistência local — TASK-024 CP-D)
- Orçamentos com PDF e exportação (persistência local do grafo completo — TASK-024 CP-E)
- Configurações da empresa (persistência local — TASK-024 CP-C)
- Agenda: propostas e confirmados computados a partir dos orçamentos + bloqueios manuais persistidos (TASK-025 CP-A a CP-C)
- Agenda Inteligente: consultas de disponibilidade em português, deterministas e sem persistência, integradas à tela de Agenda (TASK-026)
- Financeiro: categorias e lançamentos persistidos (schema v4+), vínculo opcional a orçamentos, resumo global, filtros e relatórios por período (TASK-027)
- Estoque & Equipamentos: categorias e inventário (schema v5), vínculo `quote_equipment` (schema v6), UI de gestão e disponibilidade dinâmica sem persistir quantidades derivadas (TASK-028)
- Equipe & Escalas: funções e colaboradores (schema v7), vínculo `quote_team_members` (schema v8), UI de gestão e disponibilidade dinâmica sem persistir estado derivado (TASK-029)
- Logística & Transporte: tipos e veículos (schema v9), vínculo `quote_vehicles` (schema v10), UI de gestão e disponibilidade logística dinâmica sem persistir estado derivado (TASK-030)
- Contratos & Assinaturas: templates e contratos (schema v11), UI de gestão, integração com orçamento/dashboard e fluxo interno de status sem PDF/assinatura externa (TASK-031)
- Faturamento & Documentos Fiscais: invoices/items (schema v12), UI de gestão, integração com orçamento/dashboard, resumo financeiro derivado e fluxo interno de status sem PDF/NF-e/banco (TASK-032)
- Hidratação automática de clientes, catálogo, configurações da empresa, orçamentos e bloqueios da Agenda ao iniciar o app (TASK-024 CP-F; TASK-025 CP-E); Financeiro, Estoque, Equipe, Logística, Contratos e Faturamento carregam sob demanda ao abrir o módulo

---

## Tema

**Premium Dark**

Cores: Preto · Dourado · Branco

---

## Missão

Criar o melhor software de gestão para empresas de eventos do Brasil.
