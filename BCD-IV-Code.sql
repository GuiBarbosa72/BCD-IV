-- ==========================================
-- 1. CRIAÇÃO DAS TABELAS (DDL)
-- ==========================================

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE hubs (
    id_hub SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL
);

CREATE TABLE motoristas (
    id_motorista SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    tipo_vinculo VARCHAR(20) CHECK (tipo_vinculo IN ('Proprio', 'Parceiro')),
    status VARCHAR(20) DEFAULT 'Ativo' CHECK (status IN ('Ativo', 'Inativo', 'Em Entrega')),
    chave_pix VARCHAR(100)
);

CREATE TABLE encomendas (
    id_encomenda SERIAL PRIMARY KEY,
    codigo_rastreio VARCHAR(20) UNIQUE NOT NULL,
    id_cliente INT REFERENCES clientes(id_cliente),
    id_hub_origem INT REFERENCES hubs(id_hub),
    id_motorista INT REFERENCES motoristas(id_motorista),
    valor_frete DECIMAL(10,2) NOT NULL,
    valor_repasse_motorista DECIMAL(10,2) NOT NULL,
    status_atual VARCHAR(30) DEFAULT 'Pendente' CHECK (status_atual IN ('Pendente', 'Em Transito', 'Entregue', 'Falha')),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE historico_rastreamento (
    id_historico SERIAL PRIMARY KEY,
    id_encomenda INT REFERENCES encomendas(id_encomenda),
    status_registrado VARCHAR(50) NOT NULL,
    descricao VARCHAR(255),
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE repasses_financeiros (
    id_repasse SERIAL PRIMARY KEY,
    id_motorista INT REFERENCES motoristas(id_motorista),
    periodo_inicio DATE NOT NULL,
    periodo_fim DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    status_pagamento VARCHAR(20) DEFAULT 'Pendente' CHECK (status_pagamento IN ('Pendente', 'Pago'))
);

-- ==========================================
-- 2. INSERÇÃO DE DADOS DE TESTE (DML)
-- ==========================================

INSERT INTO clientes (razao_social, cnpj, email, telefone) VALUES
('TechStore Eletronicos Ltda', '12.345.678/0001-90', 'contato@techstore.com', '11988887777'),
('Moda Viva E-commerce', '98.765.432/0001-10', 'logistica@modaviva.com', '21977776666');

INSERT INTO hubs (nome, cidade, estado) VALUES
('Hub Central SP', 'São Paulo', 'SP'),
('Hub Rio Express', 'Rio de Janeiro', 'RJ');

INSERT INTO motoristas (nome, cpf, tipo_vinculo, status, chave_pix) VALUES
('Carlos Eduardo Silva', '111.222.333-44', 'Parceiro', 'Ativo', 'carlos@pix.com'),
('Mariana Oliveira', '555.666.777-88', 'Proprio', 'Em Entrega', 'mariana@pix.com');

INSERT INTO encomendas (codigo_rastreio, id_cliente, id_hub_origem, id_motorista, valor_frete, valor_repasse_motorista, status_atual) VALUES
('LOG-2026-001', 1, 1, 1, 45.00, 25.00, 'Entregue'),
('LOG-2026-002', 1, 1, 1, 30.00, 15.00, 'Entregue'),
('LOG-2026-003', 2, 2, 2, 60.00, 35.00, 'Em Transito');

INSERT INTO historico_rastreamento (id_encomenda, status_registrado, descricao) VALUES
(1, 'Recebido no Hub', 'Pacote chegou ao Hub Central SP'),
(1, 'Em Rota de Entrega', 'Saiu para entrega com o motorista Carlos'),
(1, 'Entregue', 'Entregue ao destinatário final'),
(2, 'Recebido no Hub', 'Pacote chegou ao Hub Central SP'),
(2, 'Entregue', 'Entregue ao destinatário final'),
(3, 'Em Rota de Entrega', 'Saiu para entrega com a motorista Mariana');

-- ==========================================
-- 3. QUERIES DE TESTE E VALIDAÇÃO (ANALÍTICAS)
-- ==========================================

-- Teste 1: Calcular o valor total a ser pago a cada motorista parceiro por entregas concluídas
SELECT 
    m.id_motorista,
    m.nome AS motorista,
    COUNT(e.id_encomenda) AS total_entregas,
    SUM(e.valor_repasse_motorista) AS total_a_receber
FROM motoristas m
JOIN encomendas e ON m.id_motorista = e.id_motorista
WHERE e.status_atual = 'Entregue'
GROUP BY m.id_motorista, m.nome;

-- Teste 2: Consultar o histórico completo de rastreamento de uma encomenda específica
SELECT 
    e.codigo_rastreio,
    c.razao_social AS cliente,
    h.status_registrado,
    h.descricao,
    h.data_atualizacao
FROM encomendas e
JOIN clientes c ON e.id_cliente = c.id_cliente
JOIN historico_rastreamento h ON e.id_encomenda = h.id_encomenda
WHERE e.codigo_rastreio = 'LOG-2026-001'
ORDER BY h.data_atualizacao ASC;