-- Seleciona a base de dados:
USE [loja]
GO


-- Declara vari�vel que ser� utilizada multiplas vezes no c�digo abaixo:
DECLARE @idPessoa INT;


-- Insere usu�rios:
INSERT INTO Usuario
	([login],[senha])
     VALUES ('op1', 'op1'), ('op2', 'op2')
GO


-- Insere produtos:
INSERT INTO Produto (nome, quantidade, precoVenda)
VALUES ('Banana', 100, 5.0),
       ('Laranja', 500, 2.0),
       ('Laranja', 800, 4.0);
GO


-- Insere pessoa f�sica:
DECLARE @idPessoa INT;
SET @idPessoa = NEXT VALUE FOR dbo.PessoaSequence;

INSERT INTO Pessoa (idPessoa, nome, logradouro, cidade, estado, telefone, email)
VALUES (@idPessoa, 'Joao', 'Rua 12, casa 3, Quitanda', 'Riacho do Sul', 'PA', '1111-1111', 'joao@riacho.com');

INSERT INTO PessoaFisica (idPessoa, CPF)
VALUES (@idPessoa, '11111111111');


-- Insere pessoas juridica:
SET @idPessoa = NEXT VALUE FOR dbo.PessoaSequence;

INSERT INTO Pessoa (idPessoa, nome, logradouro, cidade, estado, telefone, email)
VALUES (@idPessoa, 'JJC', 'Rua 11, Centro', 'Riacho do Norte', 'PA', '1212-1212', 'jjc@riacho.com');

INSERT INTO PessoaJuridica (idPessoa, CNPJ)
VALUES (@idPessoa, '22222222222222');


-- Insere movimenta��es:
INSERT INTO Movimento (Usuario_idUsuario, Pessoa_idPessoa, Produto_idProduto, quantidade, tipo, valorUnitario)
VALUES (1, 1, 1, 20, 'S', 4.00),
       (1, 1, 2, 15, 'S', 2.00),
       (2, 1, 2, 10, 'S', 3.00),
       (1, 2, 2, 15, 'E', 5.00),
       (1, 2, 3, 20, 'E', 4.00);
	   

-- Lista usu�rios:
SELECT * FROM Usuario
GO


-- Lista dados completos de pessoas f�sicas:
SELECT * FROM Pessoa p JOIN PessoaFisica pf ON p.idPessoa = pf.idPessoa;
GO


-- Lista dados completos de pessoas jur�dicas:
SELECT * FROM Pessoa p JOIN PessoaJuridica pj ON p.idPessoa = pj.idPessoa;
GO


-- Lista movimenta��es de entrada, com produto, fornecedor, quantidade, pre�o unit�rio e valor total:
SELECT Produto.nome AS produto,
       Pessoa.nome AS fornecedor,
       Movimento.quantidade,
       Movimento.valorUnitario,
       Movimento.quantidade * Movimento.valorUnitario AS "valor total"
FROM Movimento
	JOIN Produto ON Movimento.Produto_idProduto = Produto.idProduto
	JOIN Pessoa ON Movimento.Pessoa_idPessoa = Pessoa.idPessoa
WHERE tipo = 'E';
GO


-- Lista movimenta��es de sa�da, com produto, comprador, quantidade, pre�o unit�rio e valor total:
SELECT Produto.nome AS produto,
       Pessoa.nome AS comprador,
       Movimento.quantidade,
       Movimento.valorUnitario,
       Movimento.quantidade * Movimento.valorUnitario AS "valor total"
FROM Movimento
	JOIN Produto ON Movimento.Produto_idProduto = Produto.idProduto
	JOIN Pessoa ON Movimento.Pessoa_idPessoa = Pessoa.idPessoa
WHERE tipo = 'S';
GO


-- Lista valor total das entradas agrupadas por produto:
SELECT Produto.nome AS produto,
       SUM(Movimento.quantidade * Movimento.valorUnitario) AS "valor total entradas"
FROM Movimento
	JOIN Produto ON Movimento.Produto_idProduto = Produto.idProduto
WHERE tipo = 'E'
GROUP BY Produto.nome;
GO


-- Lista valor total das sa�das agrupadas por produto:
SELECT Produto.nome AS produto,
       SUM(Movimento.quantidade * Movimento.valorUnitario) AS "valor total saidas"
FROM Movimento
	JOIN Produto ON Movimento.Produto_idProduto = Produto.idProduto
WHERE tipo = 'S'
GROUP BY Produto.nome;
GO


-- Lista operadores que n�o efetuaram movimenta��es de entrada (compra):
SELECT Usuario.login AS "operador sem compra"
FROM Usuario
	LEFT JOIN (SELECT DISTINCT Usuario_idUsuario FROM Movimento WHERE tipo = 'E') m ON Usuario.idUsuario = m.Usuario_idUsuario
WHERE m.Usuario_idUsuario IS NULL;


-- Lista valor total de entrada, agrupado por operador:
SELECT Usuario.login AS operador,
       SUM(Movimento.quantidade * Movimento.valorUnitario) AS "valor total entradas"
FROM Movimento
JOIN Usuario ON Movimento.Usuario_idUsuario = Usuario.idUsuario
WHERE tipo = 'E'
GROUP BY Usuario.login;


-- Lista valor total de sa�da, agrupado por operador:
SELECT Usuario.login AS operador,
       SUM(Movimento.quantidade * Movimento.valorUnitario) AS "valor total saidas"
FROM Movimento
	JOIN Usuario ON Movimento.Usuario_idUsuario = Usuario.idUsuario
WHERE tipo = 'S'
GROUP BY Usuario.login;
GO


-- Lista valor m�dio de venda por produto, utilizando m�dia ponderada:
WITH VendasPorProduto AS (
  SELECT Produto_idProduto,
         SUM(quantidade * valorUnitario) / SUM(quantidade) AS valorMedioVendaPorProduto
  FROM Movimento
  WHERE tipo = 'S'
  GROUP BY Produto_idProduto)
SELECT Produto.nome AS produto,
       VendasPorProduto.valorMedioVendaPorProduto AS "valor medio de venda por produto (media ponderada)"
FROM VendasPorProduto
	JOIN Produto ON VendasPorProduto.Produto_idProduto = Produto.idProduto;
GO