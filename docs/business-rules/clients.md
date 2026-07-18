# Regras de negócio — Clientes

## Observações internas

- Campo exclusivo para uso interno da equipe.
- **Nunca** deve ser incluído em orçamentos.
- **Nunca** deve ser incluído em PDFs.
- **Nunca** deve ser incluído em materiais compartilhados com o cliente.
- Futuras integrações (orçamentos, PDF, compartilhamento) devem respeitar esta regra.

## Telefone e WhatsApp

- **Telefone**, **WhatsApp** e **E-mail** são individualmente opcionais.
- Para salvar, é obrigatório informar **pelo menos um** dos três contatos.
- Mensagem quando nenhum contato é informado: *"Informe pelo menos um contato: telefone, WhatsApp ou e-mail."*
- Quando preenchidos, cada campo mantém sua validação específica (formato de telefone, WhatsApp com DDI 55 e e-mail válido).
- Telefone fixo retornado pela consulta de CNPJ satisfaz a regra de contato mínimo.
- A opção **"Este número também é WhatsApp"** copia o telefone para o WhatsApp somente quando o número informado é um celular válido.
- Telefone fixo **não** pode ser copiado automaticamente para o WhatsApp; o usuário recebe feedback claro e deve preencher o WhatsApp manualmente.
- Desmarcar a opção **não** apaga um WhatsApp já digitado.
- Na listagem, o contato exibido segue a prioridade: WhatsApp → Telefone → E-mail.

## Data de aniversário

- Campo opcional destinado ao cadastro de **Pessoa Física**.
- **Pessoa Jurídica** não exibe nem salva data de aniversário.
- Deve ser preparado para futura integração com o módulo **Agenda**.

## Data de cadastro

- Gerada automaticamente no momento do cadastro (`createdAt`).
- Exibida nos detalhes do cliente como **Data de cadastro**.
- Não pode ser editada; é preservada durante atualizações.

## CPF (Pessoa Física)

- O CPF é um **dado pessoal** e **não** é consultado em APIs externas.
- O EventPro realiza apenas **validação matemática local** dos dígitos verificadores.
- Nome, contato e endereço de Pessoa Física permanecem de preenchimento manual.
- Esta decisão evita exposição desnecessária de dados pessoais e está alinhada à LGPD.

## CNPJ (Pessoa Jurídica)

- O CNPJ informado deve ser **matematicamente válido** (dígitos verificadores) para habilitar a consulta.
- A validação é local; a consulta de dados cadastrais ocorre somente após confirmação explícita do usuário.

## Consulta de CNPJ (Pessoa Jurídica)

- Disponível somente quando **Pessoa Jurídica** está selecionada e o CNPJ é válido (14 dígitos e dígitos verificadores corretos).
- A consulta ocorre **apenas** ao toque em **Buscar dados da empresa**; nunca a cada tecla.
- Os dados retornados preenchem o formulário, mas o usuário **sempre revisa** antes de salvar.
- Campos já preenchidos **não** são sobrescritos sem confirmação do usuário.
- O **Telefone** é preenchido automaticamente com o primeiro número retornado pela API (`ddd_telefone_1` ou `ddd_telefone_2`), fixo ou celular, após normalização.
- O **WhatsApp** só é preenchido automaticamente quando o telefone retornado é um **celular brasileiro válido** (DDD + 9 dígitos). Telefone fixo preenche apenas o campo Telefone.
- O **E-mail** retornado é sanitizado e validado antes do preenchimento. E-mail ausente ou inválido é ignorado sem interromper a consulta.
- O **CEP** retornado é preenchido quando disponível, respeitando os modos de conflito.
- O endereço é montado a partir de `descricao_tipo_de_logradouro` + `logradouro`, além de número, complemento, bairro, município e UF.
- O campo **Nome fantasia** é opcional e, na listagem, aparece como título principal quando existir; a razão social fica como informação secundária.
- Falha na API **não impede** o cadastro manual.

## Consulta de CEP

- Campo **CEP** opcional com máscara `00000-000`.
- A busca ocorre **somente** ao toque em **Buscar endereço**, quando o CEP possui 8 dígitos válidos.
- Preenche automaticamente: **Logradouro, Bairro, Cidade e Estado (UF)**.
- **Número** e **Complemento** permanecem manuais.
- Campos já preenchidos seguem o mesmo diálogo de conflito (Cancelar / Preencher só vazios / Substituir).
- Falha na API **não impede** o cadastro manual do endereço.

## Persistência

- Os clientes são persistidos localmente em SQLite via Drift (`ClientsDao` / `DriftClientRepository`), desde a TASK-024 CP-B.
- Os dados são hidratados automaticamente ao iniciar o app (TASK-024 CP-F); nenhum cliente é perdido ao fechar ou reiniciar.
- A integração com Firebase (sincronização online) permanece em etapa futura.

## Detalhes do cliente

- A lista de clientes é clicável e abre a tela de detalhes do registro selecionado.
- Os detalhes exibem identificação, contato, endereço e informações adicionais preenchidas.
- **Observações internas** aparecem somente nos detalhes e na edição; nunca na lista, orçamento ou PDF.
- Ações disponíveis: **Editar** e **Excluir**.

## Edição de cliente

- O formulário de cadastro é reutilizado em modo edição, com campos pré-preenchidos.
- Após salvar a edição, o usuário retorna diretamente à lista com feedback *"Cliente atualizado com sucesso"*.
- O identificador (`id`) e a data de cadastro (`createdAt`) são preservados durante a atualização.

## Exclusão de cliente

- A exclusão exige confirmação em diálogo exibindo o nome do cliente.
- O botão de confirmação usa estilo destrutivo (cor de erro).
- Após confirmar, o usuário retorna à lista com feedback *"Cliente excluído com sucesso"*.

## Rotas

- `/clients/new` deve ser declarada **antes** da rota dinâmica `/clients/:id`, para que `new` nunca seja interpretado como ID.
