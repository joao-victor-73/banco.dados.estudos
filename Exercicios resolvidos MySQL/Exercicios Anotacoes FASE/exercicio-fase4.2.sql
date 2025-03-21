USE aptvendas;

SELECT * FROM produtos;
SELECT * FROM categorias;
SELECT * FROM pedidos;
SELECT * FROM clientes;

UPDATE pedidos
SET fk_id_cliente = NULL
WHERE id_pedido = 19;

SELECT * FROM pedidos;

-- ==========================================================================================================================================


-- 4.1. INNER JOIN
-- o	Liste os nomes dos clientes, os produtos comprados e a quantidade adquirida.
SELECT c.nome_cliente, p.nome_produto, pe.quant FROM pedidos pe
INNER JOIN clientes c ON pe.fk_id_cliente = c.id_cliente
INNER JOIN produtos p ON pe.fk_id_produto = p.id_produto;


-- 4.2. LEFT JOIN
-- o	Liste todos os clientes e, caso tenham realizado pedidos, mostre os produtos comprados. Inclua os clientes que não fizeram pedidos.
SELECT 
	c.nome_cliente, 
    COALESCE(p.nome_produto, 'Nenhum pedido') AS produto_comprado 
FROM clientes c
LEFT JOIN pedidos pe 
	ON c.id_cliente = pe.fk_id_cliente
		LEFT JOIN produtos p 
			ON pe.fk_id_produto = p.id_produto;
            
									-- COALESCE é uma função SQL usada para lidar com valores NULL. 
									-- Ela retorna o primeiro valor não nulo de uma lista de argumentos.


-- 4.3. RIGHT JOIN
-- o	Liste todos os produtos e, caso tenham sido comprados, exiba o nome do cliente que os adquiriu.
SELECT 
	c.nome_cliente,
    COALESCE(p.nome_produto, 'Nenhum pedido') AS produto_comprado
FROM produtos p
RIGHT JOIN pedidos pe
	ON p.id_produto = pe.fk_id_produto
		RIGHT JOIN clientes c
			ON c.id_cliente = pe.fk_id_cliente;
            

-- 4.4. FULL JOIN
-- o	Liste todos os clientes e todos os produtos, mesmo que não tenham relação entre si.


-- 4.5. COMBINANDO JOINs COM CONDIÇÕES ADICIONAIS
-- o	Listar os nomes dos clientes, com a soma de preços acima de R$ 400:

SELECT 
	c.nome_cliente, 
    p.nome_produto, 
    SUM(p.preco * pe.quant) AS gasto_total
FROM pedidos pe
INNER JOIN clientes c 
	ON pe.fk_id_cliente = c.id_cliente
		INNER JOIN produtos p 
			ON pe.fk_id_produto = p.id_produto
GROUP BY nome_cliente, nome_produto
HAVING gasto_total > 2000;

-- o	Liste os nomes dos clientes que compraram produtos cujo preço seja maior que R$ 2.000, mostrando também o nome do produto e o valor total da compra (quantidade * preço).



-- 4.7. DESAFIO EXTRA
-- Crie uma consulta que mostre o valor total de vendas por cliente. Para clientes que não realizaram pedidos, mostre o valor total como 0.00.
SELECT 
	c.nome_cliente AS 'Cliente',
    COALESCE(p.nome_produto, 'Nenhum pedido') AS 'Produto',
    COALESCE(SUM(p.preco * pe.quant), 0.00) AS  total_vendas
FROM clientes c
LEFT JOIN pedidos pe
	ON c.id_cliente = pe.fk_id_cliente
		LEFT JOIN produtos p
			ON pe.fk_id_produto = p.id_produto
GROUP BY c.id_cliente, c.nome_cliente, p.nome_produto;