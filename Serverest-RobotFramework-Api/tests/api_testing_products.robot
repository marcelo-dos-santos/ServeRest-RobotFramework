*** Settings ***
Documentation    This test suits realizes a test in api of the site ServeRest, englobing all the products part.
Resource    ../resources/api_testing_products.resource
Resource    ../resources/api_testing_login.resource

*** Test Cases ***
Caso 01: Cadastrar um produto
    Criar um usuário novo
    Iniciar sessão na API serverest
    Cadastrar o usuário criado na ServeRest
    Realizar Login com o usuário                             status_code_desejado=200              
    Cadastrar um produto    
    Conferir se o produto foi cadastrado com sucesso

Caso 02: Listar produtos cadastrados
    Pesquisar produto previamente criado
    Conferir as informações do produto

Caso 03: Excluir produto
    Excluir produto previamente criado
    Conferir se o produto foi realmente excluido
    Tentar buscar o produto excluido                         status_code_desejado=400
    Conferir se o produto aparece na lista de produtos

Caso 04: Editar produto
    Editar produto previamente criado
    Conferir se o produto realmente foi editado
    Buscar o produto editado
    Conferir se o produto está correto