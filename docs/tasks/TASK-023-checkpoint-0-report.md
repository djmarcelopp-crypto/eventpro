# TASK-023 — Checkpoint 0: Prova técnica e ADR

| Campo | Valor |
|-------|-------|
| **Data** | 2026-07-14 (evidências ao vivo) |
| **Ambiente** | macOS 26.5 — Xcode 26.5 — Flutter 3.44.6 |
| **Branch** | `cursor/task-023-cloud-foundation` |
| **Status** | **Checkpoint 0 parcialmente concluído** |
| **Plataformas validadas ao vivo** | **2 de 4** (macOS, iOS Simulator) |

---

## 1. Resumo executivo

O Checkpoint 0 validou **Auth anônimo + CRUD Firestore completo + logout** em **macOS** e **iOS Simulator**, com `success: true` nos relatórios JSON. **Cloud Storage não foi testado** — permanece bloqueado (exige Blaze).

**Android** pendente (Android SDK ausente). **Windows** pendente (notebook Windows).

**Checkpoint A não deve ser iniciado** até decisão explícita sobre encerramento do Checkpoint 0 nas quatro plataformas.

---

## 2. Entregáveis

| Artefato | Caminho | Status |
|----------|---------|--------|
| Spike isolado | `tool/firebase_spike/` | ✅ |
| ADR | `docs/adr/ADR-001-firebase-local-sync.md` | ✅ |
| Guia Firebase dev | `docs/tasks/TASK-023-firebase-dev-setup.md` | ✅ |
| Functions (stubs TS) | `functions/` | ✅ |
| Firestore Rules spike | `tool/firebase_spike/firestore.rules` | ✅ publicadas no dev |
| Storage | — | 🚫 **não aberto** (Blaze) |
| Este relatório | `docs/tasks/TASK-023-checkpoint-0-report.md` | ✅ |

**Não alterados:** `lib/features/**` — EventPro principal, providers e modelos de produção.

---

## 3. Matriz de validação — 2 de 4 plataformas validadas ao vivo

| Plataforma | Build | Auth + Firestore real | Storage | Validada ao vivo? |
|------------|-------|----------------------|---------|-------------------|
| **macOS** | ✅ | ✅ Auth anônimo + CRUD + logout | 🚫 não aberto | **Sim** |
| **iOS Simulator** | ✅ | ✅ Auth anônimo + CRUD + logout | 🚫 não aberto | **Sim** |
| **Android** | 🚫 SDK ausente | ⏳ pendente | 🚫 | **Não** |
| **Windows** | ⏳ notebook indisponível | ⏳ pendente | 🚫 | **Não** |

> Validação ao vivo = relatório JSON com `success: true` e passos `auth_sign_in`, `firestore_create/read/update/delete`, `auth_sign_out`. Build sozinho não conta.

---

## 4. Evidências ao vivo (Auth + Firestore)

Relatórios locais (gitignored em `tool/firebase_spike/reports/`). Integridade por SHA-256:

| Arquivo | Plataforma | SHA-256 |
|---------|------------|---------|
| `macos_live_1784050700344.json` | macOS | `bc3f2e9e0cd072a57756f9a051c29570b30cd744cfb9a16fe99a93fdeb9cdcf9` |
| `ios_live_1784052495570.json` | iOS Simulator | `42ebc87ed65442bbdedbbdd7ad346f1e21d1f6445099dc5e4db53dea3a4772f3` |

### Passos confirmados em ambos os relatórios

| Passo | Resultado |
|-------|-----------|
| `firebase_initialize` | ✅ |
| `auth_sign_in` (anônimo) | ✅ |
| `firestore_create` | ✅ |
| `firestore_read` | ✅ |
| `firestore_update` | ✅ |
| `firestore_delete` | ✅ |
| `storage_skipped` | ✅ (Storage bloqueado — Blaze não autorizado) |
| `auth_sign_out` | ✅ |
| **`success`** | **`true`** |

