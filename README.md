# Projeto Paynow

Sobre o projeto
Uma escola de programação, a CodePlay, decidiu lançar uma plataforma de cursos online de
programação. Você já está trabalhando nesse projeto e agora vamos começar uma nova etapa:
uma ferramenta de pagamentos capaz de configurar os meios de pagamentos e registrar as
cobranças referentes a cada venda de curso na CodePlay. O objetivo deste projeto é construir
o mínimo produto viável (MVP) dessa plataforma de pagamentos.
Na plataforma de pagamentos temos dois perfis de usuários: os administradores da plataforma
e os donos de negócios que querem vender seus produtos por meio da plataforma, como as
pessoas da CodePlay, por exemplo. Os administradores devem cadastrar os meios de
pagamento disponíveis, como boletos bancários, cartões de crédito, PIX etc, especificando
detalhes de cada formato. Administradores também podem consultar os clientes da plataforma,
consultar e avaliar solicitações de reembolso, bloquear compras por suspeita de fraudes etc.
Já os donos de negócios devem ser capazes de cadastrar suas empresas e ativar uma conta
escolhendo quais meios de pagamento serão utilizados. Devem ser cadastrados também os
planos disponíveis para venda, incluindo seus valores e condições de desconto de acordo com
o meio de pagamento. E a cada nova venda realizada, devem ser armazenados dados do
cliente, do produto selecionado e do meio de pagamento escolhido. Um recibo deve ser emitido
para cada pagamento e esse recibo deve ser acessível para os clientes finais, alunos da
CodePlay no nosso contexto.

## Configurações
* Ruby 3.0.1
* Rails 6.1.3.2
* Testes:
    * Rspec
    * Capybara
* Gems adicionadas
    * 'rspec-rails'
    * 'capybara'
    * 'devise'
    * 'mail'

## Testes

Os testes utilizam framework RSpec. Para executá-los, rode rspec no terminal aberto na aplicação.

### Informações adicionais para uso da aplicação

* Apenas funcionários da Paynow, com o domínio de email @paynow.com.br, são passíveis de serem administradores.
* Não há página específica para registro de administradores, para adicionar um administrador é necessário adicionar seu email ao model Admin, isso permitirá que ele seja reconhecido com o status de administrador (admin). Adicionado o email no model Admin, o funcionário pode fazer o registro padrão da aplicação, como os demais usuários.
* O cliente da Paynow, quando registra sua empresa no site, é reconhecido automaticamente como o administrador daquela empresa (client_admin), podendo modificar opções de pagamento escolhidas.
* Os demais funcionários da empresas cadastradas são reconhecidos como client
* Domínios de email públicos não são aceitos para cadastro.

### Instalação

* Clone o projeto no computador, entre na respectiva pasta e execute o comando bin/setup
* Caso vá adcionar administradores, rode o rails c e cadastre os emails no model Admin, seguindo o exemplo:
```
Admin.create(email: 'email_a_ser_cadastrado@paynow.com.br')
```
* rode rail s no terminal e, no navegador, abra o endereço http://localhost:3000/ para ver a aplicaçao funcionado. No site, o administrador, se já cadastrado no model Admin, irá se registrar, no caso de primero acesso, ou entrar, no caso de já ter se registrado.

### Populando banco de dados

* rode o comando rails db:seed para adicionar dados ao banco, isso irá criar cadastros de usuários, empresas, meios de pagamento, produtos e de clientes finais, que são os clientes das empresas cadastradas (final_client).

* Step-by-step bullets
```
code blocks for commands
```

## API

### Registro de Client final

### Emissão de cobrança

Any advise for common problems or issues.
```
command to run if program contains helper info
```
