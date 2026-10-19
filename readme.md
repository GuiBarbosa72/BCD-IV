Documentação do Projeto LogiFlow Logistics

1. Visão Geral do Sistema

O LogiFlow Logistics é um sistema de banco de dados relacional projetado para automatizar e otimizar a gestão de entregas expressas e e-commerce de última milha (last-mile). O projeto centraliza informações de clientes corporativos, centros de distribuição (hubs), motoristas, veículos, rastreamento de encomendas e controle de repasses financeiros.

2. Normalização do Banco de Dados

O modelo de dados foi estruturado seguindo rigorosamente as normas formais de modelagem de dados.
Primeira Forma Normal (1FN): Todos os atributos contêm valores atômicos e indivisíveis. Colunas com múltiplos dados foram desmembradas.
Segunda Forma Normal (2FN): Todos os atributos não-chave dependem totalmente da chave primária das tabelas.
Terceira Forma Normal (3FN): Não existem dependências transitivas. Atributos não-chave dependem exclusivamente da chave primária.
Quarta Forma Normal (4FN): Foram eliminadas as dependências multivaloradas independentes por meio da criação das tabelas motorista_veiculos e motorista_turnos, garantindo a integridade dos dados sem redundância.

3. Modelo Físico SQL

O script SQL contém os comandos DDL para criação do esquema, DML para inserção de dados de teste e 15 consultas essenciais para a operação do negócio.
