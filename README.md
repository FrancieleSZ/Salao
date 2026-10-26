# Entrega 1 — Modelo Conceitual (DER)
### Sistema de gestão de informações do Salão dos Primos

---

## Metadados

- **Integrantes**
  - Emilly Rodrigues de Souza — RGM: 47508248
  - Franciele Souza de Jesus — RGM: 47643323
  - Julia Parra — RGM: 47566604
  - Kamilly Vitória Alves da Silva — RGM: 46919431
- **Organização:** Salão dos Primos
- **Responsável entrevistada:** Alaide
- **Versão do documento:** 2.0 — 24/10/2026

## 1. Caracterização da organização

O Salão dos Primos é um salão de beleza feminino e masculino, com fins lucrativos, quatro profissionais e aproximadamente 30 a 50 clientes. Conforme a entrevista e a observação realizadas no local, o controle de horários é feito em caderno de papel. Isso dificulta consultar a disponibilidade antes de ir ao salão e aumenta a quantidade de mensagens de WhatsApp recebidas pelos profissionais durante os atendimentos.

**Evidências registradas no trabalho**
- Endereço informado: R. Bernardino Vergueiro, 276 — Jardim Jaú, São Paulo - SP, 03710-060.
- Instagram: https://www.instagram.com/salaodosprimoss/
- Telefone de contato do salão: (11) 94400-0738.
- Fotos da visita: [Imagem1.jpeg](Imagem1.jpeg) e [Imagem2.jpeg](Imagem2.jpeg).
- Pesquisa de campo: entrevista com a responsável e observação dos processos no salão.

## 2. Processos de negócio

### 2.1 Processos identificados

1. **Cadastro de clientes:** registrar dados básicos necessários para contato e organização dos atendimentos.
2. **Marcação de horário:** selecionar cliente, profissional, procedimento, data e hora.
3. **Organização e consulta da agenda:** verificar disponibilidade por profissional e duração do procedimento, evitando sobreposição.
4. **Contato e confirmação:** comunicação presencial ou por WhatsApp para marcar, confirmar e esclarecer dúvidas.
5. **Cancelamento e remarcação:** localizar o agendamento, cancelar ou escolher outro horário e liberar a vaga anterior quando aplicável.
6. **Atendimento / execução do procedimento:** realizar o serviço reservado; a duração depende do procedimento e pode ser maior em casos como coloração para loiro.
7. **Recebimento do pagamento:** ocorre presencialmente ao final do atendimento; o valor final é combinado no salão e pode variar conforme o tamanho do cabelo. Formas informadas: débito, crédito, Pix e dinheiro.
8. **Comissão e despesas do salão:** o relato registrado pelo grupo indica uma divisão de 30% para despesas do salão e 70% para os profissionais. Confirmar com a responsável a base exata de cálculo antes de implementar.
9. **Fechamento de caixa:** conferir os valores recebidos no período e a divisão correspondente. A forma detalhada de conferência precisa ser validada com a responsável.
10. **Compra de produtos e insumos:** reposição de tintas e produtos químicos usados nos procedimentos, por meio de fornecedores.
11. **Controle de estoque de insumos:** acompanhar entradas, consumo e saldo para reduzir risco de falta de materiais. O procedimento exato de controle deve ser confirmado com a responsável.
12. **Cadastro/consulta de fornecedores:** registrar ou consultar os fornecedores de quem o salão compra insumos, caso esse controle seja adotado pelo sistema.
13. **Venda de produtos no salão:** segundo o registro da entrevista, o salão **não vende produtos**. Portanto, venda de produtos não é tratada como processo operacional do sistema nesta versão.

### 2.2 Integração dos processos

- O cadastro do cliente antecede a marcação; cada agendamento deve estar ligado a um cliente.
- A consulta da agenda verifica o tempo livre do profissional durante toda a duração estimada do procedimento.
- Cancelamentos liberam o horário; remarcações devem verificar disponibilidade antes de confirmar o novo período.
- Ao concluir o atendimento, registra-se a situação do agendamento e o pagamento presencial.
- Os pagamentos registrados dão suporte à conferência de caixa e ao cálculo da divisão financeira, após validação da regra dos 30%/70%.
- A compra de insumos gera entradas de estoque; o consumo dos materiais nos procedimentos reduz o saldo, caso o salão confirme que deseja controlar estoque no sistema.
- O cadastro de fornecedor dá suporte à identificação da origem das compras.
- A venda de produtos foi excluída do escopo funcional porque o salão informou que não realiza essa atividade.

