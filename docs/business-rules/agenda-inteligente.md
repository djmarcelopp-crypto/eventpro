# Regras de negócio — Agenda Inteligente

## Visão geral

A Agenda Inteligente permite consultar a disponibilidade da Agenda em português simples ("Tenho agenda livre hoje?", "Como está a próxima semana?") e receber uma resposta textual clara, **sem IA/LLM**. Toda a interpretação e análise seguem regras deterministas em Dart puro — a mesma pergunta, com os mesmos dados, sempre produz exatamente a mesma resposta.

A Agenda Inteligente **não duplica nem persiste nenhum dado**. Ela consome, em memória, a lista de `AgendaOccupancy` já computada por `agendaOccupancyProvider` (TASK-025 CP-C) — a mesma lista que alimenta a listagem visual da `AgendaScreen`. Nenhuma tabela, DAO, repository ou provider de persistência foi criado nesta task.

## Fluxo determinístico

```text
Frase em português
      │
      ▼
AgendaAvailabilityRequestParser.parse(phrase)
      │
      ├─ sucesso → AgendaAvailabilityRequest (intent + AgendaQuery + período opcional)
      │        │
      │        ├─ intent de 1 dia/horário → AgendaAvailabilityAnalyzer.analyze(...)
      │        └─ intent de semana/mês/intervalo → AgendaAvailabilityQueryService.run(...)
      │                 │
      │                 ▼
      │        AgendaAvailabilityResponseFormatter.formatDay/formatPeriod(...)
      │
      └─ falha → AgendaAvailabilityParseError (ambiguous | unsupported)
               │
               ▼
      AgendaAvailabilityResponseFormatter.formatError(...)
               │
               ▼
      AgendaAvailabilityResponse (texto PT-BR + kind: success | ambiguous | unsupported)
```

`AgendaAvailabilityAssistantService.ask({phrase, occupancies})` é o único ponto de entrada que orquestra todo o fluxo acima — nenhuma outra classe reimplementa essa orquestração.

## Componentes e responsabilidades

| Componente | Camada | Responsabilidade | Conhece |
|---|---|---|---|
| `AgendaAvailabilityAnalyzer` | Motor | Analisa `List<AgendaOccupancy>` contra um dia/intervalo e classifica `free`/`partial`/`busy` | Apenas `AgendaOccupancy` |
| `AgendaAvailabilityQueryService` | Orquestração multi-dia | Chama o Analyzer para cada dia civil de uma `AgendaQuery` e agrega o resultado | `AgendaAvailabilityAnalyzer` |
| `AgendaAvailabilityRequestParser` | Interpretação | Converte frase em português em `AgendaAvailabilityRequest` ou erro estruturado | Nada das camadas acima — apenas produz uma `AgendaQuery` |
| `AgendaAvailabilityResponseFormatter` | Apresentação | Converte resultados já computados em texto PT-BR determinístico | `AgendaAvailabilityResult`/`AgendaQueryResult`, nunca recalcula disponibilidade |
| `AgendaAvailabilityAssistantService` | Orquestração geral | Liga parser → analyzer/query service → formatter | Todas as camadas acima |
| `AgendaAvailabilityQueryCard` | UI | Campo, botão e exibição da resposta na `AgendaScreen` | Apenas o `AssistantService` — nenhuma regra própria |

Nenhum componente acima conhece `Quote`, `AgendaBlock`, SQLite, DAO ou Repository — apenas `AgendaOccupancy`, já unificado pela TASK-025.

## Regras de disponibilidade (`free` / `partial` / `busy`)

Aplicadas por `AgendaAvailabilityAnalyzer.analyze` a um único período (dia civil inteiro ou intervalo de horário explícito):

| Status | Condição |
|---|---|
| `free` | Nenhuma ocupação sobrepõe o período consultado |
| `partial` | Ao menos uma ocupação sobrepõe o período, mas resta ao menos um intervalo livre dentro dele |
| `busy` | As ocupações cobrem integralmente o período consultado, sem nenhum intervalo livre |

