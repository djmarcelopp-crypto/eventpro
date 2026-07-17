# Roadmap — Ideias futuras do EventPro ERP

Registro de ideias de produto para fases futuras, fora do escopo das tasks ativas. Nenhum item aqui possui plano técnico, arquitetura definida ou aprovação de implementação — apenas a intenção registrada para priorização futura pelo Product Owner e CTO.

Ao promover um item deste roadmap para desenvolvimento, ele deve receber uma `TASK-XXX` própria com plano técnico completo, conforme `CLAUDE.md`.

---

## Agenda Inteligente e Análise de Disponibilidade

**Status:** Parcialmente implementado — `TASK-026` (encerrada). Ver `docs/tasks/TASK-026.md` e `docs/business-rules/agenda-inteligente.md`.

### O que já foi entregue (TASK-026)

- Consultar disponibilidade por data, intervalo de datas, semana ou mês, em português simples, sem IA/LLM.
- Mostrar eventos confirmados, propostas e bloqueios (via `AgendaOccupancy`, já existente desde a TASK-025).
- Identificar disponibilidade total (`busy`), parcial (`partial`) ou livre (`free`), e conflitos entre ocupações.
- Perguntas em linguagem natural dentro de um conjunto fixo de padrões reconhecidos, como:
  - "Tenho agenda livre hoje?"
  - "Como está minha agenda no sábado?"
  - "Quais dias desta semana estão livres?"
  - "Como está o mês de agosto?"
- Exibir a justificativa em texto determinístico (contagem de ocupações e conflitos).
- Decisão final permanece com o usuário — a Agenda Inteligente não bloqueia nem decide nada automaticamente.

### O que permanece futuro (fora do escopo da TASK-026)

- **IA/LLM generativa** — a interpretação atual é baseada em regras fixas (regex/palavras-chave), não em modelo de linguagem; perguntas fora do conjunto reconhecido retornam erro "não suportada".
- **Interface de voz.**
- **Considerar horário de montagem e desmontagem** — a análise opera sobre o intervalo único de cada ocupação (`AgendaOccupancy`); granularidade adicional (`AgendaEventSchedules`) não foi criada.
- **Verificar conflitos de equipe e equipamentos** — depende de um modelo de recursos (`AgendaResourceReservations`) ainda não criado.
- **Consultas mais livres e complexas** — comparações, negociação de horário, perguntas compostas (ex.: "consigo atender dois eventos no mesmo dia?") fora do conjunto de padrões reconhecidos.
- **Chat/histórico de conversa** — cada consulta é independente, sem memória de perguntas anteriores.

### Restrições (herdadas, ainda válidas)

- Não deve ser antecipada antes da definição de task própria para os itens "O que permanece futuro" acima.
- Qualquer evolução deve manter a decisão final com o usuário — a Agenda Inteligente é uma ferramenta de análise, não de decisão automática.
