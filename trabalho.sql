CREATE DATABASE loja_horizonte;
USE loja_horizonte;

-- CRIACAO DAS TABELAS

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
    FOREIGN KEY (id_categoria)
        REFERENCES Categoria(id_categoria)
);

CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY,
    data_pedido DATE NOT NULL,
    status VARCHAR(30),
    id_cliente INT,
    FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente)
);

CREATE TABLE Item_Pedido (
    id_pedido INT,
    id_produto INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido)
        REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_produto)
        REFERENCES Produto(id_produto)
);

-- INSERCAO DOS DADOS

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

-- QUESTAO 06

ALTER TABLE Cliente ADD telefone VARCHAR(15);

INSERT INTO Produto VALUES
(7, 'Webcam', 250.00, 20, 2);

UPDATE Produto
SET preco = 95.00
WHERE nome = 'Mouse';

DELETE FROM Produto
WHERE id_produto = 6;

-- QUESTAO 07

SELECT
    Cliente.nome AS cliente,
    Pedido.id_pedido,
    Pedido.data_pedido,
    Produto.nome AS produto,
    Item_Pedido.quantidade,
    Item_Pedido.preco_unitario
FROM Cliente
INNER JOIN Pedido
    ON Cliente.id_cliente = Pedido.id_cliente
INNER JOIN Item_Pedido
    ON Pedido.id_pedido = Item_Pedido.id_pedido
INNER JOIN Produto
    ON Item_Pedido.id_produto = Produto.id_produto
ORDER BY Pedido.id_pedido ASC;

-- QUESTAO 08

SELECT
    Cliente.nome AS cliente,
    COUNT(DISTINCT Pedido.id_pedido) AS quantidade_pedidos,
    SUM(Item_Pedido.quantidade * Item_Pedido.preco_unitario) AS total_adquirido
FROM Cliente
INNER JOIN Pedido
    ON Cliente.id_cliente = Pedido.id_cliente
INNER JOIN Item_Pedido
    ON Pedido.id_pedido = Item_Pedido.id_pedido
WHERE Pedido.status = 'Concluido'
GROUP BY Cliente.id_cliente, Cliente.nome
HAVING total_adquirido > 1000
ORDER BY total_adquirido DESC;

-- QUESTAO 09

SELECT
    id_produto,
    nome,
    preco,
    estoque
FROM Produto
WHERE preco > (
    SELECT AVG(preco)
    FROM Produto
)
AND estoque < 10
ORDER BY preco DESC;
