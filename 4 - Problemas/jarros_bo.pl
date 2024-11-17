%entrada:busca([[0, 0, 0,[0,0]]],Solucao).
%saida:

%FATOS
maximo(vaso1, 4).
maximo(vaso2, 3).

objetivo(2, _).
objetivo(_, 2).

capacidade(Vaso, Valor, Dif) :-
	maximo(Vaso, Max),
	Dif is Max - Valor.

%MOVIMENTOS
%esvazia
altera([_, Va2], [0, Va2]).
altera([Va1, _], [Va1, 0]).

%enche
altera([_, Va2], [Vn1, Va2]) :- maximo(vaso1, Vn1).
altera([Va1, _], [Va1, Vn2]) :- maximo(vaso2, Vn2).

%transfere
altera([Va1, Va2], [Vn1, Vn2]) :- 
	capacidade(vaso2, Va2, Capacidade),
    Va1 >= Capacidade,
    Vn1 is Va1 - Capacidade,
	Vn2 is Capacidade + Va2. %valorMaximo
altera([Va1, Va2], [0, Vn2]) :- 
	capacidade(vaso2, Va2, Capacidade),
    Va1 < Capacidade,
	Vn2 is Va1 + Va2.

altera([Va1, Va2], [Vn1, Vn2]) :- 
	capacidade(vaso1, Va1, Capacidade),
    Va2 >= Capacidade,
    Vn1 is Capacidade + Va1, %valorMaximo
	Vn2 is Va2 - Capacidade.
altera([Va1, Va2], [Vn1, 0]) :- 
	capacidade(vaso1, Va1, Capacidade),
    Va2 < Capacidade,
	Vn1 is Va1 + Va2.

%BUSCA
busca([[_, _,  _, [VasoA1, VasoA2]|Estados]|_], Solucao) :-
	objetivo(VasoA1, VasoA2),
	reverse([[VasoA1, VasoA2]|Estados], Solucao).

busca([EstadoAtual|EstadosVisitados], Solucao) :-
	estende(EstadoAtual, NovosEstados),
	append(EstadosVisitados, NovosEstados, EstadosPossiveis),
	ordena(EstadosPossiveis, EstadosOrdenados),
	busca(EstadosOrdenados, Solucao).

%ExpandeCaminhos
estende([CustoA, _, _, [VasoA1, VasoA2]|Estados], NovosEstados) :-
	findall(
    	[CustoN, EstimativaN, MetricaN, [VasoN1, VasoN2], [VasoA1, VasoA2]|Estados],
    	(altera([VasoA1, VasoA2], [VasoN1, VasoN2]),
    	    not(member([VasoN1, VasoN2], [[VasoA1, VasoA2]|Estados])),
    	    CustoN is CustoA + 1,
            EstimativaN is VasoN1 + VasoN2,
            MetricaN is CustoN + EstimativaN),
        NovosEstados).

%OrdenaCaminhos
ordena(Estados, EstadosOrdenados) :- 
    quicksort(Estados, EstadosOrdenados).

quicksort([], []).

quicksort([X|Cauda], ListaOrdenada):-
	particionar(X, Cauda, Menor, Maior),
	quicksort(Menor, MenorOrd),
	quicksort(Maior, MaiorOrd),
	append(MenorOrd, [X|MaiorOrd], ListaOrdenada).

maior([_, _, M1|_], [_, _, M2|_]) :-
    M1 > M2 .

particionar(_, [], [], []).

particionar(X, [Y|Cauda], [Y|Menor], Maior):-
    maior(X, Y),
    !,
    particionar(X, Cauda, Menor, Maior).

particionar(X, [Y|Cauda], Menor, [Y|Maior]):-
    particionar(X, Cauda, Menor, Maior).