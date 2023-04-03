*** Settings ***
Library  RequestsLibrary
Library  String
Library  Collections

*** Keywords ***
Criar um usuário novo
    ${palavra_aleatoria}  Generate Random String  length=4  chars=[LETTERS]
    ${palavra_aleatoria}  Convert To Lower Case   ${palavra_aleatoria}
    Set Test Variable     ${EMAIL_TESTE}  ${palavra_aleatoria}@emailteste.com
    Log  ${EMAIL_TESTE}

Cadastrar o usuário criado na ServeRest
    [Arguments]    ${email}    ${status_code_desejado}
    ${body}    Create Dictionary
    ...    nome=Gabriel Barbosa
    ...    email=${email}
    ...    password=4321
    ...    administrador=true
    Log    ${BODY}
    Criar sessão na ServeRest
    ${resposta}    POST On Session
    ...            alias=ServeRest
    ...            url=/usuarios
    ...            json=${body}
    ...            expected_status=${status_code_desejado}
    Log    ${resposta.json()}
    IF    ${resposta.status_code} == 201
        Set Test Variable    ${ID_USUARIO}  ${resposta.json()["_id"]}
    END
    Set Test Variable    ${RESPOSTA}    ${resposta.json()}

Criar sessão na ServeRest
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=ServeRest    url=https://serverest.dev

Conferir se o usuário foi cadastrado corretamente
   Log    ${RESPOSTA}
   Dictionary Should Contain Item    ${RESPOSTA}    message    Cadastro realizado com sucesso
   Dictionary Should Contain Key    ${RESPOSTA}   _id

Repetir o cadastro do usuário
    Cadastrar o usuário criado na ServeRest    ${EMAIL_TESTE}    status_code_desejado=400

Verificar se a API não permitiu o cadastro repetido
    Dictionary Should Contain Item    ${RESPOSTA}    message    Este email já está sendo usado

Consultar os dados do novo usuário
    ${resposta_consulta}    GET On Session    alias=ServeRest    url=/usuarios/${ID_USUARIO}
    Set Test Variable    ${RESP_CONSULTA}    ${resposta_consulta.json()}

Conferir os dados retornados
    Log    ${RESP_CONSULTA}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    nome           Gabriel Barbosa
    Dictionary Should Contain Item    ${RESP_CONSULTA}    email          ${EMAIL_TESTE}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    password       4321
    Dictionary Should Contain Item    ${RESP_CONSULTA}    administrador  true
    Dictionary Should Contain Item    ${RESP_CONSULTA}    _id            ${ID_USUARIO}

Realizar Login com o usuário
    ${login_user_email_password}    Create Dictionary    email=${EMAIL_TESTE}    password=4321
    ${login_user_email_password}    POST On Session    alias=ServeRest    url=/login    json=${login_user_email_password}
    Set Test Variable    ${login_user_complete}    ${login_user_email_password.json()}


Conferir se o Login ocorreu com sucesso
    Dictionary Should Contain Item    ${login_user_complete}    message    Login realizado com sucesso

Deletar o usuário cadastrado
    ${resposta_consulta}    DELETE On Session    alias=ServeRest    url=/usuarios/${ID_USUARIO}
    Set Test Variable    ${RESP_DELETE}    ${resposta_consulta.json()}

Conferir se o usuário foi realmente deletado
    Dictionary Should Contain Item    ${RESP_DELETE}    message    Registro excluído com sucesso

Editar informações do usuário
    ${novas_info}    Create Dictionary    nome=Gabriel B  password=1234    email=${EMAIL_TESTE}    administrador=true
    ${novas_info}    PUT On Session    alias=ServeRest    url=/usuarios/${ID_USUARIO}    json=${novas_info}

Consultar os novos dados do usuário
    ${resposta_consulta}    GET On Session    alias=ServeRest    url=/usuarios/${ID_USUARIO}
    Set Test Variable    ${RESP_CONSULTA}    ${resposta_consulta.json()}

Conferir os dados retornados se estão editados
    Log    ${RESP_CONSULTA}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    nome           Gabriel B
    Dictionary Should Contain Item    ${RESP_CONSULTA}    email          ${EMAIL_TESTE}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    password       1234
    Dictionary Should Contain Item    ${RESP_CONSULTA}    administrador  true