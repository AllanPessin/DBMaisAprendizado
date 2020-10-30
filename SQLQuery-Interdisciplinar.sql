--Cria o banco de dados
create database DBinter
go --Da continuidade no código atualizando o banco de dados

use DBinter--Torna o banco especificado em uso
go

create table Pessoas --Cria tabela 
(
	PessoaId       int         not null primary key identity, --Número inteiro, não pode ser nulo, chave primária e o proprio SGBD cria
	Nome           varchar(50) not null, --Nome é uma variavel de tamanho 50
	Email          varchar(30) unique,
	DataNascimento date        not null,
	Senha	       varchar(8)  not null
	--Telefone varchar(15) not null --Colocar uma unica coluna usada nas duas heranças
)
go
 
create table Alunos --Cria tabela
(
	AlunoId int not null primary key references Pessoas, --Usa a chave primaria de pessoas
	Telefone varchar(15) not null
)
go

create table Professores
(
	ProfessorId int not null primary key references Pessoas, --Usa a chave primaria de pessoas
	Credito     money,
	Telefone    varchar(15) not null
)
go

create table Compras
(
	CompraId   int      not null primary key identity,
	AlunoId    int      not null references Alunos, --Preciso do id de quem faz a compra
	DataCompra datetime not null,
	status     int,
	Valor      money
)
go

create table Cursos
(
	CursoId        int         not null primary key identity,
	AlunoId        int	           null references Alunos, --Precisa do id de quem faz a compra
	ProfessoresId  int         not null references Professores, --Precisa do id de quem disponibiliza o material
	Nome           varchar(50) not null,
	Preco          money	   not null,
	CargaHoraria   time        not null --varchar(50)
)
go

create table Compra_Curso
(	
	CompraId   int   not null references Compras,
	CursoId    int   not null references Cursos,
	primary    key (CompraId, CursoId), --Chave primária composta
	Quantidade int   not null,
	status     int,
	Valor      money not null
)
go

create table Aula_gravada
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

--CREATE PROCEDURE AdicionarCurso
--(
--	@Nome  VARCHAR(50), @Preco DECIMAL, @CargaHoraria DATE
--)
--AS
--BEGIN
--	INSERT INTO Cursos(
--END
--GO

-------------------------------------------------------------------
--Procedures para Update
-------------------------------------------------------------------

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