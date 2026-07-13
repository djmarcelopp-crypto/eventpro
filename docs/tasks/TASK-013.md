# TASK-013 — Detalhes, edição e ativação/desativação de itens do Catálogo

## Objetivo
Permitir visualizar detalhes de itens do Catálogo, editá-los e ativá-los/desativá-los sem exclusão definitiva.

## Escopo
- Rota `/catalog/:id` com tela de detalhes observando `catalogProvider`.
- Rota `/catalog/:id/edit` reutilizando `NewCatalogItemScreen`.
- Card clicável na listagem.
- Ação Editar nos detalhes.
- Ativar/Desativar com confirmação e SnackBar local.
- Edição com SnackBar global ao retornar ao Catálogo.
- Remoção de `deleteItem` da API pública do provider.
- `RegistrationDateFormatter` em `core/` (sem dependência de `ClientDateFormatter`).

## Fora de escopo
- Exclusão definitiva de itens.
- Upload de foto, Firebase, estoque, pacotes.
- Integração com orçamentos.
- Alteração dos formatadores de preço da TASK-012.

## Critérios de aceite
- Detalhes resolvem item pelo ID via `catalogProvider` em cada atualização.
- Descrição omitida quando vazia.
- Edição preserva `id`, `createdAt` e `imageReference`.
- `updateItem` preserva `id`, `createdAt` e posição na lista; no-op se ID inexistente.
- Itens inativos permanecem visíveis na listagem.
- Clientes, Dashboard e rotas existentes preservados.
- `flutter analyze` e `flutter test` passam sem novas dependências.

## Decisões
- Itens são **desativados, não apagados**, para preservar futuros históricos de orçamentos.
- `catalogProvider` é a fonte oficial dos dados pelo ID da rota.
- `extra` na navegação é opcional; nunca fonte principal.
- SnackBar global após editar; SnackBar local nos detalhes após ativar/desativar.
- `/catalog/new` permanece antes das rotas dinâmicas.
