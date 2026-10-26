-- Sistema de Gestão — Salão dos Primos
-- Script didático para MySQL 8.0.16+ (CHECK efetivo). Os registros de exemplo são fictícios.
-- Execute em um banco limpo: a massa é carregada por INSERTs e não foi feita para duplicação.
-- Os DERs não foram alterados, conforme solicitado.

CREATE DATABASE IF NOT EXISTS salao_dos_primos
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE salao_dos_primos;

CREATE TABLE IF NOT EXISTS cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  telefone VARCHAR(20),
  email VARCHAR(120),
  KEY idx_cliente_nome (nome)
);

CREATE TABLE IF NOT EXISTS profissional (
  id_profissional INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  telefone VARCHAR(20),
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  KEY idx_profissional_ativo (ativo)
);

CREATE TABLE IF NOT EXISTS procedimento (
  id_procedimento INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  descricao VARCHAR(500),
  duracao_minutos INT NOT NULL,
  preco DECIMAL(10,2),
  CHECK (duracao_minutos > 0),
  CHECK (preco IS NULL OR preco >= 0),
  KEY idx_procedimento_nome (nome)
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
  status VARCHAR(20) NOT NULL DEFAULT 'agendado',
  observacoes TEXT,
  data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ag_cliente FOREIGN KEY (id_cliente)
    REFERENCES cliente(id_cliente),
  CONSTRAINT fk_ag_profissional FOREIGN KEY (id_profissional)
    REFERENCES profissional(id_profissional),
  CONSTRAINT fk_ag_procedimento FOREIGN KEY (id_procedimento)
    REFERENCES procedimento(id_procedimento),
  CONSTRAINT chk_ag_horario CHECK (hora_fim > hora_inicio),
  CONSTRAINT chk_ag_status CHECK (status IN ('agendado','confirmado','concluido','cancelado','faltou'))
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
  KEY idx_pagamento_data (data_pagamento),
  CONSTRAINT chk_pag_valor CHECK (valor_pago > 0),
  CONSTRAINT chk_pag_forma CHECK (forma_pagamento IN ('debito','credito','pix','dinheiro'))
);

-- Compras, fornecedores e estoque de insumos.
-- O salão não realiza venda de produtos; o estoque é de materiais usados nos serviços.
CREATE TABLE IF NOT EXISTS fornecedor (
  id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  telefone VARCHAR(20),
  email VARCHAR(120),
  observacoes TEXT,
  KEY idx_fornecedor_nome (nome)
);

CREATE TABLE IF NOT EXISTS insumo (
  id_insumo INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  unidade_medida VARCHAR(20) NOT NULL,
  quantidade_estoque DECIMAL(10,3) NOT NULL DEFAULT 0,
  estoque_minimo DECIMAL(10,3) NOT NULL DEFAULT 0,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT chk_insumo_qtd CHECK (quantidade_estoque >= 0),
  CONSTRAINT chk_insumo_min CHECK (estoque_minimo >= 0),
  KEY idx_insumo_nome (nome),
  KEY idx_insumo_ativo (ativo)
);

CREATE TABLE IF NOT EXISTS compra (
  id_compra INT AUTO_INCREMENT PRIMARY KEY,
  id_fornecedor INT NOT NULL,
  data_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  observacoes TEXT,
  CONSTRAINT fk_compra_fornecedor FOREIGN KEY (id_fornecedor)
    REFERENCES fornecedor(id_fornecedor),
  KEY idx_compra_data (data_compra)
);

CREATE TABLE IF NOT EXISTS item_compra (
  id_item_compra INT AUTO_INCREMENT PRIMARY KEY,
  id_compra INT NOT NULL,
  id_insumo INT NOT NULL,
  quantidade DECIMAL(10,3) NOT NULL,
  valor_unitario DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_item_compra_compra FOREIGN KEY (id_compra)
    REFERENCES compra(id_compra),
  CONSTRAINT fk_item_compra_insumo FOREIGN KEY (id_insumo)
    REFERENCES insumo(id_insumo),
  CONSTRAINT chk_item_qtd CHECK (quantidade > 0),
  CONSTRAINT chk_item_valor CHECK (valor_unitario >= 0),
  KEY idx_item_compra_insumo (id_insumo)
);

CREATE TABLE IF NOT EXISTS movimentacao_estoque (
  id_movimentacao INT AUTO_INCREMENT PRIMARY KEY,
  id_insumo INT NOT NULL,
  id_agendamento INT NULL,
  tipo VARCHAR(20) NOT NULL,
  quantidade DECIMAL(10,3) NOT NULL,
  data_movimentacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  observacoes TEXT,
  CONSTRAINT fk_mov_insumo FOREIGN KEY (id_insumo)
    REFERENCES insumo(id_insumo),
  CONSTRAINT fk_mov_agendamento FOREIGN KEY (id_agendamento)
    REFERENCES agendamento(id_agendamento),
  CONSTRAINT chk_mov_tipo CHECK (tipo IN ('entrada','consumo','ajuste')),
  CONSTRAINT chk_mov_qtd CHECK (quantidade > 0),
  KEY idx_mov_estoque_insumo_data (id_insumo, data_movimentacao)
);

