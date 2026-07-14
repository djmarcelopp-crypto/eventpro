/**
 * Cloud Functions — stubs documentados (Checkpoint 0).
 * Implementação real inicia no Checkpoint A.
 */
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {setGlobalOptions} from "firebase-functions/v2";

setGlobalOptions({region: "southamerica-east1"});

/**
 * Cria organização + membership owner.
 * Chamada confiável — cliente não pode auto-promover role.
 */
export const createOrganization = onCall(async (_request) => {
  throw new HttpsError(
    "failed-precondition",
    "Checkpoint 0: createOrganization não implementada — aguardando Checkpoint A.",
  );
});

/**
 * Atribui número ORC-YYYY-#### atomicamente.
 * Orçamento offline permanece sem número oficial até sucesso.
 */
export const assignQuoteNumber = onCall(async (_request) => {
  throw new HttpsError(
    "failed-precondition",
    "Checkpoint 0: assignQuoteNumber não implementada — aguardando Checkpoint D.",
  );
});

/**
 * Transição de status — online only no MVP.
 */
export const transitionQuoteStatus = onCall(async (_request) => {
  throw new HttpsError(
    "failed-precondition",
    "Checkpoint 0: transitionQuoteStatus não implementada — aguardando Checkpoint D.",
  );
});

/**
 * Sincronização com detecção de conflito baseVersion/syncVersion.
 */
export const syncEntity = onCall(async (_request) => {
  throw new HttpsError(
    "failed-precondition",
    "Checkpoint 0: syncEntity não implementada — aguardando Checkpoint B.",
  );
});
