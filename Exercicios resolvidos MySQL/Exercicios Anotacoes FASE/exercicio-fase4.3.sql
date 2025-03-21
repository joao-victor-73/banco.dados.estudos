-- EXERCÍCIOS SUBCONSULTA
USE aptvendas;

DESC clientes;

-- Foi adicionado uma nova coluna na tabela 'produtos' para a prática do exercício:
ALTER TABLE produtos
ADD COLUMN estoque INT;

select * from produtos;

UPDATE produtos
SET estoque = 10
WHERE id_produto = 6;

UPDATE produtos
SET estoque = 15
WHERE id_produto = 5;

UPDATE produtos
SET estoque = 5
WHERE id_produto = 7;

UPDATE produtos
SET estoque = 8
WHERE id_produto = 9;


-- ==========================================================================================================================================

-- 4.1 o	Liste o id_pedido, o id_cliente e o valor total de cada pedido. Use uma subconsulta para calcular o valor total com base no preço do produto e na quantidade.
SELECT 
    pe.id_pedido,
    pe.fk_id_cliente AS id_cliente,
    (SELECT p.preco FROM produtos p WHERE p.id_produto = pe.fk_id_produto) * pe.quant AS valor_total
FROM pedidos pe;


-- 4.2. o	Liste os produtos cujo estoque está abaixo da média de todos os produtos.
SELECT 
    p.nome_produto,
    p.estoque
FROM produtos p
WHERE p.estoque < (SELECT AVG(estoque) FROM produtos);


-- 4.3. o	Liste os nomes e e-mails dos clientes que ainda não realizaram pedidos.
SELECT 
	c.nome_cliente,
    c.cidade
FROM clientes c
WHERE NOT EXISTS (
    SELECT 1
    FROM pedidos p
    WHERE p.fk_id_cliente = c.id_cliente
);
-- NOT EXISTS ignora valores NULL na subconsulta. Enquanto NOT IN leva em consideração os registros com NULL.


-- 4.4. o	Mostre o nome e o preço do produto mais caro da loja.
SELECT
	nome_produto,
    preco
FROM produtos
WHERE preco = (SELECT MAX(preco) FROM produtos);


-- 4.5. o	Liste os nomes dos clientes que compraram qualquer produto com preço acima de R$ 3.000.
SELECT DISTINCT
	c.nome_cliente
FROM clientes c
INNER JOIN pedidos pe ON c.id_cliente = pe.fk_id_cliente
WHERE pe.fk_id_produto IN (
	SELECT id_produto 
    FROM produtos p
    WHERE preco > 300
);

-- Consulta para verificar os produtos que foram vendidos:
SELECT 
	c.nome_cliente,
    p.preco
FROM clientes c
INNER JOIN pedidos pe ON c.id_cliente = pe.fk_id_cliente
INNER JOIN produtos p ON pe.fk_id_produto = p.id_produto;


-- 4.6. o	Liste os nomes dos produtos que foram pedidos no mês de janeiro de 2025.
SELECT * FROM pedidos;
SELECT * FROM produtos;

SELECT 
	nome_produto
FROM produtos p
WHERE id_produto IN (
	SELECT fk_id_produto 
    FROM pedidos 
    WHERE MONTH(data_pedido) = 1 AND YEAR(data_pedido) = 2025
);


-- 4.7. o	Verifique se existe algum pedido em que a quantidade solicitada seja maior do que o estoque do produto.
SELECT * FROM pedidos;
SELECT * FROM produtos;

SELECT 
	id_pedido, 
    fk_id_produto, quant
FROM pedidos
WHERE quant > (
    SELECT estoque FROM produtos WHERE produtos.id_produto = pedidos.fk_id_produto
);

-- 4.8. o	Liste o nome dos clientes e o número de pedidos que cada um realizou. Inclua os clientes que não realizaram pedidos (mostre como 0).
SELECT 
	nome_cliente,
    COALESCE(
		(SELECT COUNT(*) 
        FROM pedidos 
        WHERE pedidos.fk_id_cliente = clientes.id_cliente), 
        0) AS total_pedidos
FROM clientes;


-- 4.9. (Desafio Extra) 
-- o	Liste o nome de cada cliente e o valor total de todas as compras que ele realizou. Inclua clientes que não realizaram compras (mostre o valor como 0.00).
SELECT * FROM clientes;
SELECT * FROM pedidos;
SELECT * FROM produtos;

SELECT 
	c.nome_cliente,
    COALESCE((
		SELECT SUM(pe.quant * p.preco)
		FROM pedidos pe
		INNER JOIN produtos p ON pe.fk_id_produto = p.id_produto
        WHERE pe.fk_id_cliente = c.id_cliente
	), 0.00) AS total_compras
FROM clientes c;