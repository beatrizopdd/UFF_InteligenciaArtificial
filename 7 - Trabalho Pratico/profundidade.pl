/* ALGORITMO DE BUSCA EM PROFUNDIDADE SEM HEURÍSTICA */

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
buscaProfundidade(Solucao) :-
    conteiner(L, A, P),
    busca([L, A, P], [], Solucao).

/* REGRA 1: TENTA ALOCAR A CAIXA NA CAMADA DO CONTEINER COM AS DIMENSOES ESPECIFICADAS */
busca(EspacoDisponivel, EstadoAtual, Solucao) :-
    buscaCaixa(EstadoAtual, NovaCaixa, QtdDisponivel),
    NovaCaixa \== none,
    verificaEspaco(NovaCaixa, EspacoDisponivel),
    insereCaixa(NovaCaixa, QtdDisponivel, EstadoAtual, NovoEstado, EspacoDisponivel, CamadaAtual),
    mudaCapacidade(EspacoDisponivel, CamadaAtual, NovoEstado, NovoEspaco),
    busca(NovoEspaco, NovoEstado, Solucao).

% Se não tiver caixa ou espaço disponível, então é a solução
busca(_, EstadoAtual, [QtdCaixas, VolumeOcupado, EstadoAtual]) :-
    somaCaixas(QtdCaixas, VolumeOcupado, EstadoAtual).

/* REGRA 2: BUSCA A CAIXA DISPONÍVEL */
buscaCaixa(CaixasUtilizadas, TipoCaixa, QtdDisponivel) :-
    encontraCaixas(CaixasExistentes),
    encontraPrimeiraDisponivel(CaixasUtilizadas, CaixasExistentes, TipoCaixa, QtdDisponivel).

/* REGRA 3: SELECIONA TODAS AS CAIXAS EXISTENTES */
encontraCaixas(CaixasExistentes) :-
    findall(Tipo, (caixa(Tipo, _, _)), CaixasExistentes).

/* REGRA 4: SELECIONA A PRIMEIRA CAIXA DISPONÍVEL */
encontraPrimeiraDisponivel(_, [], none, 0).

encontraPrimeiraDisponivel(CaixasUtilizadas, [TipoPrimeira|OutrasOpcoes], TipoCaixa, QtdDisponivel) :-
	member([TipoPrimeira, QtdUtilizada], CaixasUtilizadas),
	caixa(TipoPrimeira, QtdMaxima, _),
	QtdMaxima =< QtdUtilizada,
    encontraPrimeiraDisponivel(CaixasUtilizadas, OutrasOpcoes, TipoCaixa, QtdDisponivel).

encontraPrimeiraDisponivel(CaixasUtilizadas, [TipoPrimeira|_], TipoPrimeira, QtdDisponivel) :-
    caixa(TipoPrimeira, QtdMaxima, _),
    (\+ (member([TipoPrimeira, _], CaixasUtilizadas)),
     QtdDisponivel is QtdMaxima;
     member([TipoPrimeira, QtdUtilizada], CaixasUtilizadas),
     QtdMaxima > QtdUtilizada,
     QtdDisponivel is (QtdMaxima - QtdUtilizada)).

/* REGRA 5: VERIFICA SE A CAIXA CABE NO ESPAÇO DISPONÍVEL */
verificaEspaco(TipoCaixa, [Lcnt, Acnt, Pcnt]) :-
    caixa(TipoCaixa, _, [Lcx, Acx, Pcx]),
    0 =< (Lcnt - Lcx),
    0 =< (Acnt - Acx),
    0 =< (Pcnt - Pcx).

/* REGRA 6: INSERE A CAIXA NO CONTEINER */
insereCaixa(TipoCaixa, QtdDisponivel, AntigoEstado, NovoEstado, EspacoDisponivel, CamadaOcupada) :-
    caixa(TipoCaixa, _, DimensaoCaixa),
    calculaCamada(DimensaoCaixa, QtdDisponivel, QtdUtilizada, EspacoDisponivel, CamadaOcupada),
    mudaEstado(AntigoEstado, TipoCaixa, QtdUtilizada, NovoEstado).

/* REGRA 7: CALCULA O ESPAÇO DO CONTEINER QUE SERÁ OCUPADO */
calculaCamada([Lcx, Acx, Pcx], QtdCaixasDisponivel, QtdCaixasEscolhida, [Ldis, Adis, _], [Lcmd, Acmd, Pcx]) :-
    NecessariasAltura is floor(Adis / Acx),
    QtdAltura is min(QtdCaixasDisponivel, NecessariasAltura),
    Acmd is (Acx * QtdAltura),
    NecessariasLargura is floor(QtdCaixasDisponivel / QtdAltura),
    QtdLargura is min(NecessariasLargura, floor(Ldis / Lcx)),
    Lcmd is (Lcx * QtdLargura),
    QtdCaixasEscolhida is (QtdLargura * QtdAltura).

/* REGRA 8: ATUALIZA A LISTA DE ESTADOS UTILIZADOS */
mudaEstado([], TipoCaixa, QtdCaixas, [[TipoCaixa, QtdCaixas]]).

mudaEstado([[TipoCaixa, QtdAntiga]|Outras], TipoCaixa, QtdCaixas, [[TipoCaixa, QtdNova]|Outras]) :-
    QtdNova is (QtdAntiga + QtdCaixas).

mudaEstado([[TipoAntigo, QtdAntiga]|Outras], TipoCaixa, QtdCaixas, [[TipoAntigo, QtdAntiga]|NovoEstado]) :-
    TipoAntigo \== TipoCaixa,
    mudaEstado(Outras, TipoCaixa, QtdCaixas, NovoEstado).

/* REGRA 9: CALCULA O ESPAÇO DISPONÍVEL DO CONTEINER */
mudaCapacidade([Ldis, Adis, Pdis], [_, Acmd, _], CaixasUtilizadas, [Ldis, Anv, Pdis]) :-
    Anv is (Adis - Acmd),
    espacoSuficiente([Ldis, Anv, Pdis], CaixasUtilizadas).

mudaCapacidade([Ldis, _, Pdis], [Lcmd, _, _], CaixasUtilizadas, [Lnv, Amax, Pdis]) :-
    Lnv is (Ldis - Lcmd),
    conteiner(_, Amax, _),
    espacoSuficiente([Lnv, Amax, Pdis], CaixasUtilizadas).

mudaCapacidade([_, _, Pdis], [_, _, Pcmd], _, [Lmax, Amax, Pnv]) :-
    conteiner(Lmax, Amax, _),
    Pnv is (Pdis - Pcmd).

/* REGRA 10: VERIFICA SE EXISTE ALGUMA CAIXA QUE CABE NA CAMADA */
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

/* REGRA 11: CALCULA A QUANTIDADE TOTAL DE CAIXAS UTILIZADAS E O VOLUME TOTAL OCUPADO POR ELAS */
somaCaixas(0, 0, []).

somaCaixas(QtdTotal, VolumeTotal, [[TipoAtual, QtdAtual]|OutrasCaixas]) :-
    somaCaixas(QtdOutras, VolumeOutras, OutrasCaixas),
    calculaVolume(TipoAtual, VolumeAtual),
    QtdTotal is QtdOutras + QtdAtual,
    VolumeTotal is VolumeOutras + (VolumeAtual * QtdAtual).

/* REGRA 12: CALCULA O VOLUME DA CAIXA */
calculaVolume(Tipo, Volume) :-
    caixa(Tipo, _, [L, A, P]),
    Volume is L * A * P.