# Roadmap — Ideias futuras do EventPro ERP

Registro de ideias de produto para fases futuras, fora do escopo das tasks ativas. Nenhum item aqui possui plano técnico, arquitetura definida ou aprovação de implementação — apenas a intenção registrada para priorização futura pelo Product Owner e CTO.

Ao promover um item deste roadmap para desenvolvimento, ele deve receber uma `TASK-XXX` própria com plano técnico completo, conforme `CLAUDE.md`.

---

## Agenda Inteligente e Análise de Disponibilidade

**Status:** Parcialmente implementado — `TASK-026` (encerrada). Ver `docs/tasks/TASK-026.md` e `docs/business-rules/agenda-inteligente.md`.

### O que já foi entregue (TASK-026)

- Consultar disponibilidade por data, intervalo de datas, semana ou mês, em português simples, sem IA/LLM.
- Mostrar eventos confirmados, propostas e bloqueios (via `AgendaOccupancy`, já existente desde a TASK-025).
- Identificar disponibilidade total (`busy`), parcial (`partial`) ou livre (`free`), e conflitos entre ocupações.
- Perguntas em linguagem natural dentro de um conjunto fixo de padrões reconhecidos, como:
  - "Tenho agenda livre hoje?"
  - "Como está minha agenda no sábado?"
  - "Quais dias desta semana estão livres?"
  - "Como está o mês de agosto?"
- Exibir a justificativa em texto determinístico (contagem de ocupações e conflitos).
- Decisão final permanece com o usuário — a Agenda Inteligente não bloqueia nem decide nada automaticamente.

### O que permanece futuro (fora do escopo da TASK-026)

- **IA/LLM generativa** — a interpretação atual é baseada em regras fixas (regex/palavras-chave), não em modelo de linguagem; perguntas fora do conjunto reconhecido retornam erro "não suportada".
- **Interface de voz.**
- **Considerar horário de montagem e desmontagem** — a análise opera sobre o intervalo único de cada ocupação (`AgendaOccupancy`); granularidade adicional (`AgendaEventSchedules`) não foi criada.
- **Verificar conflitos de equipe e equipamentos** — depende de um modelo de recursos (`AgendaResourceReservations`) ainda não criado.
- **Consultas mais livres e complexas** — comparações, negociação de horário, perguntas compostas (ex.: "consigo atender dois eventos no mesmo dia?") fora do conjunto de padrões reconhecidos.
- **Chat/histórico de conversa** — cada consulta é independente, sem memória de perguntas anteriores.

### Restrições (herdadas, ainda válidas)

- Não deve ser antecipada antes da definição de task própria para os itens "O que permanece futuro" acima.
- Qualquer evolução deve manter a decisão final com o usuário — a Agenda Inteligente é uma ferramenta de análise, não de decisão automática.

---

## Financeiro — evoluções avançadas

**Status:** MVP do módulo entregue na `TASK-027` (encerrada). Ver `docs/tasks/TASK-027.md` e `docs/business-rules/financial.md`.

### O que já foi entregue (TASK-027)

- Categorias e lançamentos (receita/despesa) persistidos em Drift (`schemaVersion` 4).
- Regras de categoria e status × `paidAt`.
- Vínculo opcional a orçamentos via `Quote.id` (referência).
- Resumo global, filtros, resumo por orçamento (serviço/calculator) e relatórios por período com evolução mensal tabular.

### O que permanece futuro (fora do escopo da TASK-027)

- Gráficos (charts) sobre a série mensal já preparada.
- Exportações PDF / Excel / CSV.
- Múltiplas moedas.
- Centros de custo.
- Conciliação bancária.
- Integrações fiscais.
- Dashboards financeiros avançados.
- Hidratação do Financeiro no bootstrap do app.
- UI do resumo por orçamento embutida na tela de Quotes.

---

## Estoque & Equipamentos — evoluções avançadas

**Status:** MVP do módulo entregue na `TASK-028` (encerrada). Ver `docs/tasks/TASK-028.md` e `docs/business-rules/equipment.md`.

### O que já foi entregue (TASK-028)

- Categorias e equipamentos persistidos em Drift (`schemaVersion` 5).
- Vínculo planejado orçamento ↔ equipamento (`quote_equipment`, schema v6).
- UI de inventário, filtros e associação a orçamentos.
- Disponibilidade dinâmica (pico concorrente, conflitos, resumo) sem persistir quantidades derivadas.
- `EquipmentStatus` cadastral independente do cálculo de disponibilidade.

### O que permanece futuro (fora do escopo da TASK-028)

- Reservas efetivas / bloqueio automático de estoque.
- Integração com Agenda (ocupação, recursos, conflitos de agenda × equipamento).
- Gráficos e exportações de inventário.
- Leitura por QR Code / RFID.
- Rastreamento em tempo real.
- Manutenção preventiva.
- Logística de retirada / devolução.
- Hidratação do Estoque no bootstrap do app.
- UI dedicada de disponibilidade/conflitos (hoje o cálculo existe em domínio/providers).

