# Regras de negócio — Agenda

## Visão geral

A Agenda reúne, em uma única linha do tempo, tudo o que ocupa datas da empresa: **propostas** e **eventos confirmados** vindos de Orçamentos, e **bloqueios manuais** (montagem, manutenção, feriado, evento de terceiros, etc.) cadastrados diretamente na Agenda.

A Agenda **não duplica dados de Orçamentos**. Ela lê o `QuoteEventSnapshot` de cada orçamento existente e o combina, em tempo real, com os bloqueios manuais persistidos (`AgendaBlocks`). Não existe uma tabela `AgendaEventSchedules` ou equivalente — a ocupação de um orçamento é sempre **derivada**, nunca uma cópia gravada.

Bloqueios manuais são persistidos localmente em SQLite via Drift (`AgendaBlocksDao` / `DriftAgendaBlockRepository`), desde a TASK-025 CP-A/CP-B, e hidratados automaticamente ao iniciar o app (CP-E).

## `AgendaBlock` (persistido)

| Campo | Tipo | Regra |
|-------|------|-------|
| `id` | `String` | UUID v7, gerado na criação |
| `title` | `String` | Obrigatório, não pode ser vazio/somente espaços |
| `notes` | `String?` | Opcional |
| `start` | `DateTime` | Obrigatório |
| `end` | `DateTime` | Obrigatório; deve ser **posterior** a `start` |
| `createdAt` | `DateTime` | Definido no momento da criação; preservado em edições |
| `updatedAt` | `DateTime` | Atualizado em cada edição |

### Validação (`AgendaBlockValidator`)

- `title` obrigatório.
- `start` obrigatório.
- `end` obrigatório.
- `end` deve ser posterior a `start` (`end.isAfter(start)`).
- Validação roda **antes** de qualquer chamada ao repositório, tanto na criação quanto na edição; falha de validação não persiste nada e retorna `false` para a UI.

### CRUD (`AgendaBlocksNotifier`)

- `addBlock`: gera `id` (UUID v7), `createdAt` e `updatedAt`; valida; persiste; atualiza o estado em memória.
- `updateBlock`: preserva `id` e `createdAt` do bloqueio existente; atualiza `updatedAt`; valida; persiste.
- `deleteBlock`: exclui do repositório e do estado em memória.
- Toda operação é assíncrona e retorna `bool`: `true` em sucesso, `false` em falha (validação ou erro de persistência) — **nenhuma exceção propaga para a UI**.
- Falha de persistência não altera o estado em memória (sem hidratação parcial).

## `AgendaOccupancy` (computado, nunca persistido)

Modelo somente leitura, **derivado** em tempo real por `agendaOccupancyProvider` a partir de `quotesProvider` (orçamentos) e `agendaBlocksProvider` (bloqueios). Não existe tabela, DAO ou repositório para `AgendaOccupancy` — ele nunca é gravado.

| Campo | Origem |
|-------|--------|
| `id` | `'quote-{quote.id}'` ou `'block-{block.id}'` |
| `kind` | `proposal` \| `confirmed` \| `block` |
| `title` | Nome do evento (orçamento) ou título do bloqueio |
| `start` / `end` | Intervalo resolvido (ver seção seguinte) |
| `sourceQuoteId` | Preenchido somente quando a origem é um orçamento |
| `sourceBlockId` | Preenchido somente quando a origem é um bloqueio manual |

### Regra de status → ocupação

| `QuoteStatus` | `AgendaOccupancyKind` |
|---------------|------------------------|
| `draft` | `proposal` |
| `sent` | `proposal` |
| `approved` | `confirmed` |
| `rejected` | *(ignorado — não ocupa a Agenda)* |
| `cancelled` | *(ignorado — não ocupa a Agenda)* |

Um orçamento sem `QuoteEventSnapshot.date` também é ignorado (evento sem data não ocupa a Agenda).

### Conversão de `QuoteEventSnapshot` em intervalo (`AgendaEventIntervalResolver`)

O snapshot do evento guarda `date` (data civil) e `startTime`/`endTime` (`"HH:mm"` opcionais). A conversão para um intervalo `DateTime` concreto preserva a data civil e o horário local, **sem qualquer conversão de fuso horário**:

- Sem `date` → orçamento não ocupa a Agenda (`null`).
- Sem `startTime` → assume `00:00`.
- Sem `endTime` → assume `23:59`.
- `endTime` inválido ou não posterior a `startTime` (`end <= start`, inclusive quando ambos usam o fallback) → o fim é empurrado para o dia seguinte (`end + 1 dia`), cobrindo eventos que atravessam a madrugada.

