--Cria o banco de dados
create database DBinter
go --Da continuidade no código atualizando o banco de dados

use DBinter--Torna o banco especificado em uso
go

create table Pessoas --Cria tabela 
(
	Id             int         not null primary key identity, --Número inteiro, não pode ser nulo, chave primária e o proprio SGBD cria
	Nome           varchar(50) not null, --Nome é uma variavel de tamanho 50
	Email          varchar(30) unique,
	DataNascimento date        not null,
	Senha	       varchar(8)  not null
)
go
 
create table Alunos --Cria tabela
(
	PessoaId int not null primary key references Pessoas, --Usa a chave primaria de pessoas
	Telefone varchar(15) not null
)
go

create table Professores
(
	PessoaId int not null primary key references Pessoas, --Usa a chave primaria de pessoas
	Credito money
)
go

create table Compras
(
	CompraId  int      not null primary key identity,
	AlunoId   int      not null references Alunos, --Preciso do id de quem faz a compra
	DataCompra datetime not null,
	status     int,
	Valor      money
)
go

create table Cursos
(
	CursoId       int         not null primary key identity,
	AlunoId       int	   not null references Alunos, --Precisa do id de quem faz a compra
	ProfessoresId int         not null references Professores, --Precisa do id de quem disponibiliza o material
	Nome           varchar(50) not null,
	Preco          money	   not null,
	CargaHoraria   time        not null
)
go

create table Compra_Curso
(	
	CompraId int   not null references Compras,
	CursoId  int   not null references Cursos,
	primary   key (CompraId, CursoId), --Chave primária composta
	Qtde      int   not null,
	status    int,
	Valor     money not null
)
go

create table Aula_gravada
(
	AulaId  int            not null primary key identity,
	CursoId int          	not null references Cursos,
	Titulo   varchar(40)	not null,
	Arquivo  varbinary(max) not null, --Guarda arquivos no Banco de até 2GB,
	Descricao varchar(50)	 	
)
go

-------------------------------------------------
--Procedimentos para inserir
-------------------------------------------------
CREATE PROCEDURE AdicionarAluno

	@Nome     VARCHAR(50),
	@Email    VARCHAR(30),
	@DataNascimento DATE,
	@Senha    VARCHAR (8),
	@Telefone VARCHAR(15)

AS
BEGIN
	INSERT INTO Pessoas VALUES( @Nome, @Email, @DataNascimento, @Senha )
	INSERT INTO Alunos  VALUES( @@IDENTITY, @Telefone )
END
GO;

CREATE PROCEDURE AdicionarProfessor

	@Nome     VARCHAR(50),
	@Email    VARCHAR(30),
	@DataNascimento DATE,
	@Senha    VARCHAR (8),
	@Credito  DECIMAL(10,2)

AS
BEGIN
	INSERT INTO Pessoas VALUES( @Nome, @Email, @DataNascimento,@Senha )
	INSERT INTO Professores  VALUES( @@IDENTITY, @Credito )
END
GO;

CREATE PROCEDURE AdicionarCurso

	@ProfessoresId INT,
	@Nome           VARCHAR(50),
	@Preco          DECIMAL(10,2),
	@CargaHoraria   TIME

AS
BEGIN
	INSERT INTO Cursos VALUES( @ProfessoresId, @Nome, @Preco, @CargaHoraria )
END
GO;

CREATE PROCEDURE AdicionarCompra

	@Aluno	    INT,
	@DataCompra DATETIME,
	@Status     INT,
	@Valor      DECIMAL(10,2)

AS
BEGIN
	INSERT INTO Cursos VALUES( @Aluno, @DataCompra, @Status, @Valor )
END
GO;

-------------------------------------------------
--Procedimentos para alterar
-------------------------------------------------
CREATE PROCEDURE AlterarAluno

	@PessoaId INT OUTPUT,
	@Nome VARCHAR(50),
	@Email VARCHAR(30),
	@DataNascimento DATE,
	@Senha varchar(8),
	@Telefone VARCHAR(15)

AS
BEGIN
	DECLARE @Aluno INT
BEGIN TRY 
	BEGIN TRAN --Inicia transação

	UPDATE Pessoas
	SET Nome = @Nome, Email = @Email, DataNascimento = @DataNascimento, Senha = @Senha
	WHERE Id = @PessoaId
	SET @Aluno = SCOPE_IDENTITY();
	
	UPDATE Alunos
	SET Telefone = @Telefone
	WHERE PessoaId = @Aluno

	COMMIT TRAN --Finaliza a transação
END TRY 
BEGIN CATCH
	ROLLBACK TRAN --Se ocorreu erro cancela tudo
	SELECT ERROR_MESSAGE() AS Retorno --Mostra o erro
END CATCH
END;
go


CREATE PROCEDURE AlterarProfessor

	@PessoaId INT OUTPUT,
	@Nome     VARCHAR(50),
	@Email    VARCHAR(30),
	@DataNascimento DATE,
	@Senha    VARCHAR(8),
	@Credito  DECIMAL(10,2)

AS
BEGIN
	DECLARE @Professor INT
BEGIN TRY 
	BEGIN TRAN --Inicia transação

	UPDATE Pessoas
	SET Nome = @Nome, Email = @Email, DataNascimento = @DataNascimento, Senha = @Senha
	WHERE Id = @PessoaId
	SET @Alunos = SCOPE_IDENTITY();
	
	UPDATE Professores
	SET Credito = @Credito
	WHERE PessoaId = @Professor

	COMMIT TRAN --Finaliza a transação
END TRY 
BEGIN CATCH
	ROLLBACK TRAN --Se ocorreu erro cancela tudo
	SELECT ERROR_MESSAGE() AS Retorno --Mostra o erro
END CATCH
END;
go
-------------------------------------------------
--Procedimentos para atualizando do status = 'excluido'
-------------------------------------------------


-------------------------------------------------
--Fun��es
-------------------------------------------------

CREATE FUNCTION CalcularTotalCompra( @IdCompra INT )
RETURNS DECIMAL(10,2)
AS
BEGIN
	RETURN ( SELECT SUM( Qtde*Valor ) FROM Compra_Curso WHERE CompraId = @IdCompra )
END