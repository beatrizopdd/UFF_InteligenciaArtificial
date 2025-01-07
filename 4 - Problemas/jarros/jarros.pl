%entrada:busca([[0, 0, 0, [0,0]]],Solucao).

%FATOS
objetivo(2, _).

maximo(jarro1, 4).
maximo(jarro2, 3).

%ESTADOS
capacidade(Jarro, Valor, Dif) :-
    maximo(Jarro, Max),
    Dif is Max - Valor.

%esvazia
altera([_, Ja2], [0, Ja2]).
altera([Ja1, _], [Ja1, 0]).

%enche
altera([_, Ja2], [Jn1, Ja2]) :- maximo(jarro1, Jn1).
altera([Ja1, _], [Ja1, Jn2]) :- maximo(jarro2, Jn2).

%transfere
altera([Ja1, Ja2], [Jn1, Jn2]) :- 
	capacidade(jarro2, Ja2, Capacidade),
    Ja1 >= Capacidade,
    Jn1 is Ja1 - Capacidade,
	Jn2 is Capacidade + Ja2. %valorMaximo
altera([Ja1, Ja2], [0, Jn2]) :- 
	capacidade(jarro2, Ja2, Capacidade),
    Ja1 < Capacidade,
	Jn2 is Ja1 + Ja2.

altera([Ja1, Ja2], [Jn1, Jn2]) :- 
	capacidade(jarro1, Ja1, Capacidade),
    Ja2 >= Capacidade,
    Jn1 is Capacidade + Ja1, %valorMaximo
	Jn2 is Ja2 - Capacidade.
altera([Ja1, Ja2], [Jn1, 0]) :- 
	capacidade(jarro1, Ja1, Capacidade),
    Ja2 < Capacidade,
	Jn1 is Ja1 + Ja2.

%BUSCA
busca([[_, _,  _, [JarroA1, JarroA2]|Estados]|_], Solucao) :-
	objetivo(JarroA1, JarroA2),
	reverse([[JarroA1, JarroA2]|Estados], Solucao).

busca([CaminhoAtual|CaminhosVisitados], Solucao) :-
	estende(CaminhoAtual, NovosCaminhos),
	append(CaminhosVisitados, NovosCaminhos, CaminhosPossiveis),
	ordena(CaminhosPossiveis, CaminhosOrdenados),
	busca(CaminhosOrdenados, Solucao).

estende([CustoA, _, _, [JarroA1, JarroA2]|Estados], NovosCaminhos) :-
	findall(
    	[CustoN, AvaliacaoN, MetricaN, [JarroN1, JarroN2], [JarroA1, JarroA2]|Estados],
    	(altera([JarroA1, JarroA2], [JarroN1, JarroN2]),
    	    not(member([JarroN1, JarroN2], [[JarroA1, JarroA2]|Estados])),
    	    CustoN is CustoA + 1,
            AvaliacaoN is JarroN1 + JarroN2,
            MetricaN is CustoN + AvaliacaoN),
        NovosCaminhos).

%ORDENACAO
divide(_, [], [], []).

divide([CP, EP, Pivo|EstadosP], [[CS, ES, Soma|EstadosS]|Cauda], [[CS, ES, Soma|EstadosS]|Menores], Maiores) :-
    Soma < Pivo,
    divide([CP, EP, Pivo|EstadosP], Cauda, Menores, Maiores),
    !.

divide([CP, EP, Pivo|EstadosP], [[CS, ES, Soma|EstadosS]|Cauda], Menores, [[CS, ES, Soma|EstadosS]|Maiores]) :-
    Soma >= Pivo,
    divide([CP, EP, Pivo|EstadosP], Cauda, Menores, Maiores).

ordena([], []).

ordena([Pivo|Cauda], Final) :-
    divide(Pivo, Cauda, Menores, Maiores),
    ordena(Menores, FinalMenores),
    ordena(Maiores, FinalMaiores),
    append(FinalMenores, [Pivo|FinalMaiores], Final).