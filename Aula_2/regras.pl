/* BANCO DE FATOS */
progenitor(sara,isaque).
progenitor(abraao,isaque).
progenitor(abraao,ismael).
progenitor(isaque,esau).
progenitor(isaque,jaco).
progenitor(jaco,jose).
mulher(sara).
homem(isaque).
homem(abraao).
homem(ismael).
homem(esau).
homem(jaco).
homem(jose).

/* Regras */

ehFilhoDe(X, Y) :- progenitor(Y, X).

pai(_p, _f) :- progenitor(_p, _f), homem(_p).

mae(_m, _f) :-
    progenitor(_m, _f),
    mulher(_m).