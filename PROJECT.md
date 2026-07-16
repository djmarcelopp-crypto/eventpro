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
| CP-H | Documentação final da task | 🔄 Próximo |

### Branch e commit atuais

| Campo | Valor |
|-------|-------|
| Branch | `cursor/task-024-local-persistence` |
| Último commit | `e424d1f` — `feat(app): hydrate persisted data on startup` |
| Alterações locais | Nenhuma — CP-G commitado e enviado ao remoto |
| Próximo checkpoint | **CP-H** |

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
- Agenda, contratos, financeiro, equipe, estoque, relatórios e IA — **fases futuras**

---

## MVP em andamento

Funcionalidades entregues ou em desenvolvimento no MVP:

- Dashboard
- Clientes (persistência local — CP-B)
- Catálogo: equipamentos, serviços e pacotes (persistência local — CP-D)
- Orçamentos com PDF e exportação (persistência local do grafo completo — CP-E)
- Configurações da empresa (persistência local — CP-C)
- Hidratação automática de clientes, catálogo, configurações da empresa e orçamentos ao iniciar o app (CP-F)

---

## Tema

**Premium Dark**

Cores: Preto · Dourado · Branco

---

## Missão

Criar o melhor software de gestão para empresas de eventos do Brasil.
