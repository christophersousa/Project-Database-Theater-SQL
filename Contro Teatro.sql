/* Formato para as datas */
SET DATEFORMAT dmy

/* Cria��o do Banco de Dados ControleTeatro */
CREATE DATABASE ControleTeatro

/* Usar o Bando depois de criado como default */
USE ControleTeatro

-- Cria��o da Tabela Teatro
CREATE TABLE Teatro 
(
  idteatro   smallint         IDENTITY,
  nome       varchar(150)     NOT NULL,
  rua        varchar(150)     NOT NULL,
  numero     varchar(10)      NOT NULL
  CONSTRAINT CK_teatro_numero CHECK(numero LIKE '[0-9] [0-9] [0-9] [0-9] [0-9] [0-9] [0-9] [0-9] [0-9] [0-9]'),
  bairro     varchar(45)      NOT NULL,
  cidade     varchar(45)      NOT NULL
  CONSTRAINT DF_teatro_cidade DEFAULT 'Jo�o Pessoa',
  capacidade varchar(15)      NOT NULL,
  CONSTRAINT PK_teatro        PRIMARY KEY (idteatro),
)

INSERT INTO Teatro VALUES(1,'Santa Rosa','Praça Pedro Américo','Centro')

/* Cria��o da Tabela Telefone */
CREATE TABLE Telefone
(
  fone       smallint           IDENTITY,
  idteatro   smallint           NOT NULL,
  tipo       varchar(15)        NOT NULL,
  CONSTRAINT PK_telefone        PRIMARY KEY (fone),
  CONSTRAINT FK_telefone_teatro FOREIGN KEY (idteatro) REFERENCES Teatro,
  
)

/* Cria��o da Tabela Artista */
CREATE TABLE Artista
(
  idartista       smallint                  IDENTITY,
  nome            varchar(150)              NOT NULL,
  data_nascimento date                      NOT NULL
  CONSTRAINT      CK_possui_data_nascimento CHECK(data_nascimento < GETDATE()),
  pais_origem     varchar(45)               NOT NULL
  CONSTRAINT      DF_artista_pais_origem    DEFAULT 'Brasil',
  cidade          varchar(45)               NOT NULL
  CONSTRAINT      DF_artista_cidade         DEFAULT 'Jo�o Pessoa',
  CONSTRAINT      PK_artista                PRIMARY KEY (idartista),
)

/* Cria��o da Tabela Pe�a */
CREATE TABLE Peca
(
  idpeca        smallint        IDENTITY,
  idteatro      smallint        NOT NULL,
  idartista     smallint        NOT NULL,
  titulo        varchar(45)     NOT NULL,
  duracao       varchar(45)     NOT NULL,
  classificacao varchar(45)     NOT NULL,
  CONSTRAINT    PK_peca         PRIMARY KEY (idpeca),
  CONSTRAINT    FK_peca_teatro  FOREIGN KEY (idteatro)  REFERENCES Teatro,
  CONSTRAINT    FK_peca_artista FOREIGN KEY (idartista) REFERENCES Artista
)

/* Cria��o da Tabela Sessao */
CREATE TABLE Sessao
(
  idsessao   smallint       IDENTITY,
  idpeca     smallint       NOT NULL,
  publico    varchar(45)    NOT NULL,
  hora       time           NOT NULL,
  CONSTRAINT FK_sessao_peca FOREIGN KEY (idpeca) REFERENCES Peca,
  CONSTRAINT PK_sessao      PRIMARY KEY (idsessao, idpeca),
)

/* Cria��o da Tabela Patrocinio */
CREATE TABLE Patrocinio
(
  idpatrocinio smallint      IDENTITY,
  nome         varchar(150)  NOT NULL,
  CONSTRAINT   PK_patrocinio PRIMARY KEY (idpatrocinio),
)