### 2.3 Fluxos resumidos

**Marcação:** solicitação do cliente → localizar/cadastrar cliente → escolher profissional e procedimento → consultar disponibilidade → validar duração e conflitos → registrar e confirmar agendamento.

**Atendimento e pagamento:** chegada do cliente → execução do procedimento → concluir atendimento → registrar pagamento e forma de pagamento → incluir no controle de caixa.

**Cancelamento/remarcação:** receber solicitação → localizar agendamento → cancelar e liberar horário ou consultar nova disponibilidade → atualizar registro → confirmar com o cliente.

**Compra e estoque:** identificar necessidade de reposição → selecionar/consultar fornecedor → registrar compra e itens → registrar entrada dos insumos → atualizar saldo. O controle de consumo durante os procedimentos depende da confirmação do processo real do salão.

## 3. Requisitos do sistema

### 3.1 Requisitos funcionais

- **RF01.** Cadastrar clientes com dados básicos de contato.
- **RF02.** Cadastrar procedimentos com nome, descrição, duração estimada e preço de referência.
- **RF03.** Cadastrar profissionais e indicar se estão ativos.
- **RF04.** Cadastrar especialidades e vincular profissionais às especialidades que dominam.
- **RF05.** Registrar agendamento com cliente, profissional, procedimento, data e hora de início.
- **RF06.** Calcular ou determinar o horário previsto de término a partir da duração do procedimento.
- **RF07.** Impedir sobreposição de agendamentos do mesmo profissional.
- **RF08.** Consultar a agenda por data e profissional e verificar horários disponíveis.
- **RF09.** Cancelar ou remarcar agendamentos, liberando o horário anterior quando cancelado ou remarcado.
- **RF10.** Consultar o histórico de agendamentos de um cliente.
- **RF11.** Impedir novos agendamentos com profissional inativo.
- **RF12.** Registrar o pagamento do atendimento, com valor efetivamente recebido, data e forma de pagamento.
- **RF13.** Consultar os pagamentos registrados por período para apoiar a conferência de caixa.
- **RF14.** Apoiar o cálculo da divisão de valores entre despesas do salão e profissionais, após a regra de cálculo ser validada.
- **RF15.** Registrar compras de insumos, com fornecedor, data e itens comprados, caso esse controle seja aprovado pelo salão.
- **RF16.** Consultar entradas e saldo de insumos, caso o controle de estoque seja confirmado.
- **RF17.** Cadastrar e consultar fornecedores de insumos, caso o salão deseje manter esse cadastro no sistema.

### 3.2 Restrição de escopo

O sistema não inclui venda de produtos nesta versão, pois a responsável informou que o salão não comercializa produtos. Isso é uma decisão de escopo, não uma funcionalidade do sistema.

### 3.3 Requisitos não funcionais

- **RNF01 — Usabilidade:** interface simples e rápida para uso durante o expediente.
- **RNF02 — Desempenho:** consulta de disponibilidade deve responder rapidamente.
- **RNF03 — Segurança e privacidade:** restringir acesso a dados pessoais e financeiros conforme a função do usuário.
- **RNF04 — Disponibilidade:** sistema acessível durante o funcionamento do salão.
- **RNF05 — Confiabilidade:** evitar conflitos de agenda e preservar a consistência dos registros de pagamentos e compras.
- **RNF06 — Integridade:** relacionamentos devem usar chaves estrangeiras e validações adequadas no banco de dados.

## 4. Regras de negócio

