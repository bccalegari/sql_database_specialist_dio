-- E-commerce Schema

CREATE DATABASE e_commerce;
USE e_commerce;

-- Tables

CREATE TABLE conta_pf(
	id_conta CHAR(4) NOT NULL,
	nome_usuario VARCHAR(25) NOT NULL,
    	senha VARCHAR(32) NOT NULL,
    	email VARCHAR(255) NOT NULL,
	cpf CHAR(11) NOT NULL,
	CONSTRAINT UNIQUE_contapf_nome_usuario UNIQUE (nome_usuario),
    	CONSTRAINT UNIQUE_contapf_cpf UNIQUE (cpf),
    	PRIMARY KEY (id_conta)
	);

CREATE TABLE conta_pj(
	id_conta CHAR(4) NOT NULL,
	nome_usuario VARCHAR(25) NOT NULL,
    	senha VARCHAR(32) NOT NULL,
    	email VARCHAR(255) NOT NULL,
	cnpj CHAR(14) NOT NULL,
	CONSTRAINT UNIQUE_contapj_nome_usuario UNIQUE (nome_usuario),
    	CONSTRAINT UNIQUE_contapj_cnpj UNIQUE (cnpj),
    	PRIMARY KEY (id_conta)
	);

CREATE TABLE cliente(
	id_cliente INT NOT NULL AUTO_INCREMENT,
	nome VARCHAR(15) NOT NULL,
    	sobrenome VARCHAR(20) NOT NULL,
    	sexo ENUM('M', 'F') NOT NULL,
    	data_nascimento DATE NOT NULL,
	telefone VARCHAR(10) NOT NULL,
    	endereco VARCHAR(100) NOT NULL,
    	id_conta CHAR(4) NOT NULL,
	CONSTRAINT UNIQUE_cliente_id_conta UNIQUE (id_conta),
	CONSTRAINT FK_cliente_conta_pf FOREIGN KEY (id_conta) REFERENCES conta_pf(id_conta) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_cliente_conta_pj FOREIGN KEY (id_conta) REFERENCES conta_pj(id_conta) ON DELETE CASCADE ON UPDATE CASCADE,
    	PRIMARY KEY (id_cliente)
	);

CREATE TABLE pagamento(
	id_pagamento INT NOT NULL AUTO_INCREMENT,
    	tipo ENUM('credito', 'debito', 'pix', 'boleto', 'transferencia bancaria') NOT NULL,
    	id_cliente INT NOT NULL,
	CONSTRAINT FK_pagamento_id_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (id_pagamento)
);

CREATE TABLE entrega(
	id_entrega INT NOT NULL AUTO_INCREMENT,
	valor_frete FLOAT NOT NULL,
    	transportadora VARCHAR(45) NOT NULL,
	codigo_rastreio VARCHAR(45),
	PRIMARY KEY (id_entrega)
);

CREATE TABLE pedido(
	id_pedido INT NOT NULL AUTO_INCREMENT,
    	status_pedido ENUM('Pedido recebido', 'Pagamento aprovado', 'Em separação', 'Enviado à transportadora', 'Pedido saiu para entrega', 'Pedido entregue') NOT NULL,
	observacao VARCHAR(100),
	id_cliente INT NOT NULL,
    	id_pagamento INT,
    	id_entrega INT,
	CONSTRAINT UNIQUE_pedido_id_entrega UNIQUE (id_entrega),
	CONSTRAINT FK_pedido_id_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_pedido_pagamento FOREIGN KEY (id_pagamento) REFERENCES pagamento(id_pagamento) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_pedido_entrega FOREIGN KEY (id_entrega) REFERENCES entrega(id_entrega) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (id_pedido)
);

CREATE TABLE produto(
	id_produto INT NOT NULL AUTO_INCREMENT,
    	nome VARCHAR(45) NOT NULL,
    	categoria VARCHAR(20) NOT NULL,
    	descricao VARCHAR(100) NOT NULL,
	valor FLOAT NOT NULL,
	PRIMARY KEY (id_produto)
);

CREATE TABLE relacao_pedido_produto(
	id_pedido INT NOT NULL,
	id_produto INT NOT NULL,
	quantidade INT NOT NULL,
	CONSTRAINT FK_relacao_pedido_produto_id_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_relacao_pedido_produto_id_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (id_pedido, id_produto)
);

CREATE TABLE fornecedor(
	id_fornecedor INT NOT NULL AUTO_INCREMENT,
    	razao_social VARCHAR(80) NOT NULL,
	cnpj CHAR(14) NOT NULL,
    	endereco VARCHAR(100) NOT NULL,
    	telefone VARCHAR(10) NOT NULL,
    	email VARCHAR(255) NOT NULL,
    	CONSTRAINT UNIQUE_fornecedor_cnpj UNIQUE(cnpj),
	PRIMARY KEY (id_fornecedor)
);

CREATE TABLE fornecedor_disponibiliza_produto(
	id_fornecedor INT NOT NULL,
	id_produto INT NOT NULL,
	CONSTRAINT FK_fornecedor_disponibiliza_produto_id_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_fornecedor_disponibiliza_produto_id_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (id_fornecedor, id_produto)
);

CREATE TABLE estoque(
	id_estoque INT NOT NULL AUTO_INCREMENT,
    	endereco VARCHAR(100) NOT NULL,
    	responsavel VARCHAR(50) NOT NULL,
    	telefone_responsavel VARCHAR(10) NOT NULL,
    	email_responsavel VARCHAR(255) NOT NULL,
	PRIMARY KEY (id_estoque)
);

CREATE TABLE produto_no_estoque(
	id_estoque INT NOT NULL,
    	id_produto INT NOT NULL,
    	quantidade INT NOT NULL,
    	CONSTRAINT FK_produto_no_estoque_id_estoque FOREIGN KEY (id_estoque) REFERENCES estoque(id_estoque) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT FK_produto_no_estoque_id_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (id_produto, id_estoque)
);

-- Data Import

SET foreign_key_checks = 0;

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:\\Users\\Bruno\\Desktop\\Bruno\\T.I\\DIO\\SQL Database Specialist\\ecommerce bd\\conta_pf.txt'
INTO TABLE conta_pf
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:\\Users\\Bruno\\Desktop\\Bruno\\T.I\\DIO\\SQL Database Specialist\\ecommerce bd\\conta_pj.txt'
INTO TABLE conta_pj
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:\\Users\\Bruno\\Desktop\\Bruno\\T.I\\DIO\\SQL Database Specialist\\ecommerce bd\\cliente.txt'
INTO TABLE cliente
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:\\Users\\Bruno\\Desktop\\Bruno\\T.I\\DIO\\SQL Database Specialist\\ecommerce bd\\pagamento.txt'
INTO TABLE pagamento
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:\\Users\\Bruno\\Desktop\\Bruno\\T.I\\DIO\\SQL Database Specialist\\ecommerce bd\\entrega.txt'
INTO TABLE entrega
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:\\Users\\Bruno\\Desktop\\Bruno\\T.I\\DIO\\SQL Database Specialist\\ecommerce bd\\pedido.txt'
INTO TABLE pedido
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id_pedido, status_pedido, @observacao, id_cliente, @id_pagamento, @id_entrega)
SET
observacao = IF(@observacao = 'NULL', NULL, @observacao),
id_pagamento = IF(@id_pagamento = 0, NULL, @id_pagamento),
id_entrega = IF(@id_entrega = 0, NULL, @id_entrega);

LOAD DATA LOCAL INFILE 'C:\\Users\\Bruno\\Desktop\\Bruno\\T.I\\DIO\\SQL Database Specialist\\ecommerce bd\\produto.txt'
INTO TABLE produto
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:\\Users\\Bruno\\Desktop\\Bruno\\T.I\\DIO\\SQL Database Specialist\\ecommerce bd\\relacao_pedido_produto.txt'
INTO TABLE relacao_pedido_produto
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:\\Users\\Bruno\\Desktop\\Bruno\\T.I\\DIO\\SQL Database Specialist\\ecommerce bd\\fornecedor.txt'
INTO TABLE fornecedor
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:\\Users\\Bruno\\Desktop\\Bruno\\T.I\\DIO\\SQL Database Specialist\\ecommerce bd\\fornecedor_disponibiliza_produto.txt'
INTO TABLE fornecedor_disponibiliza_produto
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:\\Users\\Bruno\\Desktop\\Bruno\\T.I\\DIO\\SQL Database Specialist\\ecommerce bd\\estoque.txt'
INTO TABLE estoque
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:\\Users\\Bruno\\Desktop\\Bruno\\T.I\\DIO\\SQL Database Specialist\\ecommerce bd\\produto_no_estoque.txt'
INTO TABLE produto_no_estoque
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET foreign_key_checks = 1;