-- Fechamento de caixa: guarda os totais apurados no período e a divisão informada.
CREATE TABLE IF NOT EXISTS fechamento_caixa (
  id_fechamento INT AUTO_INCREMENT PRIMARY KEY,
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL,
  total_recebido DECIMAL(12,2) NOT NULL DEFAULT 0,
  percentual_salao DECIMAL(5,2) NOT NULL DEFAULT 30.00,
  valor_salao DECIMAL(12,2) NOT NULL DEFAULT 0,
  percentual_profissionais DECIMAL(5,2) NOT NULL DEFAULT 70.00,
  valor_profissionais DECIMAL(12,2) NOT NULL DEFAULT 0,
  data_fechamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  observacoes TEXT,
  CONSTRAINT uq_fechamento_periodo UNIQUE (data_inicio, data_fim),
  CONSTRAINT chk_fechamento_periodo CHECK (data_fim >= data_inicio),
  CONSTRAINT chk_fechamento_percentuais CHECK (
    percentual_salao >= 0 AND percentual_profissionais >= 0
    AND percentual_salao + percentual_profissionais = 100
  )
);

-- Valida profissional ativo e evita sobreposição de horários.
DROP TRIGGER IF EXISTS trg_agendamento_bi;
DROP TRIGGER IF EXISTS trg_agendamento_bu;
DROP TRIGGER IF EXISTS trg_item_compra_ai;
DROP TRIGGER IF EXISTS trg_mov_estoque_bi;
DROP TRIGGER IF EXISTS trg_mov_estoque_ai;
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

  IF NEW.status <> 'cancelado' AND (v_ativo IS NULL OR v_ativo = FALSE) THEN
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

  IF NEW.status <> 'cancelado' AND (v_ativo IS NULL OR v_ativo = FALSE) THEN
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

-- Uma compra registrada como item gera entrada de estoque automaticamente.
CREATE TRIGGER trg_item_compra_ai
AFTER INSERT ON item_compra
FOR EACH ROW
BEGIN
  INSERT INTO movimentacao_estoque
    (id_insumo, tipo, quantidade, observacoes)
  VALUES
    (NEW.id_insumo, 'entrada', NEW.quantidade,
     CONCAT('Entrada automática pela compra #', NEW.id_compra));
END//

-- Impede consumo maior que o saldo disponível.
CREATE TRIGGER trg_mov_estoque_bi
BEFORE INSERT ON movimentacao_estoque
FOR EACH ROW
BEGIN
  DECLARE v_saldo DECIMAL(10,3) DEFAULT 0;

  IF NEW.tipo = 'consumo' THEN
    SELECT quantidade_estoque INTO v_saldo
    FROM insumo
    WHERE id_insumo = NEW.id_insumo;

    IF v_saldo < NEW.quantidade THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estoque insuficiente para registrar esse consumo.';
    END IF;
  END IF;
END//

-- Mantém o saldo de estoque sincronizado com cada movimentação.
CREATE TRIGGER trg_mov_estoque_ai
AFTER INSERT ON movimentacao_estoque
FOR EACH ROW
BEGIN
  IF NEW.tipo = 'entrada' THEN
    UPDATE insumo
      SET quantidade_estoque = quantidade_estoque + NEW.quantidade
    WHERE id_insumo = NEW.id_insumo;
  ELSEIF NEW.tipo = 'consumo' THEN
    UPDATE insumo
      SET quantidade_estoque = quantidade_estoque - NEW.quantidade
    WHERE id_insumo = NEW.id_insumo;
  ELSEIF NEW.tipo = 'ajuste' THEN
    -- Ajuste positivo soma ao saldo; registrar observação explicando o motivo.
    UPDATE insumo
      SET quantidade_estoque = quantidade_estoque + NEW.quantidade
    WHERE id_insumo = NEW.id_insumo;
  END IF;
END//
DELIMITER ;

-- Registra um fechamento do período usando pagamentos recebidos.
-- Execute uma vez para cada período; a chave única evita fechar o mesmo período duas vezes.
DROP PROCEDURE IF EXISTS fechar_caixa;
DELIMITER //
CREATE PROCEDURE fechar_caixa(IN p_data_inicio DATE, IN p_data_fim DATE)
BEGIN
  DECLARE v_total DECIMAL(12,2) DEFAULT 0;

  IF p_data_fim < p_data_inicio THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'A data final não pode ser anterior à data inicial.';
  END IF;

  SELECT COALESCE(SUM(valor_pago), 0) INTO v_total
  FROM pagamento
  WHERE data_pagamento >= p_data_inicio
    AND data_pagamento < DATE_ADD(p_data_fim, INTERVAL 1 DAY);

  INSERT INTO fechamento_caixa
    (data_inicio, data_fim, total_recebido, percentual_salao, valor_salao,
     percentual_profissionais, valor_profissionais)
  VALUES
    (p_data_inicio, p_data_fim, v_total, 30.00, ROUND(v_total * 0.30, 2),
     70.00, ROUND(v_total * 0.70, 2));
END//
DELIMITER ;

