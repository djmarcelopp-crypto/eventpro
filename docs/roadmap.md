# Roadmap — Ideias futuras do EventPro ERP

Registro de ideias de produto para fases futuras, fora do escopo das tasks ativas. Nenhum item aqui possui plano técnico, arquitetura definida ou aprovação de implementação — apenas a intenção registrada para priorização futura pelo Product Owner e CTO.

Ao promover um item deste roadmap para desenvolvimento, ele deve receber uma `TASK-XXX` própria com plano técnico completo, conforme `CLAUDE.md`.

---

## Agenda Inteligente e Análise de Disponibilidade

**Status:** Ideia registrada — sem task associada.

### Objetivo

Antes de elaborar um orçamento, permitir que o usuário consulte a disponibilidade de uma data e receba uma análise clara sobre eventos existentes, horários, montagem, desmontagem, equipe, equipamentos e possíveis conflitos.

### Funcionalidades futuras

- Consultar disponibilidade por data.
- Mostrar eventos confirmados, propostas e bloqueios.
- Considerar horário, montagem e desmontagem.
- Identificar disponibilidade total, parcial, conflito ou indisponibilidade.
- Verificar conflitos de equipe e equipamentos.
- Permitir perguntas em linguagem natural, como:
  - "Como está minha agenda no sábado?"
  - "Quais finais de semana de agosto estão livres?"
  - "Consigo atender dois eventos no mesmo dia?"
- Exibir justificativa da análise.
- Manter a decisão final com o usuário.

### Restrições

- Não altera o escopo da TASK-024 (Persistência local com Drift).
- Não deve ser antecipada antes da conclusão de CP-F, CP-G e CP-H da TASK-024.
- Sem task, arquitetura ou implementação definidas neste momento.
