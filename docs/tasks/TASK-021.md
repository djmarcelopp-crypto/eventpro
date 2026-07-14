# TASK-021 — Pacotes no Catálogo e integração com Orçamentos

## Objetivo

Permitir cadastrar **Pacotes** no Catálogo como um terceiro tipo de item (além de Equipamento e Serviço), composto por itens simples com quantidade por pacote, integrar pacotes ao fluxo de Orçamentos com snapshots históricos independentes do Catálogo, e oferecer **exclusão permanente segura** para cadastros incorretos ou duplicados.

## Checkpoints

### Checkpoint A — Fundação ✅

- `CatalogItemType.package` e constante de unidade fixa `Pacote`
- `CatalogPackageComponent` com snapshots de nome, tipo, categoria, unidade e `quantityPerPackage`
- `CatalogItem.components` imutável; itens simples sempre retornam lista vazia
- `CatalogPackageValidator` (mínimo 1 componente, sem duplicidade, sem pacote aninhado, bloqueio de ausentes)
- Utilitários de quantidade (`CatalogQuantityParser`, `CatalogQuantityValidator`, formatador de entrada)
- Testes de modelo e validação

### Checkpoint B — Interface do Catálogo ✅

- Formulário de cadastro/edição com seção de componentes para Pacotes
- Seletor de componentes (equipamentos e serviços ativos/inativos existentes)
- Listagem e detalhes com badge **Pacote** e resumo de itens incluídos
- Preço manual do pacote (não calculado automaticamente)
- Testes de UI e validação no formulário

### Checkpoint C — Integração com Orçamentos ✅

- `QuotePackageComponentSnapshot` e campo `QuoteLineItem.packageComponents`
- `QuoteLineDraft` transporta componentes; `QuoteLineDraftSaver` persiste snapshots
- `QuoteFormInitializer` restaura componentes na edição de rascunho
- Seletor de catálogo, editor de linha e detalhes exibem badge e lista expansível de componentes
- `QuotePackageLinePresenter` para quantidade efetiva (`quantityPerPackage × lineQuantity`)
- Orçamentos antigos sem `packageComponents` permanecem válidos
- PDF continua apresentando o pacote como **linha financeira única** (sem checklist operacional)

### Checkpoint D — Exclusão permanente segura ✅

- `CatalogDeleteResult` / `CatalogDeleteStatus` (resultado tipado)
- `CatalogPackageDependencyChecker` bloqueia exclusão se item está em qualquer pacote (ativo ou inativo)
- `CatalogItemDeletionCoordinator` remove cadastro, tenta limpar foto sem rollback
- Diálogo destrutivo com confirmação por nome exato
- Área destrutiva nos detalhes; Ativar/Desativar preservado
- Orçamentos **não** bloqueiam exclusão; `quotesProvider` não é consultado
- Testes de provider, coordenador e widget

### Checkpoint E — Documentação, auditoria e verificação final

- `docs/tasks/TASK-021.md` (este arquivo)
- Atualização de `docs/business-rules/catalog.md` e `docs/business-rules/quotes.md`
- Auditoria de isolamento entre módulos
- `flutter analyze`, `flutter test`, builds macOS/iOS/APK

## Modelos de Pacote

### `CatalogItem` (tipo Pacote)

| Campo | Regra |
|-------|-------|
| `type` | `CatalogItemType.package` |
| `unit` | Sempre `Pacote` (fixo, não editável) |
| `price` | Manual; maior que zero |
| `category` | Categoria comercial do pacote (DJ, Som, etc.) — **não** confundir com o tipo |
| `components` | Lista imutável de `CatalogPackageComponent` |

### `CatalogPackageComponent`

| Campo | Descrição |
|-------|-----------|
| `catalogItemId` | ID do equipamento ou serviço referenciado |
| `nameSnapshot` | Nome no momento da composição |
| `unitSnapshot` | Unidade do componente |
| `typeSnapshot` | Label do tipo (Equipamento/Serviço) |
| `categorySnapshot` | Label da categoria |
| `quantityPerPackage` | Quantidade do componente **por 1 pacote** vendido |

### Quantidade por pacote

- Aceita valores decimais até 3 casas (ex.: `2`, `1,5`, `0,25`).
- Validação compartilhada com quantidade de orçamento (`CatalogQuantityValidator`).
- Na operação futura (checklist), a quantidade efetiva será `quantityPerPackage × quantidade de pacotes no orçamento`.

## Integração com Orçamentos

### Fluxo de criação

1. Usuário seleciona pacote ativo no seletor de catálogo.
2. `QuotePackageComponentMapper` converte `CatalogPackageComponent` → `QuotePackageComponentSnapshot`.
3. Linha salva com preço do pacote × quantidade de pacotes; componentes ficam em `packageComponents`.

### Exibição

- Formulário: badge **Pacote**, contagem de itens incluídos, lista expansível com quantidade por pacote e quantidade efetiva.
- Detalhes do orçamento: mesma apresentação em `QuoteLineItemsSection`.

