--Cria o banco de dados
create database Interdisciplinar 
go --Da continuidade no código atualizando o banco de dados

use Interdisciplinar --Torna o banco especificado em uso
go

create table Pessoas --Cria tabela 
(
	id       int         not null primary key identity, --Número inteiro, não pode ser nulo, chave primária e o proprio SGBD cria
	Nome     varchar(50) not null, --Nome é uma variavel de tamanho 50
	Email    varchar(30) unique,
	DataNasc date        not null
)
go
 
create table Alunos --Cria tabela
(
	Pessoa_id int not null primary key references Pessoas, --Usa a chave primaria de pessoas
	Telefone varchar(15) not null
)
go

create table Professores
(
	Pessoa_id int not null primary key references Pessoas, --Usa a chave primaria de pessoas
	Credtio money
)
go

create table Compras
(
	Compra_id  int      not null primary key identity,
	Aluno_id   int      not null references Alunos, --Preciso do id de quem faz a compra
	DataCompra datetime not null,
	status     int,
	Valor      money
)
go

create table Cursos
(
	Curso_id       int         not null primary key identity,
	Aluno_id       int		   not null references Alunos, --Precisa do id de quem faz a compra
	Professores_id int         not null references Professores, --Precisa do id de quem disponibiliza o material
	Nome           varchar(50) not null,
	Preco          money	   not null,
	CargaHoraria   time        not null
)
go

create table Compra_Curso
(	
	Compra_id int   not null references Compras,
	Curso_id  int   not null references Cursos,
	primary   key (Compra_id, Curso_id), --Chave primária composta
	Qtde      int   not null,
	status    int,
	Valor     money not null
)
go

create table Aula_gravada
(
	Aula_id  int            not null primary key identity,
	Curso_id int          	not null references Cursos,
	Titulo   varchar(40)	not null,
	Arquivo  varbinary(max) not null, --Guarda arquivos no Banco de até 2GB
)
go

-------------------------------------------------
--Procedimentos para inserir
-------------------------------------------------
CREATE PROCEDURE AdicionarAluno

	@Nome     VARCHAR(50),
	@Email    VARCHAR(30),
	@DataNasc DATE,
	@Telefone VARCHAR(15)

AS
BEGIN
	INSERT INTO Pessoas VALUES( @Nome, @Email, @DataNasc )
	INSERT INTO Alunos  VALUES( @@IDENTITY, @Telefone )
END
GO;

CREATE PROCEDURE AdicionarProfessor

	@Nome     VARCHAR(50),
	@Email    VARCHAR(30),
	@DataNasc DATE,
	@Credito  MONEY

AS
BEGIN
	INSERT INTO Pessoas VALUES( @Nome, @Email, @DataNasc )
	INSERT INTO Professores  VALUES( @@IDENTITY, @Credito )
END
GO;

-------------------------------------------------
--Procedimentos para alterar
-------------------------------------------------



-------------------------------------------------
--Procedimentos para excluir
-------------------------------------------------


-------------------------------------------------
--Fun��es
-------------------------------------------------

CREATE FUNCTION CalcularTotalCompra( @IdCompra INT )
RETURNS DECIMAL(10,2)
AS
BEGIN
	RETURN ( SELECT SUM( Qtde*Valor ) FROM Compra_Curso WHERE Compra_id = @IdCompra )
END