-- MASSA DE DADOS FICTÍCIA: 40 clientes, 4 profissionais, 10 procedimentos e 96 agendamentos.
-- A quantidade é didática, coerente com uma equipe de quatro profissionais e uma base aproximada de 30 a 50 clientes;
-- não representa nomes, contatos, pagamentos ou atendimentos reais.
INSERT INTO cliente (nome, telefone, email) VALUES
('Ana Lima', '11980000001', 'cliente01@exemplo.invalid'),
('Bruno Alves', '11980000002', 'cliente02@exemplo.invalid'),
('Carla Souza', '11980000003', 'cliente03@exemplo.invalid'),
('Daniela Rocha', '11980000004', 'cliente04@exemplo.invalid'),
('Eduarda Martins', '11980000005', 'cliente05@exemplo.invalid'),
('Felipe Ribeiro', '11980000006', 'cliente06@exemplo.invalid'),
('Gabriela Costa', '11980000007', 'cliente07@exemplo.invalid'),
('Henrique Almeida', '11980000008', 'cliente08@exemplo.invalid'),
('Isabela Santos', '11980000009', 'cliente09@exemplo.invalid'),
('João Ferreira', '11980000010', 'cliente10@exemplo.invalid'),
('Karen Oliveira', '11980000011', 'cliente11@exemplo.invalid'),
('Lucas Gomes', '11980000012', 'cliente12@exemplo.invalid'),
('Mariana Carvalho', '11980000013', 'cliente13@exemplo.invalid'),
('Nicolas Araujo', '11980000014', 'cliente14@exemplo.invalid'),
('Olivia Barros', '11980000015', 'cliente15@exemplo.invalid'),
('Pedro Lima', '11980000016', 'cliente16@exemplo.invalid'),
('Rafaela Nunes', '11980000017', 'cliente17@exemplo.invalid'),
('Samuel Castro', '11980000018', 'cliente18@exemplo.invalid'),
('Talita Mendes', '11980000019', 'cliente19@exemplo.invalid'),
('Ursula Freitas', '11980000020', 'cliente20@exemplo.invalid'),
('Vitor Cardoso', '11980000021', 'cliente21@exemplo.invalid'),
('Wesley Moraes', '11980000022', 'cliente22@exemplo.invalid'),
('Yasmin Pereira', '11980000023', 'cliente23@exemplo.invalid'),
('André Moreira', '11980000024', 'cliente24@exemplo.invalid'),
('Bianca Lopes', '11980000025', 'cliente25@exemplo.invalid'),
('Caio Fernandes', '11980000026', 'cliente26@exemplo.invalid'),
('Débora Dias', '11980000027', 'cliente27@exemplo.invalid'),
('Enzo Correia', '11980000028', 'cliente28@exemplo.invalid'),
('Fernanda Teixeira', '11980000029', 'cliente29@exemplo.invalid'),
('Gustavo Reis', '11980000030', 'cliente30@exemplo.invalid'),
('Helena Batista', '11980000031', 'cliente31@exemplo.invalid'),
('Igor Machado', '11980000032', 'cliente32@exemplo.invalid'),
('Júlia Campos', '11980000033', 'cliente33@exemplo.invalid'),
('Leonardo Pinto', '11980000034', 'cliente34@exemplo.invalid'),
('Manuela Vieira', '11980000035', 'cliente35@exemplo.invalid'),
('Nathan Moura', '11980000036', 'cliente36@exemplo.invalid'),
('Paula Andrade', '11980000037', 'cliente37@exemplo.invalid'),
('Renato Farias', '11980000038', 'cliente38@exemplo.invalid'),
('Sofia Cunha', '11980000039', 'cliente39@exemplo.invalid'),
('Tiago Neves', '11980000040', 'cliente40@exemplo.invalid');

INSERT INTO profissional (nome, telefone, ativo) VALUES
('Marina Costa', '11991110001', TRUE),
('Paulo Santos', '11991110002', TRUE),
('Beatriz Melo', '11991110003', TRUE),
('Ricardo Alves', '11991110004', TRUE);

INSERT INTO procedimento (nome, descricao, duracao_minutos, preco) VALUES
('Corte feminino', 'Corte de cabelo; dado fictício.', 45, 55.00),
('Corte masculino', 'Corte de cabelo; dado fictício.', 30, 35.00),
('Escova', 'Escova; dado fictício.', 40, 45.00),
('Hidratação', 'Tratamento capilar; dado fictício.', 50, 70.00),
('Coloração', 'Coloração; dado fictício.', 120, 180.00),
('Mechas', 'Procedimento de coloração; dado fictício.', 150, 250.00),
('Luzes para loiro', 'Duração-base fictícia; pode ser ampliada pela avaliação profissional.', 120, 280.00),
('Progressiva', 'Procedimento capilar; dado fictício.', 150, 220.00),
('Penteado', 'Penteado; dado fictício.', 60, 90.00),
('Manicure', 'Serviço de manicure; dado fictício.', 45, 40.00);

INSERT INTO especialidade (nome) VALUES
('Corte'),
('Escova'),
('Coloração'),
('Tratamentos'),
('Unhas');

INSERT INTO profissional_especialidade (id_profissional, id_especialidade) VALUES
(1, 1),
(1, 2),
(1, 4),
(2, 1),
(2, 2),
(2, 3),
(3, 3),
(3, 4),
(3, 5),
(4, 1),
(4, 3),
(4, 4);

