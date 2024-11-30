%PARTICIONAMENTO
divide(_, [], [], []).

divide(P, [X|C], [X|Menores], Maiores) :-
    X < P,
    divide(P, C, Menores, Maiores),
    !.

divide(P, [X|C], Menores, [X|Maiores]) :-
    X >= P,
    divide(P, C, Menores, Maiores).

%ORDENACAO
ordena([], []).

ordena([Pivo|Cauda], Final) :-
    divide(Pivo, Cauda, Menores, Maiores),
    ordena(Menores, FinalMenores),
    ordena(Maiores, FinalMaiores),
    append(FinalMenores, [Pivo|FinalMaiores], Final).