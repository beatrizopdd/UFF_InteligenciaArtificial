%COMANDO: aEstrela([[0, 75, 75, a]], [G, Solucao]). 

%sGH(G(n),H(n),VerticeOrigem,VerticeDestino)
sGH(63, 40, a, b).
sGH(110, 67, a, c).
sGH(53, 45, a, e).
sGH(67, 43, b, c).
sGH(65, 40, b, d).
sGH(62, 0, b, f).
sGH(45, 40, c, d).
sGH(70, 0, d, f).
sGH(45, 40, e, b).
sGH(52, 0, e, f).

sF(G, H, F, V1, V2):-
	sGH(G, H, V1, V2),
	F is G + H.

objetivo(f).

%O nó gerado no passo anterior é um nó objetivo
aEstrela([[G, _, _, No|Caminho]|_], [G, Solucao]):-
	objetivo(No),
	reverse([No|Caminho], Solucao).

%O nó corrente não é um nó objetivo
aEstrela([Caminho|Caminhos], Solucao) :-
	estende(Caminho, NovosCaminhos), %Gera novos caminhos
	append(Caminhos, NovosCaminhos, CaminhosEstendidos), %Substitui o nó atual pelos novos caminhos
	ordena(CaminhosEstendidos, CaminhosOrdenados), 
	aEstrela(CaminhosOrdenados, Solucao), %Continua a recursão
    !. %Retorna só o melhor caminho

%Gera todos os Caminhos possiveis a partir de Caminho.
estende([GV, _, _, No|Caminho], NovosCaminhos):-
	findall(
    	[GNovo, HNovo, FNovo, NovoNo, No|Caminho],
    	(sF(GN, HN, _, No, NovoNo),
    	    not(member(NovoNo, [No|Caminho])),
    	    GNovo is GV + GN,
            HNovo is HN,
            FNovo is GNovo + HNovo),
        NovosCaminhos).

%Ordenas os Caminhos por F
ordena(Caminhos, CaminhosOrdenados) :- 
    quicksort(Caminhos, CaminhosOrdenados).

quicksort([], []).

quicksort([X|Cauda], ListaOrdenada):-
	particionar(X, Cauda, Menor, Maior),
	quicksort(Menor, MenorOrd),
	quicksort(Maior, MaiorOrd),
	append(MenorOrd, [X|MaiorOrd], ListaOrdenada).

maior([_, _, F1|_], [_, _, F2|_]) :-
    F1 > F2 .

particionar(_, [], [], []).

particionar(X, [Y|Cauda], [Y|Menor], Maior):-
    maior(X, Y),
    !,
    particionar(X, Cauda, Menor, Maior).

particionar(X, [Y|Cauda], Menor, [Y|Maior]):-
    particionar(X, Cauda, Menor, Maior).