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
| `status` | VARCHAR(20) | Sim | `agendado`, `confirmado`, `concluido`, `cancelado` ou `faltou` | Situação do agendamento. |
| `observacoes` | TEXT | Não | Evitar dados pessoais desnecessários | Observações sobre o atendimento. |
| `data_criacao` | TIMESTAMP | Sim | Padrão CURRENT_TIMESTAMP | Data e hora de criação do registro. |

**Regra de agenda:** os gatilhos do SQL impedem sobreposição de horários não cancelados do mesmo profissional e bloqueiam novos agendamentos com profissional inativo. A aplicação deve calcular a duração do procedimento. Quando a coloração para loiro exigir o dobro do tempo padrão, deve reservar esse intervalo ampliado conforme avaliação profissional.

## 7. pagamento

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_pagamento` | INT | Sim | PK, auto incremento | Identificador do pagamento. |
| `id_agendamento` | INT | Sim | FK e UNIQUE | Atendimento associado; o modelo admite no máximo um pagamento por agendamento.  |
| `data_pagamento` | DATETIME | Sim | — | Data e hora do recebimento. |
| `valor_pago` | DECIMAL(10,2) | Sim | CHECK > 0 | Valor efetivamente recebido. |
| `forma_pagamento` | VARCHAR(20) | Sim | `debito`, `credito`, `pix`, `dinheiro` | Forma utilizada no recebimento. |
| `observacoes` | TEXT | Não | — | Observações opcionais sobre o pagamento. |


## 8. fornecedor

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_fornecedor` | INT | Sim | PK, auto incremento | Identificador do fornecedor. |
| `nome` | VARCHAR(120) | Sim | — | Nome do fornecedor. |
| `telefone` | VARCHAR(20) | Não | Dado de contato | Telefone do fornecedor. |
| `email` | VARCHAR(120) | Não | Dado de contato | E-mail do fornecedor. |
| `observacoes` | TEXT | Não | — | Informações adicionais. |

## 9. insumo

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_insumo` | INT | Sim | PK, auto incremento | Identificador do insumo. |
| `nome` | VARCHAR(120) | Sim | — | Nome do material utilizado pelo salão. |
| `unidade_medida` | VARCHAR(20) | Sim | — | Unidade de medida, como unidade ou ml. |
| `quantidade_estoque` | DECIMAL(10,3) | Sim | CHECK >= 0; padrão 0 | Saldo atual do material. |
| `estoque_minimo` | DECIMAL(10,3) | Sim | CHECK >= 0; padrão 0 | Nível de alerta para reposição. |
| `ativo` | BOOLEAN | Sim | Padrão TRUE | Indica se o material continua em uso. |

## 10. compra

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_compra` | INT | Sim | PK, auto incremento | Identificador da compra. |
| `id_fornecedor` | INT | Sim | FK | Fornecedor da compra. |
| `data_compra` | DATETIME | Sim | Padrão CURRENT_TIMESTAMP | Data e hora da compra. |
| `observacoes` | TEXT | Não | — | Informações adicionais. |

## 11. item_compra

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_item_compra` | INT | Sim | PK, auto incremento | Identificador da linha da compra. |
| `id_compra` | INT | Sim | FK | Compra a que a linha pertence. |
| `id_insumo` | INT | Sim | FK | Insumo comprado. |
| `quantidade` | DECIMAL(10,3) | Sim | CHECK > 0 | Quantidade adquirida. |
| `valor_unitario` | DECIMAL(10,2) | Sim | CHECK >= 0 | Valor por unidade. |

Ao inserir um item de compra, o gatilho `trg_item_compra_ai` registra automaticamente uma movimentação de entrada, que atualiza o saldo do insumo.

## 12. movimentacao_estoque

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_movimentacao` | INT | Sim | PK, auto incremento | Identificador da movimentação. |
| `id_insumo` | INT | Sim | FK | Insumo movimentado. |
| `id_agendamento` | INT | Não | FK | Atendimento associado ao consumo, quando aplicável. |
| `tipo` | VARCHAR(20) | Sim | `entrada`, `consumo` ou `ajuste` | Tipo de movimentação. |
| `quantidade` | DECIMAL(10,3) | Sim | CHECK > 0 | Quantidade movimentada. |
| `data_movimentacao` | DATETIME | Sim | Padrão CURRENT_TIMESTAMP | Data e hora do registro. |
| `observacoes` | TEXT | Não | — | Motivo ou detalhe. |

