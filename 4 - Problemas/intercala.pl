/*
recebe: L1 = [50,42,21,10,5] e L2 = [55,41,35,9,7,2]
retorna: L3 = [55,50,42,41,35,21,10,9,7,5,2]

entrada: intercala([50,42,21,10,5],[55,41,35,9,7,2],L3).
*/

intercala([], L2, L2) :- !.  
intercala(L1, [], L1) :- !.  

intercala([H1|T1], [H2|T2], [H1|L3]) :-
    H1 >= H2,
    intercala(T1, [H2|T2], L3).

intercala([H1|T1], [H2|T2], [H2|L3]) :-
    H2 > H1,
    intercala([H1|T1], T2, L3).