### Bloqueios manuais

`AgendaOccupancy.fromBlock` converte um `AgendaBlock` diretamente: `start`/`end` do bloqueio, `kind = block`, sem nenhuma resolução adicional.

## Conflitos por intervalo (`AgendaOverlapChecker`)

Verificador **puro** (sem Riverpod, sem I/O), responsável somente por detectar sobreposição entre dois intervalos. Regra padrão de overlap "half-open": dois intervalos se sobrepõem quando cada um começa antes do outro terminar —

```dart
firstStart.isBefore(secondEnd) && secondStart.isBefore(firstEnd)
```

Funciona igualmente para bloco × bloco, bloco × orçamento e orçamento × orçamento, pois opera sobre `AgendaOccupancy` (já unificado) ou diretamente sobre pares de `DateTime`. **Não bloqueia** a criação de bloqueios nem orçamentos conflitantes nesta fase — a decisão final permanece com o usuário (consistente com a intenção registrada em `docs/roadmap.md` para a futura Agenda Inteligente); a Agenda apenas expõe o verificador para uso futuro na UI/análise.

## Ordenação e apresentação

- `agendaOccupancyProvider` retorna a lista final ordenada por `start` ascendente, combinando orçamentos e bloqueios.
- `AgendaBlocksDao.getAllOrdered()` já ordena os bloqueios por `start` no nível do banco (índice `idx_agenda_blocks_start`).
- Apresentação visual distingue os três tipos (Proposta / Confirmado / Bloqueio) por cor e rótulo (`agenda_occupancy_presenter.dart`).

## Persistência e schema

- Tabela `agenda_blocks` (`AgendaBlocks`), criada na migração real `schemaVersion` 1 → 2 (TASK-025 CP-A) — a primeira migração real do projeto.
- Índices: `idx_agenda_blocks_start`, `idx_agenda_blocks_end`.
- Sem chaves estrangeiras — `AgendaBlock` não referencia `Quote`, `Client` ou `CatalogItem`; a ligação com orçamentos é sempre computada em memória via `sourceQuoteId`, nunca uma FK.
- `AgendaOccupancy` nunca é persistido — recomputado a cada leitura de `agendaOccupancyProvider`.

## Integração com Orçamentos

- Leitura: `agendaOccupancyProvider` consome `quotesProvider` (já hidratado no startup) somente leitura; a Agenda nunca escreve em orçamentos.
- Navegação: tocar em uma ocupação do tipo Proposta/Confirmado abre a tela de detalhes do orçamento já existente (`/quotes/:id`); tocar em um Bloqueio abre `/agenda/:id`.
- Qualquer mudança de status ou edição de um orçamento (via módulo Orçamentos) reflete automaticamente na Agenda na próxima leitura do provider — não há cópia para sincronizar.

## Rotas

- `/agenda` — lista de ocupações (propostas, confirmados e bloqueios).
- `/agenda/new` — novo bloqueio manual.
- `/agenda/:id` — detalhes de um bloqueio manual.
- `/agenda/:id/edit` — edição de um bloqueio manual.

Ocupações originadas de orçamentos **não** têm rota própria na Agenda — abrem a rota já existente `/quotes/:id`.

## Fora de escopo desta fase

Registrado como evolução futura, sem implementação, arquitetura definida ou task associada nesta fase:

- **Agenda Inteligente e Análise de Disponibilidade** — consulta de disponibilidade em linguagem natural, análise de montagem/desmontagem, justificativa textual (ideia registrada em `docs/roadmap.md`, anterior à TASK-025).
- **Gestão de Recursos** (`AgendaResourceReservations`) — reserva de equipe e equipamentos por evento/bloqueio; tabela deliberadamente **não criada** no schema desta fase (evitado schema especulativo sem DAO, UI ou modelo de recursos definido).
- **Agenda de eventos detalhada** (`AgendaEventSchedules`) — granularidade adicional de horários (montagem, execução, desmontagem) por evento; **não criada** nesta fase, pois a ocupação já é integralmente derivada do `QuoteEventSnapshot` existente.
- **Bloqueio automático de conflitos** — `AgendaOverlapChecker` detecta, mas não impede, sobreposição entre ocupações.
- **Financeiro, Contratos, Equipe, Fornecedores, Evento 360°** — a Agenda foi desenhada para permitir integração futura com esses módulos (ex.: `sourceQuoteId`/`sourceBlockId` como pontos de extensão), mas nenhuma integração é implementada nesta fase.
