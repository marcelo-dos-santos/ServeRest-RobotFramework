*** Settings ***
Documentation    This test suits realizes a test in api of the site ServeRest, englobing all the carts part.
Resource    ../resources/api_testing_cart.resource
Resource    ../resources/api_testing_login.resource
Resource    ../resources/api_testing_products.resource

*** Test Cases ***

Caso 01: Cadastrar um novo carrinho
    Criar um usuário novo
    Iniciar sessão na API serverest
    Cadastrar o usuário criado na ServeRest
    Realizar Login com o usuário                             status_code_desejado=200
    Cadastrar um carrinho
    Conferir se o carrinho foi cadastrado com sucesso

Caso 02: Listar carrinhos cadastrados
    Criar um usuário novo
    Iniciar sessão na API serverest
    Cadastrar o usuário criado na ServeRest
    Realizar Login com o usuário                             status_code_desejado=200
    Buscar carrinhos cadastrados
    Conferir os carrinhos cadastrados

Caso 03: Deletar um carrinho
    Criar um usuário novo
    Iniciar sessão na API serverest
    Cadastrar o usuário criado na ServeRest
    Realizar Login com o usuário                             status_code_desejado=200
    Cadastrar um carrinho
    Conferir se o carrinho foi cadastrado com sucesso
    Realizar requisição para deletar carrinho
    A API deve responder com código 200, deletar o carrinho