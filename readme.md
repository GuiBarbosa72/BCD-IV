# 🚚 LogiFlow Logistics — Sistema de Gestão de Entregas e Repasses

![Status do Projeto](https://img.shields.io/badge/Status-Conclu%C3%ADdo-brightgreen)
![SQL](https://img.shields.io/badge/Database-PostgreSQL%2FMySQL-blue)

## 📌 Sobre a Empresa

A **LogiFlow Logistics** é uma LogTech especializada em entregas expressas de "última milha" (*last-mile*) para o setor de e-commerce. A empresa conecta lojas virtuais a hubs de distribuição e motoristas parceiros para realizar entregas ágeis em grandes centros urbanos.

---

## ⚠️ O Problema de Negócio

Devido ao crescimento acelerado da empresa, a gestão realizada via planilhas tornou-se inviável, gerando os seguintes gargalos:

- **Perda de Rastreabilidade:** Inabilidade de acompanhar o histórico exato de status de cada pedido.
- **Inconsistência Financeira:** Falhas no cálculo dos repasses devidos aos motoristas parceiros autônomos.
- **Ineficiência Operacional:** Dificuldade em alocar encomendas para os hubs e motoristas corretos.

---

## 🛠️ Solução Proposta

Foi planejado e implementado um banco de dados relacional normalizado para estruturar a operação. A solução contempla:

1. **Gestão de Clientes e Hubs:** Registro centralizado das lojas contratantes e pontos de distribuição.
2. **Controle de Encomendas:** Vinculação de cada pacote ao seu remetente, motorista responsável e frete.
3. **Histórico Auditável de Status:** Tabela dedicada a registrar todas as alterações de estado das entregas com carimbo de data/hora.
4. **Fechamento Financeiro:** Consolidação de valores de repasse por motorista com base unicamente em entregas confirmadas.

---

## 📊 Modelo de Dados (Diagrama de Entidades)

O banco de dados é composto por 6 tabelas principais:

- `clientes`
- `hubs`
- `motoristas`
- `encomendas`
- `historico_rastreamento`
- `repasses_financeiros`

---

## 🚀 Como Executar o Projeto

1. Clone este repositório:
   ```bash
   git clone [https://github.com/seu-usuario/logiflow-database.git](https://github.com/seu-usuario/logiflow-database.git)