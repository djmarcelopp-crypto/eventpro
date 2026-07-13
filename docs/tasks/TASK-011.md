# TASK-011 — Fundação do módulo Catálogo

## Objetivo
Ativar o módulo Catálogo no Dashboard com rota, tela, estado vazio, modelo de dados e provider em memória.

## Escopo
- Card Catálogo ativo no Dashboard.
- Rota `/catalog` e `CatalogScreen`.
- Estado vazio com botão **Novo item** (sem formulário nesta tarefa).
- Modelo `CatalogItem` com tipos Equipamento/Serviço e 8 categorias.
- Campo opcional `imageReference` para foto principal futura.
- Placeholder Premium Dark quando não houver foto.
- Provider Riverpod em memória (`catalogProvider`).

## Fora de escopo
- Formulário de cadastro/edição.
- Upload, seletor de arquivos, câmera, galeria, Firebase Storage.
- Múltiplas fotos por item.
- Estoque, disponibilidade, pacotes, integração com orçamentos/PDF.

## Critérios de aceite
- Dashboard navega para Catálogo e volta corretamente.
- Estado vazio profissional com placeholder e botão **Novo item**.
- `CatalogItem` com `imageReference` opcional.
- `catalogProvider` com CRUD básico testado.
- Clientes e rotas existentes preservados.
- `flutter analyze` e `flutter test` passam sem novas dependências.

## Decisões
- Referência de imagem: `imageReference` (neutra para evolução futura de storage).
- Foto principal única nesta fase; múltiplas fotos documentadas como evolução futura.
