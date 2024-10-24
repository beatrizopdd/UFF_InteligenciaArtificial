/* 
Escreva um programa Prolog para representar:
- João nasceu em Pelotas e Jean nasceu em Paris.
- Pelotas fica no estado do Rio Grande do Sul.
- Paris fica na França.
- Só é gaúcho quem nasceu no estado do Rio Grande do Sul.

Aumente a base de conhecimento (fatos e regras) para responder:
- Quem é brasileiro?
- Quem é francês?
- Quem é paulista?
*/
nasceu(joao, pelotas).
nasceu(jean, paris).
nasceu(john, santos).
fica(pelotas, rs).
fica(santos, sp).
fica(rs, brasil).
fica(sp, brasil).
fica(paris, franca).

gaucho(X) :-
    nasceu(X, Cidade),
    fica(Cidade, rs).

paulista(X) :- 
    nasceu(X, Cidade),
    fica(Cidade, sp).

frances(X) :-
    nasceu(X, Provincia),
    fica(Provincia, franca).

brasileiro(X) :-
    nasceu(X, Cidade),
    fica(Cidade, Estado),
    fica(Estado, brasil).

