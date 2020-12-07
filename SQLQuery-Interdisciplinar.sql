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
	Credito     DECIMAL(10,2) NULL

)
GO

CREATE TABLE Compras
(
	CompraId   INT      NOT NULL PRIMARY KEY IDENTITY (1, 1),
	AlunoId    INT      NOT NULL REFERENCES Alunos,
	DataCompra DATETIME NOT NULL,
	Status     INT,
	Valor      DECIMAL(10,2)
)
GO

CREATE TABLE Cursos
(
	CursoId      INT           NOT NULL PRIMARY KEY IDENTITY (1, 1),
	ProfessorId  INT           NOT NULL REFERENCES Professores,
	Nome         VARCHAR(50)   NOT NULL,
	Preco        DECIMAL(10,2) NOT NULL,
	CargaHoraria DECIMAL(4,2)  NOT NULL
)
GO
sp_help cursos	
CREATE TABLE Compra_Curso
(	
	CompraId   INT   NOT NULL FOREIGN KEY REFERENCES Compras,
	CursoId    INT   NOT NULL FOREIGN KEY REFERENCES Cursos,
	Quantidade INT   NOT NULL,
	Status     INT,
	Valor      DECIMAL(10,2) NOT NULL
	PRIMARY    KEY (CompraId, CursoId)
)
GO

CREATE TABLE Aula_Gravada
(
	AulaId    INT            NOT NULL PRIMARY KEY IDENTITY (1, 1),
	CursoId   INT            NOT NULL FOREIGN KEY REFERENCES Cursos,
	Titulo    VARCHAR(50)	 NOT NULL,
	Descricao VARCHAR(max)   NOT NULL,
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

INSERT INTO Professores VALUES (4, NULL)
INSERT INTO Professores VALUES (5, NULL)
INSERT INTO Professores VALUES (6, NULL)

INSERT INTO Compras VALUES (1, GETDATE(), 1, NULL)
INSERT INTO Compras VALUES (2, GETDATE(), 1, NULL)
INSERT INTO Compras VALUES (3, GETDATE(), 1, 30.0)

INSERT INTO Cursos VALUES (4, 'Programação', 80.0, 40.0)
INSERT INTO Cursos VALUES (5, 'Banco de Dados', 25, 80.00)
INSERT INTO Cursos VALUES (6, 'Mobile', 40, 30)
	
INSERT INTO Aula_Gravada VALUES(3, 'React Native', 'Utilização de react natice')
INSERT INTO Aula_Gravada VALUES(2, 'INSERT', 'Como fazer insert')
INSERT INTO Aula_Gravada VALUES(1, 'C# Herança', 'Conceito de herança')

INSERT INTO Compra_Curso VALUES(1, 2, 1, 1, 80)
INSERT INTO Compra_Curso VALUES(2, 1, 1, 1, 40)
INSERT INTO Compra_Curso VALUES(3, 3, 1, 1, 30)

-------------------------------------------------------------------
--Testes de Procedures
-------------------------------------------------------------------
EXEC AdicionarProfessor 'Roberto', 'robert@email.com', '1979-08-06', '555555', '179523164'
EXEC AdicionarProfessor 'Marcelo', 'celo@email.com', '1979-08-06', '123654', '179124564'


EXEC AdicionarAluno 'Pedro', 'Pedrinho@Gmail.com', '1999-09-05', '498431', '169998855'
EXEC UpdateAluno '1', 'Allan da Silva', 'allan@hotmail.com', '1998-03-08', '31599753', '981522510'

EXEC AdicionarCurso '7', 'Guitarra', '120', '20'

EXEC AdicionarCompra '1', '80.00' 

EXEC AdicionarAula '1', 'Primeira aula', 'introdução aos conceitos'
EXEC AdicionarCompraCurso  '5', '1', '100', '6'

EXEC UpdateProfessor '6', 'Jéssica', 'Jess@hotmail.com', '1999-08-04', '3159975', '981458796'
EXEC UpdateProfessor '7', 'Roberto', 'roberto@email.com', '1979-08-06', '555555', '179523164'
-------------------------------------------------------------------
--Procedures para inserir
-------------------------------------------------------------------
--Procedure para inserir tabela Professores
GO
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
	@ProfessorId INT, @Nome VARCHAR(50), @Preco DECIMAL(10,2), @CargaHoraria DECIMAL(4,2)
)
AS
BEGIN
	INSERT INTO Cursos VALUES (@ProfessorId, @Nome, @Preco, @CargaHoraria)
