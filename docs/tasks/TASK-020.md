# TASK-020 — PDF profissional de orçamentos

## Objetivo

Gerar, visualizar e exportar PDF de orçamentos a partir de snapshots congelados (`Quote.companySnapshot`, cliente, evento e itens), com layout de proposta comercial premium, preview integrado e exportação confiável em desktop e mobile.

## Checkpoints

### Checkpoint A — View models e builder ✅

- `QuotePdfDocumentData` e subseções (empresa, cliente, evento, linhas, financeiro, pagamento)
- `QuotePdfDocumentBuilder` monta o documento exclusivamente a partir do `Quote` congelado
- `QuotePdfFormatter` (datas longas, contatos deduplicados, unidades compactas no PDF)
- `QuotePdfEligibility` (bloqueio sem `companySnapshot`)
- `QuotePdfStatusPolicy` (watermark/badge por status)
- `QuotePdfFilenameBuilder`

### Checkpoint B — Geração offline ✅

- Pacote `pdf` + fontes Inter (`assets/fonts/`)
- `QuotePdfGeneratorService` (layout premium, multipáginas, logo JPG/PNG)
- `QuotePdfLogoLoader` (somente `quotes/company-assets/`)
- `QuotePdfGenerationCoordinator`
- Testes de generator, formatter, builder e segurança

### Checkpoint C — Preview e exportação ✅

- `QuotePdfPreviewScreen` + rota `/quotes/:id/pdf`
- `QuotePdfPreviewController` (gera bytes, exporta)
- `PlatformQuotePdfExportService`:
  - **Mobile:** `Printing.sharePdf`
  - **Desktop:** `FilePicker.saveFile` **sem bytes** → `File(path).writeAsBytes(bytes, flush: true)`
- Abstrações injetáveis: `QuotePdfSaveDialogService`, `QuotePdfFileWriterService`
- Preview Premium Dark (ambiente escuro; folha A4 branca para impressão)
- Entitlements macOS: `user-selected.read-write`

### Checkpoint D — Integração nos detalhes ✅

- `QuotePdfActionsSection` em `QuoteDetailScreen` (todos os status)
- Visualizar PDF e Salvar/Compartilhar direto dos detalhes
- `QuotePdfDetailActionsController`
- Bloqueio amigável quando falta snapshot da empresa
- Testes E2E (`quote_task_020_checkpoint_d_test.dart`)

### Checkpoint E — Documentação e encerramento ✅

- `docs/tasks/TASK-020.md` (este arquivo)
- Regras de PDF em `docs/business-rules/quotes.md` e `docs/business-rules/pdf.md`
- Verificação: `flutter analyze`, `flutter test`, `flutter build macos`

## Regras de negócio consolidadas

| Regra | Comportamento |
|-------|---------------|
| Fonte de dados | Somente snapshots do `Quote`; nunca Settings atual |
| Elegibilidade | `companySnapshot != null` obrigatório |
| `internalNotes` | Nunca entra no PDF |
| Status | Preview e exportação em todos os status |
| Watermark | Rascunho, Recusado, Cancelado (diagonal, opacidade reduzida) |
| Badge | Enviado, Aprovado, Recusado, Cancelado |
| Data da proposta | `createdAt` formatado (`13 de julho de 2026`) |
| Logo | Bytes de `quotes/company-assets/`; `BoxFit.contain`, ~85 pt |
| Unidade no PDF | Labels compactos (`Unidade` → `un.`); valor salvo inalterado |
| Pagamento | PIX, beneficiário e condições do snapshot |
| Desktop save | `saveFile` sem bytes + gravação manual com verificação de tamanho |
| Mobile | Compartilhamento via sheet nativo |
| Cancelamento export | Silencioso (sem snackbar de erro) |

## Layout premium (proposta comercial)

1. Cabeçalho centralizado: logo, nome fantasia, razão social/CNPJ/IE, contatos e endereço (deduplicados)
2. Linha dourada separadora
3. Título **PROPOSTA COMERCIAL** + número do orçamento
4. Meta em 3 colunas: data, validade, status
5. Cliente e evento em blocos lado a lado
6. Tabela de itens com cabeçalho dourado
7. Resumo financeiro alinhado à direita
8. Pagamento e observações em seções leves (`Inseparable` — título não órfão)
9. Rodapé: número, paginação, texto profissional
10. Páginas 2+: cabeçalho compacto (sem logo grande)

## Arquivos principais

```
lib/features/quotes/pdf/
  models/quote_pdf_document_data.dart
  utils/quote_pdf_document_builder.dart
  utils/quote_pdf_formatter.dart
  utils/quote_pdf_eligibility.dart
  utils/quote_pdf_status_policy.dart
  services/quote_pdf_generator_service.dart
  services/quote_pdf_generation_coordinator.dart
  services/quote_pdf_export_service.dart
  services/quote_pdf_save_dialog_service.dart
  services/quote_pdf_file_writer_service.dart
  providers/quote_pdf_preview_controller.dart
  providers/quote_pdf_detail_actions_controller.dart
  quote_pdf_preview_screen.dart
lib/features/quotes/widgets/
  quote_pdf_actions_section.dart
assets/fonts/
  Inter-Regular.ttf
  Inter-SemiBold.ttf
```

## Rotas

| Rota | Tela |
|------|------|
| `/quotes/:id/pdf` | Preview do PDF |

Acesso também via seção **Documento PDF** em `/quotes/:id`.

## Testes

| Arquivo | Escopo |
|---------|--------|
| `quote_pdf_document_builder_test.dart` | Builder + snapshots |
| `quote_pdf_eligibility_test.dart` | Bloqueio sem empresa |
| `quote_pdf_formatter_test.dart` | Formatação pt-BR |
| `quote_pdf_generator_service_test.dart` | Bytes, multipáginas, logo |
| `quote_pdf_export_service_test.dart` | Desktop save + writer |
| `quote_pdf_preview_controller_test.dart` | Estados do preview |
| `quote_pdf_preview_screen_test.dart` | Rota e exportação |
| `quote_pdf_detail_actions_controller_test.dart` | Ações nos detalhes |
| `quote_task_020_checkpoint_d_test.dart` | E2E integração detalhes |
| `generate_quote_pdf_demo_test.dart` | PDF de demonstração |

## Verificação

```bash
flutter analyze
flutter test
flutter build macos
```

Demo visual (opcional):

```bash
flutter test test/features/quotes/pdf/generate_quote_pdf_demo_test.dart
# Gera build/quote_pdf_demo.pdf
```

## Limitações e fora de escopo

- Representante legal **não** exibido no PDF (capturado no snapshot; TASK-022)
- Bloco de aceite/assinaturas (TASK-022)
- Assinatura eletrônica, gov.br, ICP-Brasil
- Fotos de itens do catálogo no PDF
- Envio automático por e-mail/WhatsApp
- Persistência do PDF gerado no servidor
- Atualização do snapshot da empresa pelo PDF
- Contrato PDF

## Dependências adicionadas

- `pdf` — geração offline
- `printing` — preview e compartilhamento mobile
- `file_picker` — diálogo de salvamento desktop (sem `bytes` no macOS)
