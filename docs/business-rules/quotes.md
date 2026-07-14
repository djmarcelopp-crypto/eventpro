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
- **Aprovado** → Cancelado, **Rascunho** (reabrir para edição)
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
- `approvedAt` representa a **aprovação vigente**; é **limpo** (`null`) na reabertura **Aprovado → Rascunho**.
- `approvedAt` é **preservado** se o orçamento for posteriormente cancelado — marca a última aprovação vigente antes do cancelamento.
- O histórico de aprovações anteriores permanece em `statusHistory`, mesmo após reabertura.
- Nova aprovação após reabertura define um **novo** `approvedAt`.
- `isApprovedForContract` retorna `true` quando `status == approved`.

## Snapshots

### Princípio

Um orçamento é um **documento congelado**. Alterações futuras em Clientes, Catálogo ou Configurações **não propagam** para orçamentos existentes.

### Cliente (`QuoteClientSnapshot`)

- Usa `QuoteClientType` local (individual/company), não `ClientType` do módulo Clientes.
- Factory `fromClient` converte na criação; snapshot permanece válido se Clientes evoluir.
- Guarda `sourceClientId` para rastreio.
- Telefone e WhatsApp permanecem **somente dígitos** no snapshot; a formatação ocorre **somente na apresentação** (detalhes).
- **Excluído:** `internalNotes`, `instagram`, `birthday`.

### Evento (`QuoteEventSnapshot`)

- Dados essenciais: nome, tipo, data, horários, local, endereço, convidados.
- Nesta fase: modelo e testes; formulário em tarefa futura.

### Itens (`QuoteLineItem`)

- `catalogItemId` opcional (`null` = item personalizado futuro).
- Campos congelados: nome, descrição, unidade, quantidade, preço unitário, total da linha.
- **Sem `imageReference`** nesta fase (ver seção Imagens).
- `packageComponents` opcional (`null` = linha simples; lista imutável quando presente).

#### Pacotes (`packageComponents`) — TASK-021

| Conceito | Regra |
|----------|-------|
| Modelo | `List<QuotePackageComponentSnapshot>?` em `QuoteLineItem` |
| Compatibilidade | Orçamentos antigos sem o campo permanecem válidos (`packageComponents == null`) |
| Captura | Snapshots gravados no **save** a partir do Catálogo vigente |
| Independência | Mudanças futuras no Catálogo **não alteram** orçamentos existentes |
| Preço da linha | Preço unitário do **pacote** × quantidade de pacotes (centavos) |
| Componentes no total | Componentes são informativos nesta fase; **não** somam ao total financeiro |
| Quantidade efetiva | `quantityPerPackage × lineQuantity` (exibida na UI; base para checklist futuro) |
| PDF | Pacote aparece como **linha financeira única**; sem detalhamento operacional de componentes |
| Checklist | Conferência de saída/retorno, responsável e horário — **tarefa futura** |

Cada `QuotePackageComponentSnapshot` congela: `name`, `unit`, `typeLabel`, `categoryLabel`, `quantityPerPackage` e `catalogItemId` opcional para rastreio.

Na criação de linha nova, `QuotePackageComponentMapper` converte componentes do Catálogo em snapshots. Orçamentos salvos **não** dependem de `CatalogPackageComponent` em tempo de leitura.

### Empresa emissora (`QuoteCompanySnapshot`) — TASK-019

- Criado no **primeiro save** de um novo orçamento (`addQuote`), a partir do `CompanyProfile` vigente em Configurações.
- Se não houver perfil salvo no momento do save, `companySnapshot` permanece `null` (orçamento válido).
- **Edição** (`updateQuote`) **nunca** recria nem altera o snapshot existente.
- **Transições de status** e **reabertura** (Aprovado → Rascunho) preservam o snapshot integralmente.
- Logo copiado para área imutável de Quotes (`quotes/company-assets/...`); referência opaca no snapshot.
- Alterações posteriores em Configurações **não propagam** para orçamentos já salvos.
- Ação explícita **"Atualizar dados da empresa"** no orçamento fica para etapa futura.
- PDF usa exclusivamente o snapshot (TASK-020); contrato permanece futuro.
- Estado ainda em memória (provider); persistência Firebase em etapa futura.

#### Campos capturados

