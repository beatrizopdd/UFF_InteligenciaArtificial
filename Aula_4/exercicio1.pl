ponto(X, Y).
retangulo(SupEsq, InfDir).

quadrado(retangulo(ponto(X1, Y1), ponto(X2, Y2))) :-
    Largura is X2-X1,
    Altura is Y2-Y1,
    Largura == Altura.