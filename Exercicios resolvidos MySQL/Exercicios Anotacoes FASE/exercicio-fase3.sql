-- Criando a base de dados para o exercicio
CREATE DATABASE smallmercado_2;
USE smallmercado_2;


-- 1. Criação das tabelas:

-- Produtos
CREATE TABLE produtos (
	id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(100) NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL
);

-- Clientes
CREATE TABLE clientes (
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome_cliente VARCHAR(100) NOT NULL,
	email VARCHAR(100) UNIQUE,
    cidade VARCHAR(100) NOT NULL
);


-- Vendas
CREATE TABLE vendas (
	id_vendas INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_cliente INT,
    fk_id_produto INT,
    quant INT NOT NULL,
    data_venda DATE NOT NULL,
    
    CONSTRAINT fk_cliente_vendas 
    FOREIGN KEY (fk_id_cliente) REFERENCES clientes(id_cliente)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Criando uma FK fora da criação da tabela, com ALTER TABLE
ALTER TABLE vendas
ADD CONSTRAINT fk_produto_vendas
FOREIGN KEY (fk_id_produto) REFERENCES produtos(id_produto)
	ON DELETE SET NULL
    ON UPDATE CASCADE;
    
-- Verificando as descrições das tabelas
DESC clientes;
DESC produtos;
DESC vendas;




-- 2. Inserção de Dados nas tabelas

INSERT INTO produtos (nome_produto, categoria, preco, estoque) VALUES
("Celular Samsung", "Eletronicos", 1500.00, 10),
('Notebook Dell', 'Eletronicos', 3500.00, 5),
('Camisa Polo', 'Vestuario', 80.00, 20),
('Geladeira Brastemp', 'Eletrodomesticos', 2400.00, 3);


INSERT INTO clientes (nome_cliente, email, cidade) VALUES
('João Silva', 'joao@gmail.com', 'São Paulo'),
('Maria Oliveira', 'maria@gmail.com', 'Belo Horizonte'),
('Carlos Santos', 'carlos@gamil.com', 'Rio de Janeiro');


INSERT INTO vendas (fk_id_cliente, fk_id_produto, quant, data_venda) VALUES
(1, 1, 1, '2025-01-20'),
(2, 3, 2, '2025-01-19'),
(3, 2, 1, '2025-01-18');



SELECT * FROM clientes;
SELECT * FROM produtos;
SELECT * FROM vendas;



-- 3. Consultas básicas


	-- 3.1 Consultando produtos:
    
		-- Liste todos os produtos da tabela produto.
		SELECT * FROM produtos;

		-- Mostre apenas os produtos da categoria "Eletrônicos".
		SELECT * FROM produtos
		WHERE categoria = "Eletronicos";

		-- Retorne os produtos cujo preço seja maior que R$ 1000, ordenados por preço em ordem decrescente.
		SELECT * FROM produtos
		WHERE preco > 1000.00
		ORDER BY preco DESC;

		-- Exiba o nome e o estoque dos produtos que possuem estoque maior que 5 unidades.
		SELECT nome_produto, estoque FROM produtos
		WHERE estoque > 5;



	-- 3.2 Consultando clientes:
    
		-- Liste o nome e a cidade de todos os clientes.
		SELECT nome_cliente, cidade FROM clientes;
	   
		-- Exiba os clientes que moram em "São Paulo" ou "Belo Horizonte".
		SELECT * FROM clientes
		WHERE cidade = "São Paulo" OR cidade = "Belo Horizonte";
		
		SELECT * FROM clientes
		WHERE cidade IN ('São Paulo', 'Belo Horizonte');
		
		-- Encontre o cliente com o e-mail maria@gmail.com.
		SELECT * FROM clientes
		WHERE email = 'maria@gmail.com';
    
    
    
    -- 3.3. Consultando Vendas
    
		-- Liste todas as vendas realizadas, exibindo o nome do cliente, o nome do produto e a quantidade.
        SELECT * FROM vendas;

		-- Filtre as vendas realizadas em 2025-01-19.
        SELECT * FROM vendas
        WHERE data_venda = '2025-01-19';

		-- Mostre as vendas de produtos da categoria "Eletrônicos".
        

		-- Calcule a quantidade total de produtos vendidos.


		-- Mostre a venda com a maior quantidade de produtos.


-- 4. Desafios Avançados

-- 4.1.	Use um alias para exibir os resultados das consultas com nomes mais amigáveis.
SELECT nome_cliente AS 'Nome do Cliente', email AS 'E-mail do Cliente' FROM clientes;

SELECT 
	nome_produto AS 'Nome do Produto', 
    categoria AS 'Categoria', 
    preco AS 'Preço', 
    estoque AS 'Em Estoque' 
FROM produtos;

-- 4.2.	Crie uma consulta que mostre o total arrecadado em cada venda (multiplicando o preço do produto pela quantidade).

-- Verificando todos os produtos vendidos ( a única vendida foi a "Geladeira Brastemp")
SELECT * FROM vendas
INNER JOIN produtos
	ON fk_id_produto = id_produto;

SELECT 
	p.nome_produto AS 'PRODUTO', 
	p.categoria AS 'CATEGORIA', 
    (p.estoque - v.quant) AS 'EM ESTOQUE', 
    (v.quant * p.preco) AS 'TOTAL ARRECADADO' 
FROM vendas V
INNER JOIN produtos as p
	ON fk_id_produto = id_produto;


-- 4.3.	Mostre os produtos que não foram vendidos.
SELECT 
	p.id_produto AS "COD. PRODUTO",
    p.nome_produto AS "NOME DO PRODUTO"
FROM produtos p
LEFT JOIN vendas v
	ON p.id_produto = v.fk_id_produto
WHERE v.fk_id_produto IS NULL;
