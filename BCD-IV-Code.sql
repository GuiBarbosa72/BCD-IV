CREATE DATABASE logiflow_db;
USE logiflow_db;

-- ============================================================================
-- 1. CRIAÇÃO DAS TABELAS (DDL)
-- ============================================================================

CREATE TABLE clientes (
id_cliente INT AUTO_INCREMENT PRIMARY KEY,
razao_social VARCHAR(100) NOT NULL,
cnpj VARCHAR(18) NOT NULL UNIQUE,
email VARCHAR(100) NOT NULL,
telefone VARCHAR(20)
);

CREATE TABLE hubs (
id_hub INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(50) NOT NULL,
cidade VARCHAR(50) NOT NULL,
estado CHAR(2) NOT NULL
);

CREATE TABLE motoristas (
id_motorista INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(100) NOT NULL,
cpf VARCHAR(14) NOT NULL UNIQUE,
tipo_vinculo VARCHAR(20) NOT NULL,
chave_pix VARCHAR(100) NOT NULL
);

-- Tabela de veículos (Atende a 4FN)
CREATE TABLE motorista_veiculos (
id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
id_motorista INT NOT NULL,
placa VARCHAR(10) NOT NULL,
modelo VARCHAR(30) NOT NULL,
FOREIGN KEY (id_motorista) REFERENCES motoristas(id_motorista) ON DELETE CASCADE
);

-- Tabela de turnos (Atende a 4FN)
CREATE TABLE motorista_turnos (
id_turno INT AUTO_INCREMENT PRIMARY KEY,
id_motorista INT NOT NULL,
dia_semana VARCHAR(20) NOT NULL,
turno VARCHAR(10) NOT NULL,
FOREIGN KEY (id_motorista) REFERENCES motoristas(id_motorista) ON DELETE CASCADE
);

CREATE TABLE encomendas (
id_encomenda INT AUTO_INCREMENT PRIMARY KEY,
codigo_rastreio VARCHAR(20) NOT NULL UNIQUE,
id_cliente INT NOT NULL,
id_hub INT NOT NULL,
id_motorista INT,
valor_frete DECIMAL(10,2) NOT NULL,
valor_repasse DECIMAL(10,2) NOT NULL,
status_atual VARCHAR(20) DEFAULT 'Pendente',
data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
FOREIGN KEY (id_hub) REFERENCES hubs(id_hub),
FOREIGN KEY (id_motorista) REFERENCES motoristas(id_motorista)
);

CREATE TABLE historico_rastreamento (
id_historico INT AUTO_INCREMENT PRIMARY KEY,
id_encomenda INT NOT NULL,
status_registrado VARCHAR(50) NOT NULL,
descricao VARCHAR(200),
data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (id_encomenda) REFERENCES encomendas(id_encomenda) ON DELETE CASCADE
);

CREATE TABLE repasses_financeiros (
id_repasse INT AUTO_INCREMENT PRIMARY KEY,
id_motorista INT NOT NULL,
valor_total DECIMAL(10,2) NOT NULL,
status_pagamento VARCHAR(20) DEFAULT 'Pendente',
data_processamento DATE NOT NULL,
FOREIGN KEY (id_motorista) REFERENCES motoristas(id_motorista)
);

-- ============================================================================
-- 2. INSERÇÃO DE DADOS (DML)
-- ============================================================================

INSERT INTO clientes (razao_social, cnpj, email, telefone) VALUES
('TechStore Eletronicos', '12.345.678/0001-90', 'contato@techstore.com', '11988887777'),
('Moda Viva E-commerce', '98.765.432/0001-10', 'logistica@modaviva.com', '21977776666'),
('Livraria Saber', '45.678.912/0001-33', 'atendimento@saber.com', '31966665555'),
('Mercado EcoVida', '33.222.111/0001-55', 'pedidos@ecovida.com', '41955554444'),
('Games & Cia', '77.888.999/0001-22', 'suporte@gamescia.com', '51944443333');

INSERT INTO hubs (nome, cidade, estado) VALUES
('Hub SP', 'São Paulo', 'SP'),
('Hub RJ', 'Rio de Janeiro', 'RJ'),
('Hub BH', 'Belo Horizonte', 'MG'),
('Hub Curitiba', 'Curitiba', 'PR'),
('Hub POA', 'Porto Alegre', 'RS');

INSERT INTO motoristas (nome, cpf, tipo_vinculo, chave_pix) VALUES
('Carlos Silva', '111.222.333-44', 'Parceiro', 'carlos@pix.com'),
('Mariana Oliveira', '555.666.777-88', 'Proprio', 'mariana@pix.com'),
('Roberto Souza', '999.888.777-66', 'Parceiro', 'roberto@pix.com'),
('Fernanda Lima', '222.333.444-55', 'Proprio', 'fernanda@pix.com'),
('Lucas Mendes', '444.555.666-77', 'Parceiro', 'lucas@pix.com');

INSERT INTO motorista_veiculos (id_motorista, placa, modelo) VALUES
(1, 'ABC-1234', 'Fiorino'),
(1, 'XYZ-9876', 'Moto Cargo'),
(2, 'DEF-5678', 'Van Sprinter'),
(3, 'GHI-9012', 'Kangoo'),
(4, 'JKL-3456', 'Van Master');