INSERT INTO agendamento
(id_cliente, id_profissional, id_procedimento, data_agendamento, hora_inicio, hora_fim, status, observacoes) VALUES
(1, 1, 9, '2026-07-06', '09:00:00', '10:00:00', 'concluido', 'Dado fictício de teste #1'),
(2, 1, 6, '2026-07-06', '13:00:00', '15:30:00', 'concluido', 'Dado fictício de teste #2'),
(3, 2, 4, '2026-07-06', '09:00:00', '09:50:00', 'concluido', 'Dado fictício de teste #3'),
(4, 2, 1, '2026-07-06', '13:00:00', '13:45:00', 'concluido', 'Dado fictício de teste #4'),
(5, 3, 9, '2026-07-06', '09:00:00', '10:00:00', 'concluido', 'Dado fictício de teste #5'),
(6, 3, 6, '2026-07-06', '13:00:00', '15:30:00', 'concluido', 'Dado fictício de teste #6'),
(7, 4, 4, '2026-07-06', '09:00:00', '09:50:00', 'concluido', 'Dado fictício de teste #7'),
(8, 4, 1, '2026-07-06', '13:00:00', '13:45:00', 'concluido', 'Dado fictício de teste #8'),
(9, 1, 6, '2026-07-20', '09:00:00', '11:30:00', 'concluido', 'Dado fictício de teste #9'),
(10, 1, 3, '2026-07-20', '13:00:00', '13:40:00', 'concluido', 'Dado fictício de teste #10'),
(11, 2, 1, '2026-07-20', '09:00:00', '09:45:00', 'faltou', 'Dado fictício de teste #11'),
(12, 2, 8, '2026-07-20', '13:00:00', '15:30:00', 'concluido', 'Dado fictício de teste #12'),
(13, 3, 6, '2026-07-20', '09:00:00', '11:30:00', 'cancelado', 'Dado fictício de teste #13'),
(14, 3, 3, '2026-07-20', '13:00:00', '13:40:00', 'concluido', 'Dado fictício de teste #14'),
(15, 4, 1, '2026-07-20', '09:00:00', '09:45:00', 'concluido', 'Dado fictício de teste #15'),
(16, 4, 8, '2026-07-20', '13:00:00', '15:30:00', 'concluido', 'Dado fictício de teste #16'),
(17, 1, 3, '2026-08-03', '09:00:00', '09:40:00', 'concluido', 'Dado fictício de teste #17'),
(18, 1, 10, '2026-08-03', '13:00:00', '13:45:00', 'concluido', 'Dado fictício de teste #18'),
(19, 2, 8, '2026-08-03', '09:00:00', '11:30:00', 'concluido', 'Dado fictício de teste #19'),
(20, 2, 5, '2026-08-03', '13:00:00', '15:00:00', 'concluido', 'Dado fictício de teste #20'),
(21, 3, 3, '2026-08-03', '09:00:00', '09:40:00', 'concluido', 'Dado fictício de teste #21'),
(22, 3, 10, '2026-08-03', '13:00:00', '13:45:00', 'faltou', 'Dado fictício de teste #22'),
(23, 4, 8, '2026-08-03', '09:00:00', '11:30:00', 'concluido', 'Dado fictício de teste #23'),
(24, 4, 5, '2026-08-03', '13:00:00', '15:00:00', 'concluido', 'Dado fictício de teste #24'),
(25, 1, 10, '2026-08-17', '09:00:00', '09:45:00', 'concluido', 'Dado fictício de teste #25'),
(26, 1, 7, '2026-08-17', '13:00:00', '15:00:00', 'cancelado', 'Dado fictício de teste #26'),
(27, 2, 5, '2026-08-17', '09:00:00', '11:00:00', 'concluido', 'Dado fictício de teste #27'),
(28, 2, 2, '2026-08-17', '13:00:00', '13:30:00', 'concluido', 'Dado fictício de teste #28'),
(29, 3, 10, '2026-08-17', '09:00:00', '09:45:00', 'concluido', 'Dado fictício de teste #29'),
(30, 3, 7, '2026-08-17', '13:00:00', '15:00:00', 'concluido', 'Dado fictício de teste #30'),
(31, 4, 5, '2026-08-17', '09:00:00', '11:00:00', 'concluido', 'Dado fictício de teste #31'),
(32, 4, 2, '2026-08-17', '13:00:00', '13:30:00', 'concluido', 'Dado fictício de teste #32'),
(33, 1, 7, '2026-08-31', '09:00:00', '11:00:00', 'faltou', 'Dado fictício de teste #33'),
(34, 1, 4, '2026-08-31', '13:00:00', '13:50:00', 'concluido', 'Dado fictício de teste #34'),
(35, 2, 2, '2026-08-31', '09:00:00', '09:30:00', 'concluido', 'Dado fictício de teste #35'),
(36, 2, 9, '2026-08-31', '13:00:00', '14:00:00', 'concluido', 'Dado fictício de teste #36'),
(37, 3, 7, '2026-08-31', '09:00:00', '11:00:00', 'concluido', 'Dado fictício de teste #37'),
(38, 3, 4, '2026-08-31', '13:00:00', '13:50:00', 'concluido', 'Dado fictício de teste #38'),
(39, 4, 2, '2026-08-31', '09:00:00', '09:30:00', 'cancelado', 'Dado fictício de teste #39'),
(40, 4, 9, '2026-08-31', '13:00:00', '14:00:00', 'concluido', 'Dado fictício de teste #40'),
(1, 1, 4, '2026-09-14', '09:00:00', '09:50:00', 'concluido', 'Dado fictício de teste #41'),
(2, 1, 1, '2026-09-14', '13:00:00', '13:45:00', 'concluido', 'Dado fictício de teste #42'),
(3, 2, 9, '2026-09-14', '09:00:00', '10:00:00', 'concluido', 'Dado fictício de teste #43'),
(4, 2, 6, '2026-09-14', '13:00:00', '15:30:00', 'faltou', 'Dado fictício de teste #44'),
(5, 3, 4, '2026-09-14', '09:00:00', '09:50:00', 'concluido', 'Dado fictício de teste #45'),
(6, 3, 1, '2026-09-14', '13:00:00', '13:45:00', 'concluido', 'Dado fictício de teste #46'),
(7, 4, 9, '2026-09-14', '09:00:00', '10:00:00', 'concluido', 'Dado fictício de teste #47'),
(8, 4, 6, '2026-09-14', '13:00:00', '15:30:00', 'concluido', 'Dado fictício de teste #48'),
(9, 1, 1, '2026-09-28', '09:00:00', '09:45:00', 'concluido', 'Dado fictício de teste #49'),
(10, 1, 8, '2026-09-28', '13:00:00', '15:30:00', 'concluido', 'Dado fictício de teste #50'),
(11, 2, 6, '2026-09-28', '09:00:00', '11:30:00', 'concluido', 'Dado fictício de teste #51'),
(12, 2, 3, '2026-09-28', '13:00:00', '13:40:00', 'cancelado', 'Dado fictício de teste #52'),
(13, 3, 1, '2026-09-28', '09:00:00', '09:45:00', 'concluido', 'Dado fictício de teste #53'),
(14, 3, 8, '2026-09-28', '13:00:00', '15:30:00', 'concluido', 'Dado fictício de teste #54'),
(15, 4, 6, '2026-09-28', '09:00:00', '11:30:00', 'faltou', 'Dado fictício de teste #55'),
(16, 4, 3, '2026-09-28', '13:00:00', '13:40:00', 'concluido', 'Dado fictício de teste #56'),
(17, 1, 8, '2026-10-05', '09:00:00', '11:30:00', 'concluido', 'Dado fictício de teste #57'),
(18, 1, 5, '2026-10-05', '13:00:00', '15:00:00', 'concluido', 'Dado fictício de teste #58'),
(19, 2, 3, '2026-10-05', '09:00:00', '09:40:00', 'concluido', 'Dado fictício de teste #59'),
(20, 2, 10, '2026-10-05', '13:00:00', '13:45:00', 'concluido', 'Dado fictício de teste #60'),
(21, 3, 8, '2026-10-05', '09:00:00', '11:30:00', 'concluido', 'Dado fictício de teste #61'),
(22, 3, 5, '2026-10-05', '13:00:00', '15:00:00', 'concluido', 'Dado fictício de teste #62'),
(23, 4, 3, '2026-10-05', '09:00:00', '09:40:00', 'concluido', 'Dado fictício de teste #63'),
(24, 4, 10, '2026-10-05', '13:00:00', '13:45:00', 'concluido', 'Dado fictício de teste #64'),
(25, 1, 5, '2026-10-19', '09:00:00', '11:00:00', 'cancelado', 'Dado fictício de teste #65'),
(26, 1, 2, '2026-10-19', '13:00:00', '13:30:00', 'faltou', 'Dado fictício de teste #66'),
(27, 2, 10, '2026-10-19', '09:00:00', '09:45:00', 'concluido', 'Dado fictício de teste #67'),
(28, 2, 7, '2026-10-19', '13:00:00', '15:00:00', 'concluido', 'Dado fictício de teste #68'),
(29, 3, 5, '2026-10-19', '09:00:00', '11:00:00', 'concluido', 'Dado fictício de teste #69'),
(30, 3, 2, '2026-10-19', '13:00:00', '13:30:00', 'concluido', 'Dado fictício de teste #70'),
(31, 4, 10, '2026-10-19', '09:00:00', '09:45:00', 'concluido', 'Dado fictício de teste #71'),
(32, 4, 7, '2026-10-19', '13:00:00', '15:00:00', 'concluido', 'Dado fictício de teste #72'),
(33, 1, 2, '2026-10-28', '09:00:00', '09:30:00', 'agendado', 'Dado fictício de teste #73'),
(34, 1, 9, '2026-10-28', '13:00:00', '14:00:00', 'confirmado', 'Dado fictício de teste #74'),
(35, 2, 7, '2026-10-28', '09:00:00', '11:00:00', 'agendado', 'Dado fictício de teste #75'),
(36, 2, 4, '2026-10-28', '13:00:00', '13:50:00', 'confirmado', 'Dado fictício de teste #76'),
(37, 3, 2, '2026-10-28', '09:00:00', '09:30:00', 'agendado', 'Dado fictício de teste #77'),
(38, 3, 9, '2026-10-28', '13:00:00', '14:00:00', 'cancelado', 'Dado fictício de teste #78'),
(39, 4, 7, '2026-10-28', '09:00:00', '11:00:00', 'agendado', 'Dado fictício de teste #79'),
(40, 4, 4, '2026-10-28', '13:00:00', '13:50:00', 'confirmado', 'Dado fictício de teste #80'),
(1, 1, 9, '2026-11-09', '09:00:00', '10:00:00', 'agendado', 'Dado fictício de teste #81'),
(2, 1, 6, '2026-11-09', '13:00:00', '15:30:00', 'confirmado', 'Dado fictício de teste #82'),
(3, 2, 4, '2026-11-09', '09:00:00', '09:50:00', 'agendado', 'Dado fictício de teste #83'),
(4, 2, 1, '2026-11-09', '13:00:00', '13:45:00', 'confirmado', 'Dado fictício de teste #84'),
(5, 3, 9, '2026-11-09', '09:00:00', '10:00:00', 'agendado', 'Dado fictício de teste #85'),
(6, 3, 6, '2026-11-09', '13:00:00', '15:30:00', 'confirmado', 'Dado fictício de teste #86'),
(7, 4, 4, '2026-11-09', '09:00:00', '09:50:00', 'agendado', 'Dado fictício de teste #87'),
(8, 4, 1, '2026-11-09', '13:00:00', '13:45:00', 'confirmado', 'Dado fictício de teste #88'),
(9, 1, 6, '2026-11-23', '09:00:00', '11:30:00', 'agendado', 'Dado fictício de teste #89'),
(10, 1, 3, '2026-11-23', '13:00:00', '13:40:00', 'confirmado', 'Dado fictício de teste #90'),
(11, 2, 1, '2026-11-23', '09:00:00', '09:45:00', 'cancelado', 'Dado fictício de teste #91'),
(12, 2, 8, '2026-11-23', '13:00:00', '15:30:00', 'confirmado', 'Dado fictício de teste #92'),
(13, 3, 6, '2026-11-23', '09:00:00', '11:30:00', 'agendado', 'Dado fictício de teste #93'),
(14, 3, 3, '2026-11-23', '13:00:00', '13:40:00', 'confirmado', 'Dado fictício de teste #94'),
(15, 4, 1, '2026-11-23', '09:00:00', '09:45:00', 'agendado', 'Dado fictício de teste #95'),
(16, 4, 8, '2026-11-23', '13:00:00', '15:30:00', 'confirmado', 'Dado fictício de teste #96');

