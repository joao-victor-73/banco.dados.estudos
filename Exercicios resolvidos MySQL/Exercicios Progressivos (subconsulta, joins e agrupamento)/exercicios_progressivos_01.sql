-- |================================================================================================================================|
-- | Com base nessa base de dados ('bibli'), o ChatGPT criou alguns exercícios para eu práticar os conteúdos de MySQL a medida		|
-- | que eu ia conhecendo novos assuntos (subconsultas, JOINs, agrupamento e filtragem, e outros assuntos que foi visto mais		|
-- | a frente). Esse primeiro arquivo contém a criação das tabelas e a inserção de registros, como também 11 (onze) exercícios 	 	|
-- | que foram resolvidos. 																											|
-- | Atualmente temos três (3) arquivos de exercícios: exercicios_progressivos.sql / exercicios_progressivos_2.sql / 				|
-- | 												   exercicios_progressivos_3.sql 												|
-- |================================================================================================================================|


-- CRIANDO A BASE DE DADOS E AS TABELAS
CREATE DATABASE IF NOT EXISTS bibli;
USE bibli;


CREATE TABLE IF NOT EXISTS livros (
	id_livro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    ano_publicacao INT NOT NULL,
    genero VARCHAR(100),
    quant INT
);

CREATE TABLE IF NOT EXISTS emprestimos (
	id_emprestimos INT PRIMARY KEY AUTO_INCREMENT,
    fk_id_livro INT,
    fk_id_usuario INT,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE
);


CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20),
    endereco TEXT,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE emprestimos
ADD CONSTRAINT fk_livros_emprestimos
FOREIGN KEY (fk_id_livro) REFERENCES livros(id_livro)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE emprestimos
ADD CONSTRAINT fk_usuario_emprestimo
FOREIGN KEY (fk_id_usuario) REFERENCES usuarios(id_usuario)
ON UPDATE CASCADE
ON DELETE CASCADE;



-- INSERINDO OS REGISTROS
INSERT INTO livros (titulo, autor, ano_publicacao, genero, quant) VALUES
('Dom Casmurro', 'Machado de Assis', 1899, 'Romance', 5),
('O Hobbit', 'J.R.R Tolkien', 1937, 'Fantasia', 3),
('1984', 'George Orwell', 1949, 'Distopia', 2),
('A Revolução dos Bichos', 'George Orwell', 1945, 'Satírico', 4);

INSERT INTO emprestimos (fk_id_livro, fk_id_usuario, data_emprestimo, data_devolucao) VALUES
(2, 1, '2024-02-01', '2024-02-15'),
(3, 2, '2024-02-05', NULL),
(1, 3, '2024-02-10', NULL);

INSERT INTO usuarios (nome, email, data_nascimento, telefone, endereco) VALUES
('Ana Souza', 'ana.souza@email.com', '1995-08-12', '(11) 98765-4321', 'Rua das Flores, 123, São Paulo'),
('Carlos Lima', 'carlos.lima@email.com', '1988-04-25', '(21) 99988-7766', 'Av. Central, 456, Rio de Janeiro'),
('Mariana Ribeiro', 'mariana.ribeiro@email.com', '2000-12-03', NULL, 'Rua das Árvores, 789, Belo Horizonte'),
('João Pereira', 'joao.pereira@email.com', '1992-06-30', '(31) 98877-6655', NULL),
('Fernanda Castro', 'fernanda.castro@email.com', '1985-03-17', '(47) 97766-5544', 'Av. Paulista, 321, São Paulo');


SELECT * FROM livros;
SELECT * FROM emprestimos;
SELECT * FROM usuarios;

SELECT
	l.titulo,
    e.data_emprestimo
FROM livros l
INNER JOIN emprestimos e ON l.id_livro = e.fk_id_livro;


-- ==============================================================================================================================
-- 															EXERCÍCIOS
-- ==============================================================================================================================

-- 1 Listar todos os livros da biblioteca.
SELECT *  FROM livros;

-- 2 Exibir os livros publicados antes do ano 1950.
SELECT titulo, autor, genero, ano_publicacao, quant FROM livros
WHERE ano_publicacao < 1950;

-- 3 Exibir os livros publicados entre os anos de 1915 e 1940.
SELECT titulo, autor, genero, ano_publicacao, quant FROM livros
WHERE ano_publicacao BETWEEN 1915 AND 1940;

-- 4 Mostrar os livros do gênero "Fantasia".
SELECT titulo, autor, genero, ano_publicacao, quant FROM livros
WHERE genero = 'Fantasia';

-- 5 Listar os livros disponíveis para empréstimo (quantidade maior que 0).
SELECT titulo, autor FROM livros
WHERE quant > 0;


-- 6 Exibir os empréstimos que ainda não foram devolvidos.
SELECT * FROM emprestimos
WHERE data_devolucao IS NULL;

-- 7 Mostrar a quantidade total de livros agrupados por gênero.
SELECT titulo, genero, SUM(quant) AS total_livros FROM livros
GROUP BY titulo, genero;

-- 8 Encontrar os autores que têm mais de um livro na biblioteca.
SELECT 
	autor, 
    COUNT(*) AS quantidade_livros
FROM Livros
GROUP BY autor
HAVING COUNT(*) > 1;

-- 9 Exibir o título do livro e a data de empréstimo para os livros que ainda não foram devolvidos.
SELECT
	l.titulo,
    e.data_emprestimo
FROM livros l
INNER JOIN emprestimos e ON l.id_livro = e.fk_id_livro
WHERE data_devolucao IS NULL;

-- 10 Encontrar os livros que nunca foram emprestados.
SELECT
	l.titulo,
    l.autor,
    l.genero
FROM livros l
LEFT JOIN emprestimos e ON l.id_livro = e.fk_id_livro
WHERE e.fk_id_livro IS NULL;

-- 11 Exibir o título do livro mais antigo da biblioteca.
SELECT 
	titulo, 
    ano_publicacao 
FROM livros 
ORDER BY ano_publicacao ASC 
LIMIT 1;

-- Se caso houvesse mais de um livro com a mesma data (ou seja mais antiga), podemos fazer assim:
SELECT titulo, ano_publicacao 
FROM livros 
WHERE ano_publicacao = (SELECT MIN(ano_publicacao) FROM livros);

