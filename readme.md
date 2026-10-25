# Projeto de Gestao para Concessionaria AutoDrive

## 1. Sobre a Empresa e o Dominio
A AutoDrive e uma concessionaria de veiculos que atua na venda de carros novos e seminovos, alem de oferecer servicos de manutencao e revisao na sua oficina. O objetivo deste projeto e organizar todas as informacoes da empresa em um sistema unico e seguro.

## 2. O Problema das Planilhas
Antes de utilizar um banco de dados, a empresa gerenciava tudo por meio de planilhas de excel e anotacoes em papel. Isso gerava diversos problemas no dia a dia:
* Clientes e carros eram cadastrados varias vezes de formas diferentes.
* O historico de manutencao dos carros se perdia com facilidade.
* Vendas eram registradas sem identificar corretamente o vendedor, complicando o calculo de comissoes.
* Funcionarios podiam alterar ou apagar informacoes importantes por engano.

## 3. A Solucao Encontrada
Para resolver essas falhas, foi criado um banco de dados relacional. Esse sistema funciona como um organizador inteligente que conecta todas as partes do negocio de forma automatica:
* Cada cliente, carro e vendedor possui um cadastro unico.
* O sistema impede que uma venda seja registrada sem que o cliente, o carro e o vendedor existam no cadastro.
* Relatorios de vendas, faturamento e estoque sao gerados em poucos segundos.
* As informacoes ficam protegidas contra acessos nao autorizados e perdas.

## 4. Como o Sistema esta Organizado
O sistema divide o negocio em partes bem definidas que se conversam entre si:

### Pessoas e Equipe
* Clientes: Guardam os dados de contato e identificacao dos compradores.
* Vendedores: Registrar os dados da equipe comercial e o percentual de comissao de cada um.

### Produtos e Servicos
* Veiculos: Mantem o controle do estoque de carros, incluindo marca, modelo, preco e se o carro esta disponivel ou vendido.
* Servicos: Lista das manutencoes oferecidas pela oficina com seus respectivos precos de tabela.

### Operacoes do Dia a Dia
* Vendas: Registra o momento em que um carro e vendido, conectando o comprador, o vendedor e o veiculo negociado.
* Ordens de Servico: Registra quando um cliente traz um carro para a oficina.
* Itens da Ordem de Servico: Detalha exatamente quais servicos foram executados no carro durante aquela visita a oficina.

## 5. Como as Informacoes se Conectam
O grande diferencial do sistema e a forma como ele cruza os dados:
* Um cliente pode comprar varios carros ao longo do tempo.
* Um vendedor pode realizar diversas vendas, mas cada venda pertence a um unico vendedor.
* Cada carro vendido e unico e fica registrado para aquele comprador especifico.
* Um mesmo carro pode ir varias vezes a oficina para fazer revisoes diferentes.
* Uma unica visita a oficina pode incluir varios servicos ao mesmo tempo, como troca de oleo e alinhamento.

## 6. Inteligencia de Negocios e Relatorios
Com essa estrutura montada, a diretoria da concessionaria consegue obter respostas rapidas para tomar decisoes:
* Saber quais sao os vendedores que mais vendem e calcular suas comissoes automaticamente.
* Consultar quais modelos de carros estao disponiveis no pátio e seus precos.
* Descobrir quais clientes compraram carros mas ainda nao voltaram para fazer a primeira revisao.
* Acompanhar o faturamento total da oficina e os servicos mais procurados.

## 7. Armazenamento na Nuvem e Seguranca
Para garantir que o sistema fique sempre no ar e acessivel de qualquer local, ele foi preparado para rodar em servidores na nuvem, como Azure ou Aiven. Isso garante:
* Acesso seguro atraves de senhas e conexoes criptografadas.
* Copias de seguranca feitas periodicamente para evitar perda de dados em casos de falhas corporativas.
* Abertura para o crescimento da empresa sem a necessidade de trocar de sistema no futuro.
