# Entrega 2 — Modelo Lógico, Implementação SQL e Apresentação Final

## Sistema de gestão de informações — Salão dos Primos

> Escopo desta revisão: relatório, levantamento, dicionários, script SQL, consultas e roteiro da apresentação foram revisados. Os arquivos DER_Conceitual.png e DER_Lógico.png foram mantidos exatamente como estavam, conforme solicitado. Por isso, algumas divergências apontadas na correção da Entrega 1 continuam visíveis nos diagramas e são registradas abaixo.

## Integrantes

| Nome completo | RGM | Usuário GitHub |
|---|---:|---|
| Emilly Rodrigues de Souza | 47508248 | [emillyrodrigues-tech](https://github.com/emillyrodrigues-tech) |
| Franciele Souza de Jesus | 47643323 | FrancieleSZ |
| Julia Parra | 47566604 | confirmar conta real |
| Kamilly Vitória Alves da Silva | 46919431 | [KamillyVicks](https://github.com/KamillyVicks) |

Nomes e RGMs foram transcritos da documentação de avaliação da Entrega 1. O usuário de Julia Parra não foi identificado nos 100 commits mais recentes consultados; confirmar a conta real antes da entrega.

## 1.1 Revisão do modelo conceitual

### Caracterização da organização

O Salão dos Primos é um salão de beleza feminino e masculino, com fins lucrativos. A documentação da Entrega 1 registra quatro profissionais e aproximadamente 30 a 50 clientes. O controle de horários foi descrito como feito em caderno de papel, o que dificulta consultar a disponibilidade antes de ir ao salão e aumenta as mensagens recebidas por WhatsApp durante os atendimentos.

**Problemas de gestão da informação**

- **P1 — Consulta de agenda:** os horários anotados em papel dificultam consultar a disponibilidade por profissional e evitar conflito de horário.
- **P2 — Sobrecarga de mensagens:** dúvidas e pedidos de horários por WhatsApp interrompem os profissionais durante os atendimentos.
- **P3 — Conferência de recebimentos:** os pagamentos ocorrem presencialmente ao final do atendimento; registrar valores e formas permite consultar os recebimentos e apoiar o fechamento de caixa.
- **P4 — Acompanhamento de insumos:** o modelo registra compras, entradas e consumo de materiais usados nos procedimentos, permitindo consultar saldo e necessidade de reposição.

P1 e P2 constam na caracterização original. P3 e P4 descrevem os processos financeiros e de insumos contemplados nesta versão do sistema. As consultas gerenciais relacionadas estão identificadas como G01–G08 no script SQL. O estoque é de insumos usados nos serviços, não de produtos vendidos ao cliente.

### Evidências e contato

- **Organização:** Salão dos Primos.
- **Responsável registrada na Entrega 1:** Alaide.
- **Endereço registrado:** R. Bernardino Vergueiro, 276 — Jardim Jaú, São Paulo - SP, 03710-060.
- **Telefone registrado:** (11) 94400-0738.
- **Instagram:** https://www.instagram.com/salaodosprimoss/
- **Fotos existentes no repositório:** [Imagem1.jpeg](Imagem1.jpeg) e [Imagem2.jpeg](Imagem2.jpeg).
- **Correção da Entrega 1:** [Issue #19 — avaliação do professor](https://github.com/FrancieleSZ/Salao/issues/19).

O material registra entrevista e observação no local e duas fotos. A data exata da visita, a função completa da entrevistada e a lista dos integrantes que participaram não estão identificadas de forma verificável nos arquivos consultados; não foram inventadas. Acrescentem esses dados se estiverem nas anotações reais do grupo.

### Processos de negócio

1. **Cadastro de clientes:** manter nome e meios de contato necessários para organizar atendimentos.
2. **Cadastro de profissionais:** manter profissionais e situação ativa/inativa.
3. **Procedimentos e especialidades:** registrar serviços, duração estimada, preço de referência e áreas de atuação.
4. **Marcação e consulta da agenda:** escolher cliente, profissional, procedimento, data e horários; consultar disponibilidade e impedir sobreposição.
5. **Confirmação, cancelamento e remarcação:** atualizar a situação; o cancelamento libera o intervalo.
6. **Execução do atendimento:** registrar o estado do agendamento e consultar o serviço reservado.
7. **Recebimento:** registrar valor efetivamente recebido, data e forma (débito, crédito, Pix ou dinheiro, conforme a documentação).
8. **Conferência de caixa e divisão financeira:** consultar pagamentos e calcular a divisão informada de 30% para despesas do salão e 70% para profissionais.
9. **Compras e fornecedores:** registrar fornecedor, compra e itens adquiridos.
10. **Controle de insumos:** registrar entrada por compra, consumo e saldo; consultar insumos no nível mínimo ou abaixo.
11. **Venda de produtos:** fora do escopo, pois a documentação informa que o salão não comercializa produtos.

### Requisitos funcionais

- **RF01:** cadastrar clientes com nome, telefone e e-mail; telefone e e-mail são opcionais no esquema SQL.
- **RF02:** cadastrar procedimentos com nome, descrição, duração estimada e preço de referência.
- **RF03:** cadastrar profissionais com nome, telefone e situação ativa/inativa.
- **RF04:** cadastrar especialidades e relacioná-las aos profissionais.
- **RF05:** registrar agendamento com cliente, profissional, procedimento, data, início, término, situação e observações.
- **RF06:** permitir à aplicação calcular o término com base na duração do procedimento e na avaliação profissional quando houver duração estendida.
- **RF07:** impedir sobreposição de horários não cancelados do mesmo profissional.
- **RF08:** consultar agenda por data e profissional.
- **RF09:** cancelar ou remarcar agendamentos sem manter bloqueado o horário cancelado.
- **RF10:** consultar o histórico de agendamentos de um cliente.
- **RF11:** impedir novos agendamentos com profissional inativo.
- **RF12:** registrar um pagamento por agendamento, com valor efetivamente recebido, data e forma.
- **RF13:** consultar pagamentos por período e forma.
- **RF14:** calcular a divisão informada de 30%/70% sobre pagamentos registrados.
- **RF15:** cadastrar fornecedores e registrar compras de insumos com itens, quantidades e valores unitários.
- **RF16:** registrar entrada e consumo de insumos, atualizar saldo e consultar níveis de reposição.
- **RF17:** consultar totais de compras por fornecedor e período.

### Requisitos não funcionais

- **RNF01 — Usabilidade:** dados organizados para consulta rápida durante o expediente.
- **RNF02 — Desempenho:** consultas frequentes podem filtrar agenda por data e profissional usando índice.
- **RNF03 — Segurança e privacidade:** restringir dados pessoais e financeiros às pessoas autorizadas.
- **RNF04 — Disponibilidade:** a solução deve estar acessível durante o funcionamento do salão quando implantada.
- **RNF05 — Confiabilidade:** evitar conflitos de agenda e manter consistência dos vínculos, pagamentos e movimentações.
- **RNF06 — Integridade:** usar PKs, FKs, restrições de domínio e validações no banco.

### Regras de negócio

- **RN01 — Duração:** a reserva considera a duração estimada; coloração destinada a deixar o cabelo loiro pode exigir o dobro do tempo padrão, conforme avaliação profissional.
- **RN02 — Sem sobreposição:** um profissional não pode ter dois agendamentos não cancelados com intervalos sobrepostos na mesma data.
- **RN03 — Intervalo completo:** a disponibilidade deve cobrir todo o período entre início e término.
- **RN04 — Profissional ativo:** profissional inativo não recebe novos agendamentos.
- **RN05 — Vínculos obrigatórios:** cada agendamento referencia exatamente um cliente, profissional e procedimento; cada pagamento referencia um agendamento.
- **RN06 — Preço de referência:** o preço cadastrado é estimado; o valor final pode variar e é combinado presencialmente.
- **RN07 — Cancelamento:** agendamento cancelado não bloqueia o intervalo.
- **RN08 — Antecedência de cancelamento:** não há prazo mínimo numérico documentado; o sistema não o aplica automaticamente.
- **RN09 — Pagamento:** registrar valor efetivamente recebido e forma permitida: débito, crédito, Pix ou dinheiro.
- **RN10 — Divisão financeira:** 30% para despesas do salão e 70% para profissionais, conforme a documentação.
- **RN11 — Fechamento:** o cálculo considera pagamentos registrados no período informado.
- **RN12 — Compras:** cada compra referencia fornecedor e contém itens com quantidade e valor unitário.
- **RN13 — Estoque:** entradas, consumo e ajustes atualizam saldo; o consumo não pode superar o saldo disponível.
- **RN14 — Sem venda de produtos:** não implementar venda de produtos nesta versão.
- **RN15 — Privacidade:** coletar somente dados necessários e limitar o acesso.
- **RN16 — Higiene e segurança:** procedimentos com químicos e instrumentos devem seguir orientações sanitárias aplicáveis; detalhes específicos não foram inventados no banco.
- **RN17 — Nota fiscal:** a documentação anterior informa emissão de nota fiscal, mas o processo fiscal e a integração de emissão não fazem parte deste banco.
- **RN18 — Atraso e sinal:** não há regra numérica documentada para tolerância a atraso, sinal ou pagamento antecipado; não são automatizados.

### Tratamento dos apontamentos da Entrega 1

| Apontamento | Tratamento |
|---|---|
| Processos limitados à agenda | Documentação e SQL ampliados para pagamentos, fechamento, compras, fornecedores e controle de insumos. |
| Requisito central de agendamento ausente/inconsistente | RF05–RF11 detalham cadastro, agenda, conflitos, cancelamento e profissional ativo. |
| Regras de negócio insuficientes | RN01–RN18 documentadas e associadas às validações/consultas quando implementadas. |
| Dicionário incompleto | HTML ampliado com fluxo, convenções, tipos, relacionamentos, restrições, privacidade e proposta de log. |
| DER sem identificadores, divergência de cardinalidade e ausência de Pagamento | **Não alterado**, por instrução expressa. As divergências visuais continuam pendentes. |

**Software dos diagramas:** o software de autoria não está comprovado apenas pelos PNGs. Confirmem o nome do aplicativo a partir do arquivo-fonte antes de informar no relatório.

## 1.2 Conversão do modelo conceitual para o lógico

- **Entidades para tabelas:** Cliente, Profissional, Procedimento, Especialidade e Agendamento têm tabelas próprias. Pagamento representa o recebimento. Fornecedor, Insumo, Compra, Item_Compra, Movimentacao_Estoque e Fechamento_Caixa ampliam o SQL para processos de apoio.
- **Atributos para colunas:** identificadores inteiros, datas e horários em tipos próprios, valores monetários em DECIMAL, textos em VARCHAR/TEXT e quantidades fracionárias em DECIMAL(10,3).
- **Relacionamentos 1:N:** a FK fica no lado N: agendamento referencia cliente, profissional e procedimento; pagamento referencia agendamento; compra referencia fornecedor; item_compra referencia compra e insumo; movimentacao_estoque referencia insumo e, opcionalmente, agendamento.
- **Relacionamento N:N:** Profissional–Especialidade é resolvido por profissional_especialidade, cuja PK composta é (id_profissional, id_especialidade); ambos os campos são FKs.
- **Agendamento–Pagamento:** o SQL permite no máximo um pagamento por agendamento, por FK com UNIQUE. Isso é uma decisão de implementação, não confirmação de pagamentos parciais.
- **Generalização/especialização:** não há generalização implementada nas tabelas atuais.
- **Limitação dos diagramas:** o SQL e os dicionários incluem entidades de apoio ausentes dos DERs preservados; portanto, os diagramas não representam integralmente o esquema SQL atual.

## 1.3 Chaves primárias e estrangeiras

| Tabela | PK | FKs |
|---|---|---|
| cliente | id_cliente | — |
| profissional | id_profissional | — |
| procedimento | id_procedimento | — |
| especialidade | id_especialidade | — |
| profissional_especialidade | id_profissional, id_especialidade | id_profissional → profissional; id_especialidade → especialidade |
| agendamento | id_agendamento | id_cliente; id_profissional; id_procedimento |
| pagamento | id_pagamento | id_agendamento → agendamento (também UNIQUE) |
| fornecedor | id_fornecedor | — |
| insumo | id_insumo | — |
| compra | id_compra | id_fornecedor → fornecedor |
| item_compra | id_item_compra | id_compra → compra; id_insumo → insumo |
| movimentacao_estoque | id_movimentacao | id_insumo → insumo; id_agendamento → agendamento (opcional) |
| fechamento_caixa | id_fechamento | — |

## 1.4 Normalização: 1FN, 2FN e 3FN

- **1FN — valores atômicos:** cada coluna guarda um único valor por registro. Os vínculos de profissionais e especialidades ficam em linhas próprias na tabela associativa; cada item de compra é uma linha independente.
- **2FN — dependência completa da chave:** profissional_especialidade tem chave composta e não possui atributos não-chave que dependam apenas de parte dela. As demais tabelas usam PKs simples; compra e itens de compra são separados.
- **3FN — sem dependências transitivas indevidas:** dados de cliente, profissional, procedimento, fornecedor e insumo ficam em suas próprias tabelas e são referenciados por FKs. O nome do fornecedor não é repetido em cada compra e o nome do insumo não é repetido em cada item de compra.
- **Justificativa:** a decomposição reduz duplicidade e anomalias de inserção, atualização e exclusão, além de preservar integridade referencial. Fechamento_Caixa guarda um retrato calculado do período; os valores são gerados pela procedure e a rotina não substitui conferência financeira real.

## 1.5 Justificativas técnicas

- **PKs inteiras:** identificam registros sem depender de nome, telefone ou dado que possa mudar ou repetir.
- **PK composta em profissional_especialidade:** impede repetir o mesmo vínculo profissional/especialidade.
- **FKs obrigatórias:** impedem agendamentos sem cliente, profissional ou procedimento válido e itens sem compra/insumo correspondente.
- **FK opcional em movimentacao_estoque.id_agendamento:** permite associar um consumo a um atendimento quando conhecido; ajustes e consumos gerais podem não ter atendimento.
- **UNIQUE em pagamento.id_agendamento:** implementa um pagamento por agendamento. Se houver pagamentos parciais separados, essa decisão deve ser revista após confirmação.
- **CHECK e domínios:** restringem duração positiva, valores monetários não negativos, quantidades positivas, formas de pagamento e estados permitidos. O MySQL precisa ser versão 8.0.16 ou superior para aplicar CHECK, conforme a [documentação oficial](https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html).
- **Triggers de agenda:** verificam profissional ativo e sobreposição em inserções/alterações. Em aplicação concorrente, transações e concorrência ainda precisam ser testadas.
- **Triggers de estoque:** item de compra gera entrada; movimentações atualizam saldo; consumo maior que o saldo é rejeitado.
- **Fechamento de caixa:** a procedure soma pagamentos do período e calcula 30%/70%. O resultado depende dos pagamentos registrados e não comprova, por si só, fechamento contábil/fiscal.
- **Privacidade:** dados de exemplo são fictícios; no uso real, o acesso deve ser restrito.

## 1.6 Proposta analítica para BI e IA

### KPIs propostos

| KPI | Fórmula e período | Uso |
|---|---|---|
| Recebimento por forma | Soma de valor_pago por mês e forma | Conferir recebimentos registrados. |
| Agendamentos por situação | Contagem por mês e status | Acompanhar conclusões, cancelamentos e faltas. |
| Taxa de cancelamento/falta | (cancelados + faltas) / total de agendamentos × 100, por mês | Identificar períodos com maior perda de horários. |
| Demanda por procedimento | Contagem de agendamentos por procedimento | Planejar agenda e oferta de serviços. |
| Recebimento por profissional | Soma de pagamentos ligados aos agendamentos de cada profissional | Analisar atendimentos e recebimentos registrados. |
| Insumos no mínimo ou abaixo | Lista de insumos com saldo menor ou igual ao mínimo | Priorizar reposição. |
| Compras por fornecedor/mês | Soma de quantidade × valor unitário por fornecedor e mês | Acompanhar gastos registrados. |
| Estimativa 30%/70% | Total de pagamentos × 30% e × 70%, por mês | Conferir o cálculo baseado na divisão informada. |

### Rastreabilidade

| Problema/KPI | Tabelas | Consulta SQL |
|---|---|---|
| P1 — consulta de agenda e conflitos | agendamento, cliente, profissional, procedimento | G02; auditoria A01 |
| P2 — consulta de agenda para reduzir dependência de mensagens | agendamento, profissional, cliente, procedimento | G02 |
| P3 — recebimentos e conferência de caixa | pagamento, agendamento, profissional | G01, G05, G07 |
| P4 — reposição de insumos | insumo, movimentacao_estoque, compra, item_compra, fornecedor | G03, G06; A06 |
| Taxa de cancelamento/falta | agendamento | G08 |
| Demanda por procedimento | procedimento, agendamento | G04 |
| Integridade dos vínculos | tabelas relacionadas | A02, A07 |
| Atendimento concluído sem pagamento | agendamento, pagamento | A03 |
| Profissional inativo com agendamento ativo | profissional, agendamento | A04 |
| Pagamento inválido | pagamento | A05 |

### Potencial para BI e IA

Os dados podem alimentar painéis por mês, profissional, procedimento, situação, forma de pagamento, fornecedor e insumo. Uma evolução poderia prever demanda por procedimento e período, sugerir reposição com base no histórico de consumo ou identificar horários com mais cancelamentos. Essas aplicações são propostas futuras, não funcionalidades de IA implementadas pelo SQL. Os resultados dependem de dados suficientes, consistentes e revisados pela equipe.

## 2. Modelo lógico relacional

- **Modelo lógico existente:** [DER_Lógico.png](DER_L%C3%B3gico.png).
- **DER conceitual existente:** [DER_Conceitual.png](DER_Conceitual.png).
- **Software de autoria:** confirmar pelo arquivo-fonte; não foi possível comprová-lo apenas pelos PNGs.
- **Integridade documental:** os dois diagramas foram preservados sem edição. A correção anterior apontou falta de identificadores, cardinalidades inconsistentes e ausência de Pagamento no DER conceitual; essas divergências continuam pendentes. O SQL também contém tabelas de compras/estoque/caixa que não aparecem nos diagramas. Isso é explicitado aqui, mas não corrigido visualmente por causa da instrução de preservação.

## 3. Script SQL completo

Arquivo: [script.sql](script.sql).

O script está direcionado a MySQL 8.0.16 ou superior e contém criação do banco/tabelas, PK/FK, restrições, índices, triggers, procedure de fechamento, massa fictícia, exemplos de JOIN, UPDATE, DELETE, consultas gerenciais G01–G08 e auditorias A01–A07.

**Importante:** o script foi revisado textualmente, mas não foi executado em servidor MySQL nesta revisão. Antes da apresentação, executar em banco de teste vazio e confirmar a saída das consultas e triggers. A chamada de fechamento no final deve ser executada uma única vez em banco limpo, pois o período possui restrição UNIQUE.

## 4. Massa de dados

A massa está incluída no script.sql e contém registros fictícios:

- 40 clientes;
- 4 profissionais;
- 10 procedimentos;
- 5 especialidades e 12 vínculos profissional-especialidade;
- 96 agendamentos em períodos diferentes, com situações variadas;
- pagamentos fictícios com diferentes formas;
- 3 fornecedores, 8 insumos, 3 compras, itens e movimentações de estoque.

A quantidade de clientes está na ordem de grandeza dos 30–50 clientes registrados na caracterização; os quatro profissionais refletem o número informado. Agendamentos, pagamentos e compras foram ampliados artificialmente para demonstrar filtros, formas de pagamento, estados e níveis de estoque; não representam volume histórico real. Os nomes/contatos são exemplos fictícios e os e-mails usam o domínio reservado .invalid.

## 5. Repositório GitHub e artefatos

- [README / Relatório Técnico Final](README.md)
- [Script SQL e massa de dados](script.sql)
- [Dicionário HTML](dicionario_de_dados.html)
- [Dicionário Markdown](dicionario_dados.md)
- [Levantamento](levantamento.md)
- [DER conceitual — preservado](DER_Conceitual.png)
- [DER lógico — preservado](DER_L%C3%B3gico.png)
- [Fotos no repositório](Imagem1.jpeg) e [Imagem2.jpeg](Imagem2.jpeg)
- [Roteiro do pitch](roteiro_pitch.md)
- [Correção da Entrega 1](https://github.com/FrancieleSZ/Salao/issues/19)

O professor informa que somente a branch main será corrigida. Verifiquem se o histórico de commits identifica todos os integrantes e se a contribuição está distribuída. Esta revisão não inventa contas GitHub nem declara colaboração que não foi verificada.

## 6. Uso de Inteligência Artificial

| Item | Registro |
|---|---|
| Ferramentas e etapas | A correção da Entrega 1 registra uso de Claude no esboço inicial do README. Nesta revisão, foi usado ChatGPT para comparar o esqueleto da Entrega 2 com o repositório, revisar documentação, ampliar a massa fictícia e elaborar consultas SQL. |
| Motivação | Corrigir lacunas apontadas na avaliação e organizar os artefatos conforme o esqueleto da Entrega 2. |
| Solicitação desta revisão | “pode corrigir todos os erros agora, tem acesso ao github e o repositorio, só n mude os DErs”. Em etapas anteriores, o grupo também pediu revisão do HTML e do repositório. |
| Resposta aproveitada | Organização das seções do relatório, documentação de conversão/normalização, PK/FK, massa fictícia mais variada e consultas gerenciais/auditoria. |
| Fontes verificadas | Esqueleto da Entrega 2, arquivos do repositório, correção do professor na [issue #19](https://github.com/FrancieleSZ/Salao/issues/19) e [documentação oficial MySQL sobre CHECK](https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html). |
| Ajustes/rejeições | Não foram inventadas datas de entrevista, função da entrevistada, usuários GitHub ausentes, resultados de execução SQL ou dados reais de clientes. Os diagramas foram mantidos intactos. |
| Justificativa final | A proposta prioriza os fatos documentados e a correção do professor; os dados de demonstração são explicitamente fictícios. |
| Reflexão crítica | A IA pode sugerir estruturas plausíveis que não correspondem à operação real. O SQL precisa ser executado e testado pelo grupo. Os DERs continuam com divergências anteriores porque foram preservados, então a consistência visual entre diagramas e esquema SQL não está completa. |

## 7. Apresentação corporativa final — pitch de 8 minutos

O roteiro está em [roteiro_pitch.md](roteiro_pitch.md). A apresentação deve demonstrar o SQL realmente executando em MySQL, com ao menos uma consulta gerencial e uma auditoria. Não afirmar que os diagramas refletem todas as tabelas atuais: eles foram preservados sem alteração.

## Limitações e verificações finais

1. **DERs preservados:** os dois PNGs não foram modificados. Divergências anteriores de identificadores, cardinalidades e Pagamento continuam pendentes.
2. **Modelo lógico:** como o diagrama não foi modificado, deve ser comparado com as tabelas/FKs documentadas antes da defesa.
3. **Teste de execução:** não foi comprovado que o script executa de ponta a ponta em MySQL. Executar em banco vazio e guardar evidência.
4. **Levantamento de campo:** a data exata da entrevista, participantes e função completa da responsável precisam ser confirmadas nas anotações reais, se disponíveis.
5. **Usuários GitHub:** confirmar as contas reais dos integrantes e revisar a distribuição de commits.
6. **Regra de pagamento:** o esquema permite um pagamento por agendamento. Se houver pagamentos parciais separados, rever após confirmação.
7. **Fechamento de caixa:** calcula 30%/70% dos pagamentos lançados no período; não substitui conferência contábil/fiscal.
8. **Consumo de estoque:** a entrada por compra é automatizada, mas o consumo deve ser lançado por movimentação; a quantidade consumida em cada serviço não é calculada automaticamente.
9. **Nota fiscal:** o processo fiscal não foi implementado no banco.
10. **Escopo:** o salão não vende produtos conforme a documentação; o estoque modelado corresponde a insumos utilizados nos serviços.
