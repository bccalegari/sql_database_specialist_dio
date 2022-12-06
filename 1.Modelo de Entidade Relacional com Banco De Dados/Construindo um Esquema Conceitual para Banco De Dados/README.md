# Esquema Conceitual de Banco de Dados: Oficina Mecânica

Criação de um esquema conceitual para o contexto de uma oficina mecânica com base em uma narrativa fornecida como segundo desafio de projeto para o bootcamp de Database Experience da DIO.

## Narrativa:

- Sistema de controle e gerenciamento de execução de ordens de serviço em uma oficina mecânica
- Clientes levam veículos à oficina mecânica para serem consertados ou para passarem por revisões  periódicas
- Cada veículo é designado a uma equipe de mecânicos que identifica os serviços a serem executados e preenche uma OS com data de entrega.
- A partir da OS, calcula-se o valor de cada serviço, consultando-se uma tabela de referência de mão-de-obra
- O valor de cada peça também irá compor a OSO cliente autoriza a execução dos serviços
- A mesma equipe avalia e executa os serviços
- Os mecânicos possuem código, nome, endereço e especialidade
- Cada OS possui: n°, data de emissão, um valor, status e uma data para conclusão dos trabalhos.

## Arquivos:

- [**Projeto Final**](https://github.com/bccalegari/sql_database_specialist_dio/blob/main/1.Modelo%20de%20Entidade%20Relacional%20com%20Banco%20De%20Dados/Construindo%20um%20Esquema%20Conceitual%20para%20Banco%20De%20Dados/oficina_mecanica_dio.pdf)

## Ferramentas Utilizadas:

- MySQL Workbench
