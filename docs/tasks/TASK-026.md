# TASK-026 — Agenda Inteligente e Análise de Disponibilidade

## Objetivo

Permitir que o usuário pergunte, em português simples, sobre a disponibilidade da Agenda ("Tenho agenda livre hoje?", "Quais dias desta semana estão livres?") e receba uma resposta textual determinística — **sem IA/LLM, sem rede, sem persistência nova**. Toda a interpretação, análise e resposta são construídas por regras deterministas em Dart puro, operando exclusivamente sobre `AgendaOccupancy` (já existente, TASK-025 CP-C).

**Branch:** `cursor/task-026-agenda-inteligente`

**Origem:** ideia registrada em `docs/roadmap.md` ("Agenda Inteligente e Análise de Disponibilidade"), promovida a task após o encerramento da TASK-025.

## Arquitetura do fluxo

```text
Frase em português
      │
      ▼
AgendaAvailabilityRequestParser        (CP-C — interpretação determinística)
      │  AgendaAvailabilityParseResult (sucesso → AgendaAvailabilityRequest
      │                                  | falha → AgendaAvailabilityParseError)
      ▼
 ┌────────────────────────────┬─────────────────────────────────┐
 │ intent de 1 dia/intervalo  │ intent de semana/mês/intervalo   │
 │ (hoje, amanhã, dia         │ de datas (semana atual/próxima,  │
 │  específico, horário)      │  mês atual/nomeado, dateRange)   │
 ▼                            ▼
AgendaAvailabilityAnalyzer     AgendaAvailabilityQueryService
(CP-A — motor puro)            (CP-B — orquestra o Analyzer por dia)
 │                            │
 └────────────┬───────────────┘
              ▼
AgendaAvailabilityResponseFormatter    (CP-D — texto PT-BR determinístico)
              ▼
AgendaAvailabilityAssistantService     (CP-D — orquestra parser → analyzer/
              │                          query service → formatter)
              ▼
AgendaAvailabilityQueryCard (UI)       (CP-E — campo + botão + resposta
              │                          na AgendaScreen)
              ▼
       AgendaOccupancy (lista já computada por agendaOccupancyProvider,
                         TASK-025 CP-C — apenas consumida, nunca duplicada)
```

Nenhum componente do CP-A ao CP-D conhece Flutter, Riverpod, SQLite ou UI — são funções/classes Dart puras, testáveis isoladamente e em conjunto. Somente o CP-E (widget) depende de Riverpod, e apenas para ler `agendaBlockClockProvider` (já existente, reaproveitado) e reagir ao `agendaOccupancyProvider` (leitura, sem escrita).

## Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Motor puro de análise de disponibilidade (`AgendaAvailabilityAnalyzer`) | `f058d00` | ✅ Concluído |
| B | Serviço de consulta por dia/intervalo/semana/mês (`AgendaAvailabilityQueryService`) | `fe0129f` | ✅ Concluído |
| C | Interpretação de frases em português (`AgendaAvailabilityRequestParser`) | `49b4c66` | ✅ Concluído |
| D | Resposta textual determinística (`AgendaAvailabilityResponseFormatter` + `AgendaAvailabilityAssistantService`) | `52f3a2e` | ✅ Concluído |
| E | Integração com a interface da Agenda (`AgendaAvailabilityQueryCard`) | `bffb6db` | ✅ Concluído |
| F | Hardening — testes ponta a ponta, virada de mês/ano, meia-noite, ausência de efeitos colaterais | `fd73d84` | ✅ Concluído |
| G | Documentação final — este documento, `docs/business-rules/agenda-inteligente.md`, revisão de `ARCHITECTURE.md`/`PROJECT.md`/`TASKS.md`/`docs/roadmap.md` | *(pendente de aprovação/commit)* | ✅ Concluído |

**TASK-026 encerrada.** Histórico completo dos checkpoints abaixo.

### Checkpoint A — Motor de análise de disponibilidade ✅

