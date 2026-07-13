# Regras de negócio — Catálogo

## Visão geral

O Catálogo reúne **equipamentos** e **serviços** usados pela empresa em orçamentos e operação.

Nesta fase, os itens existem apenas durante a sessão do aplicativo (provider em memória). A integração com Firebase será implementada em etapa futura.

## Tipos de item

| Tipo | Descrição |
|------|-----------|
| Equipamento | Itens físicos alugados ou utilizados em eventos |
| Serviço | Prestações de serviço oferecidas pela empresa |

## Categorias iniciais

- Som
- Iluminação
- Painel de LED
- Estrutura
- DJ
- Equipe
- Transporte
- Outros

Novas categorias exigirão alteração do enum `CatalogCategory`.

## Campos do item

| Campo | Obrigatório | Observação |
|-------|-------------|------------|
| `id` | Sim | Gerado automaticamente |
| `type` | Sim | Equipamento ou Serviço |
| `name` | Sim | Nome do item |
| `category` | Sim | Uma das categorias iniciais |
| `description` | Não | Texto livre |
| `unit` | Sim | Unidade de cobrança (ex.: un, hora, dia) |
| `price` | Sim | Valor numérico |
| `active` | Sim | Padrão `true`; permite desativar sem excluir |
| `createdAt` | Sim | Data de cadastro automática |
| `imageReference` | Não | Referência opcional da foto principal |

## Foto principal

- Cada item pode ter **uma foto principal opcional** via `imageReference`.
- Sem foto (`imageReference == null`): exibir placeholder Premium Dark.
- Usos previstos em tarefas futuras:
  - card do Catálogo;
  - detalhes do item;
  - opcionalmente no PDF do orçamento.
- **Múltiplas fotos por item:** evolução futura — fora do escopo atual.
- Upload, Firebase Storage, câmera, galeria e seletor de arquivos: tarefa dedicada futura.

## Persistência

- Nesta fase, os itens existem apenas durante a sessão do aplicativo.
- Os dados são perdidos ao fechar ou reiniciar o app.

## Rotas

- `/catalog` — listagem do catálogo (estado vazio na fundação inicial).
