# Refinando um Projeto Conceitual de Banco de Dados – E-COMMERCE

Refinamento de um projeto conceitual de banco de dados sobre e-commerce.

## Escopo:

- Objetivo Proposto: Venda de Produtos

- Entidades Propostas: Cliente, Produto, Estoque, Pedido, Fornecedor

## Narrativa:

- Produto:  
  - Os produtos são vendidos por uma única plataforma online. Contudo, estes podem ter vendedores distintos (terceiros)
  - Cada produto possui um fornecedor
  - Um ou mais produtos podem compor um pedido
  
- Cliente:  
  - O cliente pode se cadastrar no site com seu CPF ou CNPJ
  - O Endereço do cliente irá determinar o valor do frete
  - Um cliente pode comprar mais de um pedido. Este tem um período de carência para devolução do produto
  
- Pedido:  
  - O pedidos são criados por clientes e possuem informações de compra, endereço e status da entrega
  - Um produto ou mais compoem o pedido
  - O pedido pode ser cancelado
  
## Refinamento Proposto:

- Cliente PJ e PF 
  – Uma conta pode ser PJ ou PF, mas não pode ter as duas informações
- Pagamento 
  – Pode ter cadastrado mais de uma forma de pagamento
- Entrega 
  – Possui status e código de rastreio

## Arquivos:

- [Projeto Inicial, **sem refinamento**](https://github.com/bccalegari/sql_database_specialist_dio/blob/main/1.Modelo%20de%20Entidade%20Relacional%20com%20Banco%20De%20Dados/Refinando%20um%20Projeto%20Conceitual%20de%20Banco%20de%20Dados%20%E2%80%93%20E-COMMERCE/e_commerce_proposto_dio.pdf)

- [**Projeto Refinado**](https://github.com/bccalegari/sql_database_specialist_dio/blob/main/1.Modelo%20de%20Entidade%20Relacional%20com%20Banco%20De%20Dados/Refinando%20um%20Projeto%20Conceitual%20de%20Banco%20de%20Dados%20%E2%80%93%20E-COMMERCE/e_commerce_refinado_dio.pdf), observação: foi retirado a entidade 'fornecedor'.

## Ferramentas Utilizadas:

- MySQL Workbench