- `AgendaAvailabilityAnalyzer`: classe estática pura, recebe `List<AgendaOccupancy>`, uma data e um horário/intervalo opcional; devolve `AgendaAvailabilityResult` (status `free`/`partial`/`busy`, motivo técnico, ocupações relevantes, intervalos livres e conflitos)
- `AgendaAvailabilityResult`, `AgendaAvailabilityStatus`, `AgendaFreeInterval`, `AgendaOccupancyConflict` — novos modelos, sem persistência
- Período padrão (sem `periodStart`/`periodEnd`): dia civil inteiro `00:00`–`00:00` do dia seguinte; ambos os parâmetros devem ser informados juntos ou omitidos (`ArgumentError` caso contrário)
- Regra de bordas: intervalos que apenas se tocam (fim de um = início do outro) são mesclados, evitando "falso conflito" ou gap de zero segundos
- Ocupações que atravessam a meia-noite são recortadas corretamente ao período consultado, podendo aparecer como parciais em dois dias consecutivos
- Opera exclusivamente sobre `AgendaOccupancy` — sem conhecimento de `Quote`, `AgendaBlock`, Riverpod ou banco

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 924 testes passando.

**Fora de escopo do CP-A (mantido):** consultas de múltiplos dias (CP-B), interpretação de linguagem natural (CP-C), resposta textual (CP-D), UI (CP-E).

**Commit:** `f058d00` — `feat(agenda): analyze agenda availability`

### Checkpoint B — Serviço de consulta (dia, intervalo, semana, mês) ✅

- `AgendaQuery`: representa uma consulta estruturada resolvida em intervalo de datas civis inclusivo (`day`, `dateRange`, `week` — segunda a domingo —, `month`); expõe `days` (lista de dias civis do período)
- `AgendaAvailabilityQueryService`: itera `query.days`, chama `AgendaAvailabilityAnalyzer.analyze` para cada dia civil e agrega o resultado — **nenhuma regra de disponibilidade é reimplementada**, apenas orquestrada
- `AgendaDailyAvailability`, `AgendaAvailabilitySummary` (contagem de dias livres/parciais/ocupados), `AgendaQueryResult` (período, status agregado, resultados diários, conflitos deduplicados, resumo)
- Conflitos agregados são deduplicados por par de ocupações, mesmo quando o mesmo par aparece em vários dias do período consultado

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 941 testes passando.

**Fora de escopo do CP-B (mantido):** interpretação de linguagem natural (CP-C), resposta textual (CP-D), UI (CP-E), IA/LLM.

**Commit:** `fe0129f` — `feat(agenda): query agenda availability by day, range, week and month`

### Checkpoint C — Interpretação determinística de frases em português ✅

- `AgendaAvailabilityRequestParser`: interpretador baseado em regras (regex + palavras-chave), **sem LLM, sem rede**; recebe uma frase em português e produz um `AgendaAvailabilityRequest` (intent + `AgendaQuery` + `periodStart`/`periodEnd` opcionais) ou um erro estruturado
- `AgendaAvailabilityIntent` (`today`, `tomorrow`, `specificDay`, `currentWeek`, `nextWeek`, `currentMonth`, `namedMonth`, `dateRange`, `timeRange`)
- `AgendaAvailabilityParseResult`/`AgendaAvailabilityParseError` (`ambiguous`/`unsupported`) — padrão de resultado (sucesso/falha), sem exceções propagando para o chamador
- Suporta: "hoje", "amanhã", dia da semana (atual/próxima semana), datas explícitas `dd/MM/yyyy`, intervalo de datas, semana atual/próxima, mês atual/nomeado, intervalo de horário (`entre HHh e HHh`)
- Relógio injetável (`clock: DateTime Function()`), padrão `DateTime.now`, override em testes — todas as frases relativas ("hoje", "esta semana") são determinísticas sob teste
- Detecção de ambiguidade (ex.: "hoje ou amanhã" — mais de um sinal de dia conflitante) e de horário final antes do inicial
- **Decisão de design registrada:** mês nomeado sem ano (ex.: "mês de agosto") sempre resolve para o ano do relógio injetado — aprovada pelo PO/CTO

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 965 testes passando.

**Fora de escopo do CP-C (mantido):** resposta textual (CP-D), UI (CP-E), IA/LLM, voz, chat.

**Commit:** `49b4c66` — `feat(agenda): parse structured availability requests`

