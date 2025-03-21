-- AGRUPAMENTO E FILTRAGEM (EXERCÍCIO PRÁTICO 01)

-- CENÁRIO:
-- uma loja online que gerencia dados sobre clientes, produtos, pedidos e categorias. 
-- O objetivo é realizar agrupamentos, aplicar filtragens e utilizar funções de 
-- agregação para responder a questões importantes do negócio.

-- =====================================================================================

CREATE DATABASE aptvendas;
use aptvendas;

-- 1. CRIAÇÃO DAS TABELAS

-- Clientes
CREATE TABLE clientes (
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome_cliente VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL
);

-- Categorias
CREATE TABLE categorias (
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome_categoria VARCHAR(100) NOT NULL
);

-- Produtos
CREATE TABLE produtos (
	id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(200) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    fk_id_categoria INT,
    
    CONSTRAINT fk_produto_categoria
    FOREIGN KEY (fk_id_categoria) REFERENCES categorias(id_categoria)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Pedidos
CREATE TABLE pedidos (
	id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_cliente INT,
    fk_id_produto INT,
    quant INT NOT NULL,
    data_pedido DATE NOT NULL,
    
    CONSTRAINT fk_pedido_cliente
    FOREIGN KEY (fk_id_cliente) REFERENCES clientes(id_cliente)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
        
	CONSTRAINT fk_pedido_produto
    FOREIGN KEY (fk_id_produto) REFERENCES produtos(id_produto)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);


-- 2. INSERÇÃO DE REGISTROS

INSERT INTO clientes (nome_cliente, cidade) VALUES
('João Silva', 'São Paulo'),
('Maria Oliveira', 'Belo Horizonte'),
('Pedro Santos', 'Rio de Janeiro'),
('Ana Costa', 'Salvador');

SELECT * FROM clientes;

INSERT INTO categorias (nome_categoria) VALUES
('Eletrônicos'),
('Vestuário'),
('Eletrodomésticos');

INSERT INTO categorias (nome_categoria) VALUES
('Móveis');

SELECT * FROM categorias;

INSERT INTO produtos (nome_produto, preco, fk_id_categoria) VALUES
("Celular Samsung", 1500.00, 1),
('Notebook Dell', 3500.00, 1),
('Camisa Polo', 80.00, 2),
('Geladeira Brastemp', 2400.00, 3);

INSERT INTO produtos (nome_produto, preco, fk_id_categoria) VALUES 
('TV LG', 3200.00, 1);


SELECT * FROM produtos;

INSERT INTO pedidos (fk_id_cliente, fk_id_produto, quant, data_pedido) VALUES
(1, 5, 2, '2025-01-15'),
(2, 7, 3, '2025-01-16'),
(3, 6, 1, '2025-01-17'),
(4, 8, 1, '2025-01-18'),
(1, 7, 2, '2025-01-19');

SELECT * FROM pedidos;

-- ==========================================================================================================================================================================


-- 3. CONSULTAS PRÁTICAS

-- P.1 = Análise de produtos
-- a. Liste todas as categorias e o total de produtos disponíveis em cada uma.
SELECT c.nome_categoria AS 'Categoria', COUNT(p.id_produto) AS 'Total de Produtos'
FROM categorias c
LEFT JOIN produtos p ON c.id_categoria = p.fk_id_categoria
GROUP BY c.id_categoria, c.nome_categoria;


-- b. Calcule o preço médio dos produtos em cada categoria.
SELECT c.nome_categoria, ROUND(AVG(p.preco), 2) AS preco_medio
FROM categorias c
LEFT JOIN produtos p ON c.id_categoria = p.fk_id_categoria
GROUP BY c.id_categoria, c.nome_categoria;


-- c. Encontre as categorias onde o preço médio dos produtos é maior que 1000.
SELECT c.nome_categoria, ROUND(AVG(p.preco), 2) AS preco_medio
FROM categorias c
LEFT JOIN produtos p ON c.id_categoria = p.fk_id_categoria
GROUP BY c.id_categoria, c.nome_categoria
HAVING AVG(p.preco) > 1000;


-- ==========================================================================================================================================================================

-- P.2 = Análise de Pedidos
-- d. Liste o total de produtos vendidos agrupados por cliente (use o nome do cliente).
-- e. Calcule a quantidade total de produtos vendidos agrupados por categoria.
-- f. Mostre apenas os clientes que compraram mais de 2 produtos no total.
-- g. Encontre o total de vendas (quantidade * preço) para cada cliente e ordene do maior para o menor.

-- ==========================================================================================================================================================================

-- P.3 = Filtragens Avançadas
-- h. Liste os pedidos realizados entre as datas 2025-01-16 e 2025-01-18.
-- i. Mostre os clientes que compraram produtos da categoria "Eletrônicos".
-- j. Exiba as categorias de produtos que não foram vendidos.

-- ==========================================================================================================================================================================

-- P.4 = Desafios Avançados
-- 1.	Calcule a receita total gerada por cada categoria de produto.
-- 2.	Encontre os produtos mais vendidos (com maior quantidade total) e os menos vendidos.
-- 3.	Liste os clientes que realizaram pedidos em mais de uma data diferente.

