# Roteiro de apresentação corporativa — 8 minutos

> Use slides limpos, pouco texto e demonstrações reais. Não leia parágrafos. O roteiro não substitui a execução do SQL em MySQL.

## 1. Contexto e problema — 0:00 a 0:55
- Apresentar o Salão dos Primos, organização real estudada.
- Explicar os problemas registrados: agenda em caderno e mensagens de WhatsApp sobre horários durante atendimentos.
- Informar o porte registrado no projeto: quatro profissionais e aproximadamente 30–50 clientes.
- Mostrar uma evidência autorizada, se o grupo confirmar que pode usá-la.

## 2. Solução proposta — 0:55 a 1:45
- Apresentar o banco para organizar clientes, profissionais, procedimentos e agendamentos.
- Explicar as regras de conflito, cancelamento e profissional ativo.
- Mostrar que o escopo SQL também inclui pagamento, fechamento de caixa e controle de insumos.
- Reforçar que o salão não vende produtos; estoque significa insumos de uso interno.

## 3. Modelo lógico — 1:45 a 3:05
- Mostrar o arquivo DER lógico existente e explicar PKs, FKs e tabela associativa Profissional_Especialidade.
- Explicar normalização: separar dados de clientes, profissionais, serviços, fornecedores e itens de compra.
- **Transparência:** os diagramas foram preservados sem edição, então podem não representar todas as tabelas atuais do SQL. Não afirmar que a divergência foi corrigida.

## 4. Demonstração da implementação SQL — 3:05 a 4:35
- Executar o script em um banco MySQL de teste limpo.
- Mostrar as tabelas criadas, chaves, CHECKs, triggers e procedure fechar_caixa.
- Explicar que a massa é fictícia e serve para demonstrar cenários, não representa transações reais.
- Não declarar que o script foi testado antes de realizar a execução.

## 5. Consultas gerenciais e auditoria — 4:35 a 6:10
- Demonstrar G02: agenda por data e profissional.
- Demonstrar G01 ou G07: pagamentos por período e divisão estimada de 30%/70%.
- Demonstrar G03: insumos no nível mínimo ou abaixo.
- Demonstrar A01: busca por sobreposição; A03: atendimentos concluídos sem pagamento.
- Explicar que as consultas de auditoria devem retornar zero linhas para os casos que não apresentam inconsistência.

## 6. Potencial de BI e IA — 6:10 a 7:10
- Mostrar KPIs: recebimentos por forma, cancelamentos/faltas, demanda por procedimento, reposição de insumos e compras por fornecedor.
- Citar como possibilidades futuras previsão de demanda e apoio à reposição.
- Deixar claro que não existe modelo preditivo de IA implementado neste SQL.

## 7. Benefícios e encerramento — 7:10 a 8:00
- Retomar organização da agenda, visibilidade de recebimentos e rastreabilidade de insumos.
- Informar limitações: emissão fiscal fora do escopo, consumo precisa ser lançado e os DERs continuam preservados sem revisão visual.
- Agradecer e preparar-se para a defesa individual do modelo lógico.

## Checklist antes de apresentar

- [ ] Executar script.sql em MySQL 8.0.16+ em banco de teste vazio.
- [ ] Confirmar que o script termina sem erros e que a chamada fechar_caixa é executada apenas uma vez para o período de exemplo.
- [ ] Conferir os resultados das consultas G01–G08 e A01–A07.
- [ ] Preparar explicação para as divergências entre os DERs preservados e as tabelas SQL.
- [ ] Confirmar data/participantes da entrevista e contas GitHub dos integrantes a partir dos registros reais.
- [ ] Não mostrar dados reais de clientes; usar somente a massa fictícia.
