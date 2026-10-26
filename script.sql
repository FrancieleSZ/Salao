-- Sistema de Gestão — Salão dos Primos
-- Script didático para MySQL 8.0+. Dados abaixo são fictícios.
-- Revise o modelo com a Entrega 1 antes de entregar.

CREATE DATABASE IF NOT EXISTS salao_dos_primos
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE salao_dos_primos;

CREATE TABLE IF NOT EXISTS cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  telefone VARCHAR(20),
  email VARCHAR(120)
);

CREATE TABLE IF NOT EXISTS profissional (
  id_profissional INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  telefone VARCHAR(20),
  ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS procedimento (
  id_procedimento INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao VARCHAR(255),
  duracao_minutos INT NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  CHECK (duracao_minutos > 0),
  CHECK (valor >= 0)
);

CREATE TABLE IF NOT EXISTS especialidade (
  id_especialidade INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS profissional_especialidade (
  id_profissional INT NOT NULL,
  id_especialidade INT NOT NULL,
  PRIMARY KEY (id_profissional, id_especialidade),
  CONSTRAINT fk_pe_profissional FOREIGN KEY (id_profissional)
    REFERENCES profissional(id_profissional),
  CONSTRAINT fk_pe_especialidade FOREIGN KEY (id_especialidade)
    REFERENCES especialidade(id_especialidade)
);

CREATE TABLE IF NOT EXISTS agendamento (
  id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  id_profissional INT NOT NULL,
  id_procedimento INT NOT NULL,
  data_hora DATETIME NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'agendado',
  observacoes VARCHAR(255),
  CONSTRAINT fk_ag_cliente FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente),
  CONSTRAINT fk_ag_profissional FOREIGN KEY (id_profissional)
    REFERENCES profissional(id_profissional),
  CONSTRAINT fk_ag_procedimento FOREIGN KEY (id_procedimento)
    REFERENCES procedimento(id_procedimento),
  CHECK (status IN ('agendado','confirmado','concluido','cancelado','faltou'))
);

CREATE TABLE IF NOT EXISTS pagamento (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  id_agendamento INT NOT NULL,
  data_pagamento DATETIME,
  valor DECIMAL(10,2) NOT NULL,
  forma_pagamento VARCHAR(30),
  status VARCHAR(20) NOT NULL DEFAULT 'pendente',
  CONSTRAINT fk_pag_agendamento FOREIGN KEY (id_agendamento)
    REFERENCES agendamento(id_agendamento),
  CHECK (valor >= 0),
  CHECK (status IN ('pendente','pago','estornado'))
);

-- DADOS FICTÍCIOS PARA TESTE
INSERT INTO cliente (nome, telefone, email) VALUES
('Ana Lima', '11990000001', 'ana.exemplo@email.com'),
('Bruno Alves', '11990000002', 'bruno.exemplo@email.com'),
('Carla Souza', '11990000003', 'carla.exemplo@email.com');

INSERT INTO profissional (nome, telefone, ativo) VALUES
('Marina Costa', '11991110001', TRUE),
('Paulo Santos', '11991110002', TRUE);

INSERT INTO procedimento (nome, descricao, duracao_minutos, valor) VALUES
('Corte', 'Corte de cabelo — dado fictício', 40, 45.00),
('Escova', 'Escova — dado fictício', 30, 35.00),
('Coloração', 'Coloração — dado fictício', 120, 150.00);

INSERT INTO especialidade (nome) VALUES
('Corte'), ('Escova'), ('Coloração');

INSERT INTO profissional_especialidade (id_profissional, id_especialidade) VALUES
(1,1), (1,2), (2,2), (2,3);

INSERT INTO agendamento
(id_cliente, id_profissional, id_procedimento, data_hora, status, observacoes) VALUES
(1,1,1,'2026-10-28 10:00:00','confirmado','Registro fictício para teste'),
(2,2,2,'2026-10-28 11:00:00','agendado','Registro fictício para teste'),
(3,2,3,'2026-10-29 14:00:00','concluido','Registro fictício para teste');

INSERT INTO pagamento
(id_agendamento, data_pagamento, valor, forma_pagamento, status) VALUES
(1,'2026-10-28 10:45:00',45.00,'pix','pago'),
(2,NULL,35.00,'cartao','pendente'),
(3,'2026-10-29 16:00:00',150.00,'pix','pago');

-- CONSULTAS DE EXEMPLO

-- 1. Agenda com cliente, profissional e procedimento
SELECT a.id_agendamento, a.data_hora, a.status,
       c.nome AS cliente, p.nome AS profissional,
       pr.nome AS procedimento, pr.valor
FROM agendamento a
JOIN cliente c ON c.id_cliente = a.id_cliente
JOIN profissional p ON p.id_profissional = a.id_profissional
JOIN procedimento pr ON pr.id_procedimento = a.id_procedimento
ORDER BY a.data_hora;

-- 2. Histórico de atendimentos de cada cliente
SELECT c.nome AS cliente, a.data_hora, pr.nome AS procedimento, a.status
FROM cliente c
JOIN agendamento a ON a.id_cliente = c.id_cliente
JOIN procedimento pr ON pr.id_procedimento = a.id_procedimento
ORDER BY c.nome, a.data_hora;

-- 3. Total de pagamentos efetivamente pagos
SELECT COALESCE(SUM(valor), 0) AS total_pago
FROM pagamento
WHERE status = 'pago';

-- 4. Quantidade de agendamentos por status
SELECT status, COUNT(*) AS quantidade
FROM agendamento
GROUP BY status;

-- 5. Procedimentos mais agendados
SELECT pr.nome, COUNT(*) AS quantidade_agendamentos
FROM procedimento pr
LEFT JOIN agendamento a ON a.id_procedimento = pr.id_procedimento
GROUP BY pr.id_procedimento, pr.nome
ORDER BY quantidade_agendamentos DESC;

-- 6. Profissionais e especialidades
SELECT p.nome AS profissional, e.nome AS especialidade
FROM profissional p
JOIN profissional_especialidade pe ON pe.id_profissional = p.id_profissional
JOIN especialidade e ON e.id_especialidade = pe.id_especialidade
ORDER BY p.nome, e.nome;

-- EXEMPLOS DE ALTERAÇÃO (execute separadamente em ambiente de teste)
-- UPDATE agendamento SET status = 'cancelado' WHERE id_agendamento = 2;
-- DELETE FROM profissional_especialidade
-- WHERE id_profissional = 2 AND id_especialidade = 3;

-- VERIFICAÇÕES DE INTEGRIDADE
-- Agendamentos sem cliente correspondente (esperado: zero linhas)
SELECT a.* FROM agendamento a
LEFT JOIN cliente c ON c.id_cliente = a.id_cliente
WHERE c.id_cliente IS NULL;

-- Pagamentos sem agendamento correspondente (esperado: zero linhas)
SELECT pg.* FROM pagamento pg
LEFT JOIN agendamento a ON a.id_agendamento = pg.id_agendamento
WHERE a.id_agendamento IS NULL;
