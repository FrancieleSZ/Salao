# Dicionário de dados — Salão dos Primos

**SGBD de referência:** MySQL 8.0+. Os tipos e restrições abaixo correspondem ao arquivo `script.sql`. Os dados de exemplo do script são fictícios.

## 1. cliente

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_cliente` | INT | Sim | PK, auto incremento | Identificador único do cliente. |
| `nome` | VARCHAR(100) | Sim | — | Nome do cliente. |
| `telefone` | VARCHAR(20) | Não | Dado pessoal | Telefone de contato. |
| `email` | VARCHAR(120) | Não | Dado pessoal | E-mail de contato. |

## 2. profissional

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_profissional` | INT | Sim | PK, auto incremento | Identificador único do profissional. |
| `nome` | VARCHAR(100) | Sim | — | Nome do profissional. |
| `telefone` | VARCHAR(20) | Não | Dado pessoal | Telefone de contato. |
| `ativo` | BOOLEAN | Sim | Padrão TRUE | Indica se pode receber novos agendamentos. |

## 3. procedimento

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_procedimento` | INT | Sim | PK, auto incremento | Identificador do procedimento. |
| `nome` | VARCHAR(120) | Sim | — | Nome do serviço. |
| `descricao` | VARCHAR(500) | Não | — | Descrição do procedimento. |
| `duracao_minutos` | INT | Sim | CHECK > 0 | Duração estimada em minutos. |
| `preco` | DECIMAL(10,2) | Não | CHECK >= 0 quando informado | Preço de referência; o valor final pode variar presencialmente. |

## 4. especialidade

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_especialidade` | INT | Sim | PK, auto incremento | Identificador da especialidade. |
| `nome` | VARCHAR(80) | Sim | UNIQUE | Nome único da especialidade. |

## 5. profissional_especialidade

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_profissional` | INT | Sim | PK composta e FK | Referencia `profissional.id_profissional`. |
| `id_especialidade` | INT | Sim | PK composta e FK | Referencia `especialidade.id_especialidade`. |

A chave primária composta (`id_profissional`, `id_especialidade`) impede cadastrar o mesmo vínculo duas vezes.

## 6. agendamento

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_agendamento` | INT | Sim | PK, auto incremento | Identificador do agendamento. |
| `id_cliente` | INT | Sim | FK | Cliente associado ao agendamento. |
| `id_profissional` | INT | Sim | FK | Profissional responsável pelo atendimento. |
| `id_procedimento` | INT | Sim | FK | Procedimento reservado. |
| `data_agendamento` | DATE | Sim | Índice composto com profissional e início | Data do atendimento. |
| `hora_inicio` | TIME | Sim | Deve ser anterior a `hora_fim` | Horário de início. |
| `hora_fim` | TIME | Sim | Deve ser posterior a `hora_inicio` | Horário previsto de término; calculado pela aplicação usando a duração do procedimento. |
| `status` | VARCHAR(20) | Sim | `marcado`, `concluido` ou `cancelado` | Situação do agendamento. |
| `observacoes` | TEXT | Não | Evitar dados pessoais desnecessários | Observações sobre o atendimento. |
| `data_criacao` | TIMESTAMP | Sim | Padrão CURRENT_TIMESTAMP | Data e hora de criação do registro. |

**Regra de agenda:** os gatilhos do SQL impedem sobreposição de horários não cancelados do mesmo profissional e bloqueiam novos agendamentos com profissional inativo. A aplicação ainda precisa calcular a duração e definir o tratamento específico para serviços que possam exigir tempo adicional.

## 7. pagamento

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_pagamento` | INT | Sim | PK, auto incremento | Identificador do pagamento. |
| `id_agendamento` | INT | Sim | FK e UNIQUE | Atendimento associado; o modelo admite no máximo um pagamento por agendamento. Confirmar essa hipótese com a responsável. |
| `data_pagamento` | DATETIME | Sim | — | Data e hora do recebimento. |
| `valor_pago` | DECIMAL(10,2) | Sim | CHECK > 0 | Valor efetivamente recebido. |
| `forma_pagamento` | VARCHAR(20) | Sim | `debito`, `credito`, `pix`, `dinheiro` | Forma utilizada no recebimento. |
| `observacoes` | TEXT | Não | — | Observações opcionais sobre o pagamento. |

## 8. Índices e validações

- PKs identificam unicamente cada registro e FKs mantêm os vínculos entre as tabelas.
- `especialidade.nome` é único.
- `profissional_especialidade` usa chave primária composta.
- `agendamento` possui índice para consultas por data, profissional e horário.
- Os gatilhos validam o profissional ativo e a sobreposição de horários em inserções e alterações.
- O campo de preço é uma referência; não substitui o valor efetivamente recebido no pagamento.

## 9. Privacidade e limites do modelo

Telefone e e-mail são dados pessoais e devem ser acessados apenas para finalidades legítimas do salão. O dicionário não afirma que esses dados são dados pessoais sensíveis.

Este modelo não inclui compras, fornecedores, estoque, fechamento de caixa ou cálculo automático da divisão 30%/70%. Esses processos aparecem no levantamento, mas o README os mantém como dependentes de confirmação de escopo e regras com a responsável. Os DERs foram preservados sem alterações.