- **Período padrão:** quando nenhum horário é especificado na frase, o período é o dia civil inteiro (`00:00` até `00:00` do dia seguinte, horário local, sem conversão de fuso).
- **Período com horário explícito:** frases como "entre 14h e 18h" restringem o período a esse intervalo dentro do dia consultado.
- **Ocupações fora do período:** são ignoradas — não entram na lista de `occupancies` do resultado, não afetam o status.
- **Bordas de horário:** dois intervalos que apenas se tocam (um termina exatamente quando o outro começa) são tratados como contíguos, nunca como conflito ou gap — evita falso `partial` por causa de um "buraco" de zero segundos.
- **Eventos atravessando a meia-noite:** uma ocupação com `start`/`end` cruzando `00:00` é recortada corretamente ao período consultado; pode aparecer como `partial` em dois dias civis consecutivos (o dia em que começa e o dia em que termina).
- **Consultas de múltiplos dias (semana/mês/intervalo):** `AgendaAvailabilityQueryService` aplica a regra acima **dia a dia** e agrega o resultado em um resumo (`AgendaAvailabilitySummary`: contagem de dias livres/parciais/ocupados). O status agregado do período é `free` quando todos os dias são livres, `busy` quando todos são ocupados, e `partial` em qualquer outro caso.

## Conflitos

Um conflito é um par de `AgendaOccupancy` cujos intervalos se sobrepõem entre si (`AgendaOverlapChecker`, já existente desde a TASK-025 — regra "half-open": `firstStart < secondEnd && secondStart < firstEnd`). A Agenda Inteligente não recalcula essa regra — apenas reporta os pares encontrados dentro do período consultado.

- Em consultas de um único dia: todos os pares conflitantes entre as ocupações relevantes daquele dia.
- Em consultas de múltiplos dias: os conflitos de todos os dias são agregados e **deduplicados por par** — o mesmo par de ocupações que se sobrepõe em vários dias consecutivos é reportado uma única vez.

## Interpretação de frases em português (`AgendaAvailabilityRequestParser`)

Interpretador baseado em regras (palavras-chave e expressões regulares) — **sem IA/LLM, sem rede**. Reconhece exclusivamente os padrões abaixo; qualquer frase fora desse conjunto retorna erro `unsupported`.

| Padrão de frase | Intent resolvido |
|---|---|
| "hoje" | `today` |
| "amanhã" | `tomorrow` |
| Dia da semana (ex.: "sábado"), sem "próxim(o/a)" | `specificDay` (dentro da semana atual) |
| Dia da semana com "próxim(o/a)" | `specificDay` (semana seguinte) |
| Data explícita `dd/MM/yyyy` (uma ocorrência) | `specificDay` |
| Duas datas explícitas `dd/MM/yyyy` na mesma frase | `dateRange` |
| "semana que vem" / "próxima semana" / "semana seguinte" | `nextWeek` |
| "semana" (sem os termos acima) | `currentWeek` |
| "mês atual" / "este mês" | `currentMonth` |
| Nome de mês (ex.: "agosto") | `namedMonth` |
| "entre HHh e HHh" / "das HHh às HHh" associado a um dia já resolvido | `timeRange` |

### Regras de ambiguidade e erro

- **Ambígua:** a frase contém mais de um sinal de dia conflitante (ex.: "hoje" e "amanhã" na mesma pergunta), ou um intervalo de horário com o fim antes ou igual ao início.
- **Não suportada:** a frase não contém nenhum dos padrões reconhecidos, ou contém um intervalo de horário sem nenhum dia associado.
- Em ambos os casos, o retorno é um resultado estruturado (`AgendaAvailabilityParseResult.failure`) — **nunca uma exceção** — e a resposta final ao usuário nunca expõe nenhum dado real de disponibilidade, apenas um pedido de reformulação.

### Relógio injetável

Toda frase relativa ("hoje", "amanhã", "esta semana", dia da semana sem data explícita) depende de "agora". O parser recebe um `clock: DateTime Function()` (padrão `DateTime.now`), e a integração com a UI (CP-E) reaproveita o `agendaBlockClockProvider` já existente na Agenda (criado na TASK-025 para timestamps de `AgendaBlock`) — nenhum provider de relógio novo foi criado.