- **RN01 — Duração:** a reserva de horário deve considerar a duração estimada do procedimento. A regra relatada para coloração destinada a deixar o cabelo loiro pode exigir o dobro do tempo padrão, conforme a avaliação do profissional.
- **RN02 — Sem sobreposição:** um profissional não pode ter dois agendamentos ativos com intervalos sobrepostos na mesma data.
- **RN03 — Intervalo completo:** um novo agendamento só pode ser confirmado se todo o intervalo necessário estiver disponível.
- **RN04 — Profissional ativo:** profissional inativo não pode receber novos agendamentos.
- **RN05 — Vínculos obrigatórios:** cada agendamento referencia exatamente um cliente, um profissional e um procedimento.
- **RN06 — Preço de referência:** o preço cadastrado é estimado; o valor final é combinado presencialmente e pode variar conforme o tamanho do cabelo.
- **RN07 — Cancelamento:** agendamento cancelado não bloqueia mais o intervalo na agenda.
- **RN08 — Antecedência de cancelamento:** a antecedência mínima deve ser definida pela responsável. O prazo exato não consta no material disponível e não deve ser inventado.
- **RN09 — Pagamento:** registrar valor efetivamente recebido e forma de pagamento. Formas informadas: débito, crédito, Pix e dinheiro.
- **RN10 — Comissão/despesas:** o registro atual informa 30% para despesas do salão e 70% para os profissionais. Confirmar a base do cálculo e eventuais exceções antes de automatizar.
- **RN11 — Fechamento de caixa:** o fechamento deve considerar os pagamentos efetivamente registrados no período e a divisão validada pela responsável.
- **RN12 — Compra de insumos:** a compra deve identificar os itens adquiridos e o fornecedor, caso esse controle seja implementado.
- **RN13 — Estoque:** saldo de insumo não pode ficar inconsistente entre entradas e consumo; confirmar com a responsável se o consumo será registrado individualmente.
- **RN14 — Sem venda de produtos:** o salão informou que não comercializa produtos; não modelar vendas de produtos como processo ativo nesta versão.
- **RN15 — LGPD:** coletar apenas os dados pessoais necessários e restringir seu acesso às pessoas autorizadas.
- **RN16 — Normas sanitárias:** o salão utiliza produtos químicos e instrumentos que exigem cuidados de higiene e segurança; os procedimentos concretos devem seguir a orientação sanitária aplicável.
- **RN17 — Nota fiscal:** o registro da entrevista informa que o salão emite nota fiscal; o processo e os campos necessários devem ser detalhados se entrarem no escopo do sistema.
- **RN18 — Atrasos e sinal:** tolerância de atraso, exigência de sinal e pagamento antecipado não foram definidos no material disponível; validar com a responsável antes de criar regras para esses casos.

## 5. Dicionário de dados

O dicionário detalhado está em [dicionario_de_dados.html](dicionario_de_dados.html). Ele descreve atributos, regras, tipos físicos sugeridos, índices, acesso e privacidade. Tipos e índices são propostas para o SGBD que vier a ser escolhido, não uma implementação já existente.

## 6. Modelo conceitual e lógico

### 6.1 Entidades centrais

- **Cliente:** pessoa que agenda e recebe serviços.
- **Profissionais:** pessoas que executam procedimentos.
- **Procedimentos:** serviços oferecidos, com duração estimada.
- **Agendamentos:** evento com data, início, término e situação.
- **Especialidades:** áreas de atuação dos profissionais.
- **Pagamento:** registro do recebimento presencial associado ao atendimento; incluído por ser essencial na avaliação do professor.

As compras, fornecedores e controle de insumos aparecem nos processos e requisitos. A modelagem completa dessas entidades depende da confirmação do fluxo real de compras/estoque com a responsável e deve ser adicionada ao DER se o professor exigir que esses processos também estejam representados como entidades nesta entrega.

### 6.2 Diagramas

- **DER conceitual:** [DER_Conceitual.png](DER_Conceitual.png)
- **DER lógico:** [DER_Lógico.png](DER_L%C3%B3gico.png)
- Os diagramas foram preservados nesta revisão, conforme solicitado. Nenhum arquivo de DER foi editado ou recriado. As alterações desta revisão ficam restritas ao SQL e à documentação textual.

### 6.3 Relacionamentos e cardinalidades

No diagrama conceitual, cada par (mínimo, máximo) é colocado junto à entidade que está sendo contada: o par junto a Cliente indica quantos clientes se relacionam com uma ocorrência de Agendamento; o par junto a Agendamento indica quantos agendamentos se relacionam com uma ocorrência de Cliente.

- **Cliente — Agendamentos:** junto a Cliente, (1,1), pois cada agendamento tem exatamente um cliente; junto a Agendamentos, (0,n), pois um cliente pode ter nenhum ou vários agendamentos.
- **Profissionais — Agendamentos:** junto a Profissionais, (1,1), pois cada agendamento tem exatamente um profissional; junto a Agendamentos, (0,n), pois um profissional pode ter nenhum ou vários agendamentos.
- **Procedimentos — Agendamentos:** junto a Procedimentos, (1,1), pois cada agendamento tem exatamente um procedimento; junto a Agendamentos, (0,n), pois um procedimento pode constar em nenhum ou vários agendamentos.
- **Profissionais — Especialidades:** relacionamento N:N, com (0,n) em ambos os lados, resolvido no modelo lógico por tabela associativa Profissional_Especialidade.
- **Agendamentos — Pagamento:** junto a Agendamentos, (0,1), e junto a Pagamento, (1,1): o desenho assume no máximo um pagamento por agendamento e cada pagamento pertence a exatamente um agendamento. Confirmar se há pagamentos parciais ou múltiplos antes da implementação.

