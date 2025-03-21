-- (Fazer modelo conceitual e lógico também)
-- Contexto:
--  Você é responsável por criar um banco de dados para gerenciar uma pequena loja online (Small Mercado). 
-- A loja vende produtos e mantém registros de clientes e seus pedidos.


-- 1. Criar o banco de dados
CREATE DATABASE smallmercado;
USE smallmercado;




-- 2. Criar as tabelas

-- CLIENTES
CREATE TABLE clientes (
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome_cliente VARCHAR(100) NOT NULL,
    tel VARCHAR(20) ,
    email VARCHAR(100) UNIQUE
);

-- PRODUTOS
CREATE TABLE produtos (
	id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL
);

-- PEDIDOS
CREATE TABLE pedidos (
	id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_cliente INT,
    data_pedido DATE NOT NULL,
    
    FOREIGN KEY (fk_id_cliente)
    REFERENCES clientes(id_cliente)
);

-- ITENSPEDIDOS
CREATE TABLE itens_pedidos (
	id_item INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_pedido INT,
    fk_id_produto INT,
    quant INT NOT NULL,
    
    FOREIGN KEY (fk_id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (fk_id_produto) REFERENCES produtos(id_produto)
);

-- RENAME TABLE itens_pedido TO itens_pedidos;


-- VERIFICANDO AS TABELAS CRIADAS
DESC clientes;
DESC produtos;
DESC pedidos;
DESC itens_pedidos;






-- 3. Inserir dados nas tabelas

-- CLientes
INSERT INTO clientes (nome_cliente, email, tel) VALUES 
('João Silva', 'joao@gmail.com', '112233444'),
('Maria Oliveira', 'maria.oliveria@gmail.com', '987654321'),
('Carlos Souza', 'souza.21@gmail.com', '456123789');

-- Produtos
INSERT INTO produtos (nome_produto, preco, estoque) VALUES
('Notebook', 3500.00, 10),
('Mouse', 50.00, 10),
('Teclado', 150.00, 50),
('Monitor', 800.00, 35);


-- Pedidos
INSERT INTO pedidos (fk_id_cliente, data_pedido) VALUES
(1, '2024-12-01'),
(2, '2024-12-02');


-- Itens_Pedidos
INSERT INTO itens_pedidos (fk_id_pedido, fk_id_produto, quant) VALUES
(1, 1, 1), -- João Comprou 1 Notebook
(1, 2, 2), -- João Comprou 2 Mouses
(2, 3, 1); -- Maria comprou 1 Teclado


SELECT * FROM clientes;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM itens_pedidos;




-- 4. Fazendo consultas práticas


-- A. Liste todos os clientes cadastrados
SELECT nome_cliente, tel, email FROM clientes;

-- B. Liste todos os produtos com estoque acima de 20 unidades;
SELECT * FROM produtos
WHERE estoque > 20;

-- C. Encontre os pedidos realizados no dia '2024-12-01':
SELECT * FROM pedidos
WHERE data_pedido = '2024-12-01';


-- (A partir daqui são exercícios após compreender a FASE 3.)
-- D. Liste todos os produtos comprados por 'João Silva'. Inclua o nome do produto, quantidade e preço:

-- E. Atualize o estoque do produto "Mouse" subtraindo a quantidade comprada (2 unidades):

-- F. Exclua o cliente com ID 3 ('Carlos Souza'):