### Preço

- Valor financeiro da linha = preço unitário do pacote (centavos) × quantidade de pacotes.
- Componentes **não** alteram o total financeiro da linha nesta entrega.

## Snapshots históricos

- `QuoteLineItem.packageComponents` é `List.unmodifiable` de `QuotePackageComponentSnapshot`.
- Capturados no **save** a partir do Catálogo vigente.
- Orçamentos antigos (`packageComponents == null`) continuam válidos — tratados como linha simples.
- Alterações posteriores no Catálogo (preço, componentes, exclusão, desativação) **não propagam** para orçamentos existentes.
- `catalogItemId` opcional no snapshot para rastreio; ausência não invalida o orçamento.

## Exclusão permanente

| Resultado | Comportamento |
|-----------|---------------|
| `deleted` | Item removido; foto apagada (se houver) |
| `deletedWithImageCleanupWarning` | Item removido; falha na foto com aviso genérico |
| `blockedByPackages` | Bloqueado; mensagem lista pacotes dependentes |
| `notFound` | ID inexistente — no-op seguro |
| `failure` | Erro genérico; item preservado |

### Regras

- **Desativar** para itens que não são mais oferecidos; **excluir** apenas para cadastros incorretos ou duplicados.
- Bloqueio se o item compõe qualquer pacote (ativo **ou** inativo).
- Orçamentos existentes **não** bloqueiam exclusão.
- Foto: captura `imageReference` → remove cadastro → tenta `deleteCommitted`; sem rollback por falha.
- Caminho físico da imagem nunca é exibido ao usuário.

## Testes

| Área | Arquivos principais |
|------|---------------------|
| Modelo Pacote | `catalog_item_package_test.dart`, `catalog_package_component_test.dart` |
| Validação | `catalog_package_validator_test.dart`, `catalog_quantity_parser_test.dart` |
| UI Catálogo | `new_catalog_item_screen_package_test.dart`, `catalog_item_detail_screen_test.dart` |
| Orçamentos | `quote_line_item_package_test.dart`, `quote_line_draft_saver_package_test.dart`, `quote_line_package_test.dart` |
| Exclusão | `catalog_item_deletion_coordinator_test.dart`, `catalog_item_detail_deletion_test.dart` |
| Regressão | `widget_test.dart`, testes de Clientes, Settings e PDF |

## Verificação

```bash
flutter analyze
flutter test
flutter build macos
flutter build ios --simulator
flutter build apk --debug   # depende do Android SDK no ambiente
```

## Limitações

- Dados do Catálogo e Orçamentos permanecem **em memória** (provider); perda ao reiniciar o app.
- Pacotes aninhados são **impossíveis** por validação em múltiplas camadas.
- Preço do pacote é manual; não há cálculo automático pela soma dos componentes.
- PDF apresenta pacote como linha financeira única; sem detalhamento operacional de componentes.
- Exclusão não remove componente automaticamente dos pacotes — usuário deve editar o pacote primeiro.
- Windows: build pendente de validação no notebook Windows.
- Android APK: requer Android SDK instalado no ambiente de desenvolvimento.

## Itens futuros (fora do escopo TASK-021)

Documentados como evolução; **não implementados** nesta tarefa:

### Checklist operacional de carregamento (TASK futura)

- Agrupamento de componentes por categoria
- Quantidade efetiva por linha de orçamento (`quantityPerPackage × pacotes`)
- Conferência de saída e retorno de equipamentos
- Responsável e horário de cada etapa
- Integração com operação de evento

### Outros

- Persistência Firebase do Catálogo e Orçamentos
- Lixeira/restauração de itens excluídos
- Exclusão em lote
- TASK-022 (aceite/assinaturas no PDF)
- Fotos de componentes no PDF
- Cálculo automático de preço sugerido do pacote

## Arquivos principais

```
lib/features/catalog/
  catalog_item_type.dart
  catalog_package_constants.dart
  models/catalog_item.dart
  models/catalog_package_component.dart
  models/catalog_delete_result.dart
  utils/catalog_package_validator.dart
  utils/catalog_package_dependency_checker.dart
  utils/catalog_item_deletion_coordinator.dart
  widgets/catalog_package_components_section.dart
  widgets/catalog_permanent_delete_dialog.dart

lib/features/quotes/
  models/quote_package_component_snapshot.dart
  models/quote_line_item.dart
  utils/quote_package_component_mapper.dart
  utils/quote_package_line_presenter.dart
  widgets/quote_line_package_components.dart
```

## Commits da branch

| Checkpoint | Mensagem |
|------------|----------|
| A | `feat: adiciona fundacao de pacotes ao catalogo` |
| B | `feat: adiciona interface de pacotes ao catalogo` |
| C | `feat: integra pacotes aos orcamentos` |
| D | `feat: adiciona exclusao permanente segura ao catalogo` |
