-- |================================================================================================================================|
-- | Com base nessa base de dados ('bibli'), o ChatGPT criou alguns exercícios para eu práticar os conteúdos de MySQL a medida		|
-- | que eu ia conhecendo novos assuntos (subconsultas, JOINs, agrupamento e filtragem, e outros assuntos que foi visto mais		|
-- | a frente). Esse primeiro arquivo contém a criação das tabelas e a inserção de registros, como também 11 (onze) exercícios 	 	|
-- | que foram resolvidos. 																											|
-- | Atualmente temos três (3) arquivos de exercícios: exercicios_progressivos.sql / exercicios_progressivos_2.sql / 				|
-- | 												   exercicios_progressivos_3.sql 												|
-- |================================================================================================================================|

USE bibli;

-- ==============================================================================================================================
-- 													EXERCÍCIOS COM JOINs
-- ==============================================================================================================================

-- 1. Liste o nome dos usuários e os títulos dos livros que eles pegaram emprestados.
-- 	(Dica: JOIN entre usuarios, emprestimos e livros.)

SELECT
	u.nome,
    l.titulo,
    e.data_emprestimo
FROM usuarios u
INNER JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario
INNER JOIN livros l ON e.fk_id_livro = l.id_livro;

-- 2. Mostre o nome dos usuários que não pegaram nenhum livro emprestado.
-- 	(Dica: LEFT JOIN para incluir os usuários sem empréstimos.)
SELECT
	u.nome
FROM usuarios u
LEFT JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario
WHERE e.fk_id_usuario IS NULL;


-- 3. Liste os livros emprestados, mostrando o título, o nome do usuário que pegou emprestado e a data do empréstimo.
SELECT
	l.titulo,
    u.nome,
    e.data_emprestimo
FROM livros l
INNER JOIN emprestimos e ON l.id_livro = e.fk_id_livro
INNER JOIN usuarios u ON e.fk_id_usuario = u.id_usuario;


-- 4. Exiba os livros disponíveis no acervo (aqueles que não foram emprestados ou ainda possuem cópias restantes).
-- (Dica: Use um LEFT JOIN para verificar a quantidade de exemplares disponíveis.)
SELECT
	l.titulo,
	COALESCE(l.quant - COUNT(e.id_emprestimos), l.quant) AS disponiveis -- calcula os exemplares disponíveis.
FROM livros l
LEFT JOIN emprestimos e ON l.id_livro = e.fk_id_livro AND e.data_devolucao IS NULL
GROUP BY l.id_livro, l.titulo, l.quant
HAVING disponiveis > 0;


-- ==============================================================================================================================
-- 													EXERCÍCIOS COM SUBCONSULTAS
-- ==============================================================================================================================

-- 5. Liste os usuários que pegaram emprestado um livro publicado antes de 1950.
-- (Dica: Subconsulta para encontrar id_livro com ano_publicacao < 1950.)

-- Passo a passo (desestruturar o enunciado e subdividi-lo):
	-- Precisamos encontrar os livros publicados antes de 1950.
	-- Depois, pegamos os empréstimos desses livros.
	-- Por fim, buscamos os usuários que pegaram esses livros emprestados.

SELECT DISTINCT u.nome
FROM usuarios u
INNER JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario
WHERE e.fk_id_livro IN ( -- > filtra os empréstimos desses livros.
    SELECT id_livro FROM livros WHERE ano_publicacao < 1950 -- > retorna os IDs dos livros antigos.
);


-- 6. Exiba os nomes dos usuários que nunca pegaram livros do autor 'George Orwell'.
-- (Dica: Subconsulta para encontrar os id_usuario que já pegaram livros desse autor e excluí-los.)

-- Passo a passo (desestruturar o enunciado e subdividi-lo):
	-- Primeiro, encontramos os usuários que pegaram livros de "George Orwell".
	-- Depois, excluímos esses usuários da lista de todos os usuários.

SELECT nome 
FROM usuarios 
WHERE id_usuario NOT IN ( -- A cláusula NOT IN remove esses usuários da lista.
	-- A subconsulta retorna os IDs dos usuários que já pegaram livros do autor.
    SELECT DISTINCT e.fk_id_usuario
    FROM emprestimos e
    INNER JOIN livros l ON e.fk_id_livro = l.id_livro
    WHERE l.autor = 'George Orwell'
);


