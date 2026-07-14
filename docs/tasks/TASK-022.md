# TASK-022 — Aceite e assinaturas no PDF de orçamentos

## Objetivo

Adicionar ao PDF de orçamento um bloco de **aceite bilateral** com linhas físicas de assinatura, identificação impressa das partes a partir dos snapshots congelados, registro operacional de `approvedAt` quando aplicável, e aviso de que os status do EventPro não substituem assinaturas reais — **sem** assinatura eletrônica, digital, certificado ou trilha de auditoria nesta fase.

## Checkpoints

### Checkpoint A — Modelos e regras ✅

- `QuotePdfSignatureBlock` (rótulo + linhas de identificação imutáveis)
- `QuotePdfAcceptanceSection` (título, declaração, local/data, blocos, disclaimer, `approvedAtLabel` opcional)
- `QuotePdfAcceptancePolicy` — aceite somente em `sent` e `approved`
- `QuotePdfFormatter` — textos fixos, builders contratante/contratada, `formatApprovedAtSystemLabel`
- Testes de policy e formatter

### Checkpoint B — Integração aos dados do PDF ✅

- Campo opcional `acceptanceSection` em `QuotePdfDocumentData`
- `QuotePdfAcceptanceSectionAssembler` monta a seção dos snapshots
- `QuotePdfDocumentBuilder._buildAcceptanceSection` — `approvedAtLabel` apenas em `approved` com `approvedAt` preenchido
- Testes de integração no builder (16 cenários)

### Checkpoint C — Renderização no generator ✅

- `_buildAcceptanceSection` e `_buildSignatureColumn` em `QuotePdfGeneratorService`
- Bloco envolvido em `pw.Inseparable` após Pagamento/Observações
- Estilo `disclaimer` (7 pt) em `QuotePdfTheme`
- Testes de geração de bytes (12 cenários)

### Checkpoint D — Demos e revisão visual ✅

- `tool/quote_pdf_acceptance_demo_fixtures.dart` — dados fictícios
- `generate_quote_pdf_acceptance_demo_test.dart` — gera três PDFs de aceite + regressão TASK-020
- Disclaimer refinado (texto genérico, sem aviso específico sobre Aprovado no status Enviado)
- PDFs: `build/quote_pdf_acceptance_sent.pdf`, `_approved.pdf`, `_multipage.pdf`

### Checkpoint E — Documentação e verificação final

- `docs/tasks/TASK-022.md` (este arquivo)
- Atualização de `docs/business-rules/pdf.md` e `docs/business-rules/quotes.md`
- Auditoria de isolamento e escopo
- `flutter analyze`, `flutter test`, builds macOS/iOS/APK

## Política por status

| Status | Seção de aceite | `approvedAtLabel` |
|--------|-----------------|-------------------|
| Rascunho | Ausente | — |
| Enviado | Presente | Ausente (mesmo se `approvedAt` preenchido no modelo) |
| Aprovado | Presente | Presente somente quando `approvedAt != null` |
| Recusado | Ausente | — |
| Cancelado | Ausente | — |

Preview e exportação permanecem disponíveis em **todos** os status (TASK-020).

## Fontes dos dados

| Elemento | Origem |
|----------|--------|
| Contratante | `QuoteClientSnapshot` |
| Contratada | `QuoteCompanySnapshot` |
| Representante legal | `companySnapshot.legalRepresentative` (quando presente) |
| `approvedAtLabel` | `Quote.approvedAt` (somente status Aprovado) |
| Textos fixos | `QuotePdfFormatter` (declaração, local/data, disclaimer) |

### Exclusões absolutas

- `internalNotes`
- Settings, Clientes, Catálogo ou providers atuais
- `createdAt` como data de assinatura
- `addressSummary` para inferir cidade no campo “Local e data”
- Telefone, e-mail, endereço completo ou PIX nas linhas de assinatura

## Identificação das partes

### Contratante

| Tipo | Linhas impressas |
|------|------------------|
| Pessoa Física | Nome + CPF formatado (quando documento presente) |
| Pessoa Jurídica | Razão social preferencial + CNPJ formatado |

### Contratada

| Cenário | Rótulo da coluna | Linhas impressas |
|---------|------------------|------------------|
| Com representante legal | Contratada | Nome, CPF, cargo, razão social, CNPJ (campos ausentes omitidos) |
| Sem representante | Representante da contratada | Razão social preferencial → nome fantasia; CNPJ quando presente |

## Local e data

- Linha fixa em branco: `Local e data: __________________________________________`
- Preenchimento manual na impressão; o app **não** preenche cidade nem data de assinatura.

## `approvedAt` operacional

