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

### Branch e commit atuais

| Campo | Valor |
|-------|-------|
| Branch | `cursor/task-027-financeiro` |
| Último commit | `936e952` — `feat(financial): add period reports reusing existing summary calculators` |
| Alterações locais | CP-G documental implementado e verificado — aguardando aprovação para commit |
| Próximo checkpoint | Nenhum — aguardando definição da próxima task pelo Product Owner |

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
- Contratos, equipe, estoque, gráficos/exportações financeiras avançadas e IA — **fases futuras**

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
- Financeiro: categorias e lançamentos persistidos (schema v4), vínculo opcional a orçamentos, resumo global, filtros e relatórios por período (TASK-027)
- Hidratação automática de clientes, catálogo, configurações da empresa, orçamentos e bloqueios da Agenda ao iniciar o app (TASK-024 CP-F; TASK-025 CP-E); Financeiro carrega sob demanda ao abrir o módulo

---

## Tema

**Premium Dark**

Cores: Preto · Dourado · Branco

---

## Missão

Criar o melhor software de gestão para empresas de eventos do Brasil.
