-- Sistema de Gestão — Salão dos Primos
-- Script didático para MySQL 8.0+. Os registros de exemplo são fictícios.
-- Entidades centrais documentadas no modelo; os DERs não foram alterados.

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
  nome VARCHAR(120) NOT NULL,
  descricao VARCHAR(500),
  duracao_minutos INT NOT NULL,
  preco DECIMAL(10,2),
  CHECK (duracao_minutos > 0),
  CHECK (preco IS NULL OR preco >= 0)
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
  data_agendamento DATE NOT NULL,
  hora_inicio TIME NOT NULL,
  hora_fim TIME NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'marcado',
  observacoes TEXT,
  data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ag_cliente FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente),
  CONSTRAINT fk_ag_profissional FOREIGN KEY (id_profissional)
    REFERENCES profissional(id_profissional),
  CONSTRAINT fk_ag_procedimento FOREIGN KEY (id_procedimento)
    REFERENCES procedimento(id_procedimento),
  CONSTRAINT chk_ag_horario CHECK (hora_fim > hora_inicio),
  CONSTRAINT chk_ag_status CHECK (status IN ('marcado','concluido','cancelado'))
);

CREATE INDEX idx_ag_agenda
  ON agendamento (data_agendamento, id_profissional, hora_inicio);

CREATE TABLE IF NOT EXISTS pagamento (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  id_agendamento INT NOT NULL UNIQUE,
  data_pagamento DATETIME NOT NULL,
  valor_pago DECIMAL(10,2) NOT NULL,
  forma_pagamento VARCHAR(20) NOT NULL,
  observacoes TEXT,
  CONSTRAINT fk_pag_agendamento FOREIGN KEY (id_agendamento)
    REFERENCES agendamento(id_agendamento),
  CONSTRAINT chk_pag_valor CHECK (valor_pago > 0),
  CONSTRAINT chk_pag_forma CHECK (forma_pagamento IN ('debito','credito','pix','dinheiro'))
);

-- Impede agendamento com profissional inativo ou conflito de horários.
-- A aplicação deve calcular hora_fim a partir da duração do procedimento.
DROP TRIGGER IF EXISTS trg_agendamento_bi;
DROP TRIGGER IF EXISTS trg_agendamento_bu;
DELIMITER //
CREATE TRIGGER trg_agendamento_bi
BEFORE INSERT ON agendamento
FOR EACH ROW
BEGIN
  DECLARE v_ativo BOOLEAN DEFAULT NULL;
  DECLARE v_conflitos INT DEFAULT 0;

  SELECT ativo INTO v_ativo
  FROM profissional
  WHERE id_profissional = NEW.id_profissional;

  IF v_ativo IS NULL OR v_ativo = FALSE THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Não é permitido agendar com profissional inativo ou inexistente.';
  END IF;

  IF NEW.status <> 'cancelado' THEN
    SELECT COUNT(*) INTO v_conflitos
    FROM agendamento a
    WHERE a.id_profissional = NEW.id_profissional
      AND a.data_agendamento = NEW.data_agendamento
      AND a.status <> 'cancelado'
      AND NEW.hora_inicio < a.hora_fim
      AND NEW.hora_fim > a.hora_inicio;

    IF v_conflitos > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Conflito: o profissional já possui agendamento nesse intervalo.';
    END IF;
  END IF;
END//

CREATE TRIGGER trg_agendamento_bu
BEFORE UPDATE ON agendamento
FOR EACH ROW
BEGIN
  DECLARE v_ativo BOOLEAN DEFAULT NULL;
  DECLARE v_conflitos INT DEFAULT 0;

  SELECT ativo INTO v_ativo
  FROM profissional
  WHERE id_profissional = NEW.id_profissional;

  IF v_ativo IS NULL OR v_ativo = FALSE THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Não é permitido agendar com profissional inativo ou inexistente.';
  END IF;

  IF NEW.status <> 'cancelado' THEN
    SELECT COUNT(*) INTO v_conflitos
    FROM agendamento a
    WHERE a.id_profissional = NEW.id_profissional
      AND a.data_agendamento = NEW.data_agendamento
      AND a.id_agendamento <> NEW.id_agendamento
      AND a.status <> 'cancelado'
      AND NEW.hora_inicio < a.hora_fim
      AND NEW.hora_fim > a.hora_inicio;

    IF v_conflitos > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Conflito: o profissional já possui agendamento nesse intervalo.';
    END IF;
  END IF;