END
GO
EXEC AdicionarCompraCurso 
--Procedure para inserir tabela Compras
EXEC
Create PROCEDURE AdicionarCompra
(
    @AlunoId INT, @Valor DECIMAL(10,2)
)
AS
BEGIN
    INSERT INTO Compras VALUES (@AlunoId, GETDATE(), 1, @Valor)
      SELECT @@IDENTITY AS 'CompraId';
END
GO

--Procedure para inserir tabela Aulas
CREATE PROCEDURE AdicionarAula
(
	@CursoId INT, @Titulo VARCHAR(50), @Descricao VARCHAR(MAX)
)
AS
BEGIN
	INSERT INTO Aula_gravada VALUES (@CursoId, @Titulo, @Descricao)
END
GO

--Procedure para inserir tabela Compra_Curso
ALTER PROCEDURE AdicionarCompraCurso
(
   @CompraId INT, @CursoId INT, @Valor DECIMAL(10,2), @ProfessorId INT
)
AS 
BEGIN
    INSERT INTO Compra_Curso VALUES (@CompraId, @CursoId, 1, 1, @Valor)
		UPDATE Professores SET Credito = Credito + @Valor
			WHERE ProfessorId = @ProfessorId
END
GO

-------------------------------------------------------------------
--Calcular Total da compra
-------------------------------------------------------------------
GO
CREATE FUNCTiON CalcTotal (@Compra INT)
RETURNS DECIMAL(10,2)
AS
BEGIN 
	RETURN
	(
		SELECT SUM(Quantidade * Valor) FROM Compra_Curso 
		WHERE CompraId = @Compra
	)
END
GO

GO
CREATE PROCEDURE ValorTotal(@Compra INT)
AS
BEGIN
	UPDATE Compras SET Valor = dbo.CalcTotal(Compra) WHERE Compra=@Compra	
END
GO

-------------------------------------------------------------------
--Procedures para Update
-------------------------------------------------------------------

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
EXEC UpdateAluno '1', 'Allan da Silva', 'allan@hotmail.com', '1998-03-08', '31599753', '981522510'
 
--Update para tabela Aulas
CREATE PROCEDURE UpdateAula
(
	@CursoId INT, @Titulo VARCHAR(50), @Descricao VARCHAR(MAX)
)
AS
BEGIN
	UPDATE Aula_gravada SET Titulo = @Titulo, Descricao = @Descricao
		WHERE CursoId = @CursoId
END
GO
--Update para tabela Cursos
CREATE PROCEDURE UpdateCurso
(
	@ProfessorId INT, @Nome VARCHAR(50), @Preco DECIMAL(10,2), @CargaHoraria DECIMAL(4,2)
)
AS
BEGIN
	UPDATE Cursos SET Nome = @Nome, Preco = @Preco, CargaHoraria = @CargaHoraria
		WHERE ProfessorId = @ProfessorId
END
GO
EXEC UpdateCurso '3', 'Mobile', '40.00', '35'
select * from Cursos
--Update para tabela Compra
CREATE PROCEDURE UpdateCompra
(
	@CompraId INT, @AlunoId INT, @Status INT, @Valor DECIMAL(10,2)
) 
AS
BEGIN
	UPDATE Compras SET AlunoId = @AlunoId, Status = @Status, Valor = @Valor
		WHERE CompraId = @CompraId
END
GO
EXEC UpdateCompra '1', '1', '80'

--Update para tabela Aula_Gravada
CREATE PROCEDURE UpdateAula
(
	@AulaId INT, @CursoId INT, @Titulo VARCHAR(50), @Descricao VARCHAR(MAX)	
)
AS
BEGIN
	UPDATE Aula_Gravada SET CursoId = @CursoId, Titulo = @Titulo, Descricao = @Descricao
		WHERE AulaId = @AulaId
END
GO
EXEC UpdateAula '1', '3', 'React', 'Introdução'

