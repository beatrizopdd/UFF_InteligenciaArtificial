%entrada: buscagulosa(S).
/* ALGORITMO GULOSO */

/* FATOS */
/* CASO DE TESTES 1 
conteiner(2, 2, 2).
caixa(tipoA, 5, [1, 1, 1]).
caixa(tipoB, 5, [2, 2, 2]).
*/

/* CASO DE TESTES 2 
conteiner(5, 5, 5).
caixa(tipoA, 65, [1, 1, 1]).
caixa(tipoB, 60, [2, 2, 2]).
*/

/* CASO DE TESTES 3 */ 
conteiner(250, 250, 600).
caixa(tipoA, 120, [40, 60, 50]).
caixa(tipoB, 35, [50, 120, 50]).
caixa(tipoC, 200, [50, 30, 50]).

/* CHAMADA DA BUSCA */
buscagulosa(Solucao) :-
    conteiner(L, A, P),
    busca([L, A, P], [], Solucao),
    !.

/* REGRA 1: TENTA ALOCAR A MELHOR CAIXA NA CAMADA DO CONTEINER COM AS DIMENSOES ESPECIFICADAS */
% Se tiver caixa e espaço disponível, então insere a caixa
busca(EspacoDisponivel, EstadoAtual, Solucao) :-
    buscaCaixa(EstadoAtual, NovaCaixa, QtdDisponivel),                                                   % Regra 2: Busca a menor caixa disponível
    NovaCaixa \== none,                                                                                  % Tem uma caixa disponível
    verificaEspaco(NovaCaixa, EspacoDisponivel),                                                         % Regra 6: Verifica se a caixa cabe no espaço disponível
    insereCaixa(NovaCaixa, QtdDisponivel, EstadoAtual, NovoEstado, EspacoDisponivel, CamadaAtual),       % Regra 7: Insere a caixa no conteiner
    mudaCapacidade(EspacoDisponivel, CamadaAtual, NovoEstado, NovoEspaco),                               % Regra 10: Calcula o espaço disponível do conteiner
    busca(NovoEspaco, NovoEstado, Solucao).

% Se não tiver caixa ou espaço disponível, então é a solução
busca(_, EstadoAtual, [QtdCaixas, VolumeOcupado, EstadoAtual]) :-
    somaCaixas(QtdCaixas, VolumeOcupado, EstadoAtual).                                  % Regra 11: Calcula a quantidade total de caixas utilizadas e o volume total ocupado por elas

/* REGRA 2: BUSCA A MENOR CAIXA DISPONÍVEL */
buscaCaixa(CaixasUtilizadas, TipoCaixa, QtdDisponivel) :-
    encontraCaixas(CaixasExistentes),                                                   % Regra 3: Seleciona todas as caixas existentes e ordena pelo volume de forma crescente
    encontraMenor(CaixasUtilizadas, CaixasExistentes, TipoCaixa, QtdDisponivel).        % Regra 5: Seleciona a menor caixa disponível entre as caixas existentes

/* REGRA 3: SELECIONA TODAS AS CAIXAS EXISTENTES E ORDENA PELO VOLUME DE FORMA CRESCENTE */
encontraCaixas(CaixasExistentes) :-
    findall([Volume, Caixa], (calculaVolume(Caixa, Volume)), Caixas),                   % Regra 4: Calcula o volume da caixa
    sort(Caixas, CaixasExistentes).

/* REGRA 4: CALCULA O VOLUME DA CAIXA */
calculaVolume(Tipo, Volume) :-
    caixa(Tipo, _, [L, A, P]),
    Volume is L * A * P.

/* REGRA 5: SELECIONA A MENOR CAIXA DISPONÍVEL ENTRE AS CAIXAS EXISTENTES */
% Se não tiver caixas disponíveis
encontraMenor(_, [], none, 0).

% Se a caixa foi utilizada e não estiver disponível
encontraMenor(CaixasUtilizadas, [[_, MenorTipo]|OutrasOpcoes], MenorCaixa, QtdDisponivel) :-
    member([MenorTipo, QtdUtilizada], CaixasUtilizadas),                             % Verifica se a caixa já foi utilizada e a quantidade
    caixa(MenorTipo, QtdMaxima, _),                                                  % Busca a quantidade maxima dessa caixa
    QtdMaxima =< QtdUtilizada,                                                       % Já utilizou todas as caixas disponíveis
    encontraMenor(CaixasUtilizadas, OutrasOpcoes, MenorCaixa, QtdDisponivel).        % Verifica a próxima melhor caixa

% Se a caixa estiver disponível
encontraMenor(CaixasUtilizadas, [[_, MenorTipo]|_], MenorTipo, QtdDisponivel) :-          
    caixa(MenorTipo, QtdMaxima, _),
    (\+ (member([MenorTipo, _], CaixasUtilizadas)),									 % A caixa ainda não foi utilizada
    	QtdDisponivel is QtdMaxima;                                          
    	member([MenorTipo, QtdUtilizada], CaixasUtilizadas),                         % Ou, se foi utilizada
     	QtdMaxima > QtdUtilizada,													 % Mas não utilizou todas
        QtdDisponivel is (QtdMaxima - QtdUtilizada)).                                                      
    
/* REGRA 6: VERIFICA SE A CAIXA CABE NO ESPAÇO DISPONÍVEL */
verificaEspaco(TipoCaixa, [Lcnt, Acnt, Pcnt]) :-
    caixa(TipoCaixa, _, [Lcx, Acx, Pcx]),
    0 =< (Lcnt - Lcx),
    0 =< (Acnt - Acx),
    0 =< (Pcnt - Pcx).