INSERT INTO pagamento
(id_agendamento, data_pagamento, valor_pago, forma_pagamento, observacoes) VALUES
(1, '2026-07-06 10:10:00', 87.30, 'debito', 'Pagamento fictício'),
(2, '2026-07-06 15:40:00', 260.00, 'credito', 'Pagamento fictício'),
(3, '2026-07-06 10:00:00', 77.70, 'dinheiro', 'Pagamento fictício'),
(4, '2026-07-06 13:55:00', 64.90, 'pix', 'Pagamento fictício'),
(5, '2026-07-06 10:10:00', 81.00, 'debito', 'Pagamento fictício'),
(6, '2026-07-06 15:40:00', 242.50, 'credito', 'Pagamento fictício'),
(7, '2026-07-06 10:00:00', 72.80, 'dinheiro', 'Pagamento fictício'),
(8, '2026-07-06 13:55:00', 61.05, 'pix', 'Pagamento fictício'),
(9, '2026-07-20 11:40:00', 295.00, 'debito', 'Pagamento fictício'),
(10, '2026-07-20 13:50:00', 40.50, 'credito', 'Pagamento fictício'),
(12, '2026-07-20 15:40:00', 228.80, 'pix', 'Pagamento fictício'),
(14, '2026-07-20 13:50:00', 53.10, 'credito', 'Pagamento fictício'),
(15, '2026-07-20 09:55:00', 49.50, 'dinheiro', 'Pagamento fictício'),
(16, '2026-07-20 15:40:00', 213.40, 'pix', 'Pagamento fictício'),
(17, '2026-08-03 09:50:00', 46.80, 'debito', 'Pagamento fictício'),
(18, '2026-08-03 13:55:00', 44.40, 'credito', 'Pagamento fictício'),
(19, '2026-08-03 11:40:00', 259.60, 'dinheiro', 'Pagamento fictício'),
(20, '2026-08-03 15:10:00', 162.00, 'pix', 'Pagamento fictício'),
(21, '2026-08-03 09:50:00', 43.65, 'debito', 'Pagamento fictício'),
(23, '2026-08-03 11:40:00', 244.20, 'dinheiro', 'Pagamento fictício'),
(24, '2026-08-03 15:10:00', 212.40, 'pix', 'Pagamento fictício'),
(25, '2026-08-17 09:55:00', 36.00, 'debito', 'Pagamento fictício'),
(27, '2026-08-17 11:10:00', 187.20, 'dinheiro', 'Pagamento fictício'),
(28, '2026-08-17 13:40:00', 38.85, 'pix', 'Pagamento fictício'),
(29, '2026-08-17 09:55:00', 47.20, 'debito', 'Pagamento fictício'),
(30, '2026-08-17 15:10:00', 252.00, 'credito', 'Pagamento fictício'),
(31, '2026-08-17 11:10:00', 174.60, 'dinheiro', 'Pagamento fictício'),
(32, '2026-08-17 13:40:00', 36.40, 'pix', 'Pagamento fictício'),
(34, '2026-08-31 14:00:00', 82.60, 'credito', 'Pagamento fictício'),
(35, '2026-08-31 09:40:00', 31.50, 'dinheiro', 'Pagamento fictício'),
(36, '2026-08-31 14:10:00', 87.30, 'pix', 'Pagamento fictício'),
(37, '2026-08-31 11:10:00', 291.20, 'debito', 'Pagamento fictício'),
(38, '2026-08-31 14:00:00', 77.70, 'credito', 'Pagamento fictício'),
(40, '2026-08-31 14:10:00', 81.00, 'pix', 'Pagamento fictício'),
(41, '2026-09-14 10:00:00', 67.90, 'debito', 'Pagamento fictício'),
(42, '2026-09-14 13:55:00', 57.20, 'credito', 'Pagamento fictício'),
(43, '2026-09-14 10:10:00', 99.90, 'dinheiro', 'Pagamento fictício'),
(45, '2026-09-14 10:00:00', 63.00, 'debito', 'Pagamento fictício'),
(46, '2026-09-14 13:55:00', 53.35, 'credito', 'Pagamento fictício'),
(47, '2026-09-14 10:10:00', 93.60, 'dinheiro', 'Pagamento fictício'),
(48, '2026-09-14 15:40:00', 277.50, 'pix', 'Pagamento fictício'),
(49, '2026-09-28 09:55:00', 64.90, 'debito', 'Pagamento fictício'),
(50, '2026-09-28 15:40:00', 198.00, 'credito', 'Pagamento fictício'),
(51, '2026-09-28 11:40:00', 242.50, 'dinheiro', 'Pagamento fictício'),
(53, '2026-09-28 09:55:00', 61.05, 'debito', 'Pagamento fictício'),
(54, '2026-09-28 15:40:00', 259.60, 'credito', 'Pagamento fictício'),
(56, '2026-09-28 13:50:00', 43.65, 'pix', 'Pagamento fictício'),
(57, '2026-10-05 11:40:00', 228.80, 'debito', 'Pagamento fictício'),
(58, '2026-10-05 15:10:00', 199.80, 'credito', 'Pagamento fictício'),
(59, '2026-10-05 09:50:00', 53.10, 'dinheiro', 'Pagamento fictício'),
(60, '2026-10-05 13:55:00', 36.00, 'pix', 'Pagamento fictício'),
(61, '2026-10-05 11:40:00', 213.40, 'debito', 'Pagamento fictício'),
(62, '2026-10-05 15:10:00', 187.20, 'credito', 'Pagamento fictício'),
(63, '2026-10-05 09:50:00', 49.95, 'dinheiro', 'Pagamento fictício'),
(64, '2026-10-05 13:55:00', 47.20, 'pix', 'Pagamento fictício'),
(67, '2026-10-19 09:55:00', 41.60, 'dinheiro', 'Pagamento fictício'),
(68, '2026-10-19 15:10:00', 310.80, 'pix', 'Pagamento fictício'),
(69, '2026-10-19 11:10:00', 212.40, 'debito', 'Pagamento fictício'),
(70, '2026-10-19 13:40:00', 31.50, 'credito', 'Pagamento fictício'),
(71, '2026-10-19 09:55:00', 38.80, 'dinheiro', 'Pagamento fictício'),
(72, '2026-10-19 15:10:00', 291.20, 'pix', 'Pagamento fictício');

