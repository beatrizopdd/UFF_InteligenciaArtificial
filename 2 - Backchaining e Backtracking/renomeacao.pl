gosta(joao,peixe).
gosta(joao,maria).
gosta(joao,livro).
gosta(pedro,flor).
gosta(pedro,vinho).
gosta(pedro,livro).

gosta(maria, X) :-
    gosta(joao, X).

gosta(maria, X) :-
    gosta(pedro, X).