---

## Equipe & Escalas — evoluções avançadas

**Status:** MVP do módulo entregue na `TASK-029` (encerrada). Ver `docs/tasks/TASK-029.md` e `docs/business-rules/team.md`.

### O que já foi entregue (TASK-029)

- Funções e colaboradores persistidos em Drift (`schemaVersion` 7).
- Vínculo planejado orçamento ↔ equipe (`quote_team_members`, schema v8) com snapshot de função/diária.
- UI de roster, filtros, funções e associação a orçamentos.
- Disponibilidade dinâmica (overlap de períodos, conflitos, resumo) sem persistir estado derivado.
- `TeamMemberStatus` cadastral independente do cálculo de disponibilidade.

### O que permanece futuro (fora do escopo da TASK-029)

- Check-in / check-out.
- Apontamento de horas.
- Folha de pagamento.
- Permissões e autenticação.
- Agenda visual de escalas.
- Logística de equipes.
- Comunicação interna da equipe.
- Integração com Agenda (recursos / conflitos de equipe na ocupação).
- Hidratação do módulo Equipe no bootstrap do app.
- UI dedicada de disponibilidade/conflitos (hoje o cálculo existe em domínio/providers).
- Mutação automática de `TeamMemberStatus` a partir de orçamentos.

---

## Logística & Transporte — evoluções avançadas

**Status:** MVP do módulo entregue na `TASK-030` (implementada; commits pendentes de aprovação). Ver `docs/tasks/TASK-030.md` e `docs/business-rules/logistics.md`.

### O que já foi entregue (TASK-030)

- Tipos e veículos persistidos em Drift (`schemaVersion` 9).
- Vínculo planejado orçamento ↔ veículo (`quote_vehicles`, schema v10) com motorista opcional, frete e períodos planejados.
- UI de frota, filtros, tipos e associação a orçamentos.
- Disponibilidade logística dinâmica (período planejado ou evento, overlap, conflitos, resumo/frete) sem persistir estado derivado.
- `VehicleStatus` cadastral combinado à elegibilidade, sem mutação automática.

### O que permanece futuro (fora do escopo da TASK-030)

- GPS / rastreamento em tempo real.
- Cálculo de rotas externo / mapas.
- Telemetria / abastecimento.
- Manutenção preventiva.
- Check-in / check-out de veículos.
- Baixa automática de estoque na logística.
- Confirmação de motorista.
- Integração com Agenda (recursos / conflitos de frota na ocupação).
- Hidratação do módulo Logística no bootstrap do app.
- UI dedicada de disponibilidade/conflitos (hoje o cálculo existe em domínio/providers).
- Mutação automática de `VehicleStatus` a partir de orçamentos.

---

## Contratos & Assinaturas — evoluções avançadas

**Status:** MVP do módulo entregue na `TASK-031`. Ver `docs/tasks/TASK-031.md` e `docs/business-rules/contracts.md`.

### O que já foi entregue (TASK-031)

- Modelos e contratos persistidos em Drift (`schemaVersion` 11).
- Número automático `CTR-YYYY-####`; vínculo a orçamento com FK RESTRICT; template opcional com SET NULL.
- UI de contratos/templates, seção no orçamento e resumo no dashboard.
- Fluxo interno `draft → generated → sent → signed`, com cancelamento/expiração e bloqueios de regressão.

### O que permanece futuro (fora do escopo da TASK-031)

- Geração de PDF do contrato.
- Assinatura digital / provedores externos.
- Envio automático por e-mail/WhatsApp.
- Persistência de `ContractSignatureStatus` no contrato.
- Auditoria de eventos de assinatura.
- Hidratação do módulo Contratos no bootstrap do app.
- Notificações de envio/expiração.

---

## Faturamento & Documentos Fiscais — evoluções avançadas

**Status:** MVP do módulo entregue na `TASK-032` (implementada; commits pendentes de aprovação). Ver `docs/tasks/TASK-032.md` e `docs/business-rules/billing.md`.

### O que já foi entregue (TASK-032)

- Faturas e itens persistidos em Drift (`schemaVersion` 12).
- Número automático `INV-YYYY-####`; FK quote RESTRICT; items CASCADE; totais recalculados no serviço.
- Matriz única `InvoiceStatusTransitions`; workflow consulta a matriz e resume ações para a UI.
- UI de faturamentos, seção no orçamento e resumo no dashboard.
- `InvoiceFinancialSummary` derivado (sem escrever no módulo Financeiro).
- Fluxo interno `draft → issued → paid`, com cancelamento e bloqueios de regressão/repetição.

### O que permanece futuro (fora do escopo da TASK-032)

- Geração de PDF da fatura.
- Emissão fiscal real (NF-e / NFS-e).
- Boleto, PIX e integração bancária.
- Conciliação automática, webhooks e envio externo.
- Criação automática de `FinancialEntry` a partir da fatura.
- Hidratação do módulo Faturamento no bootstrap do app.
