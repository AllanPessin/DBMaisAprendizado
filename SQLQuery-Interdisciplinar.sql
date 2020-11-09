--Cria o banco de dados
create database DBinter
GO

use DBinter--Torna o banco especificado em uso
GO

create table Pessoas --Cria tabela 
(
	PessoaId       int         not null primary key identity, --Número inteiro, não pode ser nulo, chave primária e o proprio SGBD cria
	Nome           varchar(50) not null, --Nome é uma variavel de tamanho 50
	Email          varchar(30) unique,
	DataNascimento date        not null,
	Senha	       varchar(8)  not null
	--Telefone varchar(15) not null --Colocar uma unica coluna usada nas duas heranças
)
GO
 
create table Alunos --Cria tabela
(
	AlunoId int not null primary key references Pessoas, --Usa a chave primaria de pessoas
	Telefone varchar(15) not null
)
GO

create table Professores
(
	ProfessorId int not null primary key references Pessoas, --Usa a chave primaria de pessoas
	Credito     money,
	Telefone    varchar(15) not null
)
GO

create table Compras
(
	CompraId   int      not null primary key identity,
	AlunoId    int      not null references Alunos, --Preciso do id de quem faz a compra
	DataCompra datetime not null,
	Status     int,
	Valor      money
)
GO

create table Cursos
(
	CursoId        int         not null primary key identity,
	ProfessorId  int         not null references Professores, --Precisa do id de quem disponibiliza o material
	Nome           varchar(50) not null,
	Preco          money	   not null,
	CargaHoraria   time        not null --varchar(50)
)
GO

create table Compra_Curso
(	
	CompraId   int   not null references Compras,
	CursoId    int   not null references Cursos,
	primary    key (CompraId, CursoId), --Chave primária composta
	Quantidade int   not null,
	Status     int,
	Valor      money not null
)
GO

create table Aula_Gravada
(
	AulaId    int            not null primary key identity,
	CursoId   int            not null references Cursos,
	Titulo    varchar(50)	 not null,
	Arquivo   varbinary(max) not null, --Guarda arquivos no Banco de até 2GB,
	Descricao varchar(max)   not null	 	
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

CREATE VIEW V_Alunos
AS
