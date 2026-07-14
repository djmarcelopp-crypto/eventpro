# Firebase spike — Checkpoint 0 (TASK-023)

App Flutter **isolado**. Não altera o EventPro principal.

## Status

**Checkpoint 0 parcialmente concluído** — **zero plataformas validadas** com Auth + Firestore real.

## Documentação

- Guia visual PO: `docs/tasks/TASK-023-firebase-dev-setup.md`
- ADR: `docs/adr/ADR-001-firebase-local-sync.md`
- Relatório: `docs/tasks/TASK-023-checkpoint-0-report.md`

## Dependências Firebase

Versões pinadas **sem** `dependency_overrides` nem dependência direta em `*_platform_interface`:

```yaml
firebase_core: 3.15.2
firebase_auth: 5.7.0
cloud_firestore: 5.6.12
firebase_storage: 12.4.10
```

Linha 4.x falha macOS sem override — não usar até correção upstream.

## Cloud Storage

**Bloqueado** — exige Blaze. Checkpoint 0 testa apenas **Auth + Firestore**.

## Execução ao vivo

```bash
flutter run -d macos \
  --dart-define=SPIKE_RUN_LIVE=true \
  --dart-define=SPIKE_USE_ANONYMOUS=true \
  --dart-define=SPIKE_FIRESTORE_ONLY=true
```

Relatório JSON salvo em `reports/` (gitignored).

## Higiene

Não commitar: `.dart_tool/`, `build/`, `reports/`, service accounts, senhas, debug tokens.

`firebase_options.dart` com IDs públicos do dev **pode** ser versionado.
