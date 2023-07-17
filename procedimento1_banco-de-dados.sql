-- Criação do Sequence
CREATE SEQUENCE [dbo].[PessoaSequence]
  AS INTEGER
  START WITH 1
  INCREMENT BY 1

-- Criação das tabelas
CREATE TABLE Usuario (
  idUsuario INTEGER  NOT NULL   IDENTITY ,
  login VARCHAR(255)    ,
  senha VARCHAR(255)    ,
PRIMARY KEY(idUsuario));
GO

CREATE TABLE Pessoa (
  idPessoa INTEGER  NOT NULL  PRIMARY KEY CLUSTERED DEFAULT (NEXT VALUE FOR dbo.PessoaSequence) ,
  nome VARCHAR(255)  NOT NULL  ,
  logradouro VARCHAR(255)    ,
  cidade VARCHAR(255)    ,
  estado VARCHAR(2)    ,
  telefone VARCHAR(11)    ,
  email VARCHAR(255)      ,
PRIMARY KEY(idPessoa));
GO

CREATE TABLE PessoaFisica (
  idPessoa INTEGER  PRIMARY KEY CLUSTERED,
  CPF VARCHAR(11)  NOT NULL    ,
  CONSTRAINT FK_PessoaFisica_Pessoa FOREIGN KEY (PessoaID) REFERENCES dbo.Pessoa (idPessoa),
  ON DELETE CASCADE);
GO

CREATE TABLE PessoaJuridica (
  idPessoa INTEGER  PRIMARY KEY CLUSTERED  ,
  CNPJ VARCHAR(14)  NOT NULL    ,
  CONSTRAINT FK_PessoaFisica_Pessoa FOREIGN KEY (PessoaID) REFERENCES dbo.Pessoa (idPessoa),
  ON DELETE CASCADE);
GO

CREATE TABLE Produto (
  idProduto INTEGER  NOT NULL   IDENTITY ,
  nome VARCHAR  NOT NULL  ,
  quantidade INTEGER  NOT NULL  ,
  precoVenda NUMERIC  NOT NULL    ,
PRIMARY KEY(idProduto));
GO

CREATE TABLE Movimento (
  idMovimento INTEGER  NOT NULL   IDENTITY ,
  Usuario_idUsuario INTEGER  NOT NULL  ,
  Pessoa_idPessoa INTEGER  NOT NULL  ,
  Produto_idProduto INTEGER  NOT NULL  ,
  quantidade INTEGER  NOT NULL  ,
  tipo CHAR(1)  NOT NULL  ,
  valorUnitario NUMERIC  NOT NULL    ,
PRIMARY KEY(idMovimento)      ,
  FOREIGN KEY(Produto_idProduto)
    REFERENCES Produto(idProduto),
  FOREIGN KEY(Pessoa_idPessoa)
    REFERENCES Pessoa(idPessoa),
  FOREIGN KEY(Usuario_idUsuario)
    REFERENCES Usuario(idUsuario));
GO

-- Criação dos relacionamentos
CREATE INDEX PessoaFisica_FKIndex1 ON PessoaFisica (Pessoa_idPessoa);
GO

CREATE INDEX IFK_Rel_PessoaPessoaFisica ON PessoaFisica (Pessoa_idPessoa);
GO

CREATE INDEX PessoaJuridica_FKIndex1 ON PessoaJuridica (Pessoa_idPessoa);
GO

CREATE INDEX IFK_Rel_PessoaPessoaJuridica ON PessoaJuridica (Pessoa_idPessoa);
GO

CREATE INDEX Movimento_FKIndex1 ON Movimento (Produto_idProduto);
GO
CREATE INDEX Movimento_FKIndex2 ON Movimento (Pessoa_idPessoa);
GO
CREATE INDEX Movimento_FKIndex3 ON Movimento (Usuario_idUsuario);
GO

CREATE INDEX IFK_ItemMovimentado ON Movimento (Produto_idProduto);
GO
CREATE INDEX IFK_Responsavel ON Movimento (Pessoa_idPessoa);
GO
CREATE INDEX IFK_Operador ON Movimento (Usuario_idUsuario);
GO