/* REGRA 7: INSERE A CAIXA NO CONTEINER */
insereCaixa(TipoCaixa, QtdDisponivel, AntigoEstado, NovoEstado, EspacoDisponivel, CamadaOcupada) :-
    caixa(TipoCaixa, _, DimensaoCaixa),
    calculaCamada(DimensaoCaixa, QtdDisponivel, QtdUtilizada, EspacoDisponivel, CamadaOcupada), % Regra 8: Calcula o espaço do conteiner que será ocupado
    mudaEstado(AntigoEstado, TipoCaixa, QtdUtilizada, NovoEstado).                              % Regra 9: Atualiza a lista de estados utilizados

/* REGRA 8: CALCULA O ESPAÇO DO CONTEINER QUE SERÁ OCUPADO */
calculaCamada([Lcx, Acx, Pcx], QtdCaixasDisponivel, QtdCaixasEscolhida, [Ldis, Adis, _], [Lcmd, Acmd, Pcx]) :-
    NecessariasAltura is floor(Adis / Acx),											  % N caixas enchem uma coluna
    QtdAltura is min(QtdCaixasDisponivel, NecessariasAltura), 					      % Quantidade válida de caixas
    Acmd is (Acx * QtdAltura),														  % Altura das N caixas
    NecessariasLargura is floor(QtdCaixasDisponivel/QtdAltura),					      % M colunas conseguem ser feitas com a quantidade de caixas disponíveis
    QtdLargura is min(NecessariasLargura, floor(Ldis / Lcx)), 					   	  % Quantidade válida de caixas
    Lcmd is (Lcx * QtdLargura),														  % Largura das M caixas
    QtdCaixasEscolhida is (QtdLargura * QtdAltura).                                   % Ao todo são N * M  caixas       

/* REGRA 9: ATUALIZA A LISTA DE ESTADOS UTILIZADOS */
% Se o novo tipo não está na lista
mudaEstado([], TipoCaixa, QtdCaixas, [[TipoCaixa, QtdCaixas]]).

mudaEstado([[TipoCaixa, QtdAntiga]|Outras], TipoCaixa, QtdCaixas, [[TipoCaixa, QtdNova]|Outras]) :-
    QtdNova is (QtdAntiga + QtdCaixas).

mudaEstado([[TipoAntigo, QtdAntiga]|Outras], TipoCaixa, QtdCaixas, [[TipoAntigo, QtdAntiga]|NovoEstado]) :-
    TipoAntigo \== TipoCaixa,
    mudaEstado(Outras, TipoCaixa, QtdCaixas, NovoEstado).

/* REGRA 10: CALCULA O ESPAÇO DISPONÍVEL DO CONTEINER */
% Se cabe alguma caixa disponível na altura que sobra
mudaCapacidade([Ldis, Adis, Pdis], [_, Acmd, _], CaixasUtilizadas, [Ldis, Anv, Pdis]) :-
	Anv is (Adis - Acmd),
    espacoSuficiente([Ldis, Anv, Pdis], CaixasUtilizadas).                          % Regra 12: Verifica se existe alguma caixa que cabe na camada

% Se não cabe nenhuma caixa disponível na altura mas cabe na largura
mudaCapacidade([Ldis, _, Pdis], [Lcmd, _, _], CaixasUtilizadas, [Lnv, Amax, Pdis]) :-
	Lnv is (Ldis - Lcmd),
    conteiner(_, Amax, _),
    espacoSuficiente([Lnv, Amax, Pdis], CaixasUtilizadas).                          % Regra 12: Verifica se existe alguma caixa que cabe na camada

% Se não cabe nenhuma caixa, avança na profundidade
mudaCapacidade([_, _, Pdis], [_, _, Pcmd], _, [Lmax, Amax, Pnv]) :-
    conteiner(Lmax, Amax, _),
    Pnv is (Pdis - Pcmd).

/* REGRA 11: CALCULA A QUANTIDADE TOTAL DE CAIXAS UTILIZADAS E O VOLUME TOTAL OCUPADO POR ELAS */
% Se nenhuma caixa foi utilizada
somaCaixas(0, 0, []).                                                         

somaCaixas(QtdTotal, VolumeTotal, [[TipoAtual, QtdAtual]|OutrasCaixas]) :-
    somaCaixas(QtdOutras, VolumeOutras, OutrasCaixas),                          
    calculaVolume(TipoAtual, VolumeAtual),                                          % Regra 7: Calcula o volume da caixa
    QtdTotal is QtdOutras + QtdAtual,                                               % Soma a quantidade de caixas do resto da lista com a quantidade da caixa atual
    VolumeTotal is VolumeOutras + (VolumeAtual * QtdAtual).                         % Soma o volume das caixas do resto da lista com o volume da caixa atual

/* REGRA 12: VERIFICA SE EXISTE ALGUMA CAIXA DE CABE NA CAMADA */
espacoSuficiente(EspacoDisponivel, CaixasUtilizadas) :-
    findall(
        TipoCaixa,
        (caixa(TipoCaixa, QtdDisponivel, _), 
        	verificaEspaco(TipoCaixa, EspacoDisponivel), 
            (\+ member([TipoCaixa, _], CaixasUtilizadas);
                member([TipoCaixa, QtdUtilizada], CaixasUtilizadas),
                QtdDisponivel > QtdUtilizada
            )
        ),
        CaixasQueCabem
    ),
    length(CaixasQueCabem, Tamanho), 
    Tamanho > 0.