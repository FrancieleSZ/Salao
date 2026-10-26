# Dicionário de dados — Salão dos Primos

**Versão:** 2.1 — 26/10/2026  
**SGBD:** MySQL 8.0.16 ou superior  
**Banco:** salao_dos_primos  
**Charset/collation:** utf8mb4 / utf8mb4_unicode_ci  
**Script de referência:** [script.sql](script.sql)

Os tipos e restrições desta documentação correspondem ao script SQL. Os dados de exemplo são fictícios. Os DERs conceitual e lógico foram preservados sem alterações conforme solicitado; divergências visuais anteriores continuam pendentes.

## Convenções

- Nomes de tabelas e colunas usam snake_case; chaves substitutas usam prefixo id_.
- PK é chave primária; FK é chave estrangeira; UNIQUE impede valores repetidos; CHECK valida condições.
- NOT NULL indica campo obrigatório; quando a coluna aceita NULL, o campo é opcional.
- Quantidades com casas decimais usam DECIMAL(10,3); valores monetários usam DECIMAL(10,2).
- Os CHECK são aplicados pelo MySQL a partir da versão 8.0.16.
- Os tipos de dados pessoais (telefone e e-mail) exigem acesso restrito no uso real.

## Fluxo de dados

1. Cadastrar clientes, profissionais, procedimentos e especialidades.
2. Criar agendamento com cliente, profissional, procedimento, data, início, término e status.
3. Validar se o profissional está ativo e se o intervalo não conflita com outro agendamento.
4. Registrar o atendimento e, quando concluído, lançar o pagamento recebido.
5. Consultar pagamentos por período e gerar fechamento de caixa com a divisão documentada de 30%/70%.
6. Registrar fornecedor, compra e itens; cada item de compra cria movimentação de entrada.
7. Registrar consumo/ajuste por movimentação e consultar saldo/estoque mínimo.

## 1. cliente

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_cliente | INT AUTO_INCREMENT | Sim | PK | Identificador único. |
| nome | VARCHAR(100) | Sim | — | Nome do cliente. |
| telefone | VARCHAR(20) | Não | Dado pessoal | Telefone para contato. |
| email | VARCHAR(120) | Não | Dado pessoal | E-mail para contato. |

## 2. profissional

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_profissional | INT AUTO_INCREMENT | Sim | PK | Identificador do profissional. |
| nome | VARCHAR(100) | Sim | — | Nome. |
| telefone | VARCHAR(20) | Não | Dado pessoal | Telefone de contato. |
| ativo | BOOLEAN | Sim | DEFAULT TRUE | Indica se recebe novos agendamentos. |

## 3. procedimento

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_procedimento | INT AUTO_INCREMENT | Sim | PK | Identificador. |
| nome | VARCHAR(120) | Sim | Índice | Nome do serviço. |
| descricao | VARCHAR(500) | Não | — | Descrição. |
| duracao_minutos | INT | Sim | CHECK > 0 | Duração estimada. |
| preco | DECIMAL(10,2) | Não | CHECK >= 0 quando informado | Preço de referência; o valor final pode variar. |

## 4. especialidade

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_especialidade | INT AUTO_INCREMENT | Sim | PK | Identificador. |
| nome | VARCHAR(80) | Sim | UNIQUE | Nome único da especialidade. |

## 5. profissional_especialidade

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_profissional | INT | Sim | PK composta, FK | Referencia profissional.id_profissional. |
| id_especialidade | INT | Sim | PK composta, FK | Referencia especialidade.id_especialidade. |

A PK composta (id_profissional, id_especialidade) impede repetir o mesmo vínculo.

## 6. agendamento

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_agendamento | INT AUTO_INCREMENT | Sim | PK | Identificador. |
| id_cliente | INT | Sim | FK | Cliente. |
| id_profissional | INT | Sim | FK | Profissional. |
| id_procedimento | INT | Sim | FK | Procedimento. |
| data_agendamento | DATE | Sim | Índice de agenda | Data do atendimento. |
| hora_inicio | TIME | Sim | CHECK comparativo | Horário inicial. |
| hora_fim | TIME | Sim | CHECK: maior que início | Término previsto; a aplicação deve calcular com base na duração. |
| status | VARCHAR(20) | Sim | DEFAULT agendado; CHECK | agendado, confirmado, concluido, cancelado ou faltou. |
| observacoes | TEXT | Não | — | Evitar dados pessoais desnecessários. |
| data_criacao | TIMESTAMP | Sim | DEFAULT CURRENT_TIMESTAMP | Criação do registro. |

