# Entrega 1 — Modelo Conceitual (DER)
### Modelagem de um sistema de gestão de informações para uma organização de pequeno porte

---

## Metadados

- **Nomes dos alunos e RGM**
  - Franciele Souza — RGM: 47643323
  - Julia Parra — RGM: 47566604
  - Emilly Rodrigues De Souza — RGM:47508248
  - Kamilly Vitória — RGM: 46919431 

---

## 1. Caracterização da Organização

- **Nome e natureza:** Salão dos Primos — salão de beleza feminino e masculino, organização **com fins lucrativos**.
- **Porte e contexto:** operação de pequeno porte, com **4 profissionais** e um público de **30 a 50 clientes**. A atividade gira em torno de agendamentos e da execução de procedimentos (corte, coloração, progressiva, entre outros).
- **Como as informações foram obtidas:** o grupo realizou **entrevista de campo e observação no local** com a responsável, Alaide, dentro do salão. As respostas da entrevista embasam a caracterização, os processos, as regras e a modelagem deste documento. Fotos da visita estão no repositório (abaixo).
- **Problemas identificados:**
  1. **Agenda em caderno de papel:** não há visibilidade da disponibilidade; o cliente precisa ir ao salão para saber se há horário e pode descobrir que não há vaga só ao chegar.
  2. **WhatsApp sobrecarregado:** é usado para marcar horários e tirar dúvidas durante o expediente. Com o salão cheio, as mensagens ficam de lado, as respostas atrasam e o profissional perde o foco no atendimento.
- **Justificativa da escolha:** organização real, de porte adequado ao escopo da disciplina, com processos, entidades e regras suficientes para justificar um modelo de dados, e com acesso direto do grupo para entrevista e observação.
- **Evidências da organização:**
  - Endereço: R. Bernardino Vergueiro, 276 — Jardim Jaú (Zona Leste), São Paulo - SP, 03710-060
  - Instagram: <https://www.instagram.com/salaodosprimoss/>
  - Google Meu Negócio: <https://www.google.com/searchviewer/10?svid=CAwSHRIbCgNwdnESFENnMHZaeTh4TVdZeWQyYzNkR3R4GAo>
  - Telefone: (11) 94400-0738
  - Responsável: Alaide
  - Fotos da visita de campo:
  - ![Foto da visita](.github/workflows/Imagem1.jpeg)
  - ![Foto da visita](.github/workflows/Imagem2.jpeg)

---

## 2. Processos de Negócio

- **Principais processos mapeados:**
  1. **Marcação de horário** — registro do agendamento do cliente (feito hoje em caderno).
  2. **Atendimento / execução do procedimento** — realização do serviço de beleza contratado (corte, coloração, progressiva etc.), cada um com duração própria.
  3. **Contato com clientes** — comunicação feita de forma presencial e por WhatsApp, para marcar, confirmar ou tirar dúvidas sobre horários.
  4. **Organização da agenda** — manutenção do caderno com nomes e horários dos clientes, garantindo que não haja conflitos.
- **Fluxo de cada processo e integração entre eles:**
  - A **marcação de horário** depende diretamente da **organização da agenda**: para marcar um novo horário, é preciso primeiro consultar o caderno e verificar se há tempo disponível compatível com a duração do procedimento desejado.
  - O **contato com o cliente** (via WhatsApp) alimenta tanto a marcação de horário quanto eventuais dúvidas durante o atendimento — mas, como ocorre durante o expediente, compete pela atenção do profissional com o **atendimento em andamento**, podendo estender o tempo do procedimento.
  - O **atendimento/execução do procedimento** consome o tempo reservado na agenda; procedimentos mais longos (ex.: coloração para loiro, que leva o dobro do tempo por causa da cor natural do cabelo) precisam ser considerados já na hora de marcar o horário, para não invadir o horário do próximo cliente.
- **Fluxogramas (opcional):** *(Anexar como imagem no repositório — ex.: um fluxograma para "Marcar horário" e outro para "Atendimento", mostrando as decisões: "há tempo disponível?", "procedimento é padrão ou requer tempo extra?", etc.)*
- O problema central relatado na entrevista é o **controle de horários**. Por isso, o núcleo do modelo é a agenda (cliente, profissional, procedimento, agendamento). Três assuntos foram mapeados nos processos (Seção 3), mas **não viraram entidades** nesta entrega, e a decisão é intencional:
 
