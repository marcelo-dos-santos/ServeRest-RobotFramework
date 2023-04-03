*** Settings ***
Documentation   This test suits realizes a test in api of the site ServeRest, englobing all the products part.
Library         RequestsLibrary
Library         Collections
Library         String
Library         BuiltIn
Library         RPA.JSON
Library         FakerLibrary   locale=pt_br
Resource        ../resources/api_testing_login.resource
Resource        ../resources/api_testing_products.resource

*** Variables ***
${ALIAS}                 ServeRest

*** Keywords ***
Cadastrar um produto
    ${RANDOM_PROD}   FakerLibrary.Word   
    Set Suite Variable    ${RANDOM_PROD}
    ${BODY}      Create Dictionary  
    ...          nome=${RANDOM_PROD}   
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
    Set Suite Variable   ${ID_PRODUTO_CADASTRADO}

Cadastrar um carrinho
    api_testing_cart.Cadastrar um produto
    api_testing_cart.Conferir se o produto foi cadastrado com sucesso
    ${DATA}=   Convert String to JSON    {"produtos": [{"idProduto": "id", "quantidade": 1}]}
    ${DATA}=   Update value to JSON      ${DATA}     $..quantidade   ${quant_item}
    ${DATA}=   Update value to JSON      ${DATA}     $..idProduto    ${ID_PRODUTO_CADASTRADO}     
    # ${DATA}=   Update value to JSON      ${DATA}     $.produtos[1].idProduto    ${ID_PRODUTO}     
    ${DATA}=   Evaluate      json.dumps(${DATA})     json
    # ${BODY}    Create Dictionary    idProduto=${ID_PRODUTO_CADASTRADO}    
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}
    ${RESPONSE_carts}  POST On Session     alias=${ALIAS}    url=carrinhos    headers=${HEADERS}    data=${DATA}
    Set Suite Variable    ${RESPONSE_carts}

Conferir se o carrinho foi cadastrado com sucesso
    Dictionary Should Contain Item    ${RESPONSE_carts.json()}    message    Cadastro realizado com sucesso
    ${ID_CART_CADASTRADO}  Get From Dictionary    ${RESPONSE_carts.json()}    _id
    Set Suite Variable   ${ID_CART_CADASTRADO}

Buscar carrinhos cadastrados
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}
    ${RESPONSE_listacarts}  GET On Session     alias=${ALIAS}    url=carrinhos   headers=${HEADERS}
    Set Suite Variable    ${RESPONSE_listacarts}
    Set Test Variable      ${RESPONSE_BODY}      ${RESPONSE_listacarts.json()}

Conferir os carrinhos cadastrados
    FOR    ${CARRINHO}    IN   @{RESPONSE_BODY['carrinhos']}
        ${QUANTIDADE_TOTAL}=   Set Variable    ${0}
        ${PRECO_TOTAL}=        Set Variable    ${0}
        FOR    ${PRODUTO}    IN   @{CARRINHO['produtos']}
            Set Test Variable   ${QUANTIDADE}       ${PRODUTO['quantidade']}
            Set Test Variable   ${PRECO_UNITARIO}   ${PRODUTO['precoUnitario']}
            ${QUANTIDADE_TOTAL}=  Evaluate    ${QUANTIDADE_TOTAL} + ${PRODUTO['quantidade']}
            ${PRECO_TOTAL}=       Evaluate    (${PRECO_UNITARIO} * ${PRODUTO['quantidade']}) + ${PRECO_TOTAL}
        END
        Set Test Variable  ${QUANTIDADE_TOTAL}
        Set Test Variable  ${PRECO_TOTAL}
        Should Be Equal As Integers    ${CARRINHO['quantidadeTotal']}    ${QUANTIDADE_TOTAL}
        Should Be Equal As Integers    ${CARRINHO['precoTotal']}    ${PRECO_TOTAL}

    END

Realizar requisição para deletar carrinho
    ${HEADERS}   Create Dictionary  Authorization=${TOKEN}
    ${RESPONSE_deletcart}  DELETE On Session     alias=${ALIAS}    url=carrinhos/concluir-compra  headers=${HEADERS}
    Log    ${RESPONSE_deletcart}
    Set Test Variable    ${RESPONSE_deletcart}   

A API deve responder com código 200, deletar o carrinho
    Should Be True  '${RESPONSE_deletcart.status_code}'=='200'
    ...  msg=Erro na requisição! Verifique: ${RESPONSE_deletcart}
    Dictionary Should Contain Item    ${RESPONSE_deletcart.json()}    message        Registro excluído com sucesso