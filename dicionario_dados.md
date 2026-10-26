# Dicionário de dados — versão inicial

| Tabela | Campo | Tipo | Obrigatório? | Descrição |
|---|---|---|---|---|
| cliente | id_cliente | INT | Sim | Identificador único do cliente (PK). |
| cliente | nome | VARCHAR(100) | Sim | Nome do cliente. |
| cliente | telefone | VARCHAR(20) | Não | Telefone de contato. |
| cliente | email | VARCHAR(120) | Não | E-mail de contato. |
| profissional | id_profissional | INT | Sim | Identificador único do profissional (PK). |
| profissional | nome | VARCHAR(100) | Sim | Nome do profissional. |
| profissional | telefone | VARCHAR(20) | Não | Telefone de contato. |
| profissional | ativo | BOOLEAN | Sim | Indica se o profissional está ativo. |
| procedimento | id_procedimento | INT | Sim | Identificador único do procedimento (PK). |
| procedimento | nome | VARCHAR(100) | Sim | Nome do procedimento. |
| procedimento | descricao | VARCHAR(255) | Não | Descrição do procedimento. |
| procedimento | duracao_minutos | INT | Sim | Duração estimada em minutos. |
| procedimento | valor | DECIMAL(10,2) | Sim | Valor cobrado pelo procedimento. |
| especialidade | id_especialidade | INT | Sim | Identificador único da especialidade (PK). |
| especialidade | nome | VARCHAR(80) | Sim | Nome da especialidade; único. |
| profissional_especialidade | id_profissional | INT | Sim | FK para profissional; compõe a PK. |
| profissional_especialidade | id_especialidade | INT | Sim | FK para especialidade; compõe a PK. |
| agendamento | id_agendamento | INT | Sim | Identificador único do agendamento (PK). |
| agendamento | id_cliente | INT | Sim | FK para cliente. |
| agendamento | id_profissional | INT | Sim | FK para profissional. |
| agendamento | id_procedimento | INT | Sim | FK para procedimento. |
| agendamento | data_hora | DATETIME | Sim | Data e hora previstas para o atendimento. |
| agendamento | status | VARCHAR(20) | Sim | Situação do agendamento. |
| agendamento | observacoes | VARCHAR(255) | Não | Observações adicionais. |
| pagamento | id_pagamento | INT | Sim | Identificador único do pagamento (PK). |
| pagamento | id_agendamento | INT | Sim | FK para agendamento. |
| pagamento | data_pagamento | DATETIME | Não | Data e hora do pagamento. |
| pagamento | valor | DECIMAL(10,2) | Sim | Valor registrado no pagamento. |
| pagamento | forma_pagamento | VARCHAR(30) | Não | Forma utilizada para pagar. |
| pagamento | status | VARCHAR(20) | Sim | Situação do pagamento. |

> **Importante:** confira se o professor exige o dicionário em HTML. Se a turma tiver essa exigência, este Markdown precisa ser convertido para o formato pedido.