### Decisão de design aprovada: mês nomeado sem ano

Quando a frase menciona um mês sem ano explícito (ex.: "como está o mês de agosto?"), o mês resolvido é sempre o do **ano do relógio injetado** (isto é, o ano atual, salvo override em teste) — decisão explicitamente aprovada pelo PO/CTO no CP-C.

## Respostas textuais (`AgendaAvailabilityResponseFormatter`)

- Determinísticas: a mesma entrada estruturada sempre produz exatamente o mesmo texto.
- Em português do Brasil, com singular/plural corretos para dias, ocupações e conflitos (ex.: "Existe 1 ocupação." vs. "Existem 2 ocupações e 1 conflito.").
- Datas no formato `dd/MM/yyyy`, horários no formato `HH:mm`, ambos com zero à esquerda.
- Rótulos de período contextuais: "Nesta semana", "Na próxima semana", "Neste mês", "Em agosto", "No período de dd/MM/yyyy a dd/MM/yyyy".
- Mensagens de erro (ambígua/não suportada) são fixas e nunca incluem data, hora ou contagem de ocupações reais — apenas um pedido de reformulação.
- Nenhuma regra de disponibilidade é recalculada no formatter — ele só compõe texto sobre um `AgendaAvailabilityResult`/`AgendaQueryResult` já pronto.

## Integração com `AgendaOccupancy`

- A Agenda Inteligente **não lê `Quote` ou `AgendaBlock` diretamente** — opera exclusivamente sobre a lista de `AgendaOccupancy` já computada por `agendaOccupancyProvider`.
- Não há nenhuma leitura ou escrita adicional no banco: consultar a agenda não aciona `AgendaBlockRepository` além do que já era acionado pela hidratação normal da tela.
- Qualquer mudança em um orçamento ou bloqueio (via seus respectivos módulos) reflete automaticamente nas próximas consultas — não há cópia para sincronizar, pois nada é persistido.

## Interface de consulta (`AgendaAvailabilityQueryCard`)

- Card exibido no topo do corpo da `AgendaScreen`, acima da lista/estado vazio existente — visível sempre que há dados de ocupação carregados (estados de carregamento/erro da tela permanecem inalterados).
- Campo de texto para a pergunta em português, botão "Consultar", texto de resposta exibido abaixo.
- Proteção contra duplo clique: uma segunda tentativa de consulta antes da primeira concluir é ignorada.
- A resposta é limpa automaticamente sempre que o texto da pergunta é alterado.
- A lista de ocupações e os fluxos de criação/edição/exclusão de bloqueios manuais da Agenda permanecem inalterados e funcionam normalmente junto com a área de consulta.

## Fora de escopo desta fase

Registrado como evolução futura, sem implementação, arquitetura definida ou task associada nesta fase:

- **IA/LLM generativa** — toda a interpretação e resposta desta fase são deterministas, baseadas em regras; nenhuma chamada a modelo de linguagem foi feita ou está prevista.
- **Interface de voz** — entrada e saída são exclusivamente textuais.
- **Recursos de equipe e equipamentos** — a análise não considera disponibilidade de equipe/equipamentos (`AgendaResourceReservations`, fora de escopo desde a TASK-025).
- **Montagem e desmontagem** — sem granularidade adicional de setup/desmontagem por evento (`AgendaEventSchedules`, fora de escopo desde a TASK-025); a análise opera sobre o intervalo único de cada `AgendaOccupancy`.
- **Consultas mais livres e complexas** — o parser reconhece um conjunto fixo de padrões; perguntas fora desse conjunto (ex.: "consigo atender dois eventos no mesmo dia?", comparações, negociação de horário) retornam erro "não suportada", sem tentativa de inferência.
- **Chat/histórico de conversa** — cada chamada a `ask(...)` é independente; não há memória de perguntas anteriores.
- **Bloqueio automático de conflitos** — a Agenda Inteligente apenas relata conflitos existentes; não impede a criação de orçamentos ou bloqueios conflitantes (decisão final permanece com o usuário, consistente com `docs/business-rules/agenda.md`).
