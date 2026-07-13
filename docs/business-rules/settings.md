# Regras de negócio — Configurações (Dados da empresa)

## Visão geral

O módulo de Configurações mantém o **perfil único da empresa** em memória (`CompanyProfile?`). Não há múltiplos perfis nem histórico de versões nesta entrega.

O perfil alimentará futuramente snapshots em PDF e contratos. **Documentos já gerados não serão alterados** quando o perfil for editado.

## Plataformas

- Android, iOS, Windows e macOS são obrigatórios.
- Android/iOS: galeria para logotipo.
- Windows/macOS: seletor de arquivo para logotipo.

## Status do perfil

| Status | Condição |
|--------|----------|
| Não configurado | `provider == null` |
| Incompleto | Mínimos salvos, faltam dados profissionais recomendados |
| Configurado | Mínimos + razão social, CNPJ válido, endereço principal e responsável legal |

Logo e PIX são **opcionais** para status Configurado.

## Campos mínimos para salvar

1. Nome comercial (fantasia)
2. Pelo menos um contato (telefone, WhatsApp ou e-mail)
3. Validade padrão de orçamento > 0 (inicial: 7 dias)

## Logotipo

- Infraestrutura exclusiva via `core/media`.
- Formatos: JPG/JPEG/PNG, máximo 10 MB, validação por magic bytes.
- `logoReference` opaca (`settings/logo/...`); **nunca** armazena bytes no modelo.
- Ciclo: **staged → commit somente ao salvar**.
- Cancelar/sair sem salvar: descarta apenas staged.
- Troca/remoção confirmada: exclui logo anterior **após** save bem-sucedido.
- Rollback: se save falhar após commit, remove referência commitada.
- Cancelar seletor: silencioso (sem mensagem).
- Erro real: mensagem amigável via SnackBar.

### Limitação conhecida

Ao reiniciar o app, o perfil some da memória mas arquivos de logo podem permanecer no disco (**logo órfão**). Limpeza automática fica para etapa futura com persistência.

## Consulta CNPJ

- Serviços/DTOs de `core/lookup`; filler próprio `SettingsCnpjFormFiller`.
- **Não** importa `features/clients`.
- Botão habilitado somente com CNPJ matematicamente válido (14 dígitos).
- Preenche: nome fantasia, razão social, telefone, WhatsApp (somente celular válido), e-mail válido, CEP e endereço.
- Diálogo de conflito: Preencher só vazios / Substituir / Cancelar.
- Falha da API não bloqueia preenchimento manual.

## Consulta CEP

- Serviços de `core/lookup`; filler próprio `SettingsCepFormFiller`.
- Botão habilitado com 8 dígitos de CEP válidos.
- Preenche: logradouro, bairro, cidade e UF.
- **Nunca** preenche número ou complemento.
- Mesmo fluxo de conflito do CNPJ.
- Falha da API não bloqueia cadastro manual.

## Alterações não salvas (PopScope)

Detecta dirty por:

- edição manual de campos;
- preenchimento automático CNPJ/CEP;
- seleção, troca ou remoção de logo.

Ao sair com alterações pendentes: diálogo **"Descartar alterações?"**

- Cancelar: permanece no formulário.
- Descartar: sai e remove apenas staged (logo); não apaga logo commitado.
- Após salvar com sucesso: sem diálogo.

## PIX

- Validação condicional: exige tipo + chave somente se um dos campos PIX foi iniciado.
- Mensagens de erro **nunca** expõem a chave informada.

## Snapshot futuro (Orçamentos / Contratos)

Quando implementado, o snapshot de empresa em orçamentos/PDF/contratos será **congelado no momento da geração**. Alterações posteriores em Configurações não afetam documentos antigos.