### Checkpoint D — Resposta textual determinística ✅

- `AgendaAvailabilityResponseFormatter`: converte `AgendaAvailabilityResult` (1 dia/intervalo) ou `AgendaQueryResult` (semana/mês/intervalo de datas) em texto PT-BR determinístico — nenhuma regra de disponibilidade é recalculada, apenas composição de texto sobre dados já prontos
- `AgendaAvailabilityResponse`/`AgendaAvailabilityResponseKind` (`success`/`ambiguous`/`unsupported`)
- `AgendaAvailabilityAssistantService`: orquestra parser (CP-C) → analyzer/query service (CP-A/B) → formatter, expondo um único método `ask({phrase, occupancies})`
- Singular/plural corretos para dias, ocupações e conflitos; datas `dd/MM/yyyy` e horários `HH:mm` com zero à esquerda; rótulos de período contextuais ("Nesta semana", "Na próxima semana", "Em agosto", "No período de... a...")
- Mensagens de erro (ambíguo/não suportado) nunca expõem dado real de disponibilidade — apenas pedem reformulação

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 994 testes passando.

**Fora de escopo do CP-D (mantido):** UI (CP-E), IA/LLM, rede, Riverpod, SQLite, chat.

**Commit:** `52f3a2e` — `feat(agenda): generate deterministic availability responses`

### Checkpoint E — Integração com a interface da Agenda ✅

- `AgendaAvailabilityQueryCard` (novo widget, `ConsumerStatefulWidget`): campo de pergunta em português, botão "Consultar", resposta textual exibida abaixo — inserido no topo do corpo da `AgendaScreen`, acima da lista/estado vazio existente
- Reaproveita `agendaBlockClockProvider` (já existente, usado para timestamps de `AgendaBlock`) para injetar o relógio no parser — nenhum provider novo criado
- Recebe a lista de `AgendaOccupancy` já computada por `agendaOccupancyProvider` como parâmetro — nenhuma leitura adicional, nenhuma duplicação de dados
- Proteção contra duplo clique: `_onQuery` é `async` com um `await Future<void>.delayed(Duration.zero)` antes de computar a resposta (a própria computação é síncrona/determinística), criando um ponto de suspensão real que o guard `_isQuerying` intercepta
- Resposta é limpa (`setState(_response = null)`) sempre que o texto do campo muda
- Resposta de erro estilizada com `AppColors.error`, mas o significado está no próprio texto (não depende só de cor)
- Ajuste necessário em teste pré-existente (`ensureVisible` antes do tap no botão "Novo bloqueio" do estado vazio, que ficou fora da viewport padrão de teste após o novo card)

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 1002 testes passando.

**Fora de escopo do CP-E (mantido):** IA/LLM, rede, persistência nova, schema, DAO, repository, bootstrap.

**Commit:** `bffb6db` — `feat(agenda): add intelligent availability queries to agenda`

### Checkpoint F — Hardening ✅

- Revisão do fluxo completo (frase → parser → analyzer/query service → formatter → assistant service → UI) — nenhum defeito real encontrado, nenhuma alteração em `lib/`
- 11 testes de integração ponta a ponta novos (`agenda_availability_end_to_end_test.dart`), exercitando a cadeia completa via `AgendaAvailabilityAssistantService.ask(...)`: datas relativas com relógio injetável, virada de ano ("amanhã" em 31/12, "próxima semana" cruzando o ano), regra de mês nomeado sem ano em anos diferentes, ocupação atravessando a meia-noite (parcial nos dois dias, isoladamente e dentro de uma semana), conflito singular/plural, ausência de dado real de disponibilidade em erros, determinismo (mesma entrada → mesma saída) e imutabilidade da lista de ocupações recebida
- 3 testes de hardening ao nível de widget: consultar a agenda não gera nenhuma leitura/escrita adicional no repositório de bloqueios (`_CountingAgendaBlockRepository`, decorador de teste); não altera a lista hidratada em `agendaBlocksProvider`; acessibilidade básica (campo localizável por `bySemanticsLabel`, botão com semântica de botão, resposta com significado no texto)

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 1016 testes passando.

