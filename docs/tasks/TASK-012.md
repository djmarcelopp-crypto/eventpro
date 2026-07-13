# TASK-012 — Cadastro e listagem de itens do Catálogo

## Objetivo
Permitir cadastrar itens no Catálogo via formulário e exibi-los em grid responsivo com feedback de sucesso.

## Escopo
- Rota `/catalog/new` e formulário de cadastro.
- Campos: tipo, nome, categoria, descrição, unidade de cobrança, preço, ativo.
- Unidades iniciais com opção **Outro** e unidade personalizada.
- Preço em pt-BR (entrada e exibição), obrigatório e maior que zero.
- Placeholder de foto (`imageReference` permanece `null`).
- Listagem em grid responsivo (1, 2 ou 3 colunas).
- Itens inativos visíveis com indicação visual.
- SnackBar de sucesso ao cadastrar.

## Fora de escopo
- Edição e exclusão de itens.
- Upload de foto, câmera, galeria, Firebase Storage.
- Estoque, disponibilidade, pacotes.
- Integração com orçamentos e PDF.
- Firebase.

## Critérios de aceite
- Botão **Novo item** no empty state e no AppBar (quando há itens) abre o formulário.
- Validações de campos obrigatórios e preço > 0.
- Unidade **Outro** exige texto personalizado; ao sair de **Outro**, o campo é limpo.
- Preço aceita `1500`, `1500,00` e `1.500,00`, salvando como valor numérico correto.
- Colar valor formatado no campo de preço não quebra o parser.
- Cards sem overflow para nomes, categorias e unidades longas.
- Salvar adiciona ao `catalogProvider`, volta ao Catálogo e exibe SnackBar.
- Clientes, Dashboard e rotas existentes preservados.
- `flutter analyze` e `flutter test` passam sem novas dependências.

## Decisões
- Preço deve ser **maior que zero** (`price > 0`).
- Grid responsivo: 1 coluna (&lt; 520 px), 2 colunas (520–799 px), 3 colunas (≥ 800 px).
- Formatter de preço manual em Dart, sem adicionar `intl` ao `pubspec.yaml`.
- Unidades predefinidas salvam o rótulo em `CatalogItem.unit`; **Outro** salva texto livre.