| Assunto                | Decisão nesta entrega                    | Justificativa (vinda da observação no salão)                                                                                                                                                                                                                                  |
| ---------------------- | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Pagamento              | Fora do banco; recebido presencialmente  | O valor não é tabelado: depende do tamanho e das características do cabelo (ex.: uma progressiva em cabelo curto não custa o mesmo que em cabelo longo) e é definido no atendimento. O pagamento é feito no próprio salão, sem cobrança antecipada. **[CONFIRMAR com Alaide]** |
| Material/insumos       | Fora do banco; sem controle de estoque   | O material é escolhido pelo profissional e é pré-requisito para qualquer atendimento; hoje não há controle de estoque a ser substituído. **[CONFIRMAR com Alaide]**                                                                                                            |
| Comissão e caixa       | Fora do banco                            | Dependem do pagamento, que está fora do escopo. **[CONFIRMAR com Alaide]**                                                                                                                                                                                                    |
 
**Extensão prevista:** o modelo foi pensado para crescer. `Pagamento`, `Produto/Insumo` e `Fornecedor` poderiam se ligar a `Agendamento` sem alterar a estrutura atual.
 
> **[DECISÃO DO GRUPO]** Para registrar o valor realmente cobrado sem criar uma entidade nova, o grupo pode incluir `valor_cobrado` (opcional) em `Agendamento`, mantendo `preco` em `Procedimento` como valor de referência. Se adotado, atualizar dicionário e DER.
 

---
### 2.1 Processos centrais (modelados)
 
| # | Processo | Descrição |
|---|----------|-----------|
| P1 | **Marcação de horário** | Registro do agendamento do cliente (hoje em caderno). Exige consultar a agenda e verificar tempo livre compatível com a duração do procedimento. |
| P2 | **Organização da agenda** | Manutenção dos horários por profissional, evitando conflitos. |
| P3 | **Contato e confirmação com o cliente** | Feito presencialmente e por WhatsApp, para marcar, confirmar ou tirar dúvidas. |
| P4 | **Atendimento / execução do procedimento** | Realização do serviço contratado; cada procedimento tem duração própria (ex.: coloração para loiro leva o dobro do tempo). |
 
### 2.2 Processos complementares (mapeados)
 
| # | Processo | Descrição | Relação com o modelo |
|---|----------|-----------|----------------------|
| P5 | **Cancelamento e remarcação** | O cliente avisa que não virá ou pede outro horário; o horário liberado volta a ficar disponível. **[CONFIRMAR prazo e como é feito hoje]** | Modelado: `status` do Agendamento (RF06, RF07). |
| P6 | **Cadastro de clientes** | Coleta de nome e contato na primeira visita ou no primeiro agendamento. | Modelado: entidade Cliente (RF01). |
| P7 | **Recebimento do pagamento** | Feito presencialmente, ao final do atendimento, com valor definido conforme o cabelo. **[CONFIRMAR formas de pagamento]** | Fora do escopo (Seção 2). |
| P8 | **Venda de produtos no salão** | **[CONFIRMAR se o salão vende produtos; há produtos expostos nas fotos da visita]** | Fora do escopo (Seção 2). |
| P9 | **Comissão dos profissionais** | **[CONFIRMAR se existe e como é calculada]** | Fora do escopo (Seção 2). |
| P10 | **Fechamento de caixa** | **[CONFIRMAR como é feito]** | Fora do escopo (Seção 2). |
| P11 | **Compra de produtos e insumos** | O material é escolhido pelos profissionais. **[CONFIRMAR quem compra e de onde]** | Fora do escopo (Seção 2). |
| P12 | **Cadastro de fornecedores** | **[CONFIRMAR]** | Fora do escopo (Seção 2). |
| P13 | **Controle de estoque de insumos** | Não há controle formal hoje. **[CONFIRMAR]** | Fora do escopo (Seção 2). |

## 3. Requisitos do Sistema

### 3.1 Requisitos Funcionais

