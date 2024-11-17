%FATOS
maximo(vaso1, 4).
maximo(vaso2, 3).

objetivo(2, _).
objetivo(_, 2).

/*
 O melhor estado é um estado objetivo 
avalia([[_, T, _, [VasoA1, VasoA2]|Estados]|_], [T, Solucao]):-
	objetivo(VasoA1, VasoA2),
	reverse([[VasoA1, VasoA2]|Estados], Solucao).

O melhor estado não é um estado objetivo
avalia([Estado|Estados], Solucao) :-
	estende(Estado, NovosEstados),
	append(Estados, NovosEstados, EstadosEstendidos),
	ordena(EstadosEstendidos, EstadosOrdenados), 
	avalia(EstadosOrdenados, Solucao),
    !.
*/

/* MOVIMENTAÇÕES POSSÍVEIS */
%enche
altera([Va1, Va2], [Vn1, Vn2]) :- maximo(vaso1, Vn1).
altera([Va1, Va2], [Vn1, Vn2]) :- maximo(vaso2, Vn2).

%despeja
altera([Va1, Va2], [Vn1, Vn2]) :- 
    Va1 < Va2,
    Vn2 is Va2 + (),
    Vn1 is Va1 - (Max - Va2).

/* Gera todos os estados possíveis a partir do Estados*/
estende([Sa, Ta, Fa, [VasoA1, VasoA2]|Estados], NovosEstados) :-
	findall(
    	[SNovo, TNovo, FNovo, [VasoN1, VasoN2], [VasoA1, VasoA2]|Estados],
    	(altera([VasoA1, VasoA2], [VasoN1, VasoN2]),
    	    not(member([VasoN1, VasoN2], [[VasoA1, VasoA2]|Estados])),
    	    SNovo is VasoN1 + VasoN2,
            TNovo is Ta + 1,
            FNovo is SNovo + TNovo),
        NovosEstados).

/* Ordena os estados por F*/
ordena(Estados, EstadosOrdenados) :- 
    quicksort(Estados, EstadosOrdenados).

quicksort([], []).

quicksort([X|Cauda], ListaOrdenada):-
	particionar(X, Cauda, Menor, Maior),
	quicksort(Menor, MenorOrd),
	quicksort(Maior, MaiorOrd),
	append(MenorOrd, [X|MaiorOrd], ListaOrdenada).

maior([_, _, F1|_], [_, _, F2|_]) :-
    F1 > F2 .

particionar(_, [], [], []).

particionar(X, [Y|Cauda], [Y|Menor], Maior):-
    maior(X, Y),
    !,
    particionar(X, Cauda, Menor, Maior).

particionar(X, [Y|Cauda], Menor, [Y|Maior]):-
    particionar(X, Cauda, Menor, Maior).