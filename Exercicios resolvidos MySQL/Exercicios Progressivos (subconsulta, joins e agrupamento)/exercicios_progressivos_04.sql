-- |================================================================================================================================|
-- | Com base nessa base de dados ('bibli'), o ChatGPT criou alguns exercícios para eu práticar os conteúdos de MySQL a medida		|
-- | que eu ia conhecendo novos assuntos (subconsultas, JOINs, agrupamento e filtragem, e outros assuntos que foi visto mais		|
-- | a frente). Esse primeiro arquivo contém a criação das tabelas e a inserção de registros, como também 11 (onze) exercícios 	 	|
-- | que foram resolvidos. 																											|
-- | Atualmente temos três (3) arquivos de exercícios: exercicios_progressivos.sql / exercicios_progressivos_2.sql / 				|
-- | 												   exercicios_progressivos_3.sql / exercicios_progressivos_4.sql				|
-- |================================================================================================================================|

USE bibli;

-- ==============================================================================================================================
-- 												EXERCÍCIOS COM JOINs e AGREGAÇÕES
-- ==============================================================================================================================

-- 1. Liste todos os usuários e os livros que pegaram emprestados, mostrando também a data de empréstimo. 
-- 	Inclua usuários que nunca pegaram livros (mostre como "Nenhum empréstimo").
-- 	(Dica: Use LEFT JOIN e COALESCE para exibir um valor padrão.)

SELECT
	u.nome,
    COALESCE(l.titulo, '---') AS titulo,
    COALESCE(l.autor, '---') AS autor, 
    e.data_emprestimo
FROM usuarios u
LEFT JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario
LEFT JOIN livros l ON e.fk_id_livro = l.id_livro;


-- 2. Liste os livros e quantas vezes cada um foi emprestado. Exiba também os livros que nunca foram emprestados (mostre 0).
-- 	(Dica: LEFT JOIN entre livros e emprestimos, contando id_emprestimos.)

SELECT
	l.titulo,
    COUNT(e.fk_id_livro) vezes_emprestado
FROM livros l
LEFT JOIN emprestimos e ON l.id_livro = e.fk_id_livro
GROUP BY l.titulo
ORDER BY vezes_emprestado DESC;

-- 3. Mostre a média de livros emprestados por usuário.
-- 	(Dica: Média = total de empréstimos dividido pelo total de usuários.)

-- Maneira que eu fiz, porém, O INNER JOIN remove usuários que nunca pegaram livros, o que resulta em uma média incorreta:
SELECT
    (COUNT(e.id_emprestimos) / COUNT(u.id_usuario)) AS media
FROM usuarios u
INNER JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario;

-- Maneira correta sugerida: com duas subconsultas, uma para emprestimos e outra para usuários:

SELECT
	(SELECT COUNT(*) FROM emprestimos) / (SELECT COUNT(*) FROM usuarios) AS media_emprestimos_por_usuario
FROM usuarios u;


-- 4. Liste os usuários que pegaram emprestado pelo menos 2 livros diferentes.
-- 	(Dica: Agrupe por id_usuario, conte os livros distintos e use HAVING COUNT(DISTINCT fk_id_livro) >= 2.)

SELECT
	u.nome,
    COUNT(e.fk_id_livro) AS emprestimos_feitos
FROM usuarios u
INNER JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario 
GROUP BY u.nome
HAVING COUNT(DISTINCT e.fk_id_livro) >= 2;


-- ==============================================================================================================================
-- 												EXERCÍCIOS COM SUBCONSULTAS
-- ==============================================================================================================================

-- 5. Liste os livros que nunca foram emprestados.
-- (Dica: Use NOT IN ou NOT EXISTS com uma subconsulta para encontrar os id_livro que aparecem na tabela emprestimos.)

-- Maneira com um LEFT JOIN
SELECT
	l.titulo,
    l.autor,
    COALESCE(e.data_emprestimo, 'Não teve emprestimo') AS emprestado
