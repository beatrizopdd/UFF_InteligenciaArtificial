adiciona(X, L1, [X|L1]).

apaga(_,[],[]) :- !.
apaga(X, [X|F1], F2) :- apaga(X, F1, F2), !.
apaga(X,[C|F1],[C|F2]):-
    X \== C,
    apaga(X,F1,F2).

membro(X, [X|_]).
membro(X, [_|T]):-
    membro(X, T).

concatena(L1, L2, [L1|L2]).

comprimento(0, []).
comprimento(X, [H|T]) :-
    comprimento(S, T),
    X is S+1.

maximo(X, [X]).
maximo(X, [H|T]) :-
    maximo(X, T),
    

/*
consult(exercicio1).
adiciona(1,[2,3],L).
adiciona(X,[2,3],[1,2,3]).
apaga(a,[a,b,a,c],L).
apaga(a,L,[b,c]).
membro(b,[a,b,c]).
membro(X,[a,b,c]).
findall(X,membro(X,[a,b,c]),L).
concatena([1,2],[3,4],L).
concatena([1,2],L,[1,2,3,4]).
concatena(L,[3,4],[1,2,3,4]).
comprimento(X,[a,b,c].
comprimento(X,[a,b,c].
maximo(X,[3,2,1,7,4]).
media(X,[1,2,3,4,5]).
*/