--Update para tabela Compra_Curso
CREATE PROCEDURE UpdateCompraCurso
(
	@Quantidade INT, @Valor DECIMAL(10,2), @CompraId INT, @CursoId INT
)
AS
BEGIN
	UPDATE Compra_Curso SET Quantidade = @Quantidade, Status = 1,  Valor = @Valor 
		WHERE CompraId = @CompraId and CursoId = @CursoId
END
GO
EXEC UpdateCompraCurso '1', '85', '1', '1'

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

SELECT * from V_Alunos

--VIEW para tabela Profesores
CREATE VIEW V_Professores
AS
	SELECT pp.ProfessorId AS ID, p.Nome AS Professor, p.Email, p.Telefone
	FROM Professores pp INNER JOIN Pessoas p
	ON pp.ProfessorId = p.PessoaId
GO
SELECT * FROM V_Professores
--VIEW para tabela Compras
CREATE VIEW V_Compras
AS
	SELECT DataCompra, Valor, 
	CASE Status
		WHEN 1 THEN 'Ativo'
		WHEN 2 THEN 'Inativo'	
	END Situação 
FROM Compras

SELECT * FROM V_Compras
--VIEW para tabela Cursos
CREATE VIEW V_Cursos
AS
	SELECT Nome, Preco, CargaHoraria
	FROM Cursos

SELECT * FROM V_Cursos

--VIEW para tabela Aula_Gravada
CREATE VIEW V_Aula
AS
	SELECT Titulo, Descricao
	FROM Aula_Gravada

SELECT * FROM V_Aula

--VIEW para tabela Compra_Curso
CREATE VIEW V_CompraCurso
AS
	SELECT 
	CASE Status
		WHEN 1 THEN 'Ativo'
		WHEN 2 THEN 'Inativo'	
	END Situação,
	Quantidade, Valor	
	FROM Compra_Curso

SELECT * FROM V_CompraCurso
-------------------------------------------------------------------
-- VIEW COM JUNÇÃO (JOIN)
-------------------------------------------------------------------


CREATE VIEW V_CompraCursoId
AS
	SELECT cc.Quantidade, cc.Valor, 
				CASE cc.Status
					WHEN 1 THEN 'Ativo'
					WHEN 2 THEN 'Inativo'	
				END Situação 
	FROM Compra_Curso cc LEFT JOIN Compras c ON c.CompraId = cc.CompraId 
--TESTE-
SELECT * FROM V_CompraCurso


CREATE VIEW V_CursosPorProfessor
AS
	SELECT c.*,p.nome as ProfessorNome 
	FROM Cursos c left join pessoas p on p.pessoaId = c.professorId 

SELECT * FROM V_CursosPorProfessor


ALTER VIEW V_AlunosNome
AS
	SELECT p.PessoaId, p.Nome ,p.Email
	FROM Pessoas p INNER JOIN Alunos a ON p.PessoaId = a.AlunoId

SELECT * FROM V_AlunosNome
  	


CREATE VIEW V_CompraPorAluno
AS
	SELECT a.Nome, c.DataCompra, c.Valor
	FROM Pessoas a INNER JOIN Compras c ON c.AlunoId = a.PessoaId

SELECT * FROM V_CompraPorAluno


CREATE VIEW V_ValorVendasCurso
AS
	SELECT SUM(c.Valor) AS Valor, c.CursoId, cc.Nome
	FROM Compra_Curso c LEFT JOIN Cursos cc ON cc.CursoId = c.CursoId 
	GROUP BY c.CursoId, cc.Nome

SELECT * FROM V_ValorVendasCurso

CREATE VIEW V_QtdCadastros
AS
	SELECT COUNT(p.ProfessorId) AS QuantidadeProfessores, COUNT(a.AlunoId) AS QuantidadeAlunos, COUNT(pp.PessoaId) AS TotalCadastros
	FROM Pessoas pp LEFT JOIN Alunos a ON a.AlunoId = pp.PessoaId LEFT JOIN Professores p ON p.ProfessorId = pp.PessoaId 

SELECT * FROM V_QtdCadastros


CREATE VIEW V_QtdComprasAluno
AS
	SELECT p.Nome, COUNT(c.CompraId) AS Quantidade
	FROM Alunos a INNER JOIN Compras c ON c.AlunoId = a.AlunoId LEFT JOIN Pessoas p ON p.PessoaId = a.AlunoId
	GROUP BY p.Nome

SELECT * FROM V_QtdComprasAluno