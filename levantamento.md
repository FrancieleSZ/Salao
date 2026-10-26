# Levantamento de requisitos — Salão dos Primos

## 1. Identificação

- **Organização:** Salão dos Primos, salão de beleza feminino e masculino.
- **Responsável registrada no projeto:** Alaide.
- **Endereço registrado:** R. Bernardino Vergueiro, 276 — Jardim Jaú, São Paulo - SP, 03710-060.
- **Telefone de contato registrado:** (11) 94400-0738.
- **Instagram registrado:** https://www.instagram.com/salaodosprimoss/
- **Participantes do grupo:** Emilly Rodrigues de Souza, Franciele Souza de Jesus, Julia Parra e Kamilly Vitória Alves da Silva.
- **Forma de levantamento registrada:** entrevista com a responsável e observação no local, conforme documentação da Entrega 1.
- **Data exata e função completa da entrevistada:** não constam de forma verificável nos arquivos atuais. O grupo deve acrescentar esses dados a partir das anotações reais, sem estimar ou inventar.

## 2. Descrição da organização

A organização presta serviços de beleza para público feminino e masculino, com fins lucrativos. A documentação do projeto registra quatro profissionais e aproximadamente 30 a 50 clientes.

Os serviços são organizados por agendamento, profissional e procedimento. A duração estimada do procedimento orienta o intervalo reservado. O valor final do serviço pode ser combinado presencialmente e variar conforme o tamanho do cabelo. A documentação informa recebimento presencial ao final do atendimento, com débito, crédito, Pix ou dinheiro.

A divisão financeira informada no material é de 30% para despesas do salão e 70% para os profissionais. O projeto também contempla registro de compras e controle de insumos usados nos procedimentos. A documentação informa que o salão não vende produtos ao cliente.

## 3. Achados do levantamento

### 3.1 Relatados na entrevista/documentação do projeto

1. **Agenda em caderno:** o controle de horários é feito em papel.
2. **Mensagens de WhatsApp:** clientes consultam horários por mensagem, o que aumenta interrupções durante os atendimentos.
3. **Duração variável dos procedimentos:** o tempo reservado depende do serviço; a coloração para deixar o cabelo loiro pode exigir o dobro do tempo padrão, conforme avaliação profissional.
4. **Preço final:** o preço cadastrado serve como referência e o valor pode variar conforme o tamanho do cabelo.
5. **Pagamento e divisão financeira:** o pagamento ocorre presencialmente ao final do atendimento; a divisão informada é 30% para despesas do salão e 70% para profissionais.
6. **Compra e controle de insumos:** o modelo contempla compras com fornecedor, entrada de materiais, consumo e saldo.
7. **Venda de produtos:** a documentação informa que o salão não comercializa produtos.

### 3.2 Observação presencial

O projeto registra que houve observação no local e mantém duas imagens no repositório: [Imagem1.jpeg](Imagem1.jpeg) e [Imagem2.jpeg](Imagem2.jpeg). A correção do professor também reconhece as fotos do salão e a entrevista de campo.

Os arquivos atuais não descrevem, com detalhe verificável, cada etapa observada presencialmente nem separam cada achado visual da resposta verbal. O grupo deve acrescentar apenas observações que realmente realizou, por exemplo, como a agenda estava organizada no momento da visita, quais registros eram utilizados e como os profissionais consultavam horários. Não se deve apresentar uma inferência como se fosse observação confirmada.

## 4. Problemas e necessidades

| Código | Problema/necessidade | Efeito na gestão | Requisito/consulta relacionada |
|---|---|---|---|
| P1 | Consulta de disponibilidade baseada em agenda de papel | Dificulta verificar intervalos livres e prevenir conflitos | RF05–RF08; G02; auditoria A01 |
| P2 | Muitas mensagens sobre horários durante os atendimentos | Interrompe o trabalho dos profissionais | RF08; G02 |
| P3 | Necessidade de consultar os recebimentos registrados e apoiar a conferência de caixa | Exige reunir pagamentos por período e forma | RF12–RF14; G01, G05 e G07 |
| P4 | Acompanhamento de compra, entrada, consumo e reposição de insumos no escopo do banco | Ajuda a identificar itens no nível mínimo ou abaixo | RF15–RF17; G03 e G06; auditoria A06 |

P1 e P2 são os problemas diretamente descritos na caracterização da Entrega 1. P3 e P4 correspondem aos processos financeiros e de insumos contemplados na versão atual do projeto. Não são apresentados como falas literais da entrevistada.

## 5. Requisitos derivados

