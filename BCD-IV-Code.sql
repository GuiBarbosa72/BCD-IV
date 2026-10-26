CREATE DATABASE IF NOT EXISTS concessionaria;
USE concessionaria;

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(18) NOT NULL UNIQUE,
    telefone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE vendedor (
    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    comissao_percentual DECIMAL(4,2) NOT NULL
);

CREATE TABLE veiculo (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    chassi VARCHAR(17) NOT NULL UNIQUE,
    modelo VARCHAR(50) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    ano_fabricacao INT NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Disponível'
);

CREATE TABLE venda (
    id_venda INT AUTO_INCREMENT PRIMARY KEY,
    data_venda DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    id_cliente INT NOT NULL,
    id_vendedor INT NOT NULL,
    id_veiculo INT NOT NULL UNIQUE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_vendedor) REFERENCES vendedor(id_vendedor),
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo)
);

CREATE TABLE ordem_servico (
    id_os INT AUTO_INCREMENT PRIMARY KEY,
    data_abertura DATE NOT NULL,
    descricao_problema TEXT,
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    id_veiculo INT NOT NULL,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE servico (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    nome_servico VARCHAR(100) NOT NULL,
    preco_tabela DECIMAL(10,2) NOT NULL
);

CREATE TABLE item_os (
    id_os INT NOT NULL,
    id_servico INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    preco_praticado DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_os, id_servico),
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os),
    FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);

INSERT INTO cliente (nome, cpf_cnpj, telefone, email) VALUES
('Carlos Silva', '111.222.333-44', '(11) 98765-4321', 'carlos@email.com'),
('Ana Maria Souza', '222.333.444-55', '(11) 97654-3210', 'ana.souza@email.com'),
('Empresa Logística LTDA', '12.345.678/0001-99', '(11) 3333-4444', 'contato@logistica.com'),
('Roberto Santos', '444.555.666-77', '(21) 99887-6655', 'roberto@email.com'),
('Mariana Lima', '555.666.777-88', '(31) 98877-1122', 'mariana@email.com');

INSERT INTO vendedor (nome, cpf, comissao_percentual) VALUES
('João Pereira', '123.456.789-01', 2.50),
('Beatriz Costa', '234.567.890-12', 3.00),
('Fernando Oliveira', '345.678.901-23', 2.50),
('Patricia Rocha', '456.789.012-34', 2.80),
('Lucas Mendes', '567.890.123-45', 3.00);

INSERT INTO veiculo (chassi, modelo, marca, ano_fabricacao, preco, status) VALUES
('9BWZZZ377VT001001', 'Onix', 'Chevrolet', 2023, 75000.00, 'Vendido'),
('9BWZZZ377VT001002', 'Corolla', 'Toyota', 2024, 150000.00, 'Vendido'),
('9BWZZZ377VT001003', 'Civic', 'Honda', 2022, 130000.00, 'Vendido'),
('9BWZZZ377VT001004', 'Compass', 'Jeep', 2024, 180000.00, 'Vendido'),
('9BWZZZ377VT001005', 'HB20', 'Hyundai', 2023, 70000.00, 'Vendido'),
('9BWZZZ377VT001006', 'Renegade', 'Jeep', 2024, 125000.00, 'Disponível');

INSERT INTO venda (data_venda, valor_total, id_cliente, id_vendedor, id_veiculo) VALUES
('2026-01-15', 75000.00, 1, 1, 1),
('2026-01-20', 150000.00, 2, 2, 2),
('2026-02-10', 130000.00, 3, 1, 3),
('2026-02-15', 180000.00, 4, 3, 4),
('2026-03-01', 70000.00, 5, 4, 5);

INSERT INTO servico (nome_servico, preco_tabela) VALUES
('Troca de Óleo e Filtro', 250.00),
('Alinhamento e Balanceamento', 180.00),
('Revisão de Freios', 350.00),
('Higienização de Ar Condicionado', 150.00),
('Troca de Correia Dentada', 600.00);

INSERT INTO ordem_servico (data_abertura, descricao_problema, valor_total, id_veiculo, id_cliente) VALUES
('2026-03-10', 'Revisão periódica de 10.000km', 430.00, 1, 1),
('2026-03-12', 'Barulho ao frear e direção puxando', 530.00, 2, 2),
('2026-03-15', 'Troca de óleo preventiva', 250.00, 3, 3),
('2026-03-20', 'Ar condicionado com mau cheiro', 150.00, 4, 4),
('2026-03-22', 'Revisão geral e troca de correia', 950.00, 5, 5);

