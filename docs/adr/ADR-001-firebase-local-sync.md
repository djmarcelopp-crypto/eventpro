# ADR-001 — Firebase na nuvem + Drift local + sincronização (TASK-023)

| Campo | Valor |
|-------|-------|
| **Status** | **Checkpoint 0 parcialmente concluído** — **2 de 4** plataformas validadas ao vivo (macOS, iOS Simulator) |
| **Data** | 2026-07-14 |
| **Decisores** | PO (Marcelo PP), CTO, Engenharia |
| **Contexto** | TASK-023 — persistência, autenticação e sincronização |

---

## 1. Contexto

O EventPro persiste apenas imagens em disco; Clientes, Catálogo, Orçamentos e Settings vivem em providers Riverpod em memória. O `PROJECT.md` define Firebase (Auth, Firestore, Storage) como stack oficial. Esta ADR registra decisões do Checkpoint 0 e pré-requisitos para Checkpoints A–F.

**Plataformas obrigatórias:** Android, iOS, macOS, Windows.

**Restrições Checkpoint 0:**
- Somente projeto Firebase **de desenvolvimento**.
- Sem projeto produção, sem Blaze e sem recursos pagos sem autorização explícita.
- Spike isolado — zero alteração em providers/modelos de produção.

---

## 2. Decisão principal

Adotar arquitetura **híbrida**:

| Camada | Tecnologia | Papel |
|--------|------------|-------|
| Nuvem | Firebase Auth + Firestore + Storage | Sincronização, operações atômicas, blobs |
| Local | **Drift/SQLite** + outbox persistente | Fonte operacional offline |
| Operações críticas | **Cloud Functions (Node.js/TypeScript)** | Bootstrap, numeração, status, conflitos, convites |

**Não depender** exclusivamente do cache offline nativo do Firestore, especialmente no **Windows** (plugins Firebase em beta; persistência offline do Firestore **não assumida** no Windows).

---

## 3. Firebase — plataformas e limitações (Checkpoint 0)

### 3.1 Plugins Windows em beta

Os plugins `firebase_core`, `cloud_firestore`, `firebase_auth` e `firebase_storage` para **Windows** estão em **beta** no ecossistema FlutterFire. Builds podem exigir ajustes de CMake/Pods e comportamento pode divergir de mobile/desktop Apple.

**Implicação:** Windows requer validação manual dedicada no notebook Windows; suporte não declarado sem build + teste nativo.

### 3.2 Persistência offline Firestore

| Plataforma | Assumir cache offline Firestore? |
|------------|----------------------------------|
| Android | Complementar apenas; Drift é fonte operacional |
| iOS | Idem |
| macOS | Idem; validar comportamento real |
| **Windows** | **Não assumir** — Drift + outbox obrigatórios |

### 3.3 Configuração Firebase

- **Checkpoint 0–F (até autorização):** apenas projeto **dev**.
- **Região:** `southamerica-east1` (São Paulo) — **confirmar antes de criar** (irreversível).
- `firebase_options.dart`: identificadores públicos; **não são segredos**.
- **Proibido no app:** service accounts, chaves privadas, credenciais admin.
- **Produção (futuro):** Security Rules + App Check onde suportado.

### 3.4 Cloud Storage e faturamento

**Cloud Storage exige plano Blaze (pay-as-you-go)** no Firebase. Não há teste de Storage no Checkpoint 0 sem autorização explícita de faturamento do PO.

| Serviço | Plano Spark | Checkpoint 0 |
|---------|-------------|--------------|
| Auth | ✅ | Testável |
| Firestore | ✅ | Testável com Rules restritivas |
| **Cloud Storage** | ❌ exige Blaze | **Bloqueado** — não provisionar bucket |

**Não integrar Firebase ao app EventPro principal** enquanto o conjunto de dependências FlutterFire compilar de forma reproduzível **sem** `dependency_overrides` em `platform_interface` (ver §3.5).

---

### 3.5 Compatibilidade de dependências FlutterFire (Checkpoint 0)

**Conjunto oficialmente resolvido pelo `pub` sem `dependency_overrides` e sem dependência direta em `*_platform_interface`:**