O SQL impede registrar consumo maior que o saldo disponível e atualiza o saldo automaticamente. Na versão atual, o tipo `ajuste` soma a quantidade informada ao saldo.

## 13. fechamento_caixa

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---:|---|---|
| `id_fechamento` | INT | Sim | PK, auto incremento | Identificador do fechamento. |
| `data_inicio` | DATE | Sim | UNIQUE junto com data_fim | Início do período. |
| `data_fim` | DATE | Sim | Igual ou posterior a data_inicio | Fim do período. |
| `total_recebido` | DECIMAL(12,2) | Sim | Calculado pelo procedimento | Soma dos pagamentos recebidos no período. |
| `percentual_salao` | DECIMAL(5,2) | Sim | Padrão 30% | Percentual destinado às despesas do salão. |
| `valor_salao` | DECIMAL(12,2) | Sim | 30% do total | Valor destinado ao salão. |
| `percentual_profissionais` | DECIMAL(5,2) | Sim | Padrão 70% | Percentual destinado aos profissionais. |
| `valor_profissionais` | DECIMAL(12,2) | Sim | 70% do total | Valor destinado aos profissionais. |
| `data_fechamento` | DATETIME | Sim | Padrão CURRENT_TIMESTAMP | Momento do fechamento. |
| `observacoes` | TEXT | Não | — | Observações adicionais. |

Para fechar um período, executar `CALL fechar_caixa('AAAA-MM-DD', 'AAAA-MM-DD')`. O procedimento soma os pagamentos dentro do período e calcula a divisão 30%/70%. A restrição UNIQUE impede repetir exatamente o mesmo período.

## 14. Relacionamentos adicionais

- **Fornecedor — Compra:** um fornecedor pode estar associado a várias compras; cada compra referencia um fornecedor.
- **Compra — Item_Compra:** cada compra é composta por linhas de itens; cada linha pertence a uma compra.
- **Insumo — Item_Compra:** um insumo pode aparecer em várias compras; cada item referencia um insumo.
- **Insumo — Movimentacao_Estoque:** cada movimentação pertence a um insumo; o insumo pode ter várias movimentações.
- **Agendamento — Movimentacao_Estoque:** uma movimentação pode apontar para o atendimento associado ao consumo; o vínculo é opcional.

## 15. Índices e validações

- PKs identificam unicamente cada registro e FKs mantêm os vínculos entre as tabelas.
- `especialidade.nome` é único.
- `profissional_especialidade` usa chave primária composta.
- `agendamento` possui índice para consultas por data, profissional e horário.
- Os gatilhos validam o profissional ativo e a sobreposição de horários em inserções e alterações.
- O campo de preço é uma referência; não substitui o valor efetivamente recebido no pagamento.

## 16. Privacidade e limites do modelo

Telefone e e-mail são dados pessoais e devem ser acessados apenas para finalidades legítimas do salão. O dicionário não afirma que esses dados são dados pessoais sensíveis.

O SQL implementa compras, fornecedores, itens de compra, movimentações de estoque e fechamento de caixa, além do cálculo 30%/70% sobre os pagamentos registrados no período. O consumo de insumos deve ser registrado por movimentação; o sistema não estima automaticamente a quantidade de material usada em cada procedimento. Os DERs foram preservados sem alterações, conforme solicitado.