| ID | Requisito | Origem | Prioridade |
|---|---|---|---|
| RF01 | Cadastrar cliente com nome, telefone e e-mail opcional | Necessidade de organizar os atendimentos e contatos | Alta |
| RF02 | Cadastrar procedimentos, duração e preço de referência | Duração influencia a agenda; preço final pode variar | Alta |
| RF03 | Cadastrar profissionais e sua situação ativa/inativa | Organização da agenda por profissional | Alta |
| RF04 | Associar profissionais às especialidades | Organização dos serviços disponíveis | Média |
| RF05 | Registrar agendamento com cliente, profissional, procedimento, data e intervalo | Processo de marcação descrito no projeto | Alta |
| RF06 | Calcular/definir o horário final a partir da duração | RN01 | Alta |
| RF07 | Impedir sobreposição do mesmo profissional | RN02 e RN03 | Alta |
| RF08 | Consultar agenda por data e profissional | P1 e P2 | Alta |
| RF09 | Cancelar/remarcar e liberar o horário cancelado | Processo de agenda documentado | Alta |
| RF10 | Consultar histórico de agendamentos por cliente | Organização dos atendimentos | Média |
| RF11 | Impedir novo agendamento com profissional inativo | RN04 | Alta |
| RF12 | Registrar valor, data e forma de pagamento | Processo de recebimento documentado | Alta |
| RF13 | Consultar pagamentos por período e forma | P3 | Alta |
| RF14 | Calcular a divisão financeira de 30%/70% | Regra financeira documentada | Alta |
| RF15 | Registrar fornecedor, compra e itens comprados | Processo de compras contemplado no projeto | Média |
| RF16 | Registrar entradas/consumos e consultar saldo e mínimo | Controle de insumos contemplado no projeto | Média |
| RF17 | Consultar compras por fornecedor e período | Acompanhamento das despesas com insumos | Média |

## 6. Regras de negócio documentadas

- **RN01:** a duração do procedimento define o intervalo reservado; coloração para loiro pode exigir o dobro do tempo, conforme avaliação profissional.
- **RN02:** um profissional não pode ter agendamentos ativos com intervalos sobrepostos na mesma data.
- **RN03:** todo o intervalo requerido deve estar livre.
- **RN04:** profissional inativo não recebe novos agendamentos.
- **RN05:** cada agendamento referencia um cliente, profissional e procedimento; o pagamento referencia um agendamento.
- **RN06:** preço de procedimento é referência, não garantia do valor final.
- **RN07:** cancelamento libera o horário.
- **RN08:** a documentação não define prazo mínimo numérico para cancelamento.
- **RN09:** registrar valor efetivamente recebido e forma de pagamento; as formas listadas são débito, crédito, Pix e dinheiro.
- **RN10:** divisão financeira informada de 30% para despesas do salão e 70% para profissionais.
- **RN11:** fechamento considera pagamentos registrados no período.
- **RN12:** compra deve referenciar fornecedor e listar itens, quantidades e valores unitários.
- **RN13:** estoque é atualizado por entradas, consumo e ajustes; consumo não pode exceder o saldo.
- **RN14:** o salão não vende produtos ao cliente, conforme documentação.
- **RN15:** limitar a coleta e o acesso a dados pessoais ao necessário.
- **RN16:** seguir orientações sanitárias aplicáveis a químicos e instrumentos; detalhes específicos não foram documentados no levantamento atual.
- **RN17:** a documentação anterior informa emissão de nota fiscal, mas o banco não implementa emissão fiscal.
- **RN18:** não há regra numérica documentada para tolerância de atraso, sinal ou pagamento antecipado.

## 7. Evidências

- [Imagem1.jpeg](Imagem1.jpeg) — foto existente no repositório.
- [Imagem2.jpeg](Imagem2.jpeg) — foto existente no repositório.
- [Instagram do Salão dos Primos](https://www.instagram.com/salaodosprimoss/).
- [Correção do professor na issue #19](https://github.com/FrancieleSZ/Salao/issues/19).

A correção do professor registra endereço, telefone, Instagram, Google Meu Negócio citado e duas fotos no repositório. Antes da entrega final, confirmar se o link do perfil no Google Business Profile está disponível e acrescentar a data da visita/entrevista e os participantes a partir dos registros verdadeiros do grupo.

## 8. Limites e decisões de escopo

- Os registros usados no script SQL são fictícios; não são dados de clientes ou pagamentos reais.
- O banco inclui agenda, pagamentos, compras, fornecedores, insumos, movimentações e fechamento de caixa.
- Venda de produtos ao cliente não foi incluída.
- A procedure de fechamento calcula 30%/70% sobre os pagamentos registrados; não substitui a conferência financeira real.
- O consumo de insumos precisa ser lançado por movimentação; o sistema não estima automaticamente a quantidade utilizada em cada procedimento.
- Os DERs conceitual e lógico foram preservados sem alteração conforme instrução do grupo. As divergências visuais apontadas na correção anterior continuam pendentes.
