# Regras de negócio — Catálogo

## Visão geral

O Catálogo reúne **equipamentos**, **serviços** e **pacotes** usados pela empresa em orçamentos e operação.

Nesta fase, os itens existem apenas durante a sessão do aplicativo (provider em memória). A integração com Firebase será implementada em etapa futura.

## Tipos de item

| Tipo | Descrição |
|------|-----------|
| Equipamento | Itens físicos alugados ou utilizados em eventos |
| Serviço | Prestações de serviço oferecidas pela empresa |
| **Pacote** | Combinação comercial de equipamentos e/ou serviços com quantidade por pacote |

**Pacote é um tipo de item**, não uma categoria. A categoria (Som, DJ, etc.) classifica o pacote comercialmente, assim como equipamentos e serviços.

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

## Unidades de cobrança

### Equipamentos e serviços

- Unidade
- Diária
- Hora
- Metro
- Metro quadrado
- Evento
- Serviço
- Outro (permite informar unidade personalizada)

### Pacotes

- Unidade **fixa**: `Pacote` (`CatalogPackageConstants.unit`)
- Não editável no formulário; aplicada automaticamente ao salvar

## Preço

- Entrada amigável em pt-BR: aceita `1500`, `1500,00` e `1.500,00`.
- Exibição formatada: `R$ 1.500,00`.
- Valor deve ser **maior que zero**; negativos não são permitidos.
- Colar valores formatados no campo é suportado.
- **Pacotes:** preço é **manual**; não há cálculo automático pela soma dos componentes.

## Pacotes — composição

### Componentes

- Todo pacote exige **mínimo de um componente**.
- Componentes são equipamentos ou serviços já cadastrados (ativos ou inativos **existentes** no provider).
- Cada componente possui `quantityPerPackage` (quantidade por 1 pacote vendido).
- Quantidade aceita decimais até 3 casas.

### Restrições

| Regra | Comportamento |
|-------|---------------|
| Sem duplicidade | O mesmo `catalogItemId` não pode aparecer duas vezes no pacote |
| Sem aninhamento | Pacote **não pode** ser componente de outro pacote |
| Componente ausente | Bloqueia salvamento com mensagem clara |
| Componente inativo | **Permitido** se ainda existir no provider (snapshot no componente preserva dados) |
| Itens simples | `components` é sempre lista vazia (normalizado no modelo) |

### Imutabilidade

- `CatalogItem.components` e cada `CatalogPackageComponent` são tratados como listas **imutáveis** (`List.unmodifiable`).
- Snapshots de nome, tipo, categoria e unidade são gravados no componente no momento da composição.

### Listagem e detalhes

- Badge **Pacote** na listagem.
- Detalhes exibem resumo compacto dos componentes e quantidade por pacote.

## Listagem

- Grid responsivo: 1, 2 ou 3 colunas conforme largura da tela.
- Cada card exibe: placeholder de foto, nome, tipo, categoria, preço por unidade e status.
- Itens **inativos** permanecem visíveis com indicação visual clara (badge **Inativo** e opacidade reduzida).
- Card clicável abre detalhes do item.

## Desativação vs exclusão definitiva

### Desativar (padrão operacional)

- Para itens que **não são mais oferecidos**, prefira **desativar**.
- Altera `active: false`; o item permanece no catálogo e no provider.
- Exige confirmação na tela de detalhes; feedback local na própria tela.
- Preserva referências em pacotes e histórico futuro.

### Excluir definitivamente (casos excepcionais)

- Destinada a cadastros **incorretos** ou **duplicados**.
- Área destrutiva separada nos detalhes, com botão vermelho **Excluir definitivamente**.
- Diálogo irreversível exige digitar o **nome exato** do item (comparação após `trim`, case-sensitive).
- Resultado tipado (`CatalogDeleteResult`); a UI não depende de texto de exceção.

#### Bloqueio por pacotes

- Antes de excluir, o sistema consulta todos os itens no `catalogProvider`.
- **Bloqueia** se o item compõe qualquer pacote — **ativo ou inativo**.
- Mensagem lista os nomes dos pacotes dependentes.
- O componente **não** é removido automaticamente; edite o pacote antes de excluir o item.
- Um **pacote** pode ser excluído normalmente se não for referenciado por outro pacote.

