progenitor(jay, claire).
progenitor(jay, mitchell).
progenitor(jay, joe).
progenitor(gloria, joe).
progenitor(gloria, manny).
progenitor(mitchell, lily).
progenitor(cam, lily).
progenitor(claire, luke).
progenitor(claire, alex).
progenitor(claire, haley).
progenitor(phil, luke).
progenitor(phil, alex).
progenitor(phil, haley).

/* CASO BASE */
ancestral(Velho, Novo) :-
    progenitor(Velho, Novo).

/* CASO RECURSIVO */
ancestral(Velho, Novo) :-
    progenitor(Velho, Filho),
    ancestral(Filho, Novo).



/* PERGUNTAS

Quais são os descendentes de Jay?
?- ancestral(jay, X).
X = claire ;
X = mitchell ;
X = joe ;
X = luke ;
X = alex ;
X = haley ;
X = lily ;
false.

Quais são os descendentes de Claire?
?- ancestral(claire, X).  
X = luke ;
X = alex ;
X = haley ;
false.

Quais são os ancestrais de Lily?
?- ancestral(X, lily). 
X = mitchell ;
X = cam ;
X = jay ;
false.

Quais são os ancestrais de Jay?
?- ancestral(X, jay).
false.
*/