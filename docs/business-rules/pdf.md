# Regras de negócio — PDF de orçamentos (TASK-020)

## Visão geral

O PDF de orçamento é um documento comercial gerado **offline** a partir dos snapshots congelados do `Quote`. Não consulta Configurações, Clientes ou Catálogo atuais após o save do orçamento.

## Elegibilidade

| Condição | Resultado |
|----------|-----------|
| `companySnapshot == null` | Bloqueado com mensagem amigável |
| `companySnapshot != null` | Permitido em **todos** os status |

Orçamentos legados sem empresa emissora não geram PDF até existir snapshot (ação futura de atualização).

## Fontes de dados

| Seção do PDF | Origem |
|--------------|--------|
| Empresa | `QuoteCompanySnapshot` |
| Cliente | `QuoteClientSnapshot` |
| Evento | `QuoteEventSnapshot` |
| Itens e totais | `Quote.items` + centavos do `Quote` |
| Pagamento | `companySnapshot.payment` |
| Observações | `Quote.notes` (públicas) |
| Data da proposta | `Quote.createdAt` |
| Validade | `Quote.validUntil` |
| Status visual | `Quote.status` |

### Exclusões absolutas

- `internalNotes` do orçamento
- Chave PIX e dados internos nos **detalhes** da tela (PIX aparece no PDF quando presente no snapshot)
- Representante legal (capturado no snapshot; renderização prevista na TASK-022)
- Fotos de itens do catálogo

## Status e overlay visual

| Status | Watermark diagonal | Badge |
|--------|-------------------|-------|
| Rascunho | RASCUNHO | — |
| Enviado | — | ENVIADO |
| Aprovado | — | APROVADO |
| Recusado | RECUSADO | RECUSADO |
| Cancelado | CANCELADO | CANCELADO |

Watermark com opacidade reduzida para não prejudicar leitura.

## Layout

Documento formatado como **proposta comercial premium**:

- Cabeçalho centralizado com logo (`BoxFit.contain`, altura máx. ~85 pt)
- Folha A4 branca (economia de tinta na impressão)
- Tabela de itens com cabeçalho dourado
- Unidades compactas apenas na apresentação (`un.`, `m²`, etc.)
- Seções Pagamento e Observações indivisíveis (sem título órfão em quebra de página)
- Multipáginas com cabeçalho compacto a partir da página 2

## Preview (Premium Dark)

- Ambiente do visualizador em tema escuro (`AppColors.background`)
- Folha branca com borda dourada discreta e sombra
- Barra inferior com `AppColors.surface` e botão dourado de exportação
- O documento impresso permanece branco

## Exportação

### Mobile (Android / iOS)

- `Printing.sharePdf` com nome `orcamento_{numero}.pdf`
- Cancelamento silencioso

### Desktop (macOS / Windows / Linux)

1. `FilePicker.platform.saveFile` **sem** parâmetro `bytes`
2. `File(path).writeAsBytes(bytes, flush: true)`
3. Verificação de existência e tamanho do arquivo

Motivo: `file_picker` no desktop não grava bytes de forma confiável quando passados diretamente ao diálogo.

### Erros

- Falha de gravação ou compartilhamento: snackbar genérico
- Cancelamento do usuário: sem feedback de erro

## Logo

- Carregada somente de `quotes/company-assets/`
- Referências de `settings/logo/` são rejeitadas
- Logo ilegível ou ausente: PDF gerado sem imagem (sem falha)

## Rotas e acesso

- Preview: `/quotes/:id/pdf`
- Detalhes: seção **Documento PDF** com Visualizar e Salvar/Compartilhar
- Funciona nos cinco status

## Limitações atuais

- Sem bloco de aceite/assinaturas (TASK-022)
- Sem assinatura eletrônica
- Sem envio automático ao cliente
- Sem armazenamento persistente do arquivo gerado no app
- Sem fotos de itens

## Evolução futura

- TASK-022: bloco de aceite bilateral com linhas de assinatura vazias
- Assinatura eletrônica com trilha de auditoria (fora do escopo atual)
- Contrato PDF (módulo Contratos)