#### Orçamentos

- Orçamentos existentes **não bloqueiam** exclusão.
- O Catálogo **não consulta** `quotesProvider`.
- Snapshots em orçamentos permanecem intactos.

#### Foto na exclusão

1. Captura `imageReference` antes de remover o cadastro.
2. Remove o item do provider.
3. Tenta apagar a foto definitiva pelo serviço de storage.
4. Falha na foto: item permanece excluído; aviso genérico ao usuário.
5. **Sem rollback** do cadastro por falha de limpeza.
6. Caminho físico da imagem **nunca** é exibido nem registrado em mensagens.
7. Fotos de outros itens e rascunhos (`staged`) não são afetadas.

## Detalhes e edição

- Tela de detalhes exibe: foto (placeholder), nome, tipo, categoria, descrição (se houver), unidade, preço formatado, status e data de cadastro.
- Pacotes exibem seção de componentes incluídos.
- Campos vazios não geram linhas desnecessárias.
- Edição reutiliza o formulário de cadastro, preservando `id`, `createdAt` e `imageReference`.
- Ativar/Desativar exige confirmação; permanece na tela de detalhes com feedback local.

## Campos do item

| Campo | Obrigatório | Observação |
|-------|-------------|------------|
| `id` | Sim | Gerado automaticamente |
| `type` | Sim | Equipamento, Serviço ou Pacote |
| `name` | Sim | Nome do item |
| `category` | Sim | Uma das categorias iniciais |
| `description` | Não | Texto livre |
| `unit` | Sim | Unidade de cobrança; fixa `Pacote` para pacotes |
| `price` | Sim | Valor numérico em reais; deve ser **maior que zero** |
| `active` | Sim | Padrão `true`; permite desativar sem excluir |
| `createdAt` | Sim | Data de cadastro automática |
| `imageReference` | Não | Referência opcional da foto principal |
| `components` | Pacote | Lista imutável de componentes; vazia para itens simples |

## Foto principal

- Cada item pode ter **uma foto principal opcional** via `imageReference`.
- Sem foto (`imageReference == null`): exibir placeholder Premium Dark.
- **Seleção por plataforma:**
  - Android e iPhone: galeria (sem câmera nesta fase).
  - Windows e macOS: arquivo JPG, JPEG ou PNG.
- Formatos aceitos: JPG, JPEG e PNG, validados pelos bytes (máximo 10 MB).
- HEIC/HEIF (comum no iPhone) **não é suportado** nesta entrega; o usuário recebe mensagem orientando JPG ou PNG.
- A foto é copiada imediatamente para o diretório do app; o modelo guarda apenas `imageReference` opaca (sem Base64 nem caminho absoluto externo).
- Rascunhos ficam em `catalog_images_staged/`; arquivos definitivos em `catalog_images/`.
- Cancelar o formulário descarta apenas o rascunho; a foto salva só é removida após confirmação do salvamento.
- Exibição: cards do catálogo, detalhes do item e formulário de cadastro/edição.
- **Múltiplas fotos por item:** evolução futura — fora do escopo atual.
- Firebase Storage, upload em nuvem e câmera: fora do escopo atual.

### Limitação de persistência

O catálogo permanece em memória nesta fase. As fotos persistem no disco local do dispositivo, mas os metadados dos itens são perdidos ao reiniciar o app. Arquivos órfãos podem permanecer no disco até limpeza futura.

## Persistência

- Nesta fase, os itens existem apenas durante a sessão do aplicativo.
- Os dados são perdidos ao fechar ou reiniciar o app.

## Rotas

- `/catalog` — listagem do catálogo.
- `/catalog/new` — formulário de cadastro de item.
- `/catalog/:id` — detalhes do item.
- `/catalog/:id/edit` — formulário de edição do item.

## Evolução futura (fora do escopo)

- Checklist operacional de carregamento a partir dos componentes do pacote no orçamento
- Agrupamento por categoria na operação
- Quantidade efetiva, conferência de saída/retorno, responsável e horário
- Persistência Firebase
- Lixeira e restauração de itens excluídos
- Exclusão em lote