INSERT INTO fornecedor (nome, telefone, email, observacoes) VALUES
('Distribuidora Exemplo A', '11980000001', 'contato.a@exemplo.invalid', 'Fornecedor fictício'),
('Distribuidora Exemplo B', '11980000002', 'contato.b@exemplo.invalid', 'Fornecedor fictício'),
('Distribuidora Exemplo C', '11980000003', 'contato.c@exemplo.invalid', 'Fornecedor fictício');

INSERT INTO insumo (nome, unidade_medida, quantidade_estoque, estoque_minimo, ativo) VALUES
('Coloração castanho', 'unidade', 0, 2, TRUE),
('Descolorante', 'grama', 0, 500, TRUE),
('Água oxigenada', 'ml', 0, 300, TRUE),
('Shampoo profissional', 'ml', 0, 250, TRUE),
('Condicionador profissional', 'ml', 0, 250, TRUE),
('Máscara de hidratação', 'ml', 0, 200, TRUE),
('Luvas descartáveis', 'unidade', 0, 20, TRUE),
('Papel para mechas', 'unidade', 0, 50, TRUE);

INSERT INTO compra (id_fornecedor, data_compra, observacoes) VALUES
 (1, '2026-07-02 10:00:00', 'Compra fictícia de teste'),
 (2, '2026-08-05 11:30:00', 'Compra fictícia de teste'),
 (3, '2026-09-10 14:00:00', 'Compra fictícia de teste');

