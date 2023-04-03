*** Settings ***
Documentation   Teste utilizando como base o serverest pra testar a API na parte de Login
Library         RequestsLibrary
Library         Collections
Library         FakerLibrary   locale=pt_br


*** Variables ***
${ALIAS}        ServeRest


*** Keywords ***
Criar um usuário novo
    ${RANDOM_NOME_FIRST}   FakerLibrary.First Name
    ${RANDOM_NOME_LAST}    FakerLibrary.Last Name
    ${RANDOM_EMAIL}   FakerLibrary.Email
    ${RANDOM_PWD}     FakerLibrary.Password
    ${USER}    Create Dictionary    
    ...           nome=${RANDOM_NOME_FIRST} ${RANDOM_NOME_LAST}  
    ...           email=${RANDOM_EMAIL}  
    ...           senha=${RANDOM_PWD}
    Set Global Variable    ${USER}

Iniciar sessão na API serverest
    ${HEADERS}   Create Dictionary    Content-Type=application/json
    Create Session    alias=${ALIAS}    url=https://serverest.dev   headers=${HEADERS}

Cadastrar o usuário criado na ServeRest
    Criar um usuário novo
    ${BODY}      Create Dictionary   
    ...          nome=${USER.nome}   
    ...          email=${USER.email}   
    ...          password=${USER.senha}   
    ...          administrador=true
    ${RESPONSE}  POST On Session     alias=${ALIAS}    url=usuarios    json=${BODY}
    Log   Resposta Retornada: ${\n}${RESPONSE.text}

Realizar Login com o usuário
    [Arguments]  ${status_code_desejado}
    ${BODY}      Create Dictionary   
    ...          email=${USER.email}   
    ...          password=${USER.senha}
    ${RESPONSE}  POST On Session     alias=${ALIAS}    url=login    json=${BODY}    expected_status=${status_code_desejado}
    Log   Resposta Retornada: ${\n}${RESPONSE.text}
    Dictionary Should Contain Item    ${RESPONSE.json()}    message    Login realizado com sucesso
    ${TOKEN}     Get From Dictionary    ${RESPONSE.json()}    authorization
    Set Global Variable    ${TOKEN}

Realizar Login com o usuário com erro
    [Arguments]  ${status_code_desejado}
    ${BODY}      Create Dictionary   
    ...          email=${USER.email}  
    ...          password=${USER.senha}erro
    ${RESPONSE}  POST On Session     alias=${ALIAS}    url=login    json=${BODY}    expected_status=${status_code_desejado}
    Log   Resposta Retornada: ${\n}${RESPONSE.text}
    Dictionary Should Contain Item    ${RESPONSE.json()}    message    Email e/ou senha inválidos