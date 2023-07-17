USE [loja]
GO

CREATE SEQUENCE [dbo].[PessoaSequence]
  AS INTEGER
  START WITH 1
  INCREMENT BY 1

CREATE TABLE Usuario(
  idUsuario INTEGER  NOT NULL IDENTITY,
  login VARCHAR(255),
  senha VARCHAR(255),
PRIMARY KEY(idUsuario));

CREATE TABLE Pessoa(
  idPessoa INTEGER NOT NULL PRIMARY KEY CLUSTERED DEFAULT (NEXT VALUE FOR dbo.PessoaSequence) ,
  nome VARCHAR(255) NOT NULL,
  logradouro VARCHAR(255),
  cidade VARCHAR(255),
  estado VARCHAR(2),
  telefone VARCHAR(11),
  email VARCHAR(255));

CREATE TABLE PessoaFisica(
  idPessoa INTEGER PRIMARY KEY CLUSTERED,
  CPF VARCHAR(11) NOT NULL,
  CONSTRAINT FK_PessoaFisica_Pessoa FOREIGN KEY (idPessoa) REFERENCES dbo.Pessoa (idPessoa));

CREATE TABLE PessoaJuridica(
  idPessoa INTEGER PRIMARY KEY CLUSTERED,
  CNPJ VARCHAR(14) NOT NULL,
  CONSTRAINT FK_PessoaJuridica_Pessoa FOREIGN KEY (idPessoa) REFERENCES dbo.Pessoa (idPessoa));

CREATE TABLE Produto(
  idProduto INTEGER NOT NULL IDENTITY,
  nome VARCHAR(255) NOT NULL,
  quantidade INTEGER NOT NULL,
  precoVenda NUMERIC NOT NULL,
PRIMARY KEY(idProduto));

CREATE TABLE Movimento(
  idMovimento INTEGER NOT NULL IDENTITY,
  Usuario_idUsuario INTEGER NOT NULL,
  Pessoa_idPessoa INTEGER NOT NULL,
  Produto_idProduto INTEGER NOT NULL,
  quantidade INTEGER NOT NULL,
  tipo CHAR(1) NOT NULL,
  valorUnitario NUMERIC NOT NULL,
PRIMARY KEY(idMovimento),
  FOREIGN KEY(Produto_idProduto)
    REFERENCES Produto(idProduto),
  FOREIGN KEY(Pessoa_idPessoa)
    REFERENCES Pessoa(idPessoa),
  FOREIGN KEY(Usuario_idUsuario)
    REFERENCES Usuario(idUsuario));

CREATE INDEX Movimento_FKIndex1 ON Movimento (Produto_idProduto);
CREATE INDEX Movimento_FKIndex2 ON Movimento (Pessoa_idPessoa);
CREATE INDEX Movimento_FKIndex3 ON Movimento (Usuario_idUsuario);

CREATE INDEX IFK_ItemMovimentado ON Movimento (Produto_idProduto);
CREATE INDEX IFK_Responsavel ON Movimento (Pessoa_idPessoa);
CREATE INDEX IFK_Operador ON Movimento (Usuario_idUsuario);
GO