# Cloud Functions — EventPro (TASK-023)

Funções **confiáveis no servidor** (Node.js/TypeScript). Nenhuma credencial administrativa no app Flutter.

## Escopo Checkpoint 0

- Estrutura e contratos documentados.
- **Sem deploy** até projeto Firebase dev configurado pelo PO.
- **Sem Blaze** sem autorização explícita.

## Funções planejadas

| Function | Checkpoint |
|----------|------------|
| `createOrganization` | A |
| `inviteMember` / `updateMemberRole` | F |
| `assignQuoteNumber` | D |
| `transitionQuoteStatus` | D |
| `syncEntity` (conflito `baseVersion`) | B/D |
| `deleteOrganization` (reauth) | F |

## Desenvolvimento local

```bash
cd functions
npm install
npm run build
```

Emuladores (opcional, não substitui teste nativo por plataforma):

```bash
firebase emulators:start --only functions,firestore,auth,storage
```

## Regras

- Runtime oficial Node.js/TypeScript.
- Validação de role e `orgId` em toda function.
- `serverTimestamp` para metadados de sync — nunca sobrescrever datas de negócio.
- Conflito: retornar erro explícito se `baseVersion !== syncVersion`.