| Pacote | Versão pinada |
|--------|---------------|
| `firebase_core` | 3.15.2 |
| `firebase_auth` | 5.7.0 |
| `cloud_firestore` | 5.6.12 |
| `firebase_storage` | 12.4.10 |

- **Proibido:** `dependency_overrides` em `firebase_core_platform_interface`.
- **Proibido:** dependência direta em packages `*_platform_interface`.
- A linha **4.x** (`firebase_core 4.12.x` + `firebase_auth 6.5.x`) **falha** na compilação macOS com `Type 'FirebasePlugin' not found` — não usar até FlutterFire publicar conjunto desktop compatível.
- **Não integrar Firebase ao app EventPro principal** até validação completa do Checkpoint 0 (Auth + Firestore real) e decisão sobre versão 3.x vs evolução 4.x.
- Spike iOS exige **deployment target mínimo 15.0** (requisito dos plugins Firebase via SPM).

### 3.6 Resultado da prova técnica (Checkpoint 0)

| Plataforma | Auth + Firestore ao vivo | Storage | Validada? |
|------------|--------------------------|---------|-----------|
| macOS | ✅ anônimo + CRUD + logout | 🚫 bloqueado (Blaze) | **Sim** |
| iOS Simulator | ✅ anônimo + CRUD + logout | 🚫 bloqueado (Blaze) | **Sim** |
| Android | ⏳ SDK ausente | 🚫 | **Não** |
| Windows | ⏳ notebook pendente | 🚫 | **Não** |

Evidências: relatórios `macos_live_1784050700344.json` e `ios_live_1784052495570.json` com `success: true`. Storage não foi aberto nem testado.

---

## 4. App Check por plataforma

**Não** tratar “App Check obrigatório nas quatro plataformas” como critério único impossível.

| Plataforma | App Check | Estratégia |
|------------|-----------|------------|
| Android | Play Integrity / Debug provider | App Check em produção quando estável |
| iOS | App Attest / Debug provider | Idem |
| macOS | App Attest / Debug provider | Idem |
| **Windows** | **Somente `WindowsDebugProvider`** disponível no ecossistema FlutterFire atual | **Sem attestation oficial de produção** no Windows |

### Windows — App Check e produção

- Atualmente existe apenas **`WindowsDebugProvider`** no plugin `firebase_app_check`.
- O **debug provider nunca pode ser distribuído em produção** (tokens de debug são credenciais sensíveis).
- **Não há** attestation oficial de produção equivalente a Play Integrity / App Attest no Windows nesta fase.
- **Mitigações obrigatórias no Windows:** Firebase Auth, Security Rules restritivas, API keys restritas no Google Cloud Console, validação de identidade nas Cloud Functions, rate limiting, monitoramento de abuso.
- Monitorar evolução do suporte oficial App Check no Windows; não exigir paridade de App Check nas quatro plataformas como critério de release.

**Produção Windows:** documentar risco residual de ausência de App Check de produção; mitigações acima são obrigatórias.

---

## 5. Banco local (Drift/SQLite) e criptografia

### 5.1 Decisão

**Drift** sobre SQLite como base local multiplataforma (Android, iOS, macOS, Windows via `sqlite3`/`sqlcipher`).

### 5.2 Criptografia

SQLite/Drift **puro não criptografa** arquivos. O banco, outbox e cache podem conter CPF, CNPJ, contatos e `internalNotes`.

**Avaliação Checkpoint 0:**

| Opção | Android/iOS | macOS | Windows | Notas |
|-------|-------------|-------|---------|-------|
| SQLCipher + Drift | Viável | Viável | Viável com `sqlcipher_flutter_libs` | Preferência se performance OK no spike B |
| `flutter_secure_storage` para chave DEK | Keychain / Keystore | Keychain | Credential Manager (limitado) | Chave nunca hardcoded |
| Criptografia arquivo via `encrypt` + AES-GCM | Viável | Viável | Viável | Fallback se SQLCipher problemático no Windows beta |

