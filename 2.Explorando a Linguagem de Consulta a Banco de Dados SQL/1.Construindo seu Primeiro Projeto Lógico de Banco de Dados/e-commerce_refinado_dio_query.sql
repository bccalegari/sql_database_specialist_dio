-- E-commerce

USE e_commerce;


-- Todos os clientes

WITH base AS(
	(SELECT 
		cliente.id_cliente, cliente.nome, cliente.sobrenome, cliente.sexo, cliente.data_nascimento, cliente.telefone, cliente.endereco, cliente.id_conta,
        conta_pf.nome_usuario, conta_pf.senha, conta_pf.email, conta_pf.cpf
	FROM 
		cliente
	JOIN conta_pf
	ON cliente.id_conta = conta_pf.id_conta)
UNION ALL
	(SELECT 
		cliente.id_cliente, cliente.nome, cliente.sobrenome, cliente.sexo, cliente.data_nascimento, cliente.telefone, cliente.endereco, cliente.id_conta,
        conta_pj.nome_usuario, conta_pj.senha, conta_pj.email, conta_pj.cnpj 
	FROM 
		cliente
	JOIN conta_pj
	ON cliente.id_conta = conta_pj.id_conta))
SELECT 
	CONCAT(nome, ' ', sobrenome) AS nome_cliente, sexo, data_nascimento, telefone, endereco, 
    CASE WHEN LENGTH(cpf) = 11 THEN "PF" ELSE "PJ" END AS tipo_conta,
    id_conta, nome_usuario, senha, email,
	CASE WHEN cpf IN (SELECT cpf FROM base WHERE LENGTH(cpf) = 11) THEN cpf ELSE NULL END AS cpf,
	CASE WHEN cpf IN (SELECT cpf FROM base WHERE LENGTH(cpf) = 14) THEN cpf ELSE NULL END AS cnpj
FROM 
	base
ORDER BY
	tipo_conta, nome_cliente;
    

-- Clientes e suas respectivas formas de pagamento cadastradas

WITH base AS(
	(SELECT 
		cliente.id_cliente, cliente.nome, cliente.sobrenome, cliente.sexo, cliente.data_nascimento, cliente.telefone, cliente.endereco, cliente.id_conta,
        conta_pf.nome_usuario, conta_pf.senha, conta_pf.email, conta_pf.cpf
	FROM 
		cliente
	JOIN conta_pf
	ON cliente.id_conta = conta_pf.id_conta)
UNION ALL
	(SELECT 
		cliente.id_cliente, cliente.nome, cliente.sobrenome, cliente.sexo, cliente.data_nascimento, cliente.telefone, cliente.endereco, cliente.id_conta,
        conta_pj.nome_usuario, conta_pj.senha, conta_pj.email, conta_pj.cnpj 
	FROM 
		cliente
	JOIN conta_pj
	ON cliente.id_conta = conta_pj.id_conta))
SELECT 
	CONCAT(b.nome, ' ', b.sobrenome) AS nome_cliente, 
    CASE WHEN LENGTH(cpf) = 11 THEN "PF" ELSE "PJ" END AS tipo_conta,
	p.tipo AS tipo_pagamento
FROM 
	base AS b
INNER JOIN pagamento AS p
	ON b.id_cliente = p.id_cliente
ORDER BY
	nome_cliente, tipo_conta, p.tipo;


-- Pedidos e seus respectivos clientes, produtos, pagamentos e entregas

SELECT 
	pedido.status_pedido, 
    CASE WHEN entrega.valor_frete IS NULL THEN ROUND((produto.valor * relacao_pedido_produto.quantidade), 2) 
    ELSE ROUND(((produto.valor * relacao_pedido_produto.quantidade) +  entrega.valor_frete), 2)
    END AS valor_pedido,
    CONCAT(cliente.nome, ' ', cliente.sobrenome) AS cliente_nome, 
    produto.nome AS produto_nome, produto.categoria AS categoria_produto, produto.descricao AS produto_descricao, produto.valor AS valor_produto,
    relacao_pedido_produto.quantidade AS produto_quantidade,
    pagamento.tipo AS tipo_pagamento,
    entrega.transportadora, entrega.codigo_rastreio, entrega.valor_frete