INSERT INTO item_compra (id_compra, id_insumo, quantidade, valor_unitario) VALUES
(1, 1, 1.000, 18.50),
(1, 2, 700.000, 0.12),
(1, 3, 600.000, 0.08),
(1, 4, 1000.000, 0.05),
(2, 5, 800.000, 0.06),
(2, 6, 500.000, 0.11),
(2, 7, 50.000, 0.25),
(3, 8, 100.000, 0.18);

-- Movimentações fictícias para testar consumo, saldo abaixo do mínimo e vínculo com atendimento.
INSERT INTO movimentacao_estoque (id_insumo, id_agendamento, tipo, quantidade, observacoes) VALUES
 (1, 1, 'consumo', 0.500, 'Consumo fictício vinculado ao atendimento'),
 (7, NULL, 'consumo', 35.000, 'Consumo fictício de luvas'),
 (8, NULL, 'consumo', 60.000, 'Consumo fictício de papel para mechas');

-- Demonstração de UPDATE: a transação é desfeita para preservar a massa carregada.
START TRANSACTION;
UPDATE agendamento SET observacoes = CONCAT(COALESCE(observacoes, ''), ' [teste UPDATE]') WHERE id_agendamento = 1;
SELECT id_agendamento, observacoes FROM agendamento WHERE id_agendamento = 1;
ROLLBACK;

-- Demonstração de DELETE segura: cria e remove um cliente temporário de teste.
INSERT INTO cliente (nome, email) VALUES ('Cliente temporário para teste DELETE', 'delete.teste@exemplo.invalid');
DELETE FROM cliente WHERE email = 'delete.teste@exemplo.invalid';

-- CONSULTAS GERENCIAIS
-- G01 — Qual foi o total recebido por mês e por forma de pagamento?
-- Atende: acompanhamento de recebimentos e conferência de caixa (P3, RN09, RN11).
SELECT DATE_FORMAT(data_pagamento, '%Y-%m') AS mes, forma_pagamento, SUM(valor_pago) AS total_recebido FROM pagamento GROUP BY DATE_FORMAT(data_pagamento, '%Y-%m'), forma_pagamento ORDER BY mes, forma_pagamento;

-- G02 — Qual é a agenda de cada profissional por data?
-- Atende: consulta rápida de disponibilidade e redução das mensagens sobre horários (P1, P2; RN02, RN03).
SELECT a.data_agendamento, p.nome AS profissional, a.hora_inicio, a.hora_fim, a.status, c.nome AS cliente, pr.nome AS procedimento FROM agendamento a JOIN profissional p ON p.id_profissional=a.id_profissional JOIN cliente c ON c.id_cliente=a.id_cliente JOIN procedimento pr ON pr.id_procedimento=a.id_procedimento ORDER BY a.data_agendamento, p.nome, a.hora_inicio;

-- G03 — Quais insumos estão no nível mínimo ou abaixo dele?
-- Atende: controle de reposição e prevenção de falta de material (P4, RN13).
SELECT id_insumo, nome, quantidade_estoque, estoque_minimo, unidade_medida FROM insumo WHERE ativo=TRUE AND quantidade_estoque<=estoque_minimo ORDER BY nome;

-- G04 — Quais procedimentos são mais agendados?
-- Atende: planejamento da agenda e análise de demanda por serviço (KPI de demanda, RN01).
SELECT pr.nome, COUNT(a.id_agendamento) AS total_agendamentos FROM procedimento pr LEFT JOIN agendamento a ON a.id_procedimento=pr.id_procedimento GROUP BY pr.id_procedimento, pr.nome ORDER BY total_agendamentos DESC, pr.nome;