- Exibido **somente** em status **Aprovado** com `approvedAt` preenchido.
- Formato: `Aprovado no sistema em: {data longa} às {HH:MM}`.
- Registra controle interno do EventPro; **não** equivale à assinatura física nem altera o status do orçamento.

## Disclaimer

Texto fixo (7 pt), presente em Enviado e Aprovado:

> Os status registrados no EventPro servem apenas ao controle interno e não substituem as assinaturas do contratante e da contratada.

- Não menciona status específico (ex.: “Aprovado”) no PDF Enviado.
- Não utiliza os termos “assinatura eletrônica” ou “assinatura digital”.

## Layout

1. Seção **Aceite da proposta** após Pagamento e Observações
2. Declaração de concordância
3. Linha “Local e data” em branco
4. `approvedAtLabel` (quando aplicável), estilo caption
5. Duas colunas lado a lado: Contratante | Contratada (ou Representante da contratada)
6. Linha horizontal vazia (~22 pt) para assinatura manual
7. Dados de identificação abaixo da linha (caption)
8. Disclaimer ao final do bloco
9. Bloco inteiro em `pw.Inseparable` — migra para a última página em documentos multipágina

## Arquivos principais

```
lib/features/quotes/pdf/
  models/quote_pdf_signature_block.dart
  models/quote_pdf_acceptance_section.dart
  utils/quote_pdf_acceptance_policy.dart
  utils/quote_pdf_acceptance_section_assembler.dart
  utils/quote_pdf_formatter.dart          # textos e builders de assinatura
  utils/quote_pdf_document_builder.dart   # integração acceptanceSection
  services/quote_pdf_generator_service.dart
  theme/quote_pdf_theme.dart
tool/
  quote_pdf_acceptance_demo_fixtures.dart
test/features/quotes/pdf/
  quote_pdf_acceptance_policy_test.dart
  quote_pdf_acceptance_formatter_test.dart
  quote_pdf_acceptance_section_assembler_test.dart
  quote_pdf_document_builder_acceptance_test.dart
  quote_pdf_generator_acceptance_test.dart
  generate_quote_pdf_acceptance_demo_test.dart
```

## Testes e demos

### Testes automatizados

| Arquivo | Escopo |
|---------|--------|
| `quote_pdf_acceptance_policy_test.dart` | Política por status |
| `quote_pdf_acceptance_formatter_test.dart` | Textos, builders PF/PJ, nomes longos |
| `quote_pdf_acceptance_section_assembler_test.dart` | Montagem da seção |
| `quote_pdf_document_builder_acceptance_test.dart` | Integração Quote → document data |
| `quote_pdf_generator_acceptance_test.dart` | Bytes PDF com aceite |
| `generate_quote_pdf_acceptance_demo_test.dart` | Geração dos demos + regressão TASK-020 |

### Demos visuais (dados fictícios)

```bash
flutter test test/features/quotes/pdf/generate_quote_pdf_acceptance_demo_test.dart
```

| Arquivo | Cenário |
|---------|---------|
| `build/quote_pdf_acceptance_sent.pdf` | Enviado, PF, representante, pagamento/observações |
| `build/quote_pdf_acceptance_approved.pdf` | Aprovado, PJ, `approvedAt`, nomes longos |
| `build/quote_pdf_acceptance_multipage.pdf` | Enviado, 30 itens, aceite na última página |

Validação: assinatura `%PDF`, páginas ≥ esperado, tamanho > 0, sem exceção na geração.

## Limitações

- Assinatura **física** apenas — linhas vazias para preenchimento manual
- PDF assinado fisicamente permanece **externo** ao estado em memória do app
- Geração ou exportação do PDF **não altera** `status` nem `approvedAt`
- Sem captura de assinatura, imagem de rubrica, certificado, hash ou trilha de auditoria
- Sem assinatura eletrônica, gov.br ou ICP-Brasil
- Sem dependências novas nesta task
- Preview e exportação (TASK-020) inalterados em comportamento de rota e plataforma

## Evolução futura — assinatura eletrônica real

Fora do escopo da TASK-022; evolução planejada em fase posterior:

- Captura de assinatura (canvas ou integração gov.br / ICP-Brasil)
- Vinculação de assinatura ao PDF exportado com trilha de auditoria
- Alteração de status condicionada a fluxo de assinatura validado
- Armazenamento persistente do documento assinado
- Notificação ao cliente e registro de aceite com carimbo de tempo confiável

## Verificação

```bash
flutter analyze
flutter test
flutter build macos
flutter build ios --simulator
flutter build apk --debug   # pode falhar sem Android SDK completo
```

Windows: build pendente para notebook Windows.
