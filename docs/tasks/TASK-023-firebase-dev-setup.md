# TASK-023 — Guia visual: projeto Firebase de desenvolvimento

**Somente desenvolvimento.** Não criar projeto de produção nesta etapa.

---

## Antes de começar

| Item | Regra |
|------|-------|
| Plano | **Spark (grátis)** — suficiente para Auth + Firestore no Checkpoint 0 |
| Blaze / cartão | **Não ativar** sem autorização explícita do PO |
| Cloud Storage | **Exige Blaze** — **bloqueado** no Checkpoint 0 até aprovação de faturamento |
| Região | **southamerica-east1** (São Paulo) — escolher **antes** de criar; **não pode alterar depois** |
| Modo teste Firestore | **Nunca** usar — sempre Security Rules restritivas |

---

## Passo 1 — Criar o projeto dev

1. Abra [Firebase Console](https://console.firebase.google.com/).
2. Clique em **Adicionar projeto** (ou **Create a project**).
3. Nome sugerido: `eventpro-dev` (ou similar, claramente de desenvolvimento).
4. **Desative** Google Analytics se não for necessário no spike (opcional).
5. Na etapa de **localização do Cloud Firestore** (ou ao criar o banco), selecione:
   - **southamerica-east1 (São Paulo)**
6. Confirme que o projeto foi criado no plano **Spark**.

```
┌─────────────────────────────────────────┐
│  Firebase Console                       │
│  ┌─────────────────────────────────┐   │
│  │  + Adicionar projeto            │   │
│  └─────────────────────────────────┘   │
│         ↓                               │
│  Nome: eventpro-dev                     │
│  Região Firestore: southamerica-east1   │
│  Plano: Spark (sem cartão)              │
└─────────────────────────────────────────┘
```

---

## Passo 2 — Registrar apps Flutter (quatro plataformas)

No projeto dev, vá em **Visão geral do projeto** → ícone de engrenagem → **Configurações do projeto** → **Seus apps**.

Registre os quatro apps com bundle/package `com.eventpro.spike`.

> **iOS:** os plugins Firebase exigem **deployment target mínimo 15.0** (já configurado no spike).

| Plataforma | Package / Bundle ID sugerido |
|------------|------------------------------|
| Android | `com.eventpro.spike` |
| iOS | `com.eventpro.spike` |
| macOS | `com.eventpro.spike` |
| Windows | `com.eventpro.spike` |

Para cada app, baixe os arquivos de configuração quando solicitado (Android `google-services.json`, Apple `GoogleService-Info.plist`). O FlutterFire CLI pode gerar `firebase_options.dart` automaticamente.

---

## Passo 3 — Habilitar Authentication

1. Menu **Build** → **Authentication** → **Começar**.
2. Aba **Sign-in method**.
3. Para o spike Checkpoint 0, habilite **um** método:
   - **Anônimo** (mais rápido para prova), **ou**
   - **E-mail/senha** (criar usuário de teste manualmente depois).
4. **Não** habilitar provedores extras nesta etapa.

```
Authentication → Sign-in method
  [x] Anônimo          ← recomendado para spike
  [ ] E-mail/senha     ← alternativa
```

---

## Passo 4 — Criar Firestore (modo produção + Rules)

1. Menu **Build** → **Firestore Database** → **Criar banco de dados**.
2. Escolha **modo de produção** (não “modo de teste”).
3. Local: **southamerica-east1**.
4. **Não** deixe regras abertas — publicaremos as Rules do spike no Passo 6.

---

## Passo 5 — Cloud Storage (BLOQUEADO no Checkpoint 0)

1. Menu **Build** → **Storage**.
2. **Não provisionar bucket** nesta etapa.
3. O console solicitará upgrade para **Blaze (pay-as-you-go)**.
4. **Parar aqui** — aguardar autorização explícita do PO para faturamento.

> Storage permanece **bloqueado** até aprovação. Auth + Firestore podem ser testados antes.

---

## Passo 6 — Publicar Security Rules do spike

No computador de desenvolvimento (com [Firebase CLI](https://firebase.google.com/docs/cli) instalado):

```bash
# Na raiz do repositório eventpro
cp .firebaserc.example .firebaserc
# Edite .firebaserc e substitua REPLACE_WITH_DEV_PROJECT_ID pelo ID real

firebase login
firebase deploy --only firestore:rules --project SEU_PROJETO_DEV
```

As rules publicadas estão em `tool/firebase_spike/firestore.rules`:

- **Deny all** por padrão.
- Permite CRUD apenas em `spike_checkpoint0/{userId}/runs/{runId}` para o usuário autenticado.

**Nunca** publicar regras abertas (`allow read, write: if true`).

---

## Passo 7 — Gerar `firebase_options.dart` (FlutterFire)

```bash
dart pub global activate flutterfire_cli
cd tool/firebase_spike
flutterfire configure \
  --project=SEU_PROJETO_DEV \
  --out=lib/firebase_options.dart \
  --platforms=android,ios,macos,windows
```

O arquivo `lib/firebase_options.dart` contém **identificadores públicos** — pode ser versionado no dev.

**Nunca versionar:** service account JSON, senhas de teste, debug tokens App Check.

---

## Passo 7b — Pré-requisitos nativos (correções descobertas na prova)

Antes da primeira execução ao vivo em **macOS** e **iOS**, confirme:

| Correção | Onde aplicar |
|----------|--------------|
| `WidgetsFlutterBinding.ensureInitialized()` | `tool/firebase_spike/lib/main.dart` (já no spike) |
| `com.apple.security.network.client` | `macos/Runner/DebugProfile.entitlements` e `Release.entitlements` |
| **Keychain Sharing** (`keychain-access-groups`) | entitlements macOS (Auth persiste sessão) |
| Assinatura **Apple Development** | Xcode → Signing & Capabilities (macOS + iOS) |
| iOS deployment target **15.0** | `ios/Runner.xcodeproj` (requisito dos plugins Firebase) |

Sem `network.client` ou Keychain, Auth/Firestore falham em runtime no macOS. Sem assinatura válida, o build Apple não executa.

---

## Passo 8 — Executar prova real (Auth + Firestore)

### macOS

```bash
cd tool/firebase_spike
flutter pub get
flutter run -d macos \
  --dart-define=SPIKE_RUN_LIVE=true \
  --dart-define=SPIKE_USE_ANONYMOUS=true \
  --dart-define=SPIKE_FIRESTORE_ONLY=true
```

### iOS Simulator

```bash
flutter run -d ios \
  --dart-define=SPIKE_RUN_LIVE=true \
  --dart-define=SPIKE_USE_ANONYMOUS=true \
  --dart-define=SPIKE_FIRESTORE_ONLY=true
```

### Resultado esperado

- Console exibe JSON com `success: true` e passos `auth_sign_in`, `firestore_*`, `auth_sign_out`.
- `storage_skipped` presente (Storage bloqueado — Blaze não autorizado).

### Destino dos relatórios (gitignored)

| Plataforma | Pasta do relatório JSON |
|------------|-------------------------|
| macOS / Windows | `tool/firebase_spike/reports/<platform>_live_<timestamp>.json` |
| iOS / Android | `Directory.systemTemp` — caminho **absoluto** impresso no terminal |

> No iOS Simulator, o arquivo **não** fica em `reports/`; copie do caminho exibido no console se precisar arquivar localmente.

**Não** considerar válido o modo documentação (placeholders) nem testes que só detectam placeholders.

---

## Passo 9 — Restrições de segurança

| Permitido versionar | Proibido versionar |
|---------------------|-------------------|
| `firebase_options.dart` (IDs públicos) | Service account JSON |
| `firestore.rules` do spike | Senhas de teste |
| `.firebaserc.example` | Debug tokens App Check |
| | Credenciais administrativas |

---

## Passo 10 — O que NÃO fazer agora

- [ ] Criar projeto **produção**
- [ ] Ativar **Blaze** / cadastrar cartão
- [ ] Provisionar **Cloud Storage**
- [ ] Usar Firestore em **modo teste**
- [ ] Integrar Firebase no app **EventPro** principal
- [ ] Iniciar **Checkpoint A**

---

## Checklist do proprietário

- [x] Projeto `eventpro-dev` criado em `southamerica-east1`
- [x] Plano Spark (sem Blaze)
- [x] Auth habilitado (Anônimo ou E-mail)
- [x] Firestore em modo produção + Rules do spike publicadas
- [x] `firebase_options.dart` gerado
- [x] Prova macOS executada — `macos_live_1784050700344.json` em `reports/`
- [x] Prova iOS executada — `ios_live_1784052495570.json` (systemTemp; copiar se necessário)
- [ ] Android — aguarda Android SDK
- [ ] Windows — aguarda notebook Windows
- [ ] Storage — aguarda autorização Blaze

---

## Referências

- `tool/firebase_spike/README.md`
- `docs/adr/ADR-001-firebase-local-sync.md`
- `docs/tasks/TASK-023-checkpoint-0-report.md`
