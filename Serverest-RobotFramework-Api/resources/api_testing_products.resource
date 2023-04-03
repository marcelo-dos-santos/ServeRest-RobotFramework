*** Settings ***
Documentation   This test suits realizes a test in api of the site ServeRest, englobing all the products part.
Library         RequestsLibrary
Library         Collections
Library         String
Library         BuiltIn
Library         FakerLibrary   locale=pt_br
Resource        ../resources/api_testing_login.resource

*** Variables ***
${ALIAS}                 ServeRest
${preco_item}            6661
${desc_item}             Test Product
${quant_item}            10

${preco_item_edit}       1999
${desc_item_edit}        Test Product Edited
${quant_item_edit}       6

*** Keywords ***
Cadastrar um produto
    ${RANDOM_PROD}   FakerLibrary.Word   
    Set Suite Variable    ${RANDOM_PROD}
    ${BODY}      Create Dictionary  
    ...          nome=${RANDOM_PROD} ${RANDOM_PROD}   
    ...          preco=${preco_item}   
    ...          descricao=${desc_item}  
    ...          quantidade=${quant_item}
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}
    ${RESPONSE_CADASTRO}  POST On Session    alias=${ALIAS}    url=produtos    json=${BODY}    headers=${HEADERS}
    Set Test Variable    ${RESPONSE_CADASTRO}
    Log   Resposta Retornada: ${\n}${RESPONSE_CADASTRO.text}

Conferir se o produto foi cadastrado com sucesso
    Dictionary Should Contain Item    ${RESPONSE_CADASTRO.json()}    message    Cadastro realizado com sucesso
    ${ID_PRODUTO_CADASTRADO}  Get From Dictionary    ${RESPONSE_CADASTRO.json()}    _id
    Set Global Variable   ${ID_PRODUTO_CADASTRADO}

Pesquisar produto previamente criado
    Criar um usuário novo
    Iniciar sessão na API serverest
    Cadastrar o usuário criado na ServeRest
    Realizar Login com o usuário                         status_code_desejado=200              
    Cadastrar um produto    
    Conferir se o produto foi cadastrado com sucesso
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}
    ${RESPONSE_listaprodutos}  GET On Session     alias=${ALIAS}    url=produtos/${ID_PRODUTO_CADASTRADO}  headers=${HEADERS}
    Set Suite Variable    ${RESPONSE_listaprodutos}

Conferir as informações do produto
    Log   Resposta Retornada: ${\n}${RESPONSE_listaprodutos.text}
    Dictionary Should Contain Item    ${RESPONSE_listaprodutos.json()}    nome        ${RANDOM_PROD} ${RANDOM_PROD}
    ${preco_int}  Convert To Integer  ${preco_item}
    Dictionary Should Contain Item    ${RESPONSE_listaprodutos.json()}    preco       ${preco_int}
    ${desc_int}   Convert To String  ${desc_item}
    Dictionary Should Contain Item    ${RESPONSE_listaprodutos.json()}    descricao   ${desc_int}
    ${quant_int}   Convert To Integer  ${quant_item}
    Dictionary Should Contain Item    ${RESPONSE_listaprodutos.json()}    quantidade  ${quant_int}
    Dictionary Should Contain Key     ${RESPONSE_listaprodutos.json()}    _id 

Excluir produto previamente criado
    Criar um usuário novo
    Iniciar sessão na API serverest
    Cadastrar o usuário criado na ServeRest
    Realizar Login com o usuário                         status_code_desejado=200              
    Cadastrar um produto    
    Conferir se o produto foi cadastrado com sucesso
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}
    ${RESPONSE_deletproducts}  DELETE On Session     alias=${ALIAS}    url=produtos/${ID_PRODUTO_CADASTRADO}  headers=${HEADERS}    
    Set Suite Variable    ${RESPONSE_deletproducts}

Conferir se o produto foi realmente excluido
    Log    ${RESPONSE_deletproducts}
    Dictionary Should Contain Item    ${RESPONSE_deletproducts.json()}    message        Registro excluído com sucesso

Tentar buscar o produto excluido
    [Arguments]    ${status_code_desejado}
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}
    ${RESPONSE_listaprodutos}  GET On Session     alias=${ALIAS}    url=produtos/${ID_PRODUTO_CADASTRADO}  headers=${HEADERS}    expected_status=${status_code_desejado}
    Set Suite Variable    ${RESPONSE_listaprodutos}

Conferir se o produto aparece na lista de produtos
    Dictionary Should Contain Item    ${RESPONSE_listaprodutos.json()}    message    Produto não encontrado

Editar produto previamente criado
    Criar um usuário novo
    Iniciar sessão na API serverest
    Cadastrar o usuário criado na ServeRest
    Realizar Login com o usuário                         status_code_desejado=200              
    Cadastrar um produto    
    Conferir se o produto foi cadastrado com sucesso
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}
    ${BODY}      Create Dictionary  
    ...          nome=${RANDOM_PROD}   
    ...          preco=${preco_item_edit}   
    ...          descricao=${desc_item_edit}  
    ...          quantidade=${quant_item_edit}
    ${RESPONSE_editproducts}  PUT On Session     alias=${ALIAS}    url=produtos/${ID_PRODUTO_CADASTRADO}  headers=${HEADERS}    json=${BODY}
    Set Suite Variable    ${RESPONSE_editproducts}

Conferir se o produto realmente foi editado
    Log    ${RESPONSE_editproducts}
    Dictionary Should Contain Item    ${RESPONSE_editproducts.json()}    message        Registro alterado com sucesso

Buscar o produto editado
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}
    ${RESPONSE_listaprodutos}  GET On Session     alias=${ALIAS}    url=produtos/${ID_PRODUTO_CADASTRADO}  headers=${HEADERS}
    Set Suite Variable    ${RESPONSE_listaprodutos}

Conferir se o produto está correto
    Log   Resposta Retornada: ${\n}${RESPONSE_listaprodutos.text}
    Dictionary Should Contain Item    ${RESPONSE_listaprodutos.json()}    nome        ${RANDOM_PROD}
    ${preco_int}  Convert To Integer  ${preco_item_edit}
    Dictionary Should Contain Item    ${RESPONSE_listaprodutos.json()}    preco       ${preco_int}
    ${desc_int}   Convert To String  ${desc_item_edit}
    Dictionary Should Contain Item    ${RESPONSE_listaprodutos.json()}    descricao   ${desc_int}
    ${quant_int}   Convert To Integer  ${quant_item_edit}
    Dictionary Should Contain Item    ${RESPONSE_listaprodutos.json()}    quantidade  ${quant_int}
    Dictionary Should Contain Key     ${RESPONSE_listaprodutos.json()}    _id 