- RNF01. Cadastrar **clientes**, com dados básicos de contato.
- RNF02. Cadastrar **procedimentos** oferecidos pelo salão, incluindo a duração estimada e o preço de referência.
- RNF03. Cadastrar **profissionais**, suas **especialidades** e se estão ativos.
- RNF04. **Registrar um agendamento** (cliente, profissional, procedimento, data e hora de início), calculando automaticamente a hora de término pela duração do procedimento.
- RNF05. **Impedir conflitos de agenda:** recusar agendamento cujo intervalo se sobreponha a outro do mesmo profissional ou envolva profissional inativo.
- RNF06. **Cancelar** um agendamento existente, liberando o horário.
- RNF07. **Remarcar** um agendamento existente, validando o novo horário como no RF05.
- RNF08. **Consultar a agenda** por dia e por profissional, para saber quais horários estão livres — substituindo a ida do cliente ao salão.
- RNF09. **Registrar a conclusão** do atendimento (atualizar o status do agendamento).
- RNF10. Consultar o **histórico de atendimentos** de um cliente. 
  

### 3.2 Requisitos Não Funcionais

- RNF01. Usabilidade | Interface simples; os usuários não têm familiaridade avançada com tecnologia, e registrar deve ser tão rápido quanto anotar no caderno.
- RNF02. Desempenho | A consulta de horários livres deve responder rapidamente nos horários de pico.
- RNF03. Segurança/privacidade | Dados pessoais dos clientes (telefone e e-mail) devem ser protegidos e não expostos publicamente (ver Seção 5.4 e LGPD).
- RNF04. Disponibilidade | Acessível durante o horário de funcionamento e, idealmente, fora dele, para consulta remota de horários.
- RNF05. Confiabilidade | Evitar conflitos de agenda (dois clientes no mesmo horário/profissional), principal fonte de problema do caderno.

---

## 4. Regras de Negócio

### 4.1 Regras operacionais
 
| Código | Regra |
|--------|-------|
| RN01 | Nenhum profissional pode ter dois agendamentos com horários sobrepostos. |
| RN02 | O tempo reservado no agendamento é a **duração do procedimento** (ex.: coloração para loiro = tempo padrão × 2, pela cor natural do cabelo). |
| RN03 | Um horário reservado não pode ser tomado por outro cliente, mesmo que o procedimento de outro seja mais longo. |
| RN04 | Profissional **inativo** não recebe novos agendamentos. |
| RN05 | Cancelamento com antecedência mínima de **[CONFIRMAR: X horas]**, para o horário poder ser reaproveitado. |
| RN06 | Tolerância de atraso do cliente de **[CONFIRMAR: X minutos]**; passado o prazo, o agendamento pode ser cancelado ou ajustado. |
| RN07 | O valor final cobrado depende das características do cabelo e é definido no atendimento; o pagamento é feito presencialmente. **[CONFIRMAR]** |
| RN08 | Formas de pagamento aceitas: **[CONFIRMAR: dinheiro, Pix, cartão…]**. |
| RN09 | Sinal ou pagamento antecipado: **[CONFIRMAR: não é exigido?]**. |
| RN10 | Comissão do profissional: **[CONFIRMAR se existe e qual o percentual]**. |
 
### 4.2 Restrições organizacionais e legais
 
| Código | Restrição |
|--------|-----------|
| RS01 | **LGPD (Lei 13.709/2018):** telefone e e-mail do cliente são dados pessoais; devem ser coletados só para fins de agendamento e contato, com acesso restrito e possibilidade de correção e exclusão a pedido do titular. |
| RS02 | **Normas sanitárias (vigilância sanitária):** esterilização de instrumentos e manuseio de produtos químicos. Não geram dados no modelo atual, mas condicionam o tempo de preparo entre atendimentos. **[CONFIRMAR]** |
| RS03 | **Nota fiscal:** **[CONFIRMAR se o salão emite e em que situações]**. Fora do escopo do modelo atual. |
 
### 4.3 Motivo das regras principais
 
As regras RN01 a RN04 existem para que **todos os clientes mantenham o horário reservado**, sem serem "atropelados" por atendimentos longos anteriores. O descumprimento gera atrasos em cascata na agenda do dia e insatisfação dos clientes.
 
### 4.4 Cobertura das regras no modelo
 
| Regra | Onde aparece no modelo |
|-------|------------------------|
| RN01 | Agendamento: `hora_inicio`, `hora_fim`, `id_profissional` (verificação de intervalo) |
| RN02 | Procedimento: `duracao_minutos`; Agendamento: `hora_fim` calculada |
| RN03 | Mesma verificação da RN01 |
| RN04 | Profissional: `ativo` |
| RN05–RN06 | Agendamento: `status`, `observacoes` |
| RS01 | Seção 6.5 (acesso e LGPD) |
 
