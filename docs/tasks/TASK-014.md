# TASK-014 — Foto principal dos itens do Catálogo

## Objetivo
Permitir selecionar, visualizar, substituir e remover uma foto principal no cadastro e na edição de equipamentos e serviços.

## Plataformas
- **Android e iOS:** galeria via `image_picker` (`ImageSource.gallery`, sem câmera).
- **Windows e macOS:** arquivo JPG/JPEG/PNG via `file_picker`.
- Diferenças isoladas em `data/services/`; telas não contêm código de plataforma.

## Dependências
| Pacote | Justificativa |
|--------|---------------|
| `image_picker` | Galeria nativa em Android e iOS |
| `file_picker` | Seletor de arquivo em Windows e macOS |
| `path_provider` | Diretório persistente do app |

## Armazenamento local
- Arquivos em `ApplicationDocumentsDirectory/catalog_images/` (permanentes) e `catalog_images_staged/` (rascunho).
- `imageReference` opaca e relativa: `catalog/images/{itemId}_{uuid}.jpg`.
- Catálogo permanece em memória; fotos persistem no disco local.
- Ao reiniciar o app, metadados somem mas arquivos podem permanecer (limitação documentada).

## Ciclo de vida do formulário
Estado explícito: `originalImageReference`, `stagedImageReference`, `removeImageRequested`, `formSaved`.

- Cancelar/sair (`PopScope` + dispose): descarta apenas staged.
- Salvar troca: commit → provider → apagar original.
- Salvar remoção: `clearImageReference` → provider → apagar original.
- Rollback se save falhar após commit.

## Validação
- Máximo 10 MB.
- Decodificação real dos bytes (não confiar na extensão).
- HEIC/HEIF **não suportado** nesta entrega — mensagem clara ao usuário iPhone.

## Permissões
| Plataforma | Permissão |
|------------|-----------|
| iOS | `NSPhotoLibraryUsageDescription` |
| Android (API 33+) | Photo Picker — sem permissão extra |
| Android antigo | Adicionar somente se teste real exigir |
| macOS / Windows | Nenhuma extra |

## Fora de escopo
Câmera, múltiplas fotos, recorte, conversão HEIC, Firebase, upload nuvem, exclusão definitiva do item.

## Verificação de plataformas
- `flutter analyze` e `flutter test` no ambiente de desenvolvimento.
- Build macOS no Mac.
- Build Android/iOS Simulator se SDK disponível.
- Build Windows: validar manualmente no notebook Windows (não compilável no Mac).