**Decisão condicional:**
- **Checkpoint B** implementa POC de criptografia em cada plataforma disponível.
- Se criptografia integral **não for viável** em alguma plataforma (ex.: Windows beta), documentar **risco residual** e mitigação: logout apaga banco, diretório por `userId+orgId`, permissões OS, recomendação de não usar dispositivo compartilhado sem logout.

### 5.3 Isolamento local

- Schema ou arquivos segregados por `userId` + `orgId`.
- **Logout** apaga ou torna inacessível banco, outbox e cache de imagens da sessão.
- Documentar comportamento em **dispositivo compartilhado** (desktop).

---

## 6. Metadados de sincronização vs datas de negócio

### 6.1 Regra inviolável

**Nunca** sobrescrever automaticamente com `serverTimestamp`:

- `Quote.createdAt`
- `Quote.approvedAt`
- `statusHistory[].changedAt`
- Datas congeladas em snapshots usadas pelo PDF
- `Client.createdAt`

### 6.2 Metadados de sync (campos novos)

| Campo | Uso |
|-------|-----|
| `serverCreatedAt` | Primeira persistência aceita na nuvem |
| `serverUpdatedAt` | Última mutação aceita pelo servidor |
| `serverReceivedAt` | Momento de ingestão (opcional) |
| `baseVersion` | Versão lida pelo cliente antes de editar |
| `syncVersion` | Versão oficial incrementada pelo servidor |
| `syncState` | Estado do ciclo de vida sync/numeração |

### 6.3 Data oficial de emissão — orçamento criado offline

**✅ Aprovado pelo PO (2026-07-14):**

| Campo | Semântica |
|-------|-----------|
| `Quote.createdAt` | **Data de negócio de criação da proposta** — definida no dispositivo ao criar o rascunho; usada pelo PDF (TASK-020) |
| `serverNumberedAt` | Registra **separadamente** quando o servidor atribuiu número oficial `ORC-YYYY-####` |
| PDF “Data da proposta” | Continua usando `Quote.createdAt` — **não retroalterar** ao receber numeração |

Campo adicional no PDF para data de numeração oficial: somente se solicitado explicitamente em task futura.

---

## 7. Conflitos e mutações sincronizadas

### 7.1 Detecção

- Cliente envia `baseVersion` em cada mutação.
- Servidor compara com `syncVersion` atual.
- Se divergir → **retorna conflito** (HTTP 409 / `failed-precondition`); **não aplica LWW silencioso**.

### 7.2 Resolução no cliente

- Versão local **permanece preservada** até o usuário escolher:
  - **Recarregar** versão do servidor, ou
  - **Substituir** servidor com versão local (se permitido pela regra de domínio).
- UI exibe aviso: *“Este registro foi alterado em outro dispositivo.”*

### 7.3 Domínios sem LWW silencioso

- Orçamentos (campos financeiros e snapshots após envio)
- Transições de status
- Numeração oficial

### 7.4 Mecanismo servidor (decisão ADR)

**Cloud Functions (TypeScript/Node.js)** para mutações sincronizadas críticas:

| Function | Motivo |
|----------|--------|
| `createOrganization` | Bootstrap confiável; primeiro owner |
| `assignQuoteNumber` | Atomicidade; sem número offline oficial |
| `transitionQuoteStatus` | Online-only MVP; validação de regras |
| `syncEntity` (genérica ou por tipo) | Conflito `baseVersion`, incremento `syncVersion` |
| `inviteMember` / `updateMemberRole` | Roles protegidas |

**Firestore Rules:** leitura restrita por `orgId` + role; escrita direta do cliente **limitada** a rascunhos locais espelhados ou negada para campos sensíveis.

**Transações Firestore puras** sem Function: aceitas apenas para contadores simples em spike; **não** substituem Functions para bootstrap e status (falham offline; lógica complexa).

**Runtime:** Node.js/TypeScript oficial — **não** usar runtime Dart não oficial para operações críticas.

---

## 8. Operações online-only (MVP)

