-- TRABALHO PRÁTICO DE BANCO DE DADOS
-- Cenário: Loja Horizonte
-- Arquivo com a criação do banco, carga inicial, alterações e consultas.
--
-- ATENÇÃO: este script recria o banco loja_horizonte do zero.
-- Se já existir um banco com esse nome, os dados anteriores serão apagados.

DROP DATABASE IF EXISTS loja_horizonte;
CREATE DATABASE loja_horizonte;
USE loja_horizonte;

-- =====================================================
-- 1. CRIAÇÃO DAS TABELAS
-- =====================================================

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(60),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Categoria (
    id_categoria INT PRIMARY KEY,
    descricao VARCHAR(60) NOT NULL
);

CREATE TABLE Produto (
    id_produto INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY,
    data_pedido DATE NOT NULL,
    status VARCHAR(30),
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Item_Pedido (
    id_pedido INT,
    id_produto INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto)
);

-- =====================================================
-- 2. INSERÇÃO DOS DADOS INICIAIS
-- =====================================================

INSERT INTO Cliente VALUES
(1, 'Ana Souza', 'Paracatu', 'ana@email.com'),
(2, 'Carlos Lima', 'Uberlandia', 'carlos@email.com'),
(3, 'Mariana Alves', 'Paracatu', 'mariana@email.com'),
(4, 'Joao Mendes', 'Brasilia', 'joao@email.com'),
(5, 'Fernanda Costa', 'Uberlandia', 'fernanda@email.com');

INSERT INTO Categoria VALUES
(1, 'Informatica'),
(2, 'Perifericos'),
(3, 'Moveis');

INSERT INTO Produto VALUES
(1, 'Notebook', 3500.00, 10, 1),
(2, 'Mouse', 80.00, 50, 2),
(3, 'Teclado', 150.00, 30, 2),
(4, 'Monitor', 1200.00, 15, 1),
(5, 'Cadeira', 750.00, 8, 3),
(6, 'Impressora', 900.00, 5, 1);

INSERT INTO Pedido VALUES
(101, '2026-01-10', 'Concluido', 1),
(102, '2026-01-12', 'Concluido', 2),
(103, '2026-01-15', 'Pendente', 1),
(104, '2026-02-02', 'Concluido', 3),
(105, '2026-02-05', 'Cancelado', 4),
(106, '2026-02-10', 'Concluido', 5);

INSERT INTO Item_Pedido VALUES
(101, 1, 1, 3500.00),
(101, 2, 2, 80.00),
(102, 3, 1, 150.00),
(102, 4, 1, 1200.00),
(103, 5, 1, 750.00),
(104, 2, 3, 80.00),
(104, 3, 2, 150.00),
(105, 1, 1, 3500.00),
(106, 4, 2, 1200.00);

-- =====================================================
-- 3. QUESTÃO 6 - ALTERAÇÃO DE DADOS (DDL E DML)
-- =====================================================

-- a) Adicionar telefone à tabela Cliente
ALTER TABLE Cliente
ADD telefone VARCHAR(15);

-- b) Inserir o produto Webcam
INSERT INTO Produto (id_produto, nome, preco, estoque, id_categoria)
VALUES (7, 'Webcam', 250.00, 20, 2);

-- c) Atualizar o preço do Mouse
UPDATE Produto
SET preco = 95.00
WHERE nome = 'Mouse';

-- d) Excluir a Impressora
DELETE FROM Produto
WHERE id_produto = 6;

-- =====================================================
-- 4. QUESTÃO 7 - CONSULTA COM INNER JOIN
-- =====================================================

SELECT
    c.nome AS cliente,
    p.id_pedido AS numero_pedido,
    p.data_pedido,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario
FROM Cliente c
INNER JOIN Pedido p ON c.id_cliente = p.id_cliente
INNER JOIN Item_Pedido ip ON p.id_pedido = ip.id_pedido
INNER JOIN Produto pr ON ip.id_produto = pr.id_produto
ORDER BY p.id_pedido ASC;

-- =====================================================
-- 5. QUESTÃO 8 - AGRUPAMENTO E FUNÇÕES DE AGREGAÇÃO
-- =====================================================

SELECT
    c.nome AS cliente,
    COUNT(DISTINCT p.id_pedido) AS quantidade_pedidos,
    SUM(ip.quantidade * ip.preco_unitario) AS total_adquirido
FROM Cliente c
INNER JOIN Pedido p ON c.id_cliente = p.id_cliente
INNER JOIN Item_Pedido ip ON p.id_pedido = ip.id_pedido
WHERE p.status = 'Concluido'
GROUP BY c.id_cliente, c.nome
HAVING total_adquirido > 1000
ORDER BY total_adquirido DESC;

-- =====================================================
-- 6. QUESTÃO 9 - SUBCONSULTA
-- =====================================================

SELECT
    id_produto,
    nome,
    preco,
    estoque
FROM Produto
WHERE preco > (SELECT AVG(preco) FROM Produto)
  AND estoque < 10
ORDER BY preco DESC;

-- FIM DO TRABALHO PRÁTICO
