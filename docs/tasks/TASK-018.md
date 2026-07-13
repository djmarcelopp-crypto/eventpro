# TASK-018 — Configurações e dados da empresa

## Objetivo

Implementar o módulo de Configurações com perfil único da empresa, logotipo, consultas CNPJ/CEP, validações profissionais e proteção contra perda de alterações.

## Checkpoints

### Checkpoint A — Extração para `core/` ✅

- `core/lookup/` — BrasilAPI CNPJ/CEP
- `core/validation/` — CPF, CNPJ, telefone, e-mail
- `core/formatting/` — máscaras brasileiras
- `core/media/` — infraestrutura genérica de imagem
- Clientes e Catálogo: re-exports/wrappers finos

### Checkpoint B — Settings base ✅

- Modelos, provider único, validações, status, navegação, formulário base
- Sem logo, lookup ou PopScope

### Checkpoint C — Logo, lookup, dirty form ✅

- Logotipo via `core/media`, prefixo `settings/logo/`
- `SettingsCnpjFormFiller` e `SettingsCepFormFiller`
- PopScope com diálogo de descarte
- Testes E2E em `settings_checkpoint_c_test.dart`
- Documentação em `docs/business-rules/settings.md`

## Arquivos principais

```
lib/features/settings/
  company_profile_screen.dart
  settings_screen.dart
  data/services/local_company_logo_storage_service.dart
  providers/company_logo_services_provider.dart
  providers/company_profile_provider.dart
  utils/settings_cnpj_form_filler.dart
  utils/settings_cep_form_filler.dart
  widgets/company_logo_form_section.dart
  widgets/company_logo_view.dart
```

## Verificação

```bash
flutter analyze
flutter test
flutter build macos
flutter build ios --simulator   # se SDK disponível
flutter build apk               # se SDK Android disponível
```

Build Windows: validar manualmente no notebook Windows.

## Fora de escopo

- Persistência Firebase do perfil
- Logo em PDF/contrato (snapshot futuro)
- PopScope em outros módulos
- Novas dependências
