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

## Unidades de cobrança iniciais

- Unidade
- Diária
- Hora
- Metro
- Metro quadrado
- Evento
- Serviço
- Outro (permite informar unidade personalizada)

## Preço

- Entrada amigável em pt-BR: aceita `1500`, `1500,00` e `1.500,00`.
- Exibição formatada: `R$ 1.500,00`.
- Valor deve ser **maior que zero**; negativos não são permitidos.
- Colar valores formatados no campo é suportado.

## Listagem

- Grid responsivo: 1, 2 ou 3 colunas conforme largura da tela.
- Cada card exibe: placeholder de foto, nome, tipo, categoria, preço por unidade e status.
- Itens **inativos** permanecem visíveis com indicação visual clara (badge **Inativo** e opacidade reduzida).
- Edição e exclusão: tarefas futuras.

## Campos do item

| Campo | Obrigatório | Observação |
|-------|-------------|------------|
| `id` | Sim | Gerado automaticamente |
| `type` | Sim | Equipamento ou Serviço |
| `name` | Sim | Nome do item |
| `category` | Sim | Uma das categorias iniciais |
| `description` | Não | Texto livre |
| `unit` | Sim | Unidade de cobrança (ex.: un, hora, dia) |
| `price` | Sim | Valor numérico em reais; deve ser **maior que zero** |
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

- `/catalog` — listagem do catálogo.
- `/catalog/new` — formulário de cadastro de item.
