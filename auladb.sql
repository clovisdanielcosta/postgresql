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
	FOREIGN KEY (banco_numero, agencia_numero) REFERENCES agencia (banco_numero, numero),
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
	FOREIGN KEY (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) REFERENCES conta_corrente (banco_numero, agencia_numero, numero, digito, cliente_numero)
);
