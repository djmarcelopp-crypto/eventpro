# Regras de negócio — Orçamentos

## Visão geral

O módulo de Orçamentos reúne propostas comerciais para clientes da empresa, utilizando snapshots congelados de clientes, eventos e itens do Catálogo.

Nesta fase, os orçamentos existem apenas durante a sessão do aplicativo (provider em memória). A integração com Firebase será implementada em etapa futura.

## Status e transições

| Status | Label | Descrição |
|--------|-------|-----------|
| `draft` | Rascunho | Orçamento em elaboração; único status editável |
| `sent` | Enviado | Proposta enviada ao cliente |
| `approved` | Aprovado | Cliente aceitou a proposta |
| `rejected` | Recusado | Cliente recusou a proposta |
| `cancelled` | Cancelado | Orçamento cancelado |

### Transições permitidas

- **Rascunho** → Enviado, Cancelado
- **Enviado** → Aprovado, Recusado, Cancelado
- **Aprovado** → Cancelado
- **Recusado** → *(nenhuma)*
- **Cancelado** → *(nenhuma)*

A mudança de status ocorre **exclusivamente** via `transitionStatus`. Não existe `updateStatus` genérico.

Mudança de status **não altera** snapshots, itens nem valores financeiros.

## Bloqueio de edição

- `updateQuote` funciona **somente** quando o orçamento está em **Rascunho**.
- Orçamentos enviados, aprovados, recusados ou cancelados são **imutáveis**.
- Tentativa de alteração fora de rascunho retorna `false` (no-op).
- `updateQuote` preserva `status` e `approvedAt`.
- Evolução futura: ação **"Criar nova versão"** para derivar novo rascunho de orçamento já enviado (fora de escopo).

## `approvedAt` e histórico

- Preenchido **somente** na transição válida para **Aprovado**.
- Aprovação **não gera contrato** automaticamente.
- `approvedAt` é **preservado** mesmo se o orçamento for posteriormente cancelado — marca o histórico da aprovação.
- `isApprovedForContract` retorna `true` quando `status == approved`.

## Snapshots

### Princípio

Um orçamento é um **documento congelado**. Alterações futuras em Clientes, Catálogo ou Configurações **não propagam** para orçamentos existentes.

### Cliente (`QuoteClientSnapshot`)

- Usa `QuoteClientType` local (individual/company), não `ClientType` do módulo Clientes.
- Factory `fromClient` converte na criação; snapshot permanece válido se Clientes evoluir.
- Guarda `sourceClientId` para rastreio.
- **Excluído:** `internalNotes`, `instagram`, `birthday`.

### Evento (`QuoteEventSnapshot`)

- Dados essenciais: nome, tipo, data, horários, local, endereço, convidados.
- Nesta fase: modelo e testes; formulário em tarefa futura.

### Itens (`QuoteLineItem`)

- `catalogItemId` opcional (`null` = item personalizado futuro).
- Campos congelados: nome, descrição, unidade, quantidade, preço unitário, total da linha.
- **Sem `imageReference`** nesta fase (ver seção Imagens).

## Dinheiro em centavos

| Conceito | Tipo |
|----------|------|
| Preço unitário, subtotal, desconto, frete, total | `int` (centavos) |
| Quantidade | `double` (até 3 casas decimais, > 0) |
| Catálogo (inalterado) | `double` em reais |

### Conversão Catálogo → Orçamento

```dart
unitPriceCents = (catalogItem.price * 100).round();
```

### Cálculos

```dart
lineTotalCents  = (quantity * unitPriceCents).round();
subtotalCents   = soma das linhas;
totalCents      = subtotalCents - discountCents + freightCents; // mínimo 0
```

### Arredondamento

- Reais → centavos: `(reais * 100).round()`
- Total da linha: `(quantity * unitPriceCents).round()`
- Quantidade: `> 0`, máximo 3 casas decimais (validação com tolerância para `double` binário)

## Imagens (futuro)

- `QuoteLineItem` **não** referencia `imageReference` do Catálogo.
- Fotos do Catálogo podem ser substituídas ou apagadas, quebrando referências históricas.
- Se o PDF futuro exibir fotos, o orçamento deverá criar **cópia própria** da imagem em armazenamento separado (ex.: `quotes_images/`).
- TASK-015: sem cópia, sem referência, sem storage de imagem.

## Numeração

Formato: `ORC-{ANO}-{SEQUÊNCIA}` — ex.: `ORC-2026-0001`.

- Sequência por ano, padding de 4 dígitos.
- Não usa tamanho da lista.
- Sem repetição na mesma sessão.
- Persistência no banco será implementada futuramente.

## Observações internas

- `internalNotes` do orçamento é uso interno da equipe.
- **Nunca** deve aparecer em PDF, contrato ou materiais compartilhados com o cliente.
- `internalNotes` do cliente **nunca** entra no snapshot do orçamento.

## Imutabilidade

- `Quote.items` é `List.unmodifiable`.
- Listas mutáveis externas não podem alterar um orçamento após criação.

## Persistência e serialização

- Nesta fase: provider em memória; dados perdidos ao reiniciar o app.
- `toJson`/`fromJson` **não implementados** nesta fase.
- Serialização será definida junto com persistência e versionamento do banco.

## Integração futura com Contratos

### Princípio de separação

- **Orçamento** e **Contrato** são entidades separadas.
- `Quote` **não** possui `contractId` nem importa módulo de Contratos.
- Verificação de contrato duplicado será responsabilidade do futuro `ContractsNotifier`.

### Fluxo futuro

```
Orçamento aprovado
  → [ação manual] Gerar contrato em rascunho
  → Revisar cláusulas
  → Enviar
  → Assinar
```

Aprovação **não** assina nem gera contrato definitivo automaticamente.

### `ContractSnapshot` (especificado, não implementado)

Composição prevista:

| Bloco | Origem |
|-------|--------|
| Orçamento aprovado | `Quote` congelado |
| Dados da empresa | Configurações (snapshot futuro) |
| Dados do cliente | `QuoteClientSnapshot` |
| Dados do evento | `QuoteEventSnapshot` |
| Itens e valores | `List<QuoteLineItem>` + totais em centavos |
| Cláusulas | Versão configurada e revisada juridicamente |

**Exclusão absoluta:** `internalNotes` do orçamento e do cliente.

### Prevenção de duplicidade (futuro)

- `ContractsNotifier` verificará: orçamento aprovado + ausência de contrato ativo com mesmo `quoteId`.
- Regras de cancelamento, nova versão e auditoria serão definidas no módulo Contratos.

### Cláusulas (futuro)

- Configuráveis, versionadas, com revisão jurídica.
- Alteração de cláusula não afeta contratos já gerados.

## Rotas

- `/quotes` — listagem de orçamentos (estado vazio nesta fase).