-- 7. Mostre o título do livro mais emprestado até agora.
-- (Dica: Subconsulta para contar os empréstimos de cada livro e selecionar o maior valor.)

-- Passo a passo (desestruturar o enunciado e subdividi-lo):
	-- Contamos os empréstimos de cada livro.
	-- Descobrimos qual tem o maior número de empréstimos.
	-- Selecionamos o título desse livro.
    
SELECT titulo
FROM livros
WHERE id_livro = ( 
	-- A subconsulta encontra o fk_id_livro com mais empréstimos.
    SELECT fk_id_livro 
    FROM emprestimos 
    GROUP BY fk_id_livro 
    ORDER BY COUNT(*) DESC -- ordena do maior para o menor.
    LIMIT 1
); -- A consulta externa busca o título desse livro.



-- 8. Liste os usuários que fizeram mais de um empréstimo.
-- (Dica: Agrupe por id_usuario, conte os empréstimos e filtre com HAVING COUNT(*) > 1.)

-- Passo a passo (desestruturar o enunciado e subdividi-lo):
	-- Contamos os empréstimos de cada usuário.
	-- Selecionamos os que fizeram mais de um empréstimo.

SELECT u.nome
FROM usuarios u
INNER JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario
GROUP BY u.id_usuario, u.nome -- agrupa os empréstimos por usuário.
HAVING COUNT(e.id_emprestimos) > 1; -- filtra quem pegou mais de um livro.



-- ==============================================================================================================================
-- 												EXERCÍCIOS COM AGREGAÇÃO E FUNÇÕES
-- ==============================================================================================================================

-- Testando umas coisas
SELECT SUM(quant) AS soma_geral FROM livros; -- Qual a soma geral da quantidade de todos os livros?

SELECT COUNT(id_livro) AS quantidade FROM livros; -- Quantos registros temos na tabela?

SELECT AVG(quant) FROM livros -- Qual a média de livros disponiveis do autor 'George Orwell'?
WHERE autor = 'George Orwell';

SELECT titulo, MAX(quant) AS disponiveis FROM livros -- Qual o livro que mais tem em quantidade?
GROUP BY titulo
ORDER BY disponiveis DESC
LIMIT 1;

SELECT titulo, MIN(quant) AS disponiveis FROM livros
GROUP BY titulo
ORDER BY disponiveis
LIMIT 1; -- E o que tem menos?


SELECT quant FROM livros;
SELECT * FROM livros;


-- 9. Mostre quantos livros cada usuário pegou emprestado, incluindo os que nunca pegaram.
-- (Dica: LEFT JOIN e COUNT(id_emprestimos), usando GROUP BY id_usuario.)
SELECT
	u.nome,
    COUNT(id_emprestimos) AS quant_emprestada
FROM usuarios u
LEFT JOIN emprestimos e ON e.fk_id_usuario = u.id_usuario
LEFT JOIN livros l ON l.id_livro = e.fk_id_livro
GROUP BY u.id_usuario, u.nome;

-- 10. Liste os 3 autores mais emprestados, junto com o número de empréstimos.
-- (Dica: JOIN entre livros e emprestimos, agrupando por autor e ordenando pelo total de empréstimos.)

-- Passo a passo (desestruturar o enunciado e subdividi-lo):
	-- Contamos os empréstimos de cada autor.
	-- Agrupamos por autor.
	-- Ordenamos do maior para o menor número de empréstimos.
	-- Limitamos para os 3 primeiros.

-- Minha tentativa (não terminei, mas estava indo pelo caminho certo)
SELECT
	l.autor,
    COUNT(e.id_emprestimos)
FROM livros l;

select COUNT(e.id_emprestimos) from emprestimos e
GROUP BY e.fk_id_livro;


-- Tentativa correta:
SELECT 
    l.autor, 
    COUNT(e.id_emprestimos) AS total_emprestimos -- Conta quantos empréstimos cada autor teve.
FROM livros l
INNER JOIN emprestimos e ON l.id_livro = e.fk_id_livro
GROUP BY l.autor -- Agrupa os empréstimos por autor
ORDER BY total_emprestimos DESC
LIMIT 3;
