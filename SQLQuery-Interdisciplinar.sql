CREATE DATABASE DBinter
GO

USE DBinter
GO

CREATE TABLE Pessoas
(
	PessoaId       INT         NOT NULL PRIMARY KEY IDENTITY (1, 1),
	Nome           VARCHAR(50) NOT NULL,
	Email          VARCHAR(30) NOT NULL UNIQUE,
	DataNascimento DATE        NOT NULL,
	Senha	       VARCHAR(8)  NOT NULL,
	Telefone       VARCHAR(15) NOT NULL
)
GO 

CREATE TABLE Alunos
(
	AlunoId INT NOT NULL PRIMARY KEY REFERENCES Pessoas, 
)
GO

CREATE TABLE Professores
(
	ProfessorId INT NOT NULL PRIMARY KEY REFERENCES Pessoas,
	Credito     MONEY   NULL

)
GO

CREATE TABLE Compras
(
	CompraId   INT      NOT NULL PRIMARY KEY IDENTITY (1, 1),
	AlunoId    INT      NOT NULL REFERENCES Alunos,
	DataCompra DATETIME NOT NULL,
	Status     INT,
	Valor      MONEY
)
GO

CREATE TABLE Cursos
(
	CursoId      INT         NOT NULL PRIMARY KEY IDENTITY (1, 1),
	ProfessorId  INT         NOT NULL REFERENCES Professores,
	Nome         VARCHAR(50) NOT NULL,
	Preco        MONEY	     NOT NULL,
	CargaHoraria TIME        NOT NULL,
	Thumbnail	 VARBINARY(MAX)  NULL
)
GO

CREATE TABLE Compra_Curso
(	
	CompraId   INT   NOT NULL FOREIGN KEY REFERENCES Compras,
	CursoId    INT   NOT NULL FOREIGN KEY REFERENCES Cursos,
	PRIMARY    KEY (CompraId, CursoId),
	Quantidade INT   NOT NULL,
	Status     INT,
	Valor      MONEY NOT NULL
)
GO

CREATE TABLE Aula_Gravada
(
	AulaId    INT            NOT NULL PRIMARY KEY IDENTITY (1, 1),
	CursoId   INT            NOT NULL FOREIGN KEY REFERENCES Cursos,
	Titulo    VARCHAR(50)	 NOT NULL,
	Descricao VARCHAR(max)   NOT NULL,	
	Arquivo   VARBINARY(max) NOT NULL,
)
GO
-------------------------------------------------------------------
--Inserts em tabelas
-------------------------------------------------------------------

INSERT INTO Pessoas VALUES ('Allan', 'allan@hotmail.com', '1998-03-08', '31599753', '981522510')
INSERT INTO Pessoas VALUES ('Guilherme', 'gui@hotmail.com', '1999-05-04', '123456', '992811201')
INSERT INTO Pessoas VALUES ('Matheus', 'matheus@hotmail.com', '1997-08-12', '9875646a', '981120901')

INSERT INTO Pessoas VALUES ('Luis', 'luis@hotmail.com', '1996-09-03', '2366abc', '984522596')
INSERT INTO Pessoas VALUES ('Leonardo', 'leo@hotmail.com', '2000-08-03', '987456', '984522596')
INSERT INTO Pessoas VALUES ('Fernanda', 'fer@hotmail.com', '2000-03-15', '987456', '984522596')

INSERT INTO Alunos VALUES (1)
INSERT INTO Alunos VALUES (2)
INSERT INTO Alunos VALUES (3)

INSERT INTO Professores VALUES (4, 1000.00)
INSERT INTO Professores VALUES (5, 200.00)
INSERT INTO Professores VALUES (6, 0.0)

INSERT INTO Compras VALUES (1, GETDATE(), 1, 15.0)
INSERT INTO Compras VALUES (2, GETDATE(), 1, 25.0)
INSERT INTO Compras VALUES (3, GETDATE(), 1, 30.0)

INSERT INTO Cursos ( ProfessorId, Nome, Preco, CargaHoraria, Thumbnail)
	SELECT '4', 'Programação C#', '80.0', '04:00', BulkColumn FROM OPENROWSET (Bulk 'D:\imgres.htm', Single_Blob) Thumbnail
