%COMANDO: bestFirst([[75, a]], Solucao).

%sH(H(n),VerticeOrigem,VerticeDestino)
sH(40, a, b).
sH(67, a, c).
sH(45, a, e).
sH(67, b, c).
sH(40, b, d).
sH(0, b, f).
sH(40, c, d).
sH(0, d, f).
sH(40, e, b).
sH(0, e, f).

objetivo(f).

%O nó gerado no passo anterior é um nó objetivo
bestFirst([[_, No|Caminho]|_], Solucao):-
	objetivo(No),
	reverse([No|Caminho], Solucao).

%O nó corrente não é um nó objetivo
bestFirst([Caminho|Caminhos], Solucao) :-
	estende(Caminho, NovosCaminhos), %Gera novos caminhos
	append(Caminhos, NovosCaminhos, CaminhosEstendidos), %Substitui o nó atual pelos novos caminhos
	ordena(CaminhosEstendidos, CaminhosOrdenados), 
	bestFirst(CaminhosOrdenados, Solucao), %Continua a recursão
    !. %Retorna só o melhor caminho

%Gera todos os Caminhos possiveis a partir de Caminho.
estende([_, No|Caminho], NovosCaminhos):-
	findall(
    	[HNovo, NovoNo, No|Caminho],
    	(sH(HN, No, NovoNo), 
            not(member(NovoNo, [No|Caminho])), 
            HNovo is HN),
    	NovosCaminhos).

%Ordenas os Caminhos por H
ordena(Caminhos, CaminhosOrdenados) :- 
    quicksort(Caminhos, CaminhosOrdenados).

quicksort([], []).
 
quicksort([X|Cauda], ListaOrdenada):-
	particionar(X, Cauda, Menor, Maior),
	quicksort(Menor, MenorOrd),
	quicksort(Maior, MaiorOrd),
	append(MenorOrd, [X|MaiorOrd], ListaOrdenada).

maior([H1|_], [H2|_]) :-
    H1 > H2 .

particionar(_, [], [], []).

particionar(X, [Y|Cauda], [Y|Menor], Maior):-
	maior(X, Y),
	!,
	particionar(X, Cauda, Menor, Maior).

particionar(X, [Y|Cauda], Menor, [Y|Maior]):-
	particionar(X, Cauda, Menor, Maior).