### 6.4 Chaves e integridade

- Todas as entidades possuem identificador primário.
- A tabela Agendamentos contém as FKs id_cliente, id_profissional e id_procedimento.
- Profissional_Especialidade utiliza PK composta por id_profissional e id_especialidade, que também são FKs.
- Pagamento contém id_agendamento como FK; a restrição de unicidade representa a hipótese de no máximo um pagamento por agendamento e precisa ser validada.
- A prevenção de sobreposição de horários requer uma validação transacional, trigger ou mecanismo equivalente no SGBD; um índice comum, sozinho, não garante essa regra.

## 7. Justificativa técnica

Cliente, Profissionais e Procedimentos são entidades separadas porque possuem atributos próprios e podem participar de muitos agendamentos. Agendamentos representa o evento no tempo e permite registrar data, horários e situação, além de aplicar a regra de não sobreposição. Especialidades fica separada para evitar armazenar várias áreas de atuação em um único campo. Pagamento foi incluído porque o recebimento ocorre ao final do atendimento e foi considerado essencial na avaliação do professor.

Compra, fornecedor e estoque são processos reais descritos no trabalho, mas a estrutura detalhada dessas entidades precisa ser confirmada e incluída nos diagramas caso faça parte do escopo obrigatório. O salão não realiza venda de produtos, portanto esse processo não deve ser representado como funcionalidade ativa.

## 8. Uso de inteligência artificial

| Item | Registro |
|---|---|
| **Ferramenta e etapa** | O histórico do projeto registra uso de Claude (Anthropic) no esboço inicial do README. Nesta revisão, foi utilizado ChatGPT (OpenAI) para comparar os arquivos e alinhar o SQL e os dicionários de dados. Os arquivos de DER foram preservados sem alterações. |
| **Motivação** | Organizar o material da entrevista e corrigir as divergências apontadas na avaliação do professor entre processos, requisitos, regras, dicionário e DER. |
| **Prompts utilizados nesta revisão** | “eu n arumei o html faz ele para mim de modo certo”; “agora faz a correção de tudo novamente”. |
| **Resposta recebida** | Revisão do README, ampliação dos processos e requisitos, explicitação das regras confirmadas e pendentes, atualização do SQL e dos dicionários para alinhar os campos, os tipos e as regras documentadas. Os DERs não foram modificados nesta revisão. |
| **Fontes consultadas** | README e dicionário do repositório, DERs existentes e correção do professor na issue #19. Não foram consultadas fontes externas nesta revisão. |
| **Trechos rejeitados ou corrigidos** | Foram corrigidas a classificação de telefone/e-mail como dados sensíveis, a divergência de chave primária em Profissional_Especialidade, a ausência de Pagamento nos diagramas e a leitura das cardinalidades. Regras não confirmadas, como prazo de cancelamento e base de cálculo da comissão, foram mantidas como pendências. |
| **Justificativa da escolha final** | A versão atual prioriza os fatos documentados na entrevista e a correção do professor, separando o que está descrito do que ainda precisa ser validado. |
| **Reflexão crítica** | A IA pode propor estruturas plausíveis que não correspondem ao funcionamento real do salão. Por isso, a divisão 30%/70%, a cardinalidade de Pagamento e o escopo de estoque precisam ser confirmados pela equipe com a responsável antes da entrega final. Os SVGs revisados representam o escopo central; compras, fornecedores e estoque ainda precisam ser incorporados aos diagramas caso a disciplina exija que esses processos estejam modelados como entidades nesta entrega. |

## 9. Pendências antes da entrega

1. Confirmar com Alaide a base exata do cálculo de 30%/70%.
2. Definir o prazo mínimo de antecedência para cancelamento e se há tolerância de atraso ou exigência de sinal.
3. Confirmar se cada agendamento pode ter um ou mais pagamentos.
4. Confirmar se o salão quer controlar estoque por consumo de cada atendimento ou somente registrar compras/reposição.
5. Se compras, fornecedores e estoque forem exigidos no DER desta entrega, acrescentar as entidades correspondentes aos dois diagramas e ao dicionário, mantendo nomes, PKs, FKs e cardinalidades iguais em todos os arquivos.
6. Definir o SGBD antes de fixar tipos físicos, collation e sintaxe de índices.