| Bloco | Conteúdo |
|-------|----------|
| Identificação | Nome comercial, razão social, CNPJ (dígitos), inscrição estadual |
| Contato | Telefone, WhatsApp, e-mail, Instagram, site (dígitos nos telefones) |
| Endereço | CEP, logradouro, número, complemento, bairro, cidade, UF |
| Representante legal | Nome, CPF, cargo |
| Pagamento | Tipo/chave PIX, beneficiário, condições |
| Logo | Referência copiada para Quotes |
| Metadados | `captureStatus` (configured/incomplete), `capturedAt` |

#### Status de captura

| Status | Condição |
|--------|----------|
| `configured` | Perfil com status Configurado no momento do save |
| `incomplete` | Perfil salvo, mas incompleto ou sem dados profissionais completos |

#### Defaults no novo formulário (não alteram snapshot)

- Abertura de `/quotes/new` aplica **uma vez** (sem marcar dirty):
  - validade = hoje local + `defaultValidityDays` do perfil (ou +7 dias sem perfil);
  - observações públicas = `defaultPublicNotes` do perfil (se houver).
- Edição carrega valores salvos do orçamento; banner de perfil incompleto **somente** em `/quotes/new`.

#### Detalhes — seção "Empresa emissora"

- Exibida somente leitura quando `companySnapshot != null`.
- Usa **exclusivamente** o snapshot; **não consulta** Settings.
- Campos vazios são ocultados.
- Contato principal: WhatsApp → telefone → e-mail (formatação na apresentação).
- CNPJ: `00.000.000/0000-00`; telefones com máscaras brasileiras.
- Endereço resumido sem separadores sobrando.
- Indicação de status: "Dados completos/incompletos no momento da criação".
- **Não exibe:** chave PIX, representante legal, logo, dados internos.
- Orçamentos antigos (`companySnapshot == null`): aviso discreto; sem erro em edição, transição ou listagem.

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
| Dados da empresa | `QuoteCompanySnapshot` congelado no primeiro save (ver `docs/business-rules/settings.md`) |
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

- `/quotes` — listagem de orçamentos.
- `/quotes/new` — formulário de novo orçamento (salva como rascunho).
- `/quotes/:id` — detalhes do orçamento.
- `/quotes/:id/edit` — edição (somente rascunho).

- `/quotes/:id/pdf` — preview do PDF do orçamento (TASK-020).

## PDF de orçamento (TASK-020)

Documentação detalhada: `docs/business-rules/pdf.md`.

### Princípios

- Geração **offline** a partir dos snapshots congelados do `Quote`.
- **Não consulta** Settings, Clientes ou Catálogo atuais.
- `companySnapshot` obrigatório; orçamentos legados sem empresa exibem bloqueio amigável.
- `internalNotes` **nunca** entra no PDF.
- Preview e exportação disponíveis em **todos** os status.

### Acesso

- Seção **Documento PDF** nos detalhes (`/quotes/:id`): Visualizar e Salvar/Compartilhar.
- Preview em tela dedicada: `/quotes/:id/pdf`.

### Exportação

| Plataforma | Comportamento |
|------------|---------------|
| Android / iOS | Compartilhamento via sheet nativo |
| Desktop | Diálogo de destino + gravação manual dos bytes (`flush: true`) |

### Layout

Proposta comercial premium: cabeçalho centralizado, tabela de itens, resumo financeiro, pagamento, observações públicas e overlay por status (watermark/badge).

### Fora de escopo do PDF atual

- Aceite e assinaturas (TASK-022)
- Representante legal no PDF
- Fotos de itens
- Detalhamento operacional de componentes de pacote (checklist de carregamento)
- Envio automático por e-mail/WhatsApp

## Evolução futura — checklist operacional (TASK futura)

Documentado como evolução; **não implementado** na TASK-021:

- Checklist de carregamento a partir dos `packageComponents` do orçamento aprovado
- Agrupamento de componentes por categoria
- Quantidade efetiva por componente (`quantityPerPackage × pacotes`)
- Conferência de saída e retorno de equipamentos
- Responsável e horário de cada etapa operacional

## Histórico de status (TASK-017)

- Cada orçamento possui `statusHistory` imutável (`List.unmodifiable`).
- `addQuote` ignora qualquer histórico recebido no draft e cria exatamente uma entrada inicial: `null → draft`, com `changedAt == createdAt`.
- `transitionStatus` válida adiciona `{ previous, new, changedAt }`.
- Transição inválida ou repetida não adiciona entrada.
- `updateQuote` preserva o histórico integralmente.

## Detalhes e status (TASK-017)

### Tela de detalhes

