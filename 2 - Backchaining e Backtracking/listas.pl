adicionaInicio(X, L, [X|L]).

adicionaFim(X, [], [X]) :- !.
adicionaFim(X, [H|Tv], [H|Tn]) :-
    adicionaFim(X, Tv, Tn).

apaga(_, [], []) :- !.
apaga(X, [X|Tv], Tn) :-
    apaga(X, Tv, Tn),
    !.
apaga(X, [H|Tv], [H|Tn]) :- 
    X \== H,
    apaga(X, Tv, Tn).

membro(X, [X|_]) :- !.
membro(X, [H|T]) :- 
    X \== H,
    membro(X, T).

concatena([], L2, L2) :- !.
concatena([H1|T1], L2, [H1|T3]) :-
    concatena(T1, L2, T3).

comprimento(0, []).
comprimento(X, [_|T]) :-
    comprimento(Y, T),
    X is Y+1.

maximo(X, [X]).
maximo(X, [H|T]) :-
    maximo(X, T),
    X > H,
    !.
maximo(H, [H|T]) :-
    maximo(X, T),
    H > X.

mediaUnica(0, 0, []).
mediaUnica(S, N, [H|T]) :-
    mediaUnica(Sn, Nn, T),
    S is Sn + H,
    N is Nn + 1,
    !.

media(X, L) :-
    mediaUnica(S, N, L),
    X is S / N.