FROM livros l
LEFT JOIN emprestimos e ON l.id_livro = e.fk_id_livro
WHERE fk_id_usuario IS NULL;

-- Maneira com a Subconsulta
SELECT titulo, autor
FROM livros
WHERE id_livro NOT IN (SELECT fk_id_livro FROM emprestimos);

-- Solução dada pelo chatgpt (o meu está correto, porém para tabelas maiores, o uso do NOT EXISTS é bem melhor e eficiente).
SELECT titulo, autor
FROM livros l
WHERE NOT EXISTS (
    SELECT 1 FROM emprestimos e WHERE e.fk_id_livro = l.id_livro
);



-- 6. Exiba os usuários que pegaram emprestado um livro publicado no ano mais antigo do acervo.
-- (Dica: Primeiro, encontre o menor ano_publicacao com uma subconsulta, depois use isso no WHERE.)

SELECT DISTINCT 
	u.nome, 
    l.titulo, 
    l.ano_publicacao
FROM usuarios u
INNER JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario
INNER JOIN livros l ON e.fk_id_livro = l.id_livro
WHERE l.ano_publicacao = (SELECT MIN(ano_publicacao) FROM livros); -- A subconsulta retorna o ano mais antigo.
-- O WHERE filtra os livros emprestados que têm esse ano.

-- 7. Mostre os livros emprestados mais recentemente.
-- (Dica: Use MAX(data_emprestimo) dentro de uma subconsulta.)

SELECT
	titulo,
    (SELECT MAX(data_emprestimo) FROM emprestimos) AS data_mais_recente
FROM livros l
ORDER BY titulo;
    
    
SELECT DISTINCT 
	l.titulo, 
    e.data_emprestimo
FROM livros l
INNER JOIN emprestimos e ON l.id_livro = e.fk_id_livro
WHERE e.data_emprestimo = (SELECT MAX(data_emprestimo) FROM emprestimos); 
-- A subconsulta encontra a data mais recente.
-- O WHERE seleciona os livros emprestados nessa data.


-- 8. Liste os usuários que pegaram livros do mesmo autor mais de uma vez.
-- (Dica: Agrupe por id_usuario e autor, e filtre com HAVING COUNT(*) > 1.)

SELECT 
	u.nome, 
    l.autor, 
    COUNT(*) AS total_emprestimos
FROM usuarios u
INNER JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario
INNER JOIN livros l ON e.fk_id_livro = l.id_livro
GROUP BY u.id_usuario, u.nome, l.autor --  Agrupamos por usuário e autor para contar empréstimos do mesmo autor.
HAVING COUNT(*) > 1; -- garante que pegou mais de um livro do mesmo autor.



-- ==============================================================================================================================
-- 											OUTROS EXERCÍCIOS (consultas avançadas)
-- ==============================================================================================================================

-- 9. Liste os usuários que pegaram livros e ainda não os devolveram.
-- (Dica: Filtre data_devolucao IS NULL.)

SELECT
	u.nome,
    l.titulo,
    e.data_emprestimo,
    COALESCE(e.data_devolucao, 'Não devolvido') AS data_devolucao
FROM usuarios u -- Vamos começar com usuarios pois é o que seja apresentado
INNER JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario
INNER JOIN livros l ON e.fk_id_livro = l.id_livro
WHERE e.data_devolucao IS NULL;


-- 10. Exiba os 5 livros mais emprestados, incluindo o número de vezes que cada um foi emprestado.
-- (Dica: COUNT(id_emprestimos), GROUP BY titulo, ORDER BY total DESC, LIMIT 5.)

SELECT
	l.titulo,
    COUNT(e.id_emprestimos) AS vezes_emprestados
FROM livros l
INNER JOIN emprestimos e ON l.id_livro = e.fk_id_livro
GROUP BY l.titulo
ORDER BY vezes_emprestados DESC
LIMIT 5;
