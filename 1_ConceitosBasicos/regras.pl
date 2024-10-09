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

/* RELAÇÕES DEFINIDAS POR REGRAS
em português: se chover, então o chão fica molhado
em prolog: o chão fica molhado se chover
*/

ehFilhoDe(X, Y) :- progenitor(Y, X).

pai(_p, _f) :- progenitor(_p, _f), homem(_p).

mae(_m, _f) :-
    progenitor(_m, _f),
    mulher(_m).