INSERT INTO item_os (id_os, id_servico, quantidade, preco_praticado) VALUES
(1, 1, 1, 250.00),
(1, 2, 1, 180.00),
(2, 2, 1, 180.00),
(2, 3, 1, 350.00),
(3, 1, 1, 250.00),
(4, 4, 1, 150.00),
(5, 3, 1, 350.00),
(5, 5, 1, 600.00);

-- Consulta 1: Listar vendas com nome do cliente, vendedor e veículo
SELECT v.id_venda, v.data_venda, c.nome AS cliente, vd.nome AS vendedor, vei.modelo, v.valor_total
FROM venda v
INNER JOIN cliente c ON v.id_cliente = c.id_cliente
INNER JOIN vendedor vd ON v.id_vendedor = vd.id_vendedor
INNER JOIN veiculo vei ON v.id_veiculo = vei.id_veiculo;

-- Consulta 2: Veículos disponíveis ou abaixo de R$ 130.000,00
SELECT marca, modelo, ano_fabricacao, preco 
FROM veiculo 
WHERE status = 'Disponível' OR preco < 130000.00;

-- Consulta 3: Buscar clientes com "Souza" ou "Silva"
SELECT * FROM cliente 
WHERE nome LIKE '%Silva%' OR nome LIKE '%Souza%';

-- Consulta 4: Total de vendas e faturamento por vendedor
SELECT vd.nome AS vendedor, COUNT(v.id_venda) AS total_vendas, SUM(v.valor_total) AS faturamento
FROM venda v
INNER JOIN vendedor vd ON v.id_vendedor = vd.id_vendedor
GROUP BY vd.nome;

-- Consulta 5: Vendas realizadas no primeiro bimestre de 2026
SELECT id_venda, data_venda, valor_total 
FROM venda 
WHERE data_venda BETWEEN '2026-01-01' AND '2026-02-28'
ORDER BY data_venda ASC;

-- Consulta 6: Comissões a serem pagas por venda
SELECT v.id_venda, vd.nome AS vendedor, v.valor_total,
       ROUND((v.valor_total * vd.comissao_percentual / 100), 2) AS comissao_receber
FROM venda v
INNER JOIN vendedor vd ON v.id_vendedor = vd.id_vendedor;

-- Consulta 7: Média do valor das Ordens de Serviço
SELECT ROUND(AVG(valor_total), 2) AS media_valor_os 
FROM ordem_servico;

-- Consulta 8: Ordens de serviço ordenadas pelo maior valor
SELECT os.id_os, c.nome AS cliente, vei.modelo, os.valor_total
FROM ordem_servico os
INNER JOIN cliente c ON os.id_cliente = c.id_cliente
INNER JOIN veiculo vei ON os.id_veiculo = vei.id_veiculo
ORDER BY os.valor_total DESC;

-- Consulta 9: Veículos com histórico de ordem de serviço
SELECT vei.modelo, vei.chassi, os.data_abertura, os.descricao_problema
FROM ordem_servico os
INNER JOIN veiculo vei ON os.id_veiculo = vei.id_veiculo;

-- Consulta 10: Vendedores com faturamento total superior a R$ 100.000,00
SELECT vd.nome, SUM(v.valor_total) AS faturamento_total
FROM venda v
INNER JOIN vendedor vd ON v.id_vendedor = vd.id_vendedor
GROUP BY vd.nome
HAVING SUM(v.valor_total) > 100000.00;

-- Consulta 11: Serviços executados que custam mais de R$ 200,00
SELECT DISTINCT s.nome_servico, s.preco_tabela
FROM servico s
INNER JOIN item_os io ON s.id_servico = io.id_servico
WHERE s.preco_tabela > 200.00;

-- Consulta 12: Contagem de veículos por marca
SELECT marca, COUNT(*) AS quantidade_veiculos 
FROM veiculo 
GROUP BY marca;

-- Consulta 13: Detalhamento dos itens da Ordem de Serviço 5
SELECT os.id_os, s.nome_servico, io.quantidade, io.preco_praticado
FROM item_os io
INNER JOIN servico s ON io.id_servico = s.id_servico
INNER JOIN ordem_servico os ON io.id_os = os.id_os
WHERE os.id_os = 5;

-- Consulta 14: Clientes sem Ordem de Serviço
SELECT c.nome, c.telefone, c.email
FROM cliente c
LEFT JOIN ordem_servico os ON c.id_cliente = os.id_cliente
WHERE os.id_os IS NULL;

-- Consulta 15: Veículo mais caro cadastrado
SELECT marca, modelo, ano_fabricacao, preco 
FROM veiculo 
WHERE preco = (SELECT MAX(preco) FROM veiculo);
