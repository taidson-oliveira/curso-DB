/*

* Este projeto tem como finalidade armazenar os dados

* de orçamento familiar para controle de despesas

*/

-- Criando o banco de dados

CREATE DATABASE IF NOT EXISTS orcamento

DEFAULT CHARACTER SET = utf8

DEFAULT COLLATE = utf8_general_ci;

-- Setando o banco

use orcamento;

-- exibindo as tabelas do banco orcamento

show tables;

/*criando a tabela que amarzena as despesas fixas

* Essas despesas são aquelas mais comuns

* e não tem prazo definido.

* Ex(aguá, luz, telefone)

*/

CREATE TABLE IF NOT EXISTS despesas_fixas(

num_despesa int (4) unsigned not null auto_increment primary key,

cpf_membro_familiar bigint(11) unsigned,

descricao varchar(30) not null default ' ',

valor float(10,2)

);

/*Criando a tabela que armazena as despesas variaveis

* Essas despesas são aquelas não obrigatórias

* e não possuem prazo.

* Ex(pizza,balada,mercado não planejado)

*/

CREATE TABLE IF NOT EXISTS despesas_variaveis(

num_despesa int (4) unsigned not null auto_increment primary key,

cpf_membro_familiar bigint(11) unsigned,

descricao varchar(30) not null default ' ',

valor float(10,2),

data_despesa DATE

);

/*Criando a tabela de divídas

* Essas são despesas obrigátorias ou não obrigátorias

* mas que possuem prazos definidos.

* Ex(cartão de crédito, empréstimos, compra de veicúlo)

*/

CREATE TABLE IF NOT EXISTS dividas(

num_divida int(4) unsigned not null auto_increment primary key,

cpf_membro_familiar bigint(11) unsigned,

descricao varchar(30) not null default ' ',

valor_total float(10,2) not null default '0.00',

valor_parcela float(10,2) as (valor_total/num_parcelas_totais),

valor_pago float(10,2) as (valor_parcela*num_parcelas_pagas),

valor_restante float(10,2) as (valor_total-valor_pago),

num_parcelas_totais int(4) unsigned not null default '0',

num_parcelas_pagas int(4) unsigned not null default '0',

num_parcelas_restantes int(4) unsigned as (num_parcelas_totais-num_parcelas_pagas),

data_ini_divida DATE,

data_ultima_parcela_paga DATE,

data_fim_divida DATE

);

/*Criando a tabela de ganhos

* Esse são todas as receitas

* tanto fixas Ex(sálario,aposentadoria,aluguel)

* quanto variáveis Ex(Bico, venda de bens)

*/

CREATE TABLE IF NOT EXISTS ganhos(

id int(4) unsigned not null auto_increment primary key,

cpf_membro_familiar bigint(11) unsigned,

descricao varchar(30) not null default ' ',

valor_bruto float(10,2) not null default '0.00',

valor_liquido float(10,2) not null default '0.00',

valor_desconto float(10,2) not null default '0.00',

tipo_ganho enum('fixo','variavel')

);

-- Criando a tabela que armazena os dados dos membros familiares

CREATE TABLE IF NOT EXISTS membro_familiar(

cpf bigint(11) unsigned not null primary key,

nome varchar(30) not null default ' ',

idade int(3) not null default '0',

grau_parentesco enum('avo_M','avo_F','pai','mae','filho','filha','neto','neta','parente nao cosanguineo','outros')

);

-- Adicionando a chave estrangeira

ALTER TABLE ganhos add CONSTRAINT FK_ganhos foreign key (cpf_membro_familiar) references membro_familiar(cpf);

ALTER TABLE despesas_fixas add CONSTRAINT FK_despesas_fixas foreign key (cpf_membro_familiar) references membro_familiar(cpf);

ALTER TABLE despesas_variaveis add CONSTRAINT FK_despesas_variaveis foreign key (cpf_membro_familiar) references membro_familiar(cpf);

ALTER TABLE dividas add CONSTRAINT FK_dividas foreign key (cpf_membro_familiar) references membro_familiar(cpf);

-- Inserindo os dados as tabelas
INSERT INTO membro_familiar (cpf,nome,idade,grau_parentesco) values (11111111112,'user 1',22,'filho'),(11111111113,'user 2',45,'pai');

INSERT INTO ganhos (cpf_membro_familiar,descricao,valor_bruto,valor_liquido,valor_desconto,tipo_ganho) values (11111111112,'salário',1048,1000,valor_bruto-valor_liquido,'fixo'),(11111111113,'uber',200,120,valor_bruto-valor_liquido,'variavel');

INSERT INTO despesas_variaveis (cpf_membro_familiar,descricao,valor,data_despesa) values (11111111112,'sorvete',15.55,'2020-08-31'),(11111111113,'hotel',120,'2020-08-31');

INSERT INTO despesas_fixas (cpf_membro_familiar,descricao,valor) values (11111111112,'curso',220),(11111111113,'agua',90);

INSERT INTO dividas (cpf_membro_familiar,descricao,num_parcelas_totais,num_parcelas_pagas,valor_total,data_ini_divida,data_ultima_parcela_paga,data_fim_divida)
values (11111111112,'celular',10,2,1580,'2020-08-31','2020-08-31','2021-07-01'),(11111111113,'smart tv',10,1,2100,'2020-08-31','2020-08-31','2021-07-01');

-- Consultando informações da tabela despesas fixas por cpf
SELECT * from despesas_fixas where cpf_membro_familiar LIKE '11111111113';

-- Consultando informações sobre menbro da familía por cpf
SELECT * from membro_familiar where cpf LIKE '11111111112';

-- Consultando informações das dividas por cpf relacionado a todos os membros da família
SELECT * from dividas join membro_familiar on dividas.cpf_membro_familiar = membro_familiar.cpf;

-- Consultando informações das dividas por cpf relacionado a membro familiar específico
SELECT * from dividas join membro_familiar on dividas.cpf_membro_familiar = membro_familiar.cpf WHERE cpf LIKE '11111111112';