**Fora de escopo do CP-F (mantido):** schema, banco, DAO, repository, bootstrap, rotas, regras de negócio já aprovadas, documentação.

**Commit:** `fd73d84` — `test(agenda): harden intelligent availability query pipeline`

### Checkpoint G — Documentação final e encerramento ✅

**Escopo entregue:**

- Este documento (`docs/tasks/TASK-026.md`), consolidando os 7 checkpoints (A–G)
- `docs/business-rules/agenda-inteligente.md` criado, documentando o fluxo completo, as regras `free`/`partial`/`busy`, a interpretação de frases, o relógio injetável e os itens fora de escopo
- `ARCHITECTURE.md` atualizado: seção descrevendo o pipeline determinístico da Agenda Inteligente, sem novas tabelas/providers de persistência
- `PROJECT.md` e `TASKS.md` atualizados com o encerramento da TASK-026
- `docs/roadmap.md` atualizado: item "Agenda Inteligente e Análise de Disponibilidade" marcado como parcialmente implementado, com o recorte que permanece futuro
- Nenhuma alteração em `lib/`, `test/`, schema, providers, repositories, DAOs ou UI — checkpoint exclusivamente documental

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com 1016 testes passando (suíte inalterada).

**Commit:** *(pendente de aprovação/commit)*

## Arquivos principais da task

```
lib/features/agenda/
  models/
    agenda_availability_result.dart      # CP-A
    agenda_query.dart                    # CP-B
    agenda_query_result.dart             # CP-B
    agenda_availability_intent.dart      # CP-C
    agenda_availability_request.dart     # CP-C
    agenda_availability_response.dart    # CP-D
  utils/
    agenda_availability_analyzer.dart          # CP-A
    agenda_availability_query_service.dart     # CP-B
    agenda_availability_request_parser.dart    # CP-C
    agenda_availability_response_formatter.dart # CP-D
    agenda_availability_assistant_service.dart  # CP-D
  widgets/
    agenda_availability_query_card.dart  # CP-E
  agenda_screen.dart                     # CP-E (modificado)

test/features/agenda/
  utils/
    agenda_availability_analyzer_test.dart
    agenda_availability_query_service_test.dart
    agenda_availability_request_parser_test.dart
    agenda_availability_response_formatter_test.dart
    agenda_availability_assistant_service_test.dart
  agenda_availability_end_to_end_test.dart   # CP-F
  agenda_screen_test.dart                    # CP-E/CP-F (modificado)
```

Nenhum arquivo em `lib/core/database/`, `lib/features/agenda/data/`, `lib/features/agenda/providers/` (exceto reaproveitamento de leitura de `agendaBlockClockProvider`) ou `lib/app/` foi criado ou alterado nesta task.

## Testes e verificação

| Checkpoint | Testes totais |
|---|---|
| CP-A | 924 |
| CP-B | 941 |
| CP-C | 965 |
| CP-D | 994 |
| CP-E | 1002 |
| CP-F | 1016 |
| CP-G | 1016 (inalterado — checkpoint documental) |

Todos os checkpoints executaram `flutter analyze` (sem apontamentos) e `flutter test` completo antes do commit, conforme `CLAUDE.md`. A suíte cresceu de 900 testes (fim da TASK-025) para 1016 testes, um acréscimo de 116 testes ao longo dos 6 checkpoints de código (A–F).

## Fora de escopo geral da TASK-026 (evolução futura)

- **IA/LLM generativa** — toda a interpretação e resposta são deterministas, baseadas em regras (regex/palavras-chave); nenhuma chamada a modelo de linguagem foi feita ou está prevista nesta fase.
- **Interface de voz** — entrada e saída são exclusivamente textuais.
- **Recursos de equipe e equipamentos** — a análise não considera disponibilidade de equipe/equipamentos (`AgendaResourceReservations`, já fora de escopo desde a TASK-025).
- **Montagem e desmontagem** — a análise opera sobre `AgendaOccupancy` (intervalo único por ocupação); não há granularidade adicional de setup/desmontagem (`AgendaEventSchedules`, já fora de escopo desde a TASK-025).
- **Consultas mais livres e complexas** — o parser reconhece um conjunto fixo de padrões (hoje/amanhã/dia da semana/data explícita/semana/mês/intervalo de datas/intervalo de horário); perguntas fora desse conjunto retornam erro "não suportada", sem tentativa de inferência.
- **Chat/histórico de conversa** — cada chamada a `ask(...)` é independente; não há contexto de conversas anteriores.
- Exclusão de orçamento (herdado das TASKS anteriores, ainda não implementado).
- Sincronização online/Firebase.

