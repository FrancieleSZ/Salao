-- Sistema de Gestão — Salão dos Primos
-- Script didático para MySQL 8.0+. Os registros de exemplo são fictícios.
-- Os DERs não foram alterados, conforme solicitado.

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
  observacoes TEXT
);

CREATE TABLE IF NOT EXISTS insumo (
  id_insumo INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  unidade_medida VARCHAR(20) NOT NULL,
  quantidade_estoque DECIMAL(10,3) NOT NULL DEFAULT 0,
  estoque_minimo DECIMAL(10,3) NOT NULL DEFAULT 0,
  ativo BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT chk_insumo_qtd CHECK (quantidade_estoque >= 0),
  CONSTRAINT chk_insumo_min CHECK (estoque_minimo >= 0)
);

CREATE TABLE IF NOT EXISTS compra (
  id_compra INT AUTO_INCREMENT PRIMARY KEY,
  id_fornecedor INT NOT NULL,
  data_compra DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  observacoes TEXT,
  CONSTRAINT fk_compra_fornecedor FOREIGN KEY (id_fornecedor)
    REFERENCES fornecedor(id_fornecedor)
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
  CONSTRAINT chk_item_valor CHECK (valor_unitario >= 0)
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
  CONSTRAINT chk_mov_qtd CHECK (quantidade > 0)
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
(1,1,1,'2026-10-28','10:00:00','10:40:00','agendado','Registro fictício para teste'),
(2,2,2,'2026-10-28','11:00:00','11:30:00','agendado','Registro fictício para teste'),
(3,2,3,'2026-10-29','14:00:00','16:00:00','concluido','Registro fictício para teste');

INSERT INTO pagamento
(id_agendamento, data_pagamento, valor_pago, forma_pagamento, observacoes) VALUES
(1,'2026-10-28 10:45:00',45.00,'pix','Pagamento fictício'),
(3,'2026-10-29 16:00:00',150.00,'pix','Pagamento fictício');

-- Exemplos de cadastro de compra/estoque (fictícios).
INSERT INTO fornecedor (nome, telefone, email)
VALUES ('Fornecedor Exemplo', '11998887777', 'fornecedor.exemplo@email.com');
INSERT INTO insumo (nome, unidade_medida, quantidade_estoque, estoque_minimo)
VALUES ('Coloração exemplo', 'unidade', 0, 2);
INSERT INTO compra (id_fornecedor, observacoes)
VALUES (1, 'Compra fictícia para teste');
INSERT INTO item_compra (id_compra, id_insumo, quantidade, valor_unitario)
VALUES (1, 1, 5.000, 18.50);

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

-- 7. Insumos abaixo do estoque mínimo
SELECT nome, quantidade_estoque, estoque_minimo
FROM insumo
WHERE quantidade_estoque <= estoque_minimo
ORDER BY nome;

-- 8. Compras com fornecedor e itens
SELECT c.id_compra, c.data_compra, f.nome AS fornecedor,
       i.nome AS insumo, ic.quantidade, ic.valor_unitario,
       (ic.quantidade * ic.valor_unitario) AS subtotal
FROM compra c
JOIN fornecedor f ON f.id_fornecedor = c.id_fornecedor
JOIN item_compra ic ON ic.id_compra = c.id_compra
JOIN insumo i ON i.id_insumo = ic.id_insumo
ORDER BY c.data_compra DESC;

-- 9. Exemplo de fechamento de caixa para um período:
-- CALL fechar_caixa('2026-10-01', '2026-10-31');
-- SELECT * FROM fechamento_caixa ORDER BY data_fechamento DESC;

-- EXEMPLOS DE ALTERAÇÃO (execute separadamente em ambiente de teste)
-- UPDATE agendamento SET status = 'cancelado' WHERE id_agendamento = 2;
-- INSERT INTO movimentacao_estoque (id_insumo, tipo, quantidade, observacoes)
-- VALUES (1, 'consumo', 1.000, 'Consumo fictício de insumo');

-- VERIFICAÇÕES DE INTEGRIDADE (esperado: zero linhas)
SELECT a.* FROM agendamento a
LEFT JOIN cliente c ON c.id_cliente = a.id_cliente
WHERE c.id_cliente IS NULL;

SELECT pg.* FROM pagamento pg
LEFT JOIN agendamento a ON a.id_agendamento = pg.id_agendamento
WHERE a.id_agendamento IS NULL;
