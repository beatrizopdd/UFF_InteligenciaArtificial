%COMANDO: bestFirst([[75, a]], Solucao).

%sG(G(n),VerticeOrigem,VerticeDestino)
sG(63, a, b).
sG(110, a, c).
sG(53, a, e).
sG(67, b, c).
sG(65, b, d).
sG(62, b, f).
sG(45, c, d).
sG(70, d, f).
sG(45, e, b).
sG(52, e, f).

objetivo(f).

%O nó gerado no passo anterior é um nó objetivo
branchAndBound([[G, No|Caminho]|_], [G, Solucao]):-
	objetivo(No),
	reverse([No|Caminho], Solucao).

%O nó corrente não é um nó objetivo
branchAndBound([Caminho|Caminhos], Solucao) :-
	estende(Caminho, NovosCaminhos), %Gera novos caminhos
	append(Caminhos, NovosCaminhos, CaminhosEstendidos), %Substitui o nó atual pelos novos caminhos
	ordena(CaminhosEstendidos, CaminhosOrdenados), 
	branchAndBound(CaminhosOrdenados, Solucao), %Continua a recursão
    !. %Retorna só o melhor caminho

%Gera todos os Caminhos possiveis a partir de Caminho.
estende([GV, No|Caminho], NovosCaminhos):-
	findall(
    	[GNovo, NovoNo, No|Caminho],
    	(sG(GN, No, NovoNo),
            not(member(NovoNo, [No|Caminho])), 
            GNovo is GN + GV),
    	NovosCaminhos).

%Ordenas os Caminhos por G
ordena(Caminhos, CaminhosOrdenados) :- 
    quicksort(Caminhos, CaminhosOrdenados).

quicksort([], []).

quicksort([X|Cauda], ListaOrdenada):-
	particionar(X, Cauda, Menor, Maior),
	quicksort(Menor, MenorOrd),
	quicksort(Maior, MaiorOrd),
	append(MenorOrd, [X|MaiorOrd], ListaOrdenada).

maior([G1|_], [G2|_]) :-
    G1 > G2 .

particionar(_, [], [], []).

particionar(X, [Y|Cauda], [Y|Menor], Maior):-
    maior(X, Y),
    !,
    particionar(X, Cauda, Menor, Maior).

particionar(X, [Y|Cauda], Menor, [Y|Maior]):-
    particionar(X, Cauda, Menor, Maior).