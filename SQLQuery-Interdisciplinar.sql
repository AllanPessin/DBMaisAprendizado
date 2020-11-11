--Cria o banco de dados
CREATE DATABASE DBinter
GO

USE DBinter--Torna o banco especificado em uso
GO

CREATE TABLE Pessoas --Cria tabela 
(
	PessoaId       INT         NOT NULL PRIMARY KEY IDENTITY, --Número inteiro, não pode ser nulo, chave primária e o proprio SGBD cria
	Nome           VARCHAR(50) NOT NULL, --Nome é uma variavel de tamanho 50
	Email          VARCHAR(30) UNIQUE,
	DataNascimento DATE        NOT NULL,
	Senha	       VARCHAR(8)  NOT NULL,
	Telefone       VARCHAR(15) NOT NULL
	--Telefone varchar(15) not null --Colocar uma unica coluna usada nas duas heranças
)
GO
 
CREATE TABLE Alunos --Cria tabela
(
	AlunoId INT NOT NULL PRIMARY KEY REFERENCES Pessoas, --Usa a chave primaria de pessoas
)
GO

CREATE TABLE Professores
(
	ProfessorId INT NOT NULL PRIMARY KEY REFERENCES Pessoas, --Usa a chave primaria de pessoas
	Credito     MONEY
)
GO

CREATE TABLE Compras
(
	CompraId   INT      NOT NULL PRIMARY KEY IDENTITY,
	AlunoId    INT      NOT NULL REFERENCES Alunos, --Preciso do id de quem faz a compra
	DataCompra DATETIME NOT NULL,
	Status     INT,
	Valor      MONEY
)
GO

CREATE TABLE Cursos
(
	CursoId      INT         NOT NULL PRIMARY KEY IDENTITY,
	ProfessorId  INT         NOT NULL REFERENCES Professores, --Precisa do id de quem disponibiliza o material
	Nome         VARCHAR(50) NOT NULL,
	Preco        MONEY	     NOT NULL,
	Thumnail	 VARBINARY(MAX) NOT NULL,
	CargaHoraria TIME        NOT NULL --varchar(50)
)
GO

CREATE TABLE Compra_Curso
(	
	CompraId   INT   NOT NULL REFERENCES Compras,
	CursoId    INT   NOT NULL REFERENCES Cursos,
	PRIMARY    KEY (CompraId, CursoId), --Chave primária composta
	Quantidade INT   NOT NULL,
	Status     INT,
	Valor      MONEY NOT NULL
)
GO

CREATE TABLE Aula_Gravada
(
	AulaId    INT            NOT NULL PRIMARY KEY IDENTITY,
	CursoId   INT            NOT NULL REFERENCES Cursos,
	Titulo    VARCHAR(50)	 NOT NULL,
	Arquivo   VARBINARY(max) NOT NULL, --Guarda arquivos no Banco de até 2GB,
	Descricao VARCHAR(max)   NOT NULL	 	
)
GO

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
	INSERT INTO Pessoas VALUES (@Nome, @Email, @DataNascimento, @Senha)
	INSERT INTO Professores (ProfessorId, Telefone) VALUES (@@IDENTITY, @Telefone)
END
GO
--Procedure para inserir tabela Alunos
CREATE PROCEDURE AdicionarAluno
(
	@Nome VARCHAR(50), @Email VARCHAR(50), @DataNascimento DATE, @Senha VARCHAR(8), @Telefone VARCHAR(15)
)
AS
BEGIN
	INSERT INTO Pessoas VALUES (@Nome, @Email, @DataNascimento, @Senha)
	INSERT INTO Alunos(AlunoId, Telefone) VALUES (@@IDENTITY, @Telefone)
END
GO
--Procedure para inserir tabela Cursos    
CREATE PROCEDURE AdicionarCurso
(
	@ProfessorId INT, @Nome VARCHAR(50), @Preco MONEY, @CargaHoraria TIME
)
AS
BEGIN
	INSERT INTO Cursos VALUES (@ProfessorId, @Nome, @Preco, @CargaHoraria)
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

--Update para tabela Alunos
CREATE PROCEDURE UpdateAluno
(
	@PessoaId int, @Nome VARCHAR(50), @Email VARCHAR(50), @DataNascimento DATE, @Senha VARCHAR(8), @Telefone VARCHAR(15)
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			UPDATE Pessoas SET Nome = @Nome, Email = @Email, DataNascimento = @DataNascimento
			WHERE PessoaId = @PessoaId
			UPDATE Alunos SET Telefone = @Telefone WHERE AlunoId = @PessoaId
			COMMIT
	END TRY
	BEGIN CATCH
		ROLLBACK
	END CATCH
END
GO

--Update para tabela Professores
CREATE PROCEDURE UpdateProfessor
(
	@PessoaId int, @Nome VARCHAR(50), @Email VARCHAR(50), @DataNascimento DATE, @Senha VARCHAR(8), @Telefone VARCHAR(15)
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			UPDATE Pessoas SET Nome = @Nome, Email = @Email, DataNascimento = @DataNascimento
			WHERE PessoaId = @PessoaId
			UPDATE Professores SET Telefone = @Telefone WHERE ProfessorId = @PessoaId
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
	SELECT a.AlunoId AS ID, p.Nome AS Aluno, p.Email, a.Telefone
	FROM Alunos a INNER JOIN Pessoas p
	ON a.AlunoId = p.PessoaId
GO

--VIEW para tabela Profesores
CREATE VIEW V_Professores
AS
	SELECT pp.ProfessorId AS ID, p.Nome AS Professor, p.Email, pp.Telefone
	FROM Professores pp INNER JOIN Pessoas p
	ON pp.ProfessorId = p.PessoaId
GO

--VIEW para tabela Cursos
CREATE VIEW V_Cursos
AS
	SELECT 

Sp_help Compra_Curso