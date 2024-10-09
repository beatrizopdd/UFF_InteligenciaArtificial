progenitor(grandmama, gomez).
progenitor(grandmama, tioChico).
progenitor(gomez, wandinha).
progenitor(gomez, feioso).
progenitor(morticia, wandinha).
progenitor(morticia, feioso).
mulher(grandmama).
mulher(wandinha).
mulher(morticia).
homem(gomez).
homem(tioChico).
homem(feioso).

/* Traduza para Prolog: Todo mundo que tem filho é feliz (defina a relação unária feliz) */
feliz(X) :-
    progenitor(X, F).

/* Defina as relações irmã e irmão_geral */
irmao_geral(A, B) :-
    progenitor(_pai, A),
    progenitor(_pai, B).

irma(Ia) :-
    mulher(Ia),
    irmao_geral(Ia, Io).

/* Defina a relação neto_geral usando a relação progenitor */
neto_geral(Neto, Avo) :- 
    progenitor(Avo, Pai),
    progenitor(Pai, Neto).

/* Defina a relação tio(X,Y) em termos das relações progenitor e irmão */
tio(X, Y) :-
    progenitor(_pai, Y),
    irmao_geral(_pai, X).