%entrada:busca([[0,[0, 0]]],[Custo,Solucao]).
%saida:[6, [[0, 0], [4, 0], [1, 3], [1, 0], [0, 1], [4, 1], [2, 3]]]

%FATOS
maximo(vaso1, 4).
maximo(vaso2, 3).

objetivo(2, _).

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
busca([[Custo, [VasoA1, VasoA2]|Estados]|_], [Custo, Solucao]) :-
	objetivo(VasoA1, VasoA2),
	reverse([[VasoA1, VasoA2]|Estados], Solucao).

busca([EstadoAtual|EstadosVisitados], Solucao) :-
	estende(EstadoAtual, NovosEstados),
	append(EstadosVisitados, NovosEstados, EstadosPossiveis),
	ordena(EstadosPossiveis, EstadosOrdenados),
	busca(EstadosOrdenados, Solucao),
    !.

%ExpandeCaminhos
estende([CustoA, [VasoA1, VasoA2]|Estados], NovosEstados) :-
	findall(
    	[CustoN, [VasoN1, VasoN2], [VasoA1, VasoA2]|Estados],
    	(altera([VasoA1, VasoA2], [VasoN1, VasoN2]),
    	    not(member([VasoN1, VasoN2], [[VasoA1, VasoA2]|Estados])),
    	    CustoN is CustoA + 1),
        NovosEstados).

%OrdenaCaminhos
%PARTICIONAMENTO
divide(_, [], [], []).

divide([Pivo|EstadosP], [[Custo|EstadosC]|Cauda], [[Custo|EstadosC]|Menores], Maiores) :-
    Custo < Pivo,
    divide([Pivo|EstadosP], Cauda, Menores, Maiores),
    !.

divide([Pivo|EstadosP], [[Custo|EstadosC]|Cauda], Menores, [[Custo|EstadosC]|Maiores]) :-
    Custo >= Pivo,
    divide([Pivo|EstadosP], Cauda, Menores, Maiores).

%ORDENACAO
ordena([], []).

ordena([Pivo|Cauda], Final) :-
    divide(Pivo, Cauda, Menores, Maiores),
    ordena(Menores, FinalMenores),
    ordena(Maiores, FinalMaiores),
    append(FinalMenores, [Pivo|FinalMaiores], Final).