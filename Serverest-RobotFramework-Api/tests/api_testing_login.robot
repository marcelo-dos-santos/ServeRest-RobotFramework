*** Settings ***
Documentation    This test suits realizes a test in api of the site ServeRest, englobing all the login part.
Resource        ../resources/api_testing_login.resource

*** Test Cases ***

Caso 01: Efetuar o login como um novo usuário
    Criar um usuário novo
    Iniciar sessão na API serverest
    Cadastrar o usuário criado na ServeRest  
    Realizar Login com o usuário                          status_code_desejado=200

Caso 02: Efetuar o login como um novo usuário com erro
    Criar um usuário novo
    Iniciar sessão na API serverest
    Cadastrar o usuário criado na ServeRest  
    Realizar Login com o usuário com erro                status_code_desejado=401
    