Os triggers validam profissional ativo e sobreposição em inserção/alteração. A regra de duração e o eventual dobro de tempo para coloração de loiro devem ser calculados pela aplicação conforme avaliação profissional.

## 7. pagamento

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_pagamento | INT AUTO_INCREMENT | Sim | PK | Identificador. |
| id_agendamento | INT | Sim | FK, UNIQUE | Um pagamento por agendamento nesta versão. |
| data_pagamento | DATETIME | Sim | Índice | Data/hora do recebimento. |
| valor_pago | DECIMAL(10,2) | Sim | CHECK > 0 | Valor efetivamente recebido. |
| forma_pagamento | VARCHAR(20) | Sim | CHECK | debito, credito, pix ou dinheiro. |
| observacoes | TEXT | Não | — | Observações. |

## 8. fornecedor

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_fornecedor | INT AUTO_INCREMENT | Sim | PK | Identificador. |
| nome | VARCHAR(120) | Sim | Índice | Nome do fornecedor. |
| telefone | VARCHAR(20) | Não | Contato | Telefone. |
| email | VARCHAR(120) | Não | Contato | E-mail. |
| observacoes | TEXT | Não | — | Informações adicionais. |

## 9. insumo

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_insumo | INT AUTO_INCREMENT | Sim | PK | Identificador. |
| nome | VARCHAR(120) | Sim | Índice | Nome do material. |
| unidade_medida | VARCHAR(20) | Sim | — | Unidade, ml, grama etc. |
| quantidade_estoque | DECIMAL(10,3) | Sim | DEFAULT 0; CHECK >= 0 | Saldo atual. |
| estoque_minimo | DECIMAL(10,3) | Sim | DEFAULT 0; CHECK >= 0 | Nível de reposição. |
| ativo | BOOLEAN | Sim | DEFAULT TRUE | Indica se continua em uso. |

## 10. compra

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_compra | INT AUTO_INCREMENT | Sim | PK | Identificador. |
| id_fornecedor | INT | Sim | FK | Fornecedor. |
| data_compra | DATETIME | Sim | DEFAULT CURRENT_TIMESTAMP; índice | Data/hora da compra. |
| observacoes | TEXT | Não | — | Observações. |

## 11. item_compra

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_item_compra | INT AUTO_INCREMENT | Sim | PK | Identificador da linha. |
| id_compra | INT | Sim | FK | Compra. |
| id_insumo | INT | Sim | FK | Insumo. |
| quantidade | DECIMAL(10,3) | Sim | CHECK > 0 | Quantidade adquirida. |
| valor_unitario | DECIMAL(10,2) | Sim | CHECK >= 0 | Valor por unidade. |

Ao inserir um item, um trigger gera movimentação de entrada e atualiza o saldo.

## 12. movimentacao_estoque

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_movimentacao | INT AUTO_INCREMENT | Sim | PK | Identificador. |
| id_insumo | INT | Sim | FK | Insumo movimentado. |
| id_agendamento | INT | Não | FK opcional | Atendimento associado quando aplicável. |
| tipo | VARCHAR(20) | Sim | CHECK | entrada, consumo ou ajuste. |
| quantidade | DECIMAL(10,3) | Sim | CHECK > 0 | Quantidade movimentada. |
| data_movimentacao | DATETIME | Sim | DEFAULT CURRENT_TIMESTAMP; índice | Data/hora. |
| observacoes | TEXT | Não | — | Motivo ou detalhe. |

O trigger impede consumo maior que o saldo e mantém a quantidade atualizada. O tipo ajuste soma a quantidade informada; para corrigir um saldo para baixo, a rotina atual exige modelar a diferença como consumo, com observação explicativa.

## 13. fechamento_caixa

