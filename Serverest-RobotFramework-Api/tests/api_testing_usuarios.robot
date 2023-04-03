*** Settings ***
Documentation    This test suits realizes a test in api of the site ServeRest, englobing all the users part.
Resource  ../resources/api_testing_usuarios.resource

*** Test Cases ***
Cenário 01: Cadastrar um novo usuário com sucesso na ServeRest
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest    email=${EMAIL_TESTE}    status_code_desejado=201
    Conferir se o usuário foi cadastrado corretamente

Cenário 02: Cadastrar um usuário ja existente
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest    email=${EMAIL_TESTE}    status_code_desejado=201
    Repetir o cadastro do usuário    
    Verificar se a API não permitiu o cadastro repetido

Cenário 03: Consultar os dados de um novo usuário
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest    email=${EMAIL_TESTE}    status_code_desejado=201
    Consultar os dados do novo usuário
    Conferir os dados retornados

Cenário 04: Excluir usuário
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=201
    Consultar os dados do novo usuário
    Deletar o usuário cadastrado
    Conferir se o usuário foi realmente deletado

Cenário 05: Editar usuário
    Criar um usuário novo
    Cadastrar o usuário criado na ServeRest  email=${EMAIL_TESTE}  status_code_desejado=201
    Consultar os dados do novo usuário
    Editar informações do usuário
    Consultar os novos dados do usuário
    Conferir os dados retornados se estão editados