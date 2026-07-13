# TASK-010 — Detalhes, edição e exclusão de clientes

## Objetivo
Permitir visualizar, editar e excluir clientes cadastrados, mantendo o fluxo de cadastro existente e as regras de privacidade das observações internas.

## Escopo
- Tela de detalhes do cliente com seções organizadas.
- Lista clicável que navega para os detalhes.
- Formulário reutilizado em modo edição.
- Exclusão com confirmação e ação destrutiva.
- Feedback na lista após cadastro, edição e exclusão.
- Rotas GoRouter: `/clients/new`, `/clients/:id`, `/clients/:id/edit`.

## Critérios de aceite
- Toque na lista abre detalhes do cliente selecionado.
- Detalhes exibem dados preenchidos; campos vazios são omitidos.
- Observações internas aparecem somente em detalhes e edição.
- Edição pré-preenche o formulário e, ao salvar, retorna à lista com *"Cliente atualizado com sucesso"*.
- `id` e `createdAt` são preservados no update, mesmo com dados inconsistentes no objeto enviado.
- Exclusão exige confirmação com o nome do cliente e botão destrutivo.
- Rota `/clients/new` declarada antes de `/clients/:id`.
- Cadastro, CNPJ, CEP, telefone e WhatsApp permanecem funcionais.
- `flutter analyze` e `flutter test` passam sem novas dependências.

## Decisões
- Após salvar edição, navegação direta à lista (não volta aos detalhes).
- Estado in-memory via `clientsProvider` (NotifierProvider).
