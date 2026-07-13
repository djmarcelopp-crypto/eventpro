# Regras de negócio — Clientes

## Observações internas

- Campo exclusivo para uso interno da equipe.
- **Nunca** deve ser incluído em orçamentos.
- **Nunca** deve ser incluído em PDFs.
- **Nunca** deve ser incluído em materiais compartilhados com o cliente.
- Futuras integrações (orçamentos, PDF, compartilhamento) devem respeitar esta regra.

## Data de aniversário

- Campo opcional destinado ao cadastro do cliente.
- Deve ser preparado para futura integração com o módulo **Agenda**.

## Telefone e WhatsApp

- **Telefone** é opcional e aceita número fixo ou celular com DDD.
- **WhatsApp** é obrigatório e deve ser um celular brasileiro válido com prefixo `+55`.
- A opção **"Este número também é WhatsApp"** copia o telefone para o WhatsApp somente quando o número informado é um celular válido.
- Telefone fixo **não** pode ser copiado automaticamente para o WhatsApp; o usuário recebe feedback claro e deve preencher o WhatsApp manualmente.
- Desmarcar a opção **não** apaga um WhatsApp já digitado.

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

- Nesta fase, os clientes existem apenas durante a sessão do aplicativo.
- Os dados são perdidos ao fechar ou reiniciar o app.
- A integração com Firebase será implementada em etapa futura.
