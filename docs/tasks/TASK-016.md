# TASK-016 — Criar e listar Orçamentos

## Objetivo

Implementar o formulário de Novo orçamento, integrando Clientes e Catálogo, com cálculo financeiro em tempo real e listagem responsiva.

## Escopo

- Rota `/quotes/new` (declarada antes de futura `/quotes/:id`).
- Formulário completo: cliente, evento opcional, itens, linhas editáveis, resumo financeiro, validade e observações.
- Salvamento como rascunho via `addQuote`.
- Listagem com cards Premium Dark.
- SnackBar: *"Orçamento salvo como rascunho"*.
- Confirmação ao sair com alterações não salvas.
- Snapshots criados somente no Salvar.

## Fora de escopo

- Detalhes e edição do orçamento.
- Mudança de status, envio, PDF, contrato.
- Desconto percentual.
- Alteração de Clientes, Catálogo, fotos ou formatadores de preço.
- Commit e push.

## Critérios de aceite

- Formulário funcional com busca de cliente e itens ativos.
- Cálculo tolerante durante digitação; `QuoteLineItem` só no save.
- `draftId` monotônico; controllers por `draftId`.
- Bottom sheet fecha antes de cadastro auxiliar.
- Validade +7 dias sem marcar `isDirty`; validade passada bloqueada.
- Listagem ordenada por cópia; provider intocado.
- Descarte confirmado sai em uma única tentativa.
- `flutter analyze` e `flutter test` sem erros.