| Campo | Tipo | Obrigatório | Chave/regra | Descrição |
|---|---|---|---|---|
| id_fechamento | INT AUTO_INCREMENT | Sim | PK | Identificador. |
| data_inicio | DATE | Sim | UNIQUE com data_fim | Início do período. |
| data_fim | DATE | Sim | CHECK >= data_inicio | Fim do período. |
| total_recebido | DECIMAL(12,2) | Sim | Calculado pela procedure | Soma dos pagamentos no período. |
| percentual_salao | DECIMAL(5,2) | Sim | DEFAULT 30.00 | Percentual do salão. |
| valor_salao | DECIMAL(12,2) | Sim | Calculado | 30% do total. |
| percentual_profissionais | DECIMAL(5,2) | Sim | DEFAULT 70.00 | Percentual dos profissionais. |
| valor_profissionais | DECIMAL(12,2) | Sim | Calculado | 70% do total. |
| data_fechamento | DATETIME | Sim | DEFAULT CURRENT_TIMESTAMP | Momento do fechamento. |
| observacoes | TEXT | Não | — | Observações. |

Executar CALL fechar_caixa('AAAA-MM-DD','AAAA-MM-DD') para fechar um período. O mesmo par de datas não pode ser inserido duas vezes.

## 14. Relacionamentos e cardinalidades lógicas

- Cliente (0,n) — Agendamento (1,1): um cliente pode ter vários agendamentos; cada agendamento tem um cliente.
- Profissional (0,n) — Agendamento (1,1): cada agendamento tem um profissional.
- Procedimento (0,n) — Agendamento (1,1): cada agendamento tem um procedimento.
- Profissional (0,n) — Especialidade (0,n): resolvido por profissional_especialidade.
- Agendamento (0,1) — Pagamento (1,1): um pagamento no máximo por agendamento.
- Fornecedor (0,n) — Compra (1,1).
- Compra (1,n) — Item_Compra (1,1).
- Insumo (0,n) — Item_Compra (1,1).
- Insumo (0,n) — Movimentacao_Estoque (1,1).
- Agendamento (0,n) — Movimentacao_Estoque (0,1), quando a movimentação estiver associada a um atendimento.

**Nota:** as cardinalidades acima descrevem a estrutura lógica documentada no SQL. Como os diagramas foram preservados sem edição, eles podem não refletir integralmente essas relações.

## 15. Regras, índices e restrições

- PKs e FKs preservam identificação e integridade referencial.
- especialidade.nome é UNIQUE; profissional_especialidade usa PK composta.
- agendamento tem índice para data, profissional e início, além de validações por trigger.
- pagamento tem UNIQUE em id_agendamento e índice por data_pagamento.
- CHECK restringe duração, horários, status, formas de pagamento, valores e quantidades.
- As validações de sobreposição são implementadas por triggers, mas devem ser testadas em MySQL e sob operações concorrentes.

## 16. Acesso, LGPD e auditoria

Telefone e e-mail são dados pessoais e devem ser acessados apenas por pessoas autorizadas, para finalidades legítimas do salão. Não são automaticamente classificados como dados pessoais sensíveis.

| Operação | Acesso mínimo recomendado |
|---|---|
| Cadastro/consulta de clientes | Profissionais autorizados e responsável |
| Consulta/alteração da agenda | Profissionais autorizados e responsável |
| Cadastro de procedimentos/profissionais | Responsável ou pessoa autorizada |
| Pagamentos e fechamento de caixa | Responsável e pessoas autorizadas para a função |
| Compras e estoque | Pessoas responsáveis por compras e controle de materiais |

O SQL atual não possui tabela de log de acesso. Como melhoria futura, pode ser criada uma tabela de auditoria com identificador do evento, usuário, operação, entidade afetada, data/hora e resultado, evitando gravar senhas ou dados pessoais desnecessários.

## 17. Limites e decisões

- O SQL inclui agenda, pagamentos, compras, fornecedores, itens, estoque e fechamento de caixa; os DERs preservados não exibem todas essas tabelas.
- O sistema não registra venda de produtos porque a documentação informa que o salão não os comercializa.
- O pagamento é único por agendamento nesta versão; pagamentos parciais separados exigiriam rever a regra.
- A procedure calcula a divisão 30%/70% dos pagamentos registrados, mas não substitui conferência financeira/fiscal.
- O consumo de insumos precisa ser registrado; não é calculado automaticamente por procedimento.
- O banco não implementa emissão de nota fiscal.

**Referência de versão:** MySQL aplica restrições CHECK a partir da versão 8.0.16. Consulte a [documentação oficial](https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html).
