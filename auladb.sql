-- ROLES

CREATE ROLE daniel INHERIT LOGIN PASSWORD '123' IN ROLE professores;
DROP ROLE daniel;
CREATE ROLE daniel LOGIN PASSWORD '123' ROLE professores;
CREATE TABLE teste (nome varchar);
GRANT ALL ON TABLE teste TO professores;
CREATE ROLE daniel LOGIN PASSWORD '123';
REVOKE professores FROM daniel;

-- TABELAS

CREATE TABLE IF NOT EXISTS banco (
	numero INTEGER NOT NULL,
	nome VARCHAR(50) NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (numero)
);

INSERT INTO banco (numero, nome) VALUES ('237', 'Bradesco');
INSERT INTO banco (numero, nome) VALUES ('104', 'Caixa Econômica Federal');
INSERT INTO banco (numero, nome) VALUES ('341', 'Itaú');


CREATE TABLE IF NOT EXISTS agencia(
	banco_numero INTEGER NOT NULL,
	numero INTEGER NOT NULL,
	nome VARCHAR(80) NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (banco_numero, numero),
	FOREIGN KEY (banco_numero) REFERENCES banco (numero) 
);

INSERT INTO agencia (banco_numero, numero, nome) VALUES (001, 1244, 'Visc. Guarapuava');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (001, 1316, 'Mallet');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (001, 2145, 'Itararé');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (104, 1343, 'Itapeva');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (104, 1245, 'Curitiba');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (104, 3243, 'Fortaleza');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (237, 8245, 'Santos');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (237, 3212, 'Londrina');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (237, 4389, 'Maringá');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (341, 0368, 'Praça Osório');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (341, 8113, 'Batel');
INSERT INTO agencia (banco_numero, numero, nome) VALUES (341, 2331, 'Bigorrilho');