- Resolve o orçamento pelo ID da rota via `quotesProvider` (sem `extra` como fonte oficial).
- Exibe snapshots congelados: cliente, **empresa emissora** (quando capturada), evento, itens, financeiro, observações e histórico.
- Campos vazios são ocultados; observações internas ficam em seção separada com aviso de bloqueio em PDF/contrato.
- ID inexistente exibe estado amigável com botão Voltar.

### Ações por status (sem dropdown)

| Status | Ações |
|--------|-------|
| Rascunho | Editar, Marcar como enviado, Cancelar |
| Enviado | Aprovar, Recusar, Cancelar |
| Aprovado | Indicação “Pronto para gerar contrato”, Gerar contrato (Em breve), **Reabrir para edição**, Cancelar |
| Recusado / Cancelado | Somente visualização |

- **Reabrir para edição** (somente em Aprovado): retorna para Rascunho via `transitionStatus`, limpa `approvedAt`, preserva dados/itens e exige novo envio e nova aprovação. Diálogo obrigatório com aviso explícito.

- Toda mudança de status exige diálogo de confirmação.
- “Marcar como enviado” é registro manual; sem envio real por WhatsApp/e-mail.
- Duplo clique é bloqueado (`_transitioning` restaurado em `finally`).

### Edição de rascunho

- Reutiliza `NewQuoteScreen(quoteId)` com `QuoteFormInitializer`.
- Bloqueada fora de `draft`.
- `updateQuote` preserva `id`, `number`, `createdAt`, `status`, `approvedAt`, `statusHistory` e **`companySnapshot`**.

### Linhas na edição (`isExistingLine`)

| Tipo | Regra no save |
|------|---------------|
| **Linha existente** | Preserva nome, descrição e unidade congelados do orçamento; quantidade e preço editáveis; item inativo/ausente mostra aviso mas permite salvar |
| **Linha nova** | Somente itens ativos; captura dados atuais do Catálogo |

- Nunca atualizar silenciosamente linha existente com dados novos do Catálogo.
- Para atualizar pelo Catálogo: remover a linha e adicionar novamente.

### Relógio testável

- `quoteClockProvider = Provider<DateTime Function()>` usado por `QuotesNotifier`.
- Produção: `DateTime.now`; testes: `ProviderScope` override.

## Criação de orçamento (TASK-016)

### Formulário

- Cliente obrigatório, selecionado entre clientes cadastrados.
- Itens obrigatórios, somente do catálogo ativo.
- Desconto fixo em R$ (percentual: evolução futura).
- Validade sugerida: hoje + 7 dias (não marca alterações ao abrir).
- Validade preenchida não pode ser anterior à data atual.
- Observações para o cliente (futuro PDF) separadas visualmente das internas.

### Momento do snapshot

No **Salvar**, o sistema resolve novamente `Client` e `CatalogItem` pelos IDs:

| Campo da linha | Origem no save |
|----------------|----------------|
| Nome, descrição, unidade | Estado **atual** do item no catálogo |
| Quantidade, preço unitário | Rascunho editado no formulário |
| `packageComponents` | Estado **atual** dos componentes do pacote (somente linhas novas de pacote) |
| Cliente | Estado **atual** via `QuoteClientSnapshot.fromClient()` |

Se cliente ou item estiver ausente/inativo, o salvamento é bloqueado com mensagem clara.

### Pacotes no formulário (TASK-021)

- Pacotes ativos aparecem no seletor com badge **Pacote** e contagem de itens incluídos.
- Ao adicionar pacote, componentes são capturados como snapshots na linha.
- Na edição de rascunho, linhas existentes preservam snapshots originais (`isExistingLine`).
- Linha existente de pacote: quantidade e preço editáveis; componentes congelados.
- Para atualizar componentes pelo Catálogo: remover a linha e adicionar novamente.

### Preço no orçamento

- Preço unitário editável por linha; alteração **não** modifica o Catálogo.
- Exibição monetária reutiliza formatadores existentes via bridge de centavos.

### Cálculo em tempo real

- Durante digitação, linhas inválidas exibem erro sem quebrar o formulário.
- `QuoteLineItem` só é criado após validação no Salvar.
- Total temporário pode ser zero enquanto o usuário digita.

### Quantidade

- Entrada pt-BR: aceita `1,5` e `1.5`; até 3 casas decimais.
- Modelo persiste `double`.

### Listagem

- Cards com número, cliente, status, evento, total, validade e quantidade de itens.
- Ordenação por criação mais recente (cópia para exibição; provider não é mutado).
- Card abre detalhes com `push` para `/quotes/:id`.
