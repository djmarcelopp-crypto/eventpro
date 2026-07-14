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
- Fotos de itens do catálogo

## Aceite e assinaturas (TASK-022)

### Elegibilidade da seção

| Status | Seção de aceite |
|--------|-----------------|
| Enviado | Presente |
| Aprovado | Presente |
| Rascunho, Recusado, Cancelado | **Ausente** |

Preview e exportação do PDF continuam disponíveis em todos os status.

### Conteúdo

- Título **Aceite da proposta** com declaração fixa de concordância
- Linha **Local e data** em branco para preenchimento manual na impressão
- Em **Aprovado** com `approvedAt`: linha operacional `Aprovado no sistema em: {data} às {hora}`
- Duas colunas com **linhas físicas de assinatura** vazias
- Dados de identificação impressos **abaixo** das linhas (contratante e contratada)
- Representante legal da contratada quando capturado no snapshot
- Aviso operacional em fonte menor (disclaimer)

### Fonte de dados

Somente snapshots congelados do `Quote`:

- `QuoteClientSnapshot` → contratante (PF: nome + CPF; PJ: razão social + CNPJ)
- `QuoteCompanySnapshot` → contratada e representante legal
- `Quote.approvedAt` → label operacional (somente status Aprovado)

O gerador **não consulta** Settings, Clientes, Catálogo nem providers. `createdAt` não é usado como data de assinatura. `addressSummary` não é analisado para preencher cidade.

### Layout

- Seção posicionada após Pagamento e Observações
- Bloco inteiro em `pw.Inseparable` — em multipáginas, migra integralmente para a última página
- Sem captura de assinatura, imagem de rubrica, certificado, hash ou trilha de auditoria nesta fase
- Sem assinatura eletrônica ou digital

### Disclaimer

> Os status registrados no EventPro servem apenas ao controle interno e não substituem as assinaturas do contratante e da contratada.

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
- Seções Pagamento, Observações e Aceite indivisíveis (sem título órfão em quebra de página)
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

- Assinatura física apenas (linhas vazias); sem assinatura eletrônica ou digital
- PDF assinado manualmente permanece externo ao estado do app
- Geração/exportação do PDF não altera status nem `approvedAt`
- Sem envio automático ao cliente
- Sem armazenamento persistente do arquivo gerado no app
- Sem fotos de itens

## Evolução futura

- Assinatura eletrônica com trilha de auditoria (fora do escopo atual)
- Contrato PDF (módulo Contratos)