-- G05 — Qual é o total recebido por profissional no período?
-- Atende: análise de atendimentos e recebimentos por profissional (KPI financeiro, RN09).
SELECT p.nome AS profissional, COUNT(pg.id_pagamento) AS pagamentos, COALESCE(SUM(pg.valor_pago),0) AS total_recebido FROM profissional p LEFT JOIN agendamento a ON a.id_profissional=p.id_profissional LEFT JOIN pagamento pg ON pg.id_agendamento=a.id_agendamento GROUP BY p.id_profissional, p.nome ORDER BY total_recebido DESC;

-- G06 — Quanto foi comprado por fornecedor e mês?
-- Atende: planejamento de compras e acompanhamento de despesas com insumos (P4, RN12).
SELECT f.nome AS fornecedor, DATE_FORMAT(c.data_compra,'%Y-%m') AS mes, SUM(ic.quantidade*ic.valor_unitario) AS total_comprado FROM fornecedor f JOIN compra c ON c.id_fornecedor=f.id_fornecedor JOIN item_compra ic ON ic.id_compra=c.id_compra GROUP BY f.nome, DATE_FORMAT(c.data_compra,'%Y-%m') ORDER BY mes, total_comprado DESC;

-- G07 — Qual a divisão estimada de 30%/70% sobre os pagamentos por mês?
-- Atende: conferência da divisão financeira informada (P3, RN10, RN11).
SELECT DATE_FORMAT(data_pagamento,'%Y-%m') AS mes, SUM(valor_pago) AS total_recebido, ROUND(SUM(valor_pago)*0.30,2) AS estimativa_salao_30, ROUND(SUM(valor_pago)*0.70,2) AS estimativa_profissionais_70 FROM pagamento GROUP BY DATE_FORMAT(data_pagamento,'%Y-%m') ORDER BY mes;

-- G08 — Qual a taxa de cancelamento e falta no período?
-- Atende: acompanhamento de horários perdidos e histórico de agenda (KPI operacional, RN07).
SELECT DATE_FORMAT(data_agendamento,'%Y-%m') AS mes, COUNT(*) AS total_agendamentos, SUM(status='cancelado') AS cancelados, SUM(status='faltou') AS faltas, ROUND(100*SUM(status IN ('cancelado','faltou'))/NULLIF(COUNT(*),0),2) AS percentual_cancelamento_falta FROM agendamento GROUP BY DATE_FORMAT(data_agendamento,'%Y-%m') ORDER BY mes;

-- CONSULTAS DE AUDITORIA: o resultado esperado é zero linhas.
-- A01 — Existem intervalos sobrepostos para o mesmo profissional?
-- Verifica: RN02 e RN03 (sem sobreposição entre agendamentos não cancelados).
SELECT a.id_agendamento AS agendamento_1, b.id_agendamento AS agendamento_2, a.id_profissional, a.data_agendamento FROM agendamento a JOIN agendamento b ON a.id_profissional=b.id_profissional AND a.data_agendamento=b.data_agendamento AND a.id_agendamento<b.id_agendamento AND a.status<>'cancelado' AND b.status<>'cancelado' AND a.hora_inicio<b.hora_fim AND a.hora_fim>b.hora_inicio;

-- A02 — Há agendamentos sem cliente, profissional ou procedimento válido?
-- Verifica: RN05 (vínculos obrigatórios e integridade referencial).
SELECT a.id_agendamento FROM agendamento a LEFT JOIN cliente c ON c.id_cliente=a.id_cliente LEFT JOIN profissional p ON p.id_profissional=a.id_profissional LEFT JOIN procedimento pr ON pr.id_procedimento=a.id_procedimento WHERE c.id_cliente IS NULL OR p.id_profissional IS NULL OR pr.id_procedimento IS NULL;

-- A03 — Há atendimentos concluídos sem pagamento?
-- Verifica: RN09 (pagamento registrado ao concluir o atendimento, conforme regra do modelo).
SELECT a.id_agendamento, a.data_agendamento FROM agendamento a LEFT JOIN pagamento pg ON pg.id_agendamento=a.id_agendamento WHERE a.status='concluido' AND pg.id_pagamento IS NULL;

-- A04 — Há agendamentos ativos atribuídos a profissionais inativos?
-- Verifica: RN04 (profissional inativo não recebe novos agendamentos).
SELECT a.id_agendamento, p.nome FROM agendamento a JOIN profissional p ON p.id_profissional=a.id_profissional WHERE p.ativo=FALSE AND a.status<>'cancelado';

-- A05 — Há pagamentos com valor inválido ou forma não permitida?
-- Verifica: RN09 (valor positivo e forma prevista).
SELECT id_pagamento, valor_pago, forma_pagamento FROM pagamento WHERE valor_pago<=0 OR forma_pagamento NOT IN ('debito','credito','pix','dinheiro');

-- A06 — Há saldos de estoque negativos?
-- Verifica: RN13 (saldo de insumo não pode ser negativo).
SELECT id_insumo, nome, quantidade_estoque FROM insumo WHERE quantidade_estoque<0;

-- A07 — Há pagamentos sem agendamento correspondente?
-- Verifica: RN05 (integridade referencial do pagamento).
SELECT pg.id_pagamento FROM pagamento pg LEFT JOIN agendamento a ON a.id_agendamento=pg.id_agendamento WHERE a.id_agendamento IS NULL;

-- Fechamento de caixa do período coberto pela massa fictícia; executar em banco limpo.
CALL fechar_caixa('2026-07-01','2026-11-30');
SELECT * FROM fechamento_caixa ORDER BY data_fechamento DESC;