### Destino dos relatórios

| Plataforma | Pasta |
|------------|-------|
| macOS / Windows | `tool/firebase_spike/reports/` (relativo) |
| iOS / Android | `Directory.systemTemp` (caminho absoluto no terminal) |

---

## 5. Itens pendentes

| # | Item | Status |
|---|------|--------|
| 1 | Projeto Firebase dev (`southamerica-east1`, Spark) | ✅ |
| 2 | Rules spike publicadas (deny-all + path spike) | ✅ |
| 3 | `firebase_options.dart` gerado | ✅ |
| 4 | Prova ao vivo macOS | ✅ |
| 5 | Prova ao vivo iOS Simulator | ✅ |
| 6 | Prova Android nativa | ⏳ Android SDK ausente |
| 7 | Prova Windows nativa | ⏳ notebook Windows |
| 8 | Compatibilidade Firebase 3.x sem override | ✅ |
| 9 | Cloud Storage / Blaze | 🚫 bloqueado até autorização PO |
| 10 | Decisão explícita sobre bloqueios Android/Windows | ⏳ aguarda PO |

---

## 6. Evidências técnicas complementares

### 6.1 Dependências Firebase (spike)

```
firebase_core: 3.15.2
firebase_auth: 5.7.0
cloud_firestore: 5.6.12
firebase_storage: 12.4.10
```

Sem `dependency_overrides`. Linha 4.x falha macOS — não usar.

### 6.2 Correções descobertas na prova

| Correção | Onde |
|----------|------|
| `WidgetsFlutterBinding.ensureInitialized()` | `lib/main.dart` |
| `com.apple.security.network.client` | entitlements macOS Debug + Release |
| Keychain Sharing (`keychain-access-groups`) | entitlements macOS |
| Assinatura **Apple Development** | Xcode (macOS + iOS) |
| Relatório mobile em `Directory.systemTemp` | `lib/main.dart` |
| iOS deployment target **15.0** | `ios/Runner.xcodeproj` |

### 6.3 Cloud Storage

**Não aberto.** Console exige Blaze. Nenhum bucket provisionado. Spike registra `storage_skipped`.

### 6.4 Data orçamento offline

✅ Aprovada: `Quote.createdAt` preservado; `serverNumberedAt` separado.

---

## 7. Bloqueios remanescentes

| Bloqueio | Impacto |
|----------|---------|
| Android SDK ausente | Android não validado |
| Notebook Windows indisponível | Windows não validado |
| Cloud Storage exige Blaze | Storage bloqueado (intencional) |

---

## 8. Verificações executadas (atualização)

| Comando | Escopo | Resultado |
|---------|--------|-----------|
| `flutter analyze` | EventPro | ✅ |
| `flutter test` | EventPro | ✅ **718** testes |
| `flutter analyze lib test` | spike | ✅ |
| `flutter test` | spike | ✅ |
| `npm run build` | functions | ✅ |

---

## 9. Auditoria de segurança

| Item | Resultado |
|------|-----------|
| Credenciais/senhas/tokens admin versionados | ✅ Não encontrados |
| `reports/` no `.gitignore` | ✅ |
| EventPro `lib/features/**` inalterado | ✅ |
| Storage / Blaze / Analytics habilitados | ✅ Não |
| Checkpoint A iniciado | ✅ Não |

`firebase_options.dart` contém apenas identificadores públicos do projeto dev (permitido).

---

## 10. Próximo passo

1. Validar **Android** quando SDK estiver disponível.
2. Validar **Windows** no notebook Windows.
3. Decisão PO: encerrar Checkpoint 0 com 2/4 ou aguardar 4/4.
4. Storage permanece bloqueado até autorização Blaze explícita.

**Não iniciar Checkpoint A** nesta revisão.

---

## 11. Referências

- `docs/adr/ADR-001-firebase-local-sync.md`
- `docs/tasks/TASK-023-firebase-dev-setup.md`
- `tool/firebase_spike/README.md`