-- Triggers para atualizar dados automaticamente, gerado com ajuda do DBDesigner:
CREATE TRIGGER UPDT_Usuario
ON Usuario  AFTER INSERT, UPDATE 
AS 
BEGIN 
    declare @dt varchar(15) 
    set @dt = (select replace(CONVERT(VARCHAR(6),GETDATE(),12)+CONVERT(VARCHAR,GETDATE(),14), ':', '')) 
    UPDATE Usuario SET UPDATE_DATE = @dt 
    FROM Usuario TAB INNER JOIN inserted I ON (TAB.idUsuario = I.idUsuario) 
    WHERE TAB.UPDATE_DATE < @dt OR TAB.UPDATE_DATE IS NULL 
END;


CREATE TRIGGERAS     declare @dt varchar(15) 
    set @dt = (select replace(CONVERT(VARCHAR(6),GETDATE(),12)+CONVERT(VARCHAR,GETDATE(),14), ':', '')) 
    UPDATE Pessoa SET UPDATE_DATE = @dt 
    FROM Pessoa TAB INNER JOIN inserted I ON (TAB.idPessoa = I.idPessoa) 
    WHERE TAB.UPDATE_DATE < @dt OR TAB.UPDATE_DATE IS NULL 
END;

GO 

CREATE TRIGGER UPDT_PessoaFisica
ON PessoaFisica  AFTER INSERT, UPDATE 
AS 
BEGIN 
    declare @dt varchar(15) 
    set @dt = (select replace(CONVERT(VARCHAR(6),GETDATE(),12)+CONVERT(VARCHAR,GETDATE(),14), ':', '')) 
    UPDATE PessoaFisica SET UPDATE_DATE = @dt 
    FROM PessoaFisica TAB INNER JOIN inserted I ON (TAB.idPessoaFisica = I.idPessoaFisica AND TAB.Pessoa_idPessoa = I.Pessoa_idPessoa) 
    WHERE TAB.UPDATE_DATE < @dt OR TAB.UPDATE_DATE IS NULL 
END;

GO 

CREATE TRIGGER UPDT_PessoaJuridica
ON PessoaJuridica  AFTER INSERT, UPDATE 
AS 
BEGIN 
    declare @dt varchar(15) 
    set @dt = (select replace(CONVERT(VARCHAR(6),GETDATE(),12)+CONVERT(VARCHAR,GETDATE(),14), ':', '')) 
    UPDATE PessoaJuridica SET UPDATE_DATE = @dt 
    FROM PessoaJuridica TAB INNER JOIN inserted I ON (TAB.idPessoaJuridica = I.idPessoaJuridica AND TAB.Pessoa_idPessoa = I.Pessoa_idPessoa) 
    WHERE TAB.UPDATE_DATE < @dt OR TAB.UPDATE_DATE IS NULL 
END;

GO 

CREATE TRIGGER UPDT_Produto
ON Produto  AFTER INSERT, UPDATE 
AS 
BEGIN 
    declare @dt varchar(15) 
    set @dt = (select replace(CONVERT(VARCHAR(6),GETDATE(),12)+CONVERT(VARCHAR,GETDATE(),14), ':', '')) 
    UPDATE Produto SET UPDATE_DATE = @dt 
    FROM Produto TAB INNER JOIN inserted I ON (TAB.idProduto = I.idProduto) 
    WHERE TAB.UPDATE_DATE < @dt OR TAB.UPDATE_DATE IS NULL 
END;

GO 

CREATE TRIGGER UPDT_Movimento
ON Movimento  AFTER INSERT, UPDATE 
AS 
BEGIN 
    declare @dt varchar(15) 
    set @dt = (select replace(CONVERT(VARCHAR(6),GETDATE(),12)+CONVERT(VARCHAR,GETDATE(),14), ':', '')) 
    UPDATE Movimento SET UPDATE_DATE = @dt 
    FROM Movimento TAB INNER JOIN inserted I ON (TAB.idMovimento = I.idMovimento) 
    WHERE TAB.UPDATE_DATE < @dt OR TAB.UPDATE_DATE IS NULL 
END;

GO 