INSERT INTO Cursos ( ProfessorId, Nome, Preco, CargaHoraria, Thumbnail)
	SELECT '5', 'Português', '80.0', '06:00', BulkColumn FROM OPENROWSET (Bulk 'D:\port.jpg', Single_Blob) Thumbnail
INSERT INTO Cursos ( ProfessorId, Nome, Preco, CargaHoraria, Thumbnail)
	SELECT '6', 'Matemática', '80.0', '04:00', BulkColumn FROM OPENROWSET (Bulk 'D:\mat.jpg', Single_Blob) Thumbnail

INSERT INTO Aula_Gravada (CursoId, Titulo, Descricao, Arquivo)
	SELECT '1', 'Bhaskara', 'Introdução a formula de Bhaskara', BulkColumn FROM OPENROWSET (Bulk 'D:\aula1.mp4', Single_Blob) Arquivo
INSERT INTO Aula_Gravada (CursoId, Titulo, Descricao, Arquivo)
	SELECT '1', 'Bhaskara', 'Exercícios', BulkColumn FROM OPENROWSET (Bulk 'D:\aula2.mp4', Single_Blob) Arquivo
INSERT INTO Aula_Gravada (CursoId, Titulo, Descricao, Arquivo)
	SELECT '1', 'Bhaskara', 'Prova', BulkColumn FROM OPENROWSET (Bulk 'D:\ultima-aula.mp4', Single_Blob) Arquivo

select * from Aula_Gravada
select * from Cursos
select * from Compras
select * from Professores
select * from Alunos
select * from Pessoas
-------------------------------------------------------------------
--Testes de Procedures
-------------------------------------------------------------------
EXEC AdicionarProfessor 'Roberto', 'robert@email.com', '1979-08-06', '555555', '179523164'
EXEC AdicionarProfessor 'Marcelo', 'celo@email.com', '1979-08-06', '123654', '179124564'
EXEC UpdateProfessor '6', 'Jéssica', 'Jess@hotmail.com', '1999-08-04', '3159975', '981458796'

EXEC AdicionarAluno 'Pedro', 'Pedrinho@Gmail.com', '1999-09-05', '498431', '169998855'
EXEC UpdateAluno '1', 'Allan da Silva', 'allan@hotmail.com', '1998-03-08', '31599753', '981522510'

EXEC AdicionarCurso '9', 'Banco de Dados', '120.0', '02:00'

-------------------------------------------------------------------
--Procedures para inserir
-------------------------------------------------------------------
--Procedure para inserir tabela Professores
CREATE PROCEDURE AdicionarProfessor
(
	@Nome VARCHAR(50), @Email VARCHAR(50), @DataNascimento DATE, @Senha VARCHAR(8), @Telefone VARCHAR(15)
)
AS
BEGIN
	INSERT INTO Pessoas VALUES (@Nome, @Email, @DataNascimento, @Senha, @Telefone)
	INSERT INTO Professores (ProfessorId) VALUES (@@IDENTITY)
END
GO
--Procedure para inserir tabela Alunos
CREATE PROCEDURE AdicionarAluno
(
	@Nome VARCHAR(50), @Email VARCHAR(50), @DataNascimento DATE, @Senha VARCHAR(8), @Telefone VARCHAR(15)
)
AS
BEGIN
	INSERT INTO Pessoas VALUES (@Nome, @Email, @DataNascimento, @Senha, @Telefone)
	INSERT INTO Alunos(AlunoId) VALUES (@@IDENTITY)
END
GO
--Procedure para inserir tabela Cursos    
CREATE PROCEDURE AdicionarCurso
(
	@ProfessorId INT, @Nome VARCHAR(50), @Preco MONEY, @CargaHoraria TIME, @Thumbnail VARBINARY(MAX)
)
AS
BEGIN
	INSERT INTO Cursos VALUES (@ProfessorId, @Nome, @Preco, @CargaHoraria, @Thumbnail)
END
GO

--Procedure para inserir tabela Compras
CREATE PROCEDURE AdicionarCompra
(
	@AlunoId INT, @DataCompra DATETIME, @Status INT, @Valor MONEY
)
AS
BEGIN
	INSERT INTO Compra_Curso VALUES (@AlunoId, @DataCompra, @Status, @Valor)
