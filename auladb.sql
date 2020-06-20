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