CREATE TABLE IF NOT EXISTS cliente (
	numero BIGSERIAL PRIMARY KEY,
	nome VARCHAR(120) NOT NULL,
	email VARCHAR(250) NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE conta_corrente;

CREATE TABLE IF NOT EXISTS conta_corrente (
	banco_numero INTEGER NOT NULL,
	agencia_numero INTEGER NOT NULL,
	numero BIGINT NOT NULL,
	digito SMALLINT NOT NULL,
	cliente_numero BIGINT NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (banco_numero, agencia_numero, numero, digito, cliente_numero),
	FOREIGN KEY (banco_numero, agencia_numero) 
		REFERENCES agencia (banco_numero, numero),
	FOREIGN KEY (cliente_numero) REFERENCES cliente (numero)
);

CREATE TABLE tipo_transacao (
	id SMALLSERIAL PRIMARY KEY,
	nome VARCHAR(50) NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP	
);

CREATE TABLE cliente_transacoes (
	id BIGSERIAL PRIMARY KEY,
	banco_numero INTEGER NOT NULL,
	agencia_numero INTEGER NOT NULL,
	conta_corrente_numero BIGINT NOT NULL,
	conta_corrente_digito SMALLINT NOT NULL,
	cliente_numero BIGINT NOT NULL,
	tipo_transacao_id SMALLINT NOT NULL,
	valor NUMERIC(15,2) NOT NULL,
	data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (banco_numero, agencia_numero, conta_corrente_numero, 
				conta_corrente_digito, cliente_numero) 
				REFERENCES conta_corrente (banco_numero, agencia_numero, 
				numero, digito, cliente_numero)
	);

CREATE TABLE IF NOT EXISTS teste (
	cpf VARCHAR(11) NOT NULL,
	nome VARCHAR(50) NOT NULL,
	create_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (cpf)
);

INSERT INTO teste (cpf, nome, create_at) 
VALUES ('12345678900', 'José Colméia', '20-06-2020 01:23:29');

INSERT INTO teste (cpf, nome, create_at) 
VALUES ('12345678900', 'José Colméia', '20-06-2020 01:23:29') 
		ON CONFLICT (cpf) DO NOTHING;

UPDATE teste SET nome = 'Pedro Alvares' WHERE cpf = '12345678900';

SELECT * FROM teste;


SELECT numero, nome FROM banco;
SELECT banco_numero, numero, nome FROM agencia;
SELECT numero, nome, email FROM cliente;

SELECT * FROM conta_corrente;

--PARA OBTER INFORMAÇÕES DA TABELA
SELECT * FROM information_schema.columns 
	WHERE table_name = 'banco'; 
--COLUNAS ESPECIFÍFICAS
SELECT column_name, data_type FROM information_schema.columns 
	WHERE table_name = 'banco';

-----------------------
--FUNÇÕES AGREGADAS
-----------------------
-- AVG
SELECT AVG (valor) FROM cliente_transacoes;
-- COUNT
SELECT COUNT(numero) FROM cliente;

SELECT COUNT (numero), email FROM cliente 
	WHERE email ILIKE '%gmail.com'
	GROUP BY email;

-- COUNT COM HAVING
SELECT COUNT (id), tipo_transacao_id 
	FROM cliente_transacoes
	GROUP BY tipo_transacao_id
	HAVING COUNT(id) > 150;

-- SUM
SELECT SUM(valor) FROM cliente_transacoes;

SELECT SUM(valor), tipo_transacao_id 
	FROM cliente_transacoes
	GROUP BY tipo_transacao_id;

-- SUM COM ORDENAÇÃO
SELECT SUM(valor), tipo_transacao_id 
	FROM cliente_transacoes
	GROUP BY tipo_transacao_id
	ORDER BY tipo_transacao_id DESC; -- OU ASC

-- MAX
SELECT MAX(valor) FROM cliente_transacoes;
	--Máximo por transação
SELECT MAX(valor), tipo_transacao_id 
	FROM cliente_transacoes 
	GROUP BY tipo_transacao_id;

-- MIN
SELECT MIN(valor) FROM cliente_transacoes;
	--Mínimo por transação
SELECT MIN(valor), tipo_transacao_id 
	FROM cliente_transacoes 
	GROUP BY tipo_transacao_id;

SELECT numero, nome FROM banco;
SELECT banco_numero, numero, nome FROM agencia;
SELECT numero, nome FROM cliente;
SELECT banco_numero, agencia_numero, numero, digito, cliente_numero 
	FROM conta_corrente;
SELECT id, nome FROM tipo_transacao;
SELECT banco_numero, agencia_numero, conta_corrente_numero, 
	   conta_corrente_digito, cliente_numero, valor 
	FROM cliente_transacoes;

SELECT COUNT(1) FROM banco; -- 151
SELECT COUNT(1) FROM agencia; -- 296

-- JOIN

-- 296
SELECT banco.numero, banco.nome, agencia.numero, agencia.nome
	FROM banco
	JOIN agencia ON agencia.banco_numero = banco.numero;

-- Qtos bancos têm agências = 9
SELECT COUNT(distinct banco.numero)
	FROM banco
	JOIN agencia ON agencia.banco_numero = banco.numero;

-- LEFT JOIN
SELECT banco.numero, banco.nome, agencia.numero, agencia.nome 
	FROM banco
	LEFT JOIN agencia ON agencia.banco_numero = banco.numero;

-- RIGHT JOIN
SELECT agencia.numero, agencia.nome, banco.numero, banco.nome 
	FROM agencia
	RIGHT JOIN banco ON banco.numero = agencia.banco_numero;

-- FULL JOIN
SELECT banco.numero, banco.nome, agencia.numero, agencia.nome 
	FROM banco
	FULL JOIN agencia ON agencia.banco_numero = banco.numero;

-- CROSS JOIN
SELECT bc.numero, bc.nome, ag.numero, ag.nome 
	FROM banco bc -- Criando alias para banco chamado bc
	CROSS JOIN agencia ag; --Criando alias para banco chamado bc
	
-- JOIN COM MAIS TABELAS
SELECT 	banco.nome,
		agencia.nome,
		conta_corrente.numero,
		conta_corrente.digito,
		cliente.nome
FROM 	banco
JOIN 	agencia 
	ON 	agencia.banco_numero = banco.numero
JOIN	conta_corrente
	ON	conta_corrente.banco_numero = banco.numero
	AND	conta_corrente.agencia_numero = agencia_numero
JOIN	cliente
	ON	cliente.numero = conta_corrente. cliente_numero;

------------------------------------
-- Common Table Expressions - CTE --
------------------------------------
WITH tbl_tmp_banco AS (
	SELECT numero, nome 
	FROM banco
)
SELECT numero, nome
FROM tbl_tmp_banco;

WITH params AS (
	SELECT 213 AS banco_numero
), tbl_tmp_banco AS (
	SELECT numero, nome
	FROM banco
	JOIN params ON params.banco_numero = banco.numero
)
SELECT numero, nome
FROM tbl_tmp_banco;

-- SUB SELECT
SELECT banco.numero, banco.nome
FROM banco
JOIN (
	SELECT 213 AS banco_numero
) params ON params.banco_numero = banco.numero;


-- CTE 
WITH cliente_e_transacoes AS (
	SELECT 	cliente.nome AS cliente_nome,
			tipo_transacao.nome AS tipo_transacao_nome,
			cliente_transacoes.valor AS cliente_transacoes_valor
	FROM cliente_transacoes
	JOIN cliente ON cliente.numero = cliente_transacoes.cliente_numero
	JOIN tipo_transacao 
				ON tipo_transacao.id = cliente_transacoes.tipo_transacao_id
)
SELECT cliente_nome, tipo_transacao_nome, cliente_transacoes_valor
FROM cliente_e_transacoes;

-- CTE 
WITH cliente_e_transacoes AS (
	SELECT 	cliente.nome AS cliente_nome,
			banco.nome AS banco_nome,
			tipo_transacao.nome AS tipo_transacao_nome,
			cliente_transacoes.valor AS cliente_transacoes_valor
	FROM cliente_transacoes
	JOIN cliente ON cliente.numero = cliente_transacoes.cliente_numero
	JOIN tipo_transacao 
				ON tipo_transacao.id = cliente_transacoes.tipo_transacao_id
	JOIN banco 	ON banco.numero = cliente_transacoes.banco_numero 
				AND banco.nome ILIKE '%Itaú%'
)
SELECT cliente_nome, banco_nome, tipo_transacao_nome, cliente_transacoes_valor
FROM cliente_e_transacoes;


------------------------------------
---- VIEWS
------------------------------------


CREATE OR REPLACE VIEW vw_bancos AS (
	SELECT numero, nome, ativo
	FROM banco
);

SELECT numero, nome, ativo
FROM vw_bancos;

CREATE OR REPLACE VIEW vw_bancos_2 (banco_numero, banco_nome, banco_ativo) AS (
	SELECT numero, nome, ativo
	FROM banco
);

SELECT banco_numero, banco_nome, banco_ativo
FROM vw_bancos_2;

INSERT INTO vw_bancos_2 (banco_numero, banco_nome, banco_ativo)
VALUES (51, 'Banco Boa Ideia', True);

SELECT banco_numero, banco_nome, banco_ativo FROM vw_bancos_2 WHERE banco_numero = 51;
SELECT numero, nome, ativo FROM banco WHERE numero = 51;

UPDATE vw_bancos_2 SET banco_ativo = False WHERE banco_numero = 51;

DELETE FROM vw_bancos_2 WHERE banco_numero = 51;


---------------------
-- Views Temporárias
---------------------
CREATE OR REPLACE TEMPORARY VIEW vw_agencia AS (
	SELECT nome FROM agencia
);

SELECT nome FROM vw_agencia;



-- Com With Options
CREATE OR REPLACE VIEW vw_bancos_ativos AS (
	SELECT numero, nome, ativo
	FROM banco
	WHERE ativo IS TRUE
) WITH LOCAL CHECK OPTION;

INSERT INTO vw_bancos_ativos (numero, nome, ativo)
VALUES (51, 'Banco Boa Ideia', False);
--- ERROR:  new row violates check option for view "vw_bancos_ativos"

INSERT INTO vw_bancos_ativos (numero, nome, ativo)
VALUES (51, 'Banco Boa Ideia', True);
--- OK

CREATE OR REPLACE VIEW vw_bancos_com_a AS (
	SELECT numero, nome, ativo
	FROM vw_bancos_ativos
	WHERE nome ILIKE 'a%'
) WITH LOCAL CHECK OPTION;

INSERT INTO vw_bancos_com_a (numero, nome, ativo) VALUES (333, 'Beta Banco', True);
--ERROR:  new row violates check option for view "vw_bancos_com_a"
INSERT INTO vw_bancos_com_a (numero, nome, ativo) VALUES (333, 'Alfa Banco', True);
--OK

------------
--- CASCADED
------------
CREATE OR REPLACE VIEW vw_bancos_ativos AS (
	SELECT numero, nome, ativo
	FROM banco
	WHERE ativo IS TRUE
);

CREATE OR REPLACE VIEW vw_bancos_com_a AS (
	SELECT numero, nome, ativo
	FROM vw_bancos_ativos
	WHERE nome ILIKE 'a%'
) WITH CASCADED CHECK OPTION;

INSERT INTO vw_bancos_com_a (numero, nome, ativo) VALUES (331, 'Alfa Beta Banco', False);
-- ERROR:  new row violates check option for view "vw_bancos_ativos"

INSERT INTO vw_bancos_com_a (numero, nome, ativo) VALUES (331, 'Alfa Beta Banco', True);
-- OK
INSERT INTO vw_bancos_com_a (numero, nome, ativo) VALUES (332, 'Alfa Beta Banco', True);



--------------------------------------------------------------
CREATE TABLE IF NOT EXISTS funcionarios (
	id SERIAL,
	nome VARCHAR(30) NOT NULL,
	gerente INTEGER,
	PRIMARY KEY (id),
	FOREIGN KEY (gerente) REFERENCES funcionarios(id)
);

INSERT INTO funcionarios (nome, gerente) VALUES ('Anselmo',Null);
INSERT INTO funcionarios (nome, gerente) VALUES ('Beatriz',1);
INSERT INTO funcionarios (nome, gerente) VALUES ('Magno',1);
INSERT INTO funcionarios (nome, gerente) VALUES ('Cremilda',2);
INSERT INTO funcionarios (nome, gerente) VALUES ('Wagner',4);

SELECT id, nome, gerente FROM funcionarios;

SELECT id, nome, gerente FROM funcionarios WHERE gerente IS NULL
UNION ALL
SELECT id, nome, gerente FROM funcionarios WHERE gerente = 999; -- Apenas
-- para exemplificar o primeiro Loop da view recursiva abaixo.

------------------
--- VIEW RECURSIVA
------------------
CREATE OR REPLACE RECURSIVE VIEW vw_func (id, gerente, funcionario) AS (
	SELECT id, gerente, nome
	FROM funcionarios
	WHERE gerente IS Null
	
	UNION ALL
	
	SELECT funcionarios.id, funcionarios.gerente, funcionarios.nome
	FROM funcionarios
	JOIN vw_func ON vw_func.id = funcionarios.gerente
); 
	
SELECT id, gerente, funcionario
FROM vw_func;
-----------------------------------------------------------------------------

-----------------------------------------------------
-- TRANSAÇÕES
-----------------------------------------------------
SELECT numero, nome, ativo FROM banco ORDER BY numero;

UPDATE banco SET ativo = False WHERE numero = 0;

BEGIN;
UPDATE banco SET ativo = True WHERE numero = 0;
ROLLBACK;

BEGIN;
UPDATE banco SET ativo = True WHERE numero = 0;
COMMIT;

SELECT id, gerente, nome FROM funcionarios;

BEGIN;
UPDATE funcionarios SET gerente = 2 WHERE id = 3;
SAVEPOINT sv_func;
UPDATE funcionarios SET gerente = null;
ROLLBACK TO sv_func;
UPDATE funcionarios SET gerente = 3 WHERE id = 2;
COMMIT;

SELECT id, gerente, nome FROM funcionarios;