END
GO
--Procedure para inserir tabela Aulas
CREATE PROCEDURE AdicionarAula
(
	@CursoId INT, @Titulo VARCHAR(50), @Arquivo VARBINARY(MAX), @Descricao VARCHAR(MAX)
)
AS
BEGIN
	INSERT INTO Aula_gravada VALUES (@CursoId, @Titulo, @Arquivo, @Descricao)
END
GO

-------------------------------------------------------------------
--Procedures para Update
-------------------------------------------------------------------

--Update para tabela Professores
CREATE PROCEDURE UpdateProfessor
(
	@PessoaId int, @Nome VARCHAR(50), @Email VARCHAR(50), @DataNascimento DATE, @Senha VARCHAR(8), @Telefone VARCHAR(15), @Credito
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			UPDATE Pessoas SET Nome = @Nome, Email = @Email, DataNascimento = @DataNascimento, Credito = @Credito
			WHERE PessoaId = @PessoaId
			COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
	END CATCH
END
GO

--Update para tabela Alunos
CREATE PROCEDURE UpdateAluno
(
	@PessoaId int, @Nome VARCHAR(50), @Email VARCHAR(50), @DataNascimento DATE, @Senha VARCHAR(8), @Telefone VARCHAR(15)
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			UPDATE Pessoas SET Nome = @Nome, Email = @Email, DataNascimento = @DataNascimento, Telefone = @Telefone
			WHERE PessoaId = @PessoaId
			COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
	END CATCH
END
GO
 
--Update para tabela Aulas
CREATE PROCEDURE UpdateAula
(
	@CursoId INT, @Titulo VARCHAR(50), @Arquivo VARBINARY(MAX), @Descricao VARCHAR(MAX)
)
AS
BEGIN
	UPDATE Aula_gravada SET Titulo = @Titulo, Arquivo = @Arquivo, Descricao = @Descricao
		WHERE CursoId = @CursoId
END
GO
--Update para tabela Cursos
CREATE PROCEDURE UpdateCurso
(
	@ProfessorId INT, @Nome VARCHAR(50), @Preco MONEY, @CargaHoraria TIME
)
AS
BEGIN
	UPDATE Cursos SET Nome = @Nome, Preco = @Preco, CargaHoraria = @CargaHoraria
		WHERE ProfessorId = @ProfessorId
END
GO
--Update para tabela Compra
CREATE PROCEDURE UpdateCompra
(
	@AlunoId INT, @DataCompra DATETIME, @Status INT, @Valor MONEY
)
AS
BEGIN
	UPDATE Compras SET AlunoId = @AlunoId, DataCompra = @DataCompra, Status = @Status, Valor = @Valor
END
GO
-------------------------------------------------------------------
--Views
-------------------------------------------------------------------
--VIEW para tabela Alunos
CREATE VIEW V_Alunos
AS
	SELECT a.AlunoId AS ID, p.Nome AS Aluno, p.Email, p.Telefone
	FROM Alunos a INNER JOIN Pessoas p
	ON a.AlunoId = p.PessoaId
GO

--VIEW para tabela Profesores
CREATE VIEW V_Professores
AS
	SELECT pp.ProfessorId AS ID, p.Nome AS Professor, p.Email, p.Telefone
	FROM Professores pp INNER JOIN Pessoas p
	ON pp.ProfessorId = p.PessoaId
GO

--VIEW para tabela Cursos
--CREATE VIEW V_Cursos
--AS
--	SELECT 

--TESTE
CREATE PROCEDURE AddCurso
(
	@ProfessorId INT, @Nome VARCHAR(50), @Preco MONEY, @CargaHoraria TIME, @Thumbnail VARBINARY(MAX)
)
AS
BEGIN
	INSERT INTO Cursos ( ProfessorId, Nome, Preco, CargaHoraria, Thumbnail)
		SELECT @ProfessorId, @Nome, @Preco, @CargaHoraria, BulkColumn FROM OPENROWSET (Bulk 'D:\mat.jpg', Single_Blob) Thumbnail
END
GO
EXEC AddCurso '