FROM 
	pedido
INNER JOIN cliente
	ON pedido.id_cliente = cliente.id_cliente
INNER JOIN relacao_pedido_produto
	ON pedido.id_pedido = relacao_pedido_produto.id_pedido
INNER JOIN produto
	ON relacao_pedido_produto.id_produto = produto.id_produto
LEFT OUTER JOIN pagamento
	ON pedido.id_pagamento = pagamento.id_pagamento
LEFT OUTER JOIN entrega
	ON pedido.id_entrega = entrega.id_entrega
ORDER BY
	pedido.status_pedido, produto.categoria;


-- Produtos e seus respectivos estoques

SELECT
	produto.nome AS nome_produto, produto.categoria, produto.descricao AS produto_descricao, produto.valor AS produto_valor,
    produto_no_estoque.quantidade AS quantidade_em_estoque,
    estoque.endereco AS estoque_endereco, estoque.responsavel AS estoque_responsavel, 
    estoque.telefone_responsavel AS estoque_telefone_responsavel, estoque.email_responsavel AS estoque_email_responsavel,
    ROUND((produto.valor * produto_no_estoque.quantidade), 2) AS valor_total_em_estoque
FROM 
	produto
INNER JOIN produto_no_estoque
	ON produto.id_produto = produto_no_estoque.id_produto
INNER JOIN estoque
	ON produto_no_estoque.id_estoque = estoque.id_estoque
ORDER BY 
	produto.nome, produto.categoria;


-- Produtos e seus respectivos fornecedores

SELECT
	p.nome AS nome_produto, p.categoria, p.descricao AS produto_descricao, p.valor AS produto_valor,
    f.razao_social AS fornecedor_razao_social, f.cnpj AS fornecedor_cnpj, f.endereco AS fornecedor_endereco,
    f.telefone AS fornecedor_telefone, f.email AS fornecedor_email
FROM
	produto AS p
INNER JOIN fornecedor_disponibiliza_produto AS f_p
	ON p.id_produto = f_p.id_produto
INNER JOIN fornecedor AS f
	ON f_p.id_fornecedor = f.id_fornecedor
ORDER BY
	p.nome, p.categoria, f.razao_social;


-- Quantidade de clientes por tipo de conta

WITH base AS(
	(SELECT 
		cliente.id_cliente, cliente.nome, cliente.sobrenome, cliente.sexo, cliente.data_nascimento, cliente.telefone, cliente.endereco, cliente.id_conta,
        conta_pf.nome_usuario, conta_pf.senha, conta_pf.email, conta_pf.cpf
	FROM 
		cliente
	JOIN conta_pf
	ON cliente.id_conta = conta_pf.id_conta)
UNION ALL
	(SELECT 
		cliente.id_cliente, cliente.nome, cliente.sobrenome, cliente.sexo, cliente.data_nascimento, cliente.telefone, cliente.endereco, cliente.id_conta,
        conta_pj.nome_usuario, conta_pj.senha, conta_pj.email, conta_pj.cnpj 
	FROM 
		cliente
	JOIN conta_pj
	ON cliente.id_conta = conta_pj.id_conta))
SELECT 
	CASE WHEN LENGTH(cpf) = 11 THEN "PF" ELSE "PJ" END AS tipo_conta,
	COUNT(*) AS quantidade_clientes
FROM 
	base AS b
GROUP BY
	tipo_conta
ORDER BY
	quantidade_clientes DESC;
    

-- Cliente(s) com mais de três tipos de pagamentos cadastros na plataforma