---

## 5. Dicionário de Dados Conceitual (Preliminar)

**Os exemplos de valores são fictícios**, apenas para ilustrar o tipo de informação — não representam clientes ou dados reais do salão.

[Ver Site do Dicionário de dados](https://dicionariodedados.vercel.app/)

###

[Ver HTML do Dicionário de dados](dicionario_de_dados.html)


### 5.1 Entidades e atributos
 
Resumo (detalhe em `dicionario_de_dados.html`):
 
| Entidade | Atributos |
|----------|-----------|
| Cliente | **id_cliente** (PK), nome, telefone, telefone_2, email, email_2, data_cadastro |
| Profissional | **id_profissional** (PK), nome, telefone, ativo, data_cadastro |
| Especialidade | **id_especialidade** (PK), nome, descricao |
| Profissional_Especialidade | **id_profissional_especialidade** (PK), id_profissional (FK), id_especialidade (FK) |
| Procedimento | **id_procedimento** (PK), nome, duracao_minutos, preco, descricao |
| Agendamento | **id_agendamento** (PK), data_agendamento, hora_inicio, hora_fim, status, observacoes, data_criacao, id_cliente (FK), id_profissional (FK), id_procedimento (FK) |
 
### 5.2 Fluxo de dados
 
1. O cliente pede um horário (presencial ou WhatsApp) → o atendente consulta **Agenda** (leitura de `Agendamento` por profissional/dia) e `Procedimento.duracao_minutos`.
2. Havendo tempo livre, grava-se um novo **Agendamento** com `id_cliente`, `id_profissional`, `id_procedimento`, data, `hora_inicio` e `hora_fim` calculada; `status = marcado`.
3. Se o cliente é novo, grava-se antes o **Cliente** (nome e contato).
4. A confirmação com o cliente usa `Cliente.telefone`.
5. No dia, o atendimento é realizado e `status` passa para `concluído`; em caso de falta ou aviso, `status = cancelado` e o horário volta a ficar livre.
7. O histórico do cliente é a leitura de seus `Agendamento` com `status = concluído`.

### 5.3 Convenções
 
| Item | Convenção |
|------|-----------|
| SGBD alvo | **[CONFIRMAR: ex. MySQL 8 ou PostgreSQL]** |
| Collation / charset | UTF-8 (ex.: `utf8mb4_0900_ai_ci` no MySQL) **[ajustar ao SGBD escolhido]** |
| Notação do DER | Cardinalidades no formato (mínimo, máximo), lidas a partir de cada entidade |
| Nomes | minúsculas, sem acento, palavras separadas por `_` |
| Prefixos/sufixos | `id_` para chaves; `data_` para datas; `hora_` para horários; `_2` para segundo contato |
| Chaves | PK = `id_<entidade>`; FK mantém o nome da PK de origem |
| Versão | v2 — **[inserir data da revisão]** (v1: primeiro esboço da Entrega 1) |
 
### 5.4 Por entidade: expressão formal, leitura, tipos físicos e índices
 
**Cliente**
- Expressão formal: `CLIENTE (id_cliente, nome, telefone, telefone_2, email, email_2, data_cadastro)`
- Leitura: um cliente realiza de zero a vários agendamentos (0,n); cada agendamento é realizado por exatamente um cliente (1,1).
| Atributo | Tipo físico | Restrições |
|----------|-------------|------------|
| id_cliente | INT | PK, auto incremento |
| nome | VARCHAR(100) | NOT NULL |
| telefone | VARCHAR(15) | NOT NULL |
| telefone_2 | VARCHAR(15) | NULL |
| email | VARCHAR(100) | NULL |
| email_2 | VARCHAR(100) | NULL |
| data_cadastro | DATE | DEFAULT data atual |
 
Índices: PK em `id_cliente`; índice em `nome` (busca) e em `telefone`.
 
**Profissional**
- Expressão formal: `PROFISSIONAL (id_profissional, nome, telefone, ativo, data_cadastro)`
- Leitura: um profissional atende de zero a vários agendamentos (0,n); cada agendamento é atendido por exatamente um profissional (1,1). Um profissional possui de zero a várias especialidades (0,n).
| Atributo | Tipo físico | Restrições |
|----------|-------------|------------|
| id_profissional | INT | PK, auto incremento |
| nome | VARCHAR(100) | NOT NULL |
| telefone | VARCHAR(15) | NULL |
| ativo | BOOLEAN | NOT NULL, DEFAULT verdadeiro |
| data_cadastro | DATE | DEFAULT data atual |
 
Índices: PK; índice em `ativo`.
 
**Especialidade**
- Expressão formal: `ESPECIALIDADE (id_especialidade, nome, descricao)`
- Leitura: uma especialidade pode ser possuída por zero ou vários profissionais (0,n).
| Atributo | Tipo físico | Restrições |
|----------|-------------|------------|
| id_especialidade | INT | PK, auto incremento |
| nome | VARCHAR(60) | NOT NULL, UNIQUE |
| descricao | VARCHAR(255) | NULL |
 
Índices: PK; índice único em `nome`.
 
**Profissional_Especialidade**
- Expressão formal: `PROFISSIONAL_ESPECIALIDADE (id_profissional_especialidade, #id_profissional, #id_especialidade)`
- Leitura: resolve o N:N entre Profissional e Especialidade; cada vínculo liga exatamente um profissional a exatamente uma especialidade.
| Atributo | Tipo físico | Restrições |
|----------|-------------|------------|
| id_profissional_especialidade | INT | PK, auto incremento |
| id_profissional | INT | FK → Profissional, NOT NULL |
| id_especialidade | INT | FK → Especialidade, NOT NULL |
 
Índices: PK; índice único composto (`id_profissional`, `id_especialidade`).
 
**Procedimento**
- Expressão formal: `PROCEDIMENTO (id_procedimento, nome, duracao_minutos, preco, descricao)`
- Leitura: um procedimento pode constar em zero ou vários agendamentos (0,n); cada agendamento tem exatamente um procedimento (1,1).
| Atributo | Tipo físico | Restrições |
|----------|-------------|------------|
| id_procedimento | INT | PK, auto incremento |
| nome | VARCHAR(80) | NOT NULL |
| duracao_minutos | INT | NOT NULL, CHECK > 0 |
| preco | DECIMAL(8,2) | NULL (valor de referência) |
| descricao | VARCHAR(255) | NULL |
 
Índices: PK; índice em `nome`.
 
**Agendamento**
- Expressão formal: `AGENDAMENTO (id_agendamento, data_agendamento, hora_inicio, hora_fim, status, observacoes, data_criacao, #id_cliente, #id_profissional, #id_procedimento)`
- Leitura: cada agendamento é realizado por exatamente um cliente, atendido por exatamente um profissional e refere-se a exatamente um procedimento.
| Atributo | Tipo físico | Restrições |
|----------|-------------|------------|
| id_agendamento | INT | PK, auto incremento |
| data_agendamento | DATE | NOT NULL |
| hora_inicio | TIME | NOT NULL |
| hora_fim | TIME | NOT NULL, calculado (hora_inicio + duração) |
| status | VARCHAR(15) | NOT NULL, valores: marcado, concluído, cancelado |
| observacoes | VARCHAR(255) | NULL |
| data_criacao | DATETIME | DEFAULT data/hora atual |
| id_cliente | INT | FK → Cliente, NOT NULL |
| id_profissional | INT | FK → Profissional, NOT NULL (deve estar ativo) |
| id_procedimento | INT | FK → Procedimento, NOT NULL |
 
Índices: PK; índice composto (`id_profissional`, `data_agendamento`, `hora_inicio`) para a verificação de conflito e a consulta de agenda; índice em `id_cliente` para o histórico.
 
### 5.5 Log de acesso e acesso por operação (LGPD)
 
**Log de acesso** (requisito de rastreabilidade para dados pessoais). Cada acesso a dados de cliente registra:
 
| Campo | Descrição |
|-------|-----------|
| usuario | Quem acessou **[CONFIRMAR como os usuários serão identificados]** |
| data_hora | Quando |
| operacao | Criar, consultar, alterar ou excluir |
| entidade | Tabela acessada |
| id_registro | Registro afetado |
 
> Se o grupo quiser que o log apareça no DER, será preciso incluí-lo como entidade (e uma entidade Usuário).
 
**Acesso por operação** (C = criar, L = ler, A = alterar, E = excluir). Perfis **[CONFIRMAR]**:
 
| Entidade | Responsável (Alaide) | Profissional |
|----------|----------------------|--------------|
| Cliente | C L A E | C L |
| Profissional | C L A E | L |
| Especialidade | C L A E | L |
| Profissional_Especialidade | C L A E | L |
| Procedimento | C L A E | L |
| Agendamento | C L A E | C L A (os próprios) |
 
**LGPD:** telefone e e-mail são **dados pessoais**; ficam visíveis apenas aos perfis acima, são usados só para agendamento e contato, e o cliente pode pedir correção ou exclusão (exclusão do cadastro preserva o histórico apenas de forma anonimizada **[CONFIRMAR abordagem]**).
 
---
## 6. Modelagem Conceitual (Entidades, Atributos, Relacionamentos)
 
- **Entidades:**
  - **Cliente:** pessoa que agenda e recebe o serviço.
  - **Profissional:** quem executa o procedimento; necessário para a agenda individual e para evitar conflitos.
  - **Procedimento:** serviço oferecido; sua duração determina as regras de agendamento relatadas na entrevista.
  - **Agendamento:** evento no tempo que conecta Cliente, Profissional e Procedimento; núcleo do problema (controle de horários hoje feito em papel).
  - **Especialidade:** áreas de atuação dos profissionais, para orientar a escolha do cliente.
- **Atributos:** ver Seção 6.
- **Relacionamentos** (cardinalidades (mín,máx), lidas a partir de cada entidade):
| Relacionamento | Lado A | Lado B | Tipo |
|----------------|--------|--------|------|
| Cliente **realiza** Agendamento | Cliente (0,n) | Agendamento (1,1) | 1:N |
| Profissional **atende** Agendamento | Profissional (0,n) | Agendamento (1,1) | 1:N |
| Procedimento **tem** Agendamento | Procedimento (0,n) | Agendamento (1,1) | 1:N |
| Profissional **possui** Especialidade | Profissional (0,n) | Especialidade (0,n) | N:N (resolvido por Profissional_Especialidade) |
 
- **Restrições aplicadas ao modelo:**
  - O intervalo `hora_inicio` a `hora_fim` de um agendamento não pode colidir com outro do mesmo profissional.
  - A duração do Procedimento define o tamanho do bloco de tempo reservado.
---
 
## 7. Diagrama Entidade-Relacionamento (DER)

- **Entidades:**
  - **Cliente:** pessoa que agenda e recebe o serviço.
  - **Profissional:** quem executa o procedimento; necessário para a agenda individual e para evitar conflitos.
  - **Procedimento:** serviço oferecido; sua duração determina as regras de agendamento relatadas na entrevista.
  - **Agendamento:** evento no tempo que conecta Cliente, Profissional e Procedimento; núcleo do problema (controle de horários hoje feito em papel).
  - **Especialidade:** áreas de atuação dos profissionais, para orientar a escolha do cliente.
- **Atributos:** ver Seção 6.
- **Relacionamentos** (cardinalidades (mín,máx), lidas a partir de cada entidade):
| Relacionamento | Lado A | Lado B | Tipo |
|----------------|--------|--------|------|
| Cliente **realiza** Agendamento | Cliente (0,n) | Agendamento (1,1) | 1:N |
| Profissional **atende** Agendamento | Profissional (0,n) | Agendamento (1,1) | 1:N |
| Procedimento **tem** Agendamento | Procedimento (0,n) | Agendamento (1,1) | 1:N |
| Profissional **possui** Especialidade | Profissional (0,n) | Especialidade (0,n) | N:N (resolvido por Profissional_Especialidade) |
 
- **Restrições aplicadas ao modelo:**
  - O intervalo `hora_inicio` a `hora_fim` de um agendamento não pode colidir com outro do mesmo profissional.
  - A duração do Procedimento define o tamanho do bloco de tempo reservado.
---

**DER Conceitual** (`DER Conceitual.png`):

[Ver DER Conceitual](DER_Conceitual.png)

**DER Lógico** (`DER Lógico.png`):

[Ver DER Lógico](DER_Lógico.png)

- O diagrama conceitual representa as 5 entidades (Cliente, Profissional, Procedimento, Agendamento, Especialidade), seus atributos e as cardinalidades de cada relacionamento (Seção 6).
- O diagrama lógico deriva do conceitual: cada relacionamento 1:N vira uma chave estrangeira na tabela do lado "N" (todas em Agendamento) e o relacionamento N:N entre Profissional e Especialidade vira a tabela associativa Profissional_Especialidade.
- O modelo foi pensado para ser **escalável**: novas entidades (ex.: Pagamento, Produto/Estoque, Avaliação do atendimento) podem se conectar ao Agendamento ou ao Cliente sem quebrar a estrutura atual.

---

## 8. Justificativa Técnica

O modelo **separa Cliente, Profissional e Procedimento como entidades independentes**, em vez de misturar esses dados no Agendamento, porque cada um tem ciclo de vida e atributos próprios, reutilizados em muitos agendamentos (um cliente volta várias vezes; um procedimento é feito por vários clientes). Isso evita repetição de dados e permite consultas como "histórico de um cliente" ou "agenda de um profissional".
 
**Agendamento** é uma entidade, e não um atributo de Cliente ou Profissional, porque representa um **evento no tempo** com atributos próprios (data, hora de início, hora de fim, status) e é onde se aplicam as regras mais críticas, como o conflito de horários relatado na entrevista. As cardinalidades 1:N foram escolhidas porque, pela observação de campo, cada agendamento envolve exatamente um cliente, um profissional e um procedimento, sem atendimentos simultâneos de vários clientes pelo mesmo profissional. Por isso, do lado do Agendamento a cardinalidade é (1,1) e, do lado das demais entidades, (0,n): um cliente novo, um profissional recém-contratado ou um procedimento ainda não realizado podem existir sem agendamentos.
 
**Especialidade** é entidade própria, e não um campo de texto em Profissional, para padronizar os nomes e permitir filtrar profissionais por especialidade no futuro. O relacionamento é **N:N** porque um profissional pode dominar várias especialidades e uma especialidade é compartilhada por vários profissionais; no modelo lógico, a tabela associativa Profissional_Especialidade evita atributos multivalorados.
 
**Duração no Procedimento, e não no Agendamento:** o grupo considerou guardar a duração no agendamento, mas manteve-a no Procedimento porque é característica do serviço (coloração para loiro sempre leva o dobro do tempo) e não varia de agendamento para agendamento. Isso concentra a regra central em um só lugar.
 
**Pagamento e insumos fora do modelo:** o valor cobrado depende das características do cabelo e é acertado presencialmente, e o material é escolhido pelos profissionais, sem controle de estoque hoje. Como o problema relatado é a agenda, o grupo priorizou o núcleo do agendamento e deixou esses assuntos como extensão (Seção 2).
 
---

## 9. Uso de Inteligência Artificial

| Item | O que registrar |
|------|------------------|
| **Ferramenta e etapa** | Claude (Anthropic) foi usado para criar o esboço inicial do README. |
| **Motivação** | O grupo já havia realizado a entrevista de campo e tinha as respostas em um PDF/roteiro; recorreu-se à IA para organizar essas respostas dentro da estrutura obrigatória do esboço do README. Depois, para conferir se o README e os DERs estavam coerentes entre si. |
| **Prompt(s) utilizados** | (1) "[Upload do roteiro de entrevista + template do trabalho] responda essas perguntas de acordo com esse pdf e me entregue o readme igual as instruções".|
| **Resposta recebida** | A IA gerou uma versão incompleta do README seguindo as seções do modelo, preenchendo com as respostas literais da entrevista onde havia dado e propondo conteúdo (requisitos, entidades, atributos, relacionamentos, justificativa) onde a entrevista não continha resposta explícita. Na versão mais recente, a IA alinhou o README aos DERs enviados, corrigiu inconsistências (cardinalidades, relacionamento Profissional–Especialidade, atributos do dicionário). |
| **Fontes consultadas e verificadas** | Claude e PDFs fornecidos pelo professor. |
| **Trechos rejeitados ou corrigidos** | Foram arrumadas as entidades, dicionário de dados, requisitos funcionais e não funcionais, link das imagens no READMI e informações da instituição.  |
| **Justificativa da escolha final** | Eram respostas erradas e génericas, fora do padrão de READMI desejado, erros simples mas que confundiriam. |
| **Reflexão crítica** | A IA teve alucinações bem grandes durante o esboço inicial, errou diversas coisas que foram arrumadas manualmente, todas as seções tiveram alteração por mãos humanas. |