END//
DELIMITER ;

-- DADOS FICTÍCIOS PARA TESTE
INSERT INTO cliente (nome, telefone, email) VALUES
('Ana Lima', '11990000001', 'ana.exemplo@email.com'),
('Bruno Alves', '11990000002', 'bruno.exemplo@email.com'),
('Carla Souza', '11990000003', 'carla.exemplo@email.com');

INSERT INTO profissional (nome, telefone, ativo) VALUES
('Marina Costa', '11991110001', TRUE),
('Paulo Santos', '11991110002', TRUE);

INSERT INTO procedimento (nome, descricao, duracao_minutos, preco) VALUES
('Corte', 'Corte de cabelo — dado fictício', 40, 45.00),
('Escova', 'Escova — dado fictício', 30, 35.00),
('Coloração', 'Coloração — dado fictício', 120, 150.00);

INSERT INTO especialidade (nome) VALUES
('Corte'), ('Escova'), ('Coloração');

INSERT INTO profissional_especialidade (id_profissional, id_especialidade) VALUES
(1,1), (1,2), (2,2), (2,3);

INSERT INTO agendamento
(id_cliente, id_profissional, id_procedimento, data_agendamento, hora_inicio, hora_fim, status, observacoes) VALUES
(1,1,1,'2026-10-28','10:00:00','10:40:00','marcado','Registro fictício para teste'),
(2,2,2,'2026-10-28','11:00:00','11:30:00','marcado','Registro fictício para teste'),
(3,2,3,'2026-10-29','14:00:00','16:00:00','concluido','Registro fictício para teste');

INSERT INTO pagamento
(id_agendamento, data_pagamento, valor_pago, forma_pagamento, observacoes) VALUES
(1,'2026-10-28 10:45:00',45.00,'pix','Pagamento fictício'),
(3,'2026-10-29 16:00:00',150.00,'pix','Pagamento fictício');

-- CONSULTAS DE EXEMPLO
-- 1. Agenda com cliente, profissional e procedimento
SELECT a.id_agendamento, a.data_agendamento, a.hora_inicio, a.hora_fim, a.status,
       c.nome AS cliente, p.nome AS profissional,
       pr.nome AS procedimento, pr.preco AS preco_referencia
FROM agendamento a
JOIN cliente c ON c.id_cliente = a.id_cliente
JOIN profissional p ON p.id_profissional = a.id_profissional
JOIN procedimento pr ON pr.id_procedimento = a.id_procedimento
ORDER BY a.data_agendamento, a.hora_inicio;

-- 2. Histórico de atendimentos de cada cliente
SELECT c.nome AS cliente, a.data_agendamento, a.hora_inicio, a.hora_fim,
       pr.nome AS procedimento, a.status
FROM cliente c
JOIN agendamento a ON a.id_cliente = c.id_cliente
JOIN procedimento pr ON pr.id_procedimento = a.id_procedimento
ORDER BY c.nome, a.data_agendamento, a.hora_inicio;

-- 3. Total registrado em pagamentos
SELECT COALESCE(SUM(valor_pago), 0) AS total_recebido
FROM pagamento;

-- 4. Quantidade de agendamentos por status
SELECT status, COUNT(*) AS quantidade
FROM agendamento
GROUP BY status;

-- 5. Procedimentos mais agendados
SELECT pr.nome, COUNT(a.id_agendamento) AS quantidade_agendamentos
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

-- VERIFICAÇÕES DE INTEGRIDADE (esperado: zero linhas)
SELECT a.* FROM agendamento a
LEFT JOIN cliente c ON c.id_cliente = a.id_cliente
WHERE c.id_cliente IS NULL;

SELECT pg.* FROM pagamento pg
LEFT JOIN agendamento a ON a.id_agendamento = pg.id_agendamento
WHERE a.id_agendamento IS NULL;
