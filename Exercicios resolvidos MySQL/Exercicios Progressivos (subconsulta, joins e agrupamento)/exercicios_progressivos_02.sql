-- |================================================================================================================================|
-- | Com base nessa base de dados ('bibli'), o ChatGPT criou alguns exercícios para eu práticar os conteúdos de MySQL a medida		|
-- | que eu ia conhecendo novos assuntos (subconsultas, JOINs, agrupamento e filtragem, e outros assuntos que foi visto mais		|
-- | a frente). Esse primeiro arquivo contém a criação das tabelas e a inserção de registros, como também 11 (onze) exercícios 	 	|
-- | que foram resolvidos. 																											|
-- | Atualmente temos três (3) arquivos de exercícios: exercicios_progressivos.sql / exercicios_progressivos_2.sql / 				|
-- | 												   exercicios_progressivos_3.sql 												|
-- |================================================================================================================================|

USE bibli;
SHOW TABLES;


-- ==============================================================================================================================
-- 														CONSULTAS BÁSICAS
-- ==============================================================================================================================

-- 1. Liste os títulos e autores de todos os livros da biblioteca.
SELECT titulo, autor FROM livros;

-- 2. Exiba os livros cujo título começa com a letra "A".
SELECT titulo, autor FROM livros
WHERE titulo LIKE 'A%';

-- 3. Mostre os livros que não pertencem ao gênero "Ficção".
SELECT titulo, autor, genero FROM livros
WHERE LOWER(genero) != 'ficção';

-- 4. Liste todos os livros publicados após o ano 2000, ordenados do mais novo para o mais antigo.
SELECT titulo, autor, ano_publicacao FROM livros
WHERE ano_publicacao > 2000
ORDER BY ano_publicacao DESC;

-- 5. Exiba a quantidade total de livros disponíveis na biblioteca (soma de todas as cópias).
SELECT SUM(quant) AS total_livros_disponiveis FROM livros;


-- ==============================================================================================================================
-- 														CONSULTAS COM JOINs
-- ==============================================================================================================================
SELECT * FROM livros;
SELECT * FROM emprestimos;
SELECT * FROM usuarios;

-- 6. Exiba o nome dos alunos que emprestaram livros e os títulos dos livros emprestados.
SELECT
	u.nome,
	l.titulo,
    l.autor
FROM usuarios u
INNER JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario
INNER JOIN livros l ON e.fk_id_livro = l.id_livro;

-- 7. Liste os alunos que nunca realizaram um empréstimo.
SELECT 
	u.nome 
FROM usuarios u
LEFT JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario
WHERE e.fk_id_usuario IS NULL;


-- 8. Encontre os livros que foram emprestados mais de uma vez.
SELECT
	l.titulo,
    l.autor,
    COUNT(e.fk_id_livro) AS vezez_emprestado
FROM livros l
INNER JOIN emprestimos e ON l.id_livro = e.fk_id_livro
GROUP BY l.id_livro
HAVING COUNT(e.fk_id_livro) > 1;


-- 9. Exiba os alunos que possuem um empréstimo atrasado (cuja data de devolução ainda não ocorreu e está vencida).
SELECT
	l.titulo,
    l.autor,
    u.nome
FROM usuarios u
INNER JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario
INNER JOIN livros l ON e.fk_id_livro = l.id_livro
WHERE e.data_devolucao IS NULL;

-- 10. Mostre a quantidade total de empréstimos feitos por cada aluno.
SELECT 
    u.nome, 
    COUNT(e.fk_id_usuario) AS total_emprestimos
FROM usuarios u
INNER JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario
GROUP BY u.id_usuario;

-- ==============================================================================================================================
-- 												CONSULTAS COM AGREGAÇÃO E FILTROS
-- ==============================================================================================================================
-- 11. Liste os gêneros de livros disponíveis e a quantidade total de livros em cada gênero.
SELECT 
    genero, 
    SUM(quant) AS total_livros
FROM livros
GROUP BY genero;


-- 12. Encontre os três autores com mais livros na biblioteca.
SELECT 
    autor, 
    COUNT(*) AS total_livros
FROM livros
GROUP BY autor
ORDER BY total_livros DESC
LIMIT 3;


-- 13. Mostre o número total de livros emprestados no último mês.
SELECT 
	COUNT(*) as total_emprestimos
FROM emprestimos;

-- Outra maneira mais precisa de fazer a consulta:
SELECT 
    COUNT(*) AS total_emprestimos
FROM emprestimos
WHERE MONTH(data_emprestimo) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
AND YEAR(data_emprestimo) = YEAR(CURRENT_DATE - INTERVAL 1 MONTH);


-- 14. Exiba os títulos dos livros e a quantidade de vezes que cada um foi emprestado, ordenado do mais emprestado para o menos emprestado.

-- Inserindo um novo dado de emprestimos para fazer uma consulta de teste.
INSERT INTO emprestimos (fk_id_livro, fk_id_usuario, data_emprestimo, data_devolucao) VALUES
(3, 3, '2024-02-13', '2024-02-23');

SELECT
	l.titulo,
    COUNT(e.fk_id_livro) AS vezes_emprestado
FROM livros l
INNER JOIN emprestimos e ON l.id_livro = e.fk_id_livro
GROUP BY l.titulo
ORDER BY vezes_emprestado DESC;


-- 15. Mostre o aluno que mais pegou livros emprestados.
SELECT
	u.nome,
    COUNT(e.fk_id_usuario) AS quant_livros_emprestados
FROM usuarios u
LEFT JOIN emprestimos e ON u.id_usuario = e.fk_id_usuario -- LEFT mostra também os usuários que não pegaram livros emprestados
GROUP BY u.nome
ORDER BY quant_livros_emprestados DESC;