## Lições Aprendidas

### Pipeline em camadas puras antes de qualquer UI

Dividir a Agenda Inteligente em quatro camadas Dart puras e testáveis isoladamente (Analyzer → Query Service → Parser → Formatter/Assistant Service) antes de tocar em qualquer widget permitiu validar toda a lógica de negócio — inclusive casos difíceis como virada de mês/ano e intervalos atravessando meia-noite — com testes rápidos e determinísticos, sem depender de `WidgetTester` nem de banco. A UI (CP-E) acabou sendo a camada mais simples de todas, pois só precisou orquestrar chamadas a um serviço já pronto e testado.

### Relógio injetável como pré-requisito de determinismo

Toda frase relativa ("hoje", "amanhã", "esta semana") depende de "agora". Sem um relógio injetável desde o CP-C (`AgendaAvailabilityRequestParser(clock: ...)`), seria impossível escrever testes deterministas para essas frases — e, na integração com a UI (CP-E), teria sido necessário criar um provider de relógio novo. Reaproveitar o `agendaBlockClockProvider` já existente na Agenda (criado na TASK-025 para timestamps de `AgendaBlock`) evitou duplicar esse conceito e manteve um único ponto de verdade para "agora" em toda a feature.

### Resultado estruturado em vez de exceção para erros esperados

Frases ambíguas ou não suportadas são um caminho **esperado**, não uma falha excepcional. Modelar isso como um resultado estruturado (`AgendaAvailabilityParseResult.success`/`.failure`) em vez de lançar exceções manteve o fluxo de controle explícito em cada camada (parser → assistant service → UI) e tornou trivial testar os dois caminhos (sucesso e erro) sem `try/catch` nos testes.

### Computar em vez de persistir, uma segunda vez

Assim como `AgendaOccupancy` (TASK-025 CP-C) nunca é persistido, nenhum dado da Agenda Inteligente é gravado — cada consulta é recomputada a partir da lista de ocupações já existente. Isso eliminou qualquer preocupação com sincronização, cache ou invalidação: o CP-F confirmou explicitamente, com testes, que consultar a agenda não gera nenhuma leitura ou escrita adicional no repositório de bloqueios e não altera nenhum estado hidratado.

### Hardening dedicado revela a robustez real do design

O CP-F não encontrou nenhum defeito real — mas o valor do checkpoint não foi encontrar bugs, foi **provar** propriedades importantes (determinismo, imutabilidade, ausência de efeitos colaterais, correção em bordas como virada de ano/mês e meia-noite) que já eram esperadas pelo design, mas não estavam explicitamente testadas ponta a ponta. Um pipeline inteiramente composto de funções puras (sem estado mutável compartilhado) tende a passar esse tipo de hardening sem exigir correções — uma confirmação prática de que a divisão em camadas puras (ver "Lições Aprendidas" acima) foi a decisão de design mais importante da task.

### Padrões arquiteturais confirmados (e estendidos) para futuras tasks

- Lógica de negócio determinística e complexa deve ser construída em camadas Dart puras (sem Flutter/Riverpod/persistência) antes de qualquer integração com UI — validado pela segunda vez (depois de `AgendaOverlapChecker`/`AgendaEventIntervalResolver` na TASK-025), agora em uma cadeia de 5 camadas.
- Toda lógica dependente de "agora" deve receber um relógio injetável desde o primeiro componente que o usa, não apenas na camada de integração.
- Erros esperados (ambiguidade, entrada não suportada) devem ser modelados como resultado estruturado, não como exceção.
- Testes de hardening ponta a ponta (mesmo sem encontrar defeitos) têm valor documental e de regressão — trancam propriedades do sistema (determinismo, ausência de efeitos colaterais) que testes unitários isolados não conseguem provar por si só.
