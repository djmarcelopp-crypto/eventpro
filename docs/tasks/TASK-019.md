# TASK-019 — Integração Settings ↔ Orçamentos (snapshot da empresa)

## Objetivo

Congelar os dados da empresa emissora no momento da criação do orçamento, aplicar defaults do perfil no novo formulário e exibir a seção somente leitura nos detalhes — sem consultar Settings após o save.

## Checkpoints

### Checkpoint A — Infraestrutura ✅

- Modelos: `QuoteCompanySnapshot` e submodelos, `QuotePixKeyType`, `QuoteCompanyCaptureStatus`
- `QuoteCompanySnapshotBuilder.fromProfile`
- `AppImageCopyService` / `LocalAppImageCopyService`
- `LocalQuoteCompanyLogoStorageService` + provider + fake
- `QuoteNewDraftCompanySnapshotCoordinator`
- Regras: `phoneDigits`/`whatsAppDigits` independentes; perfil `null` → snapshot `null`; logo com `required DateTime timestamp`

### Checkpoint B — Provider + save ✅

- `Quote.companySnapshot?`; `copyWith` preserva snapshot existente
- `QuotesNotifier`: `addQuote` aceita snapshot na criação; `updateQuote` força `existing.companySnapshot`; transições preservam
- `NewQuoteScreen._save()`: relógio único, leitura do perfil, cópia de logo, montagem do snapshot, rollback do logo se falhar
- Edição não recria snapshot

### Checkpoint C — Defaults + banner ✅

- `QuoteFormDefaults`: sem perfil +7 dias; com perfil usa `defaultValidityDays` + `defaultPublicNotes`; data local; não marca dirty
- `QuoteCompanyProfileBanner`: somente em `/quotes/new`; botão para Configurações; edição sem banner

### Checkpoint D — Detalhes + documentação + verificação ✅

- Seção somente leitura **"Empresa emissora"** em `QuoteDetailScreen`
- `QuoteDetailPresenter`: formatação CNPJ, contato (WhatsApp → telefone → e-mail), endereço, status de captura
- `QuoteCompanySnapshotMissingNotice` para orçamentos legados
- Documentação em `quotes.md`, `settings.md` e esta task
- Testes de presenter + E2E do checkpoint D

## Regras de negócio consolidadas

| Regra | Comportamento |
|-------|---------------|
| Momento do snapshot | Primeiro save de novo orçamento |
| Sem perfil no save | `companySnapshot == null` (válido) |
| Edição | Nunca altera snapshot |
| Transições / reabertura | Preservam snapshot |
| Logo | Copiado para `quotes/company-assets/` |
| Settings posteriores | Não alteram orçamentos existentes |
| Detalhes | Usam somente snapshot; PIX e dados internos ocultos |
| Atualizar empresa no orçamento | Futuro |
| PDF / contrato | Usarão snapshot (não implementado) |
| Persistência | Ainda em memória |

## Arquivos principais

```
lib/features/quotes/
  models/quote_company_snapshot.dart
  utils/quote_company_snapshot_builder.dart
  utils/quote_form_defaults.dart
  utils/quote_detail_presenter.dart
  utils/quote_new_draft_company_snapshot_coordinator.dart
  data/services/local_quote_company_logo_storage_service.dart
  providers/quote_company_logo_storage_provider.dart
  widgets/quote_company_profile_banner.dart
  widgets/quote_company_snapshot_missing_notice.dart
  new_quote_screen.dart
  quote_detail_screen.dart
```

## Testes

| Arquivo | Escopo |
|---------|--------|
| `quote_company_snapshot_test.dart` | Modelo |
| `quote_company_snapshot_builder_test.dart` | Builder |
| `quote_new_draft_company_snapshot_coordinator_test.dart` | Coordenador + logo |
| `quotes_notifier_test.dart` | Provider + preservação |
| `quote_task_019_checkpoint_b_test.dart` | Save E2E |
| `quote_task_019_checkpoint_c_test.dart` | Defaults + banner |
| `quote_detail_presenter_test.dart` | Formatação empresa |
| `quote_task_019_checkpoint_d_test.dart` | Detalhes E2E |

## Verificação

```bash
flutter analyze
flutter test
flutter build macos
flutter build ios --simulator
```

Android: somente se SDK disponível. Windows: validação no notebook Windows.

## Fora de escopo

- PDF e contrato
- Ação "Atualizar dados da empresa"
- Persistência Firebase
- Exibição de logo nos detalhes