INSERT INTO motorista_turnos (id_motorista, dia_semana, turno) VALUES
(1, 'Segunda-feira', 'Manhã'),
(1, 'Quarta-feira', 'Tarde'),
(2, 'Segunda-feira', 'Integral'),
(3, 'Terça-feira', 'Manhã'),
(4, 'Quinta-feira', 'Integral');

INSERT INTO encomendas (codigo_rastreio, id_cliente, id_hub, id_motorista, valor_frete, valor_repasse, status_atual) VALUES
('LOG-001', 1, 1, 1, 45.00, 25.00, 'Entregue'),
('LOG-002', 1, 1, 1, 30.00, 15.00, 'Entregue'),
('LOG-003', 2, 2, 2, 60.00, 35.00, 'Em Transito'),
('LOG-004', 3, 3, 3, 25.00, 12.00, 'Entregue'),
('LOG-005', 4, 4, 4, 80.00, 50.00, 'Pendente');

INSERT INTO historico_rastreamento (id_encomenda, status_registrado, descricao) VALUES
(1, 'Recebido no Hub', 'Chegou ao Hub SP'),
(1, 'Em Rota', 'Saiu para entrega'),
(1, 'Entregue', 'Entregue ao cliente'),
(2, 'Recebido no Hub', 'Chegou ao Hub SP'),
(2, 'Entregue', 'Entregue ao cliente');

INSERT INTO repasses_financeiros (id_motorista, valor_total, status_pagamento, data_processamento) VALUES
(1, 40.00, 'Pago', '2026-02-16'),
(2, 35.00, 'Pendente', '2026-02-16'),
(3, 12.00, 'Pago', '2026-02-16'),
(4, 0.00, 'Pendente', '2026-02-16'),
(5, 0.00, 'Pendente', '2026-02-16');

-- ============================================================================
-- 3. CONSULTAS DE TESTE (15 CONSULTAS)
-- ============================================================================

-- 1. Listar encomendas e seus clientes
SELECT e.codigo_rastreio, c.razao_social, e.valor_frete, e.status_atual
FROM encomendas e
JOIN clientes c ON e.id_cliente = c.id_cliente;

-- 2. Total gasto por cliente em frete
SELECT c.razao_social, SUM(e.valor_frete) AS total_frete
FROM clientes c
JOIN encomendas e ON c.id_cliente = e.id_cliente
GROUP BY c.razao_social;

-- 3. Total a repassar por motorista para entregas concluídas
SELECT m.nome, SUM(e.valor_repasse) AS total_repasse
FROM motoristas m
JOIN encomendas e ON m.id_motorista = e.id_motorista
WHERE e.status_atual = 'Entregue'
GROUP BY m.nome;

-- 4. Histórico de rastreamento da encomenda 'LOG-001'
SELECT e.codigo_rastreio, h.status_registrado, h.descricao, h.data_atualizacao
FROM encomendas e
JOIN historico_rastreamento h ON e.id_encomenda = h.id_encomenda
WHERE e.codigo_rastreio = 'LOG-001';

-- 5. Filtrar encomendas por faixa de valor do frete
SELECT codigo_rastreio, valor_frete, status_atual
FROM encomendas
WHERE valor_frete BETWEEN 30.00 AND 70.00;

-- 6. Buscar cliente por nome parcial
SELECT razao_social, email
FROM clientes
WHERE razao_social LIKE '%Store%';

-- 7. Contar encomendas por status
SELECT status_atual, COUNT(*) AS quantidade
FROM encomendas
GROUP BY status_atual;

-- 8. Média do valor do frete por Hub
SELECT h.nome AS hub, AVG(e.valor_frete) AS media_frete
FROM hubs h
JOIN encomendas e ON h.id_hub = e.id_hub
GROUP BY h.nome;

-- 9. Listar motoristas e seus veículos
SELECT m.nome, mv.placa, mv.modelo
FROM motoristas m
JOIN motorista_veiculos mv ON m.id_motorista = mv.id_motorista;

-- 10. Motoristas que possuem mais de um veículo
SELECT m.nome, COUNT(mv.id_veiculo) AS total_veiculos
FROM motoristas m
JOIN motorista_veiculos mv ON m.id_motorista = mv.id_motorista
GROUP BY m.nome
HAVING total_veiculos > 1;

-- 11. Encomendas pendentes ou em trânsito
SELECT codigo_rastreio, status_atual
FROM encomendas
WHERE status_atual IN ('Pendente', 'Em Transito');

-- 12. Todos os motoristas e a quantidade de encomendas associadas
SELECT m.nome, COUNT(e.id_encomenda) AS total_encomendas
FROM motoristas m
LEFT JOIN encomendas e ON m.id_motorista = e.id_motorista
GROUP BY m.nome;

-- 13. Repasses financeiros pagos
SELECT r.id_repasse, m.nome, r.valor_total, r.status_pagamento
FROM repasses_financeiros r
JOIN motoristas m ON r.id_motorista = m.id_motorista
WHERE r.status_pagamento = 'Pago';

-- 14. Lucro bruto da empresa por encomenda
SELECT codigo_rastreio, valor_frete, valor_repasse, (valor_frete - valor_repasse) AS lucro
FROM encomendas;

-- 15. Maior, menor e média de tarifa de frete
SELECT MAX(valor_frete) AS maior_frete, MIN(valor_frete) AS menor_frete, AVG(valor_frete) AS media_frete
FROM encomendas;