| Operação | Offline |
|----------|---------|
| CRUD local Settings/Clientes/Catálogo | Permitido (fila outbox) |
| Criar rascunho de orçamento (UUID) | Permitido |
| Atribuir número `ORC-YYYY-####` | **Servidor; online** |
| Enviar / Aprovar / Recusar / Cancelar / Reabrir | **Online** — mensagem clara se offline |
| Exportar PDF / contrato | Bloqueado sem número oficial |
| Transações Firestore/Functions | Falham offline — não prometer |

### Numeração

- `id` interno: UUID gerado localmente.
- `number`: somente servidor, atomicamente.
- `syncState`: `draft_local` → `pending_number` → `numbered` → `synced`.
- Enquanto não `numbered`: sem envio, aprovação, PDF ou contrato.
- **Nunca** exibir número provisório como oficial.

---

## 9. Imagens e Storage

- Firebase Storage **não** é fila offline automática.
- **Outbox local persistente** com retry após reinício.
- Metadado: **Storage path opaco** — nunca URL assinada como referência permanente.
- Referência definitiva no documento **após upload confirmado**.
- Falha: manter staged local; evitar órfãos.

---

## 10. Exclusão e TASK-021

- UX: “Excluir definitivamente” **remove** o item para o usuário.
- Técnico: tombstone (`deletedAt`, `deletedBy`) apenas pelo tempo necessário para sync.
- Retenção TTL (proposta: 30 dias) → hard delete + limpeza Storage.
- Fotos: coordinator TASK-021 + job sync.

---

## 11. `internalNotes`

- **Nunca** em PDF, contrato ou material destinado ao cliente.
- **Pode** constar em backup administrativo e exportação completa solicitada pelo **owner** (LGPD/portabilidade), com acesso restrito e auditoria.

---

## 12. Matriz de roles (MVP)

| Ação | owner | admin | operator | viewer |
|------|-------|-------|----------|--------|
| Settings | ✅ | ✅ | leitura | leitura |
| Clientes CRUD | ✅ | ✅ | ✅ | leitura |
| Catálogo CRUD | ✅ | ✅ | ✅ | leitura |
| **Exclusão permanente catálogo** | ✅ | ✅ | ❌ | ❌ |
| Orçamento rascunho | ✅ | ✅ | ✅ | leitura |
| **Transição status / reabrir** | ✅ | ✅ | ❌ | ❌ |
| Convidar membros | ✅ | ✅ | ❌ | ❌ |
| Alterar roles | ✅ | ❌ | ❌ | ❌ |
| Excluir empresa (reauth) | ✅ | ❌ | ❌ | ❌ |
| Export LGPD completo | ✅ | ❌ | ❌ | ❌ |

Configuração fina futura — matriz pode tornar-se configurável.

**Segurança:** usuário **não pode** auto-promover role nem alterar própria membership via cliente.

---

## 13. Cloud Functions — escopo mínimo

```
functions/
  package.json
  tsconfig.json
  src/index.ts
```

Funções stub documentadas no Checkpoint 0; deploy somente após projeto dev configurado.

---

## 14. Alternativas rejeitadas

| Alternativa | Motivo |
|-------------|--------|
| Somente Firestore offline cache | Insuficiente no Windows beta; sem outbox persistente |
| Supabase | Fora da stack oficial do PROJECT.md |
| Runtime Dart em Functions | Não oficial para operações críticas |
| LWW silencioso | Rejeitado pelo PO; conflito explícito |
| Número provisório offline | Risco de duplicidade e inconsistência com PDF |

---

## 15. Consequências

- Dependências Firebase **somente no spike** até Checkpoint A aprovado.
- Checkpoint B exige POC Drift + criptografia.
- Checkpoint D bloqueado até aprovação da data de emissão (§6.3).
- Android e Windows dependem de hardware/SDK disponíveis para validação.

---

## 16. Referências

- `PROJECT.md`, `ARCHITECTURE.md`
- `tool/firebase_spike/README.md`
- `docs/tasks/TASK-023-checkpoint-0-report.md`
- [FlutterFire Windows](https://firebase.flutter.dev/docs/manual-installation#windows)
- [Firebase App Check Windows](https://pub.dev/documentation/firebase_app_check/latest/firebase_app_check/WindowsDebugProvider-class.html)