/* Cria��o da Tabela Possui */
CREATE TABLE Possui
(
  idpeca       smallint             NOT NULL,
  idsessao     smallint             NOT NULL,
  idpatrocinio smallint             NOT NULL,
  intervalo    varchar(45)          NOT NULL,
  data_exib    date                 NOT NULL
  CONSTRAINT   CK_possui_data_exib  CHECK(data_exib >= GETDATE()),
  CONSTRAINT   FK_possui_peca       FOREIGN KEY (idpeca)           REFERENCES Peca,
  CONSTRAINT   FK_possui_sessao     FOREIGN KEY (idsessao, idpeca) REFERENCES Sessao,
  CONSTRAINT   FK_possui_patrocinio FOREIGN KEY (idpatrocinio)     REFERENCES Patrocinio,
  CONSTRAINT   PK_possui            PRIMARY KEY (idpeca, idsessao, idpatrocinio),
  CONSTRAINT   AK_possui_intervalo  UNIQUE (intervalo),
  CONSTRAINT   AK_possui_data_exib  UNIQUE (data_exib),
)

/* Cria��o da Tabela Pode */
CREATE TABLE Pode
(
  idpeca       smallint           NOT NULL,
  idpatrocinio smallint           NOT NULL,
  CONSTRAINT   FK_pode_peca       FOREIGN KEY (idpeca)       REFERENCES Peca,
  CONSTRAINT   FK_pode_patrocinio FOREIGN KEY (idpatrocinio) REFERENCES Patrocinio,
  CONSTRAINT   PK_pode            PRIMARY KEY (idpeca, idpatrocinio),
)

/* Cria��o da Tabela Genero */
CREATE TABLE Genero
(
  idgenero   smallint    IDENTITY,
  descricao  varchar(45) NOT NULL,
  CONSTRAINT PK_genero   PRIMARY KEY (idgenero),
)

/* Cria��o da Tabela Tem */
CREATE TABLE Tem
(
  idgenero   smallint      NOT NULL,
  idpeca     smallint      NOT NULL,
  CONSTRAINT FK_tem_genero FOREIGN KEY (idgenero) REFERENCES Genero,
  CONSTRAINT FK_tem_peca   FOREIGN KEY (idpeca)   REFERENCES Peca,
  CONSTRAINT PK_tem        PRIMARY KEY (idpeca, idgenero),
)

/* Cria��o da Tabela Personagem */
CREATE TABLE Personagem
(
  idpersonagem smallint      IDENTITY,
  nome         varchar(150)  NOT NULL,
  CONSTRAINT   PK_personagem PRIMARY KEY (idpersonagem),
)

/* Cria��o da Tabela Ator */
CREATE TABLE Ator
(
  idartista       smallint        NOT NULL,
  escola_formacao varchar(150)    NOT NULL,
  CONSTRAINT      FK_ator_artista FOREIGN KEY (idartista) REFERENCES Artista,
  CONSTRAINT      PK_ator         PRIMARY KEY (idartista),
)

/* Cria��o da Tabela Atuar */
CREATE TABLE Atuar
(
  idpersonagem smallint            NOT NULL,
  idartista    smallint            NOT NULL,
  idpeca       smallint            NOT NULL,
  CONSTRAINT   FK_atuar_personagem FOREIGN KEY (idpersonagem) REFERENCES Personagem,
  CONSTRAINT   FK_atuar_artista    FOREIGN KEY (idartista)    REFERENCES Artista,
  CONSTRAINT   FK_atuar_peca       FOREIGN KEY (idpeca)       REFERENCES Peca,
  CONSTRAINT   PK_atuar            PRIMARY KEY (idpersonagem, idartista, idpeca),
)

/* Cria��o da Tabela Figurinista */
CREATE TABLE Figurinista
(
  idartista  smallint               NOT NULL,
  CONSTRAINT FK_figurinista_artista FOREIGN KEY (idartista) REFERENCES Artista,
  CONSTRAINT PK_figurinista         PRIMARY KEY (idartista),
)

/* Cria��o da Tabela Diretor */
CREATE TABLE Diretor
(
  idartista  smallint           NOT NULL,
  CONSTRAINT FK_diretor_artista FOREIGN KEY (idartista) REFERENCES Artista,
  CONSTRAINT PK_diretor         PRIMARY KEY (idartista),
)


/* Apagar uma restri��o de uma tabela */
ALTER TABLE Diretor 
DROP CONSTRAINT FK_diretor_artista
/* Apagar uma tabela (n�o � case sensitive) */
DROP TABLE Diretor 
/* Apagar uma tabela se ela existir */
DROP TABLE IF EXISTS Peca

/* Teste para verificar as tabelas criadas */
SELECT * FROM Possui

