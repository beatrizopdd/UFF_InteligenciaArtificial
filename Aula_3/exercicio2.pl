/*
Assuma que arcos em um grafo dirigido representam custos e sejam descritos como arco(R,S,T), 
significando que há um arco de custo T entre R e S. 
Defina custo(U,V,L) – existe um caminho de custo L entre U e V.
*/

arco(a, b, 3).
arco(a, c, 4).
arco(a, d, 5).
arco(b, d, 2).
arco(c, d, 4).
arco(c, f, 5).
arco(d, e, 2).
arco(e, f, 2).

/* Caso Base */
custo(U, V, L) :-
    arco(U, V, L).

/* Caso Recursivo */
custo(U, V, L) :-
    arco(U, V1, L1),
    custo(V1, V, L2),
    L is L1+L2.