WITH base AS(
	(SELECT 
		cliente.id_cliente, cliente.nome, cliente.sobrenome, cliente.sexo, cliente.data_nascimento, cliente.telefone, cliente.endereco, cliente.id_conta,
        conta_pf.nome_usuario, conta_pf.senha, conta_pf.email, conta_pf.cpf
	FROM 
		cliente
	JOIN conta_pf
	ON cliente.id_conta = conta_pf.id_conta)
UNION ALL
	(SELECT 
		cliente.id_cliente, cliente.nome, cliente.sobrenome, cliente.sexo, cliente.data_nascimento, cliente.telefone, cliente.endereco, cliente.id_conta,
        conta_pj.nome_usuario, conta_pj.senha, conta_pj.email, conta_pj.cnpj 
	FROM 
		cliente
	JOIN conta_pj
	ON cliente.id_conta = conta_pj.id_conta))
SELECT 
	CONCAT(b.nome, ' ', b.sobrenome) AS nome_cliente, 
    CASE WHEN LENGTH(cpf) = 11 THEN "PF" ELSE "PJ" END AS tipo_conta,
    COUNT(*) AS quantidade_pagamentos
FROM 
	base AS b
INNER JOIN pagamento AS p
	ON b.id_cliente = p.id_cliente
GROUP BY
	nome_cliente
HAVING
	quantidade_pagamentos > 3
ORDER BY
	b.id_cliente;


-- Quantidade de pagamentos agrupados pelos seus respectivos tipos

SELECT
	pagamento.tipo AS pagamento_tipo,
	COUNT(*) AS quantidade
FROM
	pagamento
GROUP BY
	pagamento_tipo
ORDER BY
	quantidade DESC;


-- Máximo, média e mínimo sobre o valor dos fretes das entregas por transportadora

SELECT
	transportadora,
    MAX(valor_frete) AS maximo_valor_frete,
    ROUND(AVG(valor_frete), 2) AS media_valor_frete,
    MIN(valor_frete) AS minimo_valor_frete
FROM
	entrega
GROUP BY
	transportadora
ORDER BY
	maximo_valor_frete DESC, media_valor_frete DESC;


-- Quantidade de pedidos agrupados pelos seus status

SELECT
	status_pedido,
    COUNT(*) AS quantidade
FROM
	pedido
GROUP BY
	status_pedido
ORDER BY
	quantidade DESC;


-- Categorias de produtos com mais pedidos

SELECT 
	produto.categoria,
    COUNT(*) AS quantidade
FROM 
	pedido
INNER JOIN cliente
	ON pedido.id_cliente = cliente.id_cliente
INNER JOIN relacao_pedido_produto
	ON pedido.id_pedido = relacao_pedido_produto.id_pedido
INNER JOIN produto
	ON relacao_pedido_produto.id_produto = produto.id_produto
GROUP BY
	produto.categoria
ORDER BY
	quantidade DESC;


-- Quantidade e valor total de produtos por estoque

SELECT
	estoque.id_estoque, endereco, responsavel,
    SUM(quantidade) AS quantidade_produtos,
    SUM(valor) AS valor_total_estoque
FROM 
	produto
INNER JOIN produto_no_estoque
	ON produto.id_produto = produto_no_estoque.id_produto
INNER JOIN estoque
	ON produto_no_estoque.id_estoque = estoque.id_estoque
GROUP BY
	estoque.id_estoque
ORDER BY 
	valor_total_estoque DESC, quantidade_produtos DESC;


-- Fornecedor que mais disponibiliza produtos

SELECT
	f.razao_social,
	COUNT(*) AS quantidade_produtos
FROM
	produto AS p
INNER JOIN fornecedor_disponibiliza_produto AS f_p
	ON p.id_produto = f_p.id_produto
INNER JOIN fornecedor AS f
	ON f_p.id_fornecedor = f.id_fornecedor
GROUP BY
	f.razao_social
ORDER BY
	quantidade_produtos DESC
LIMIT 1;
