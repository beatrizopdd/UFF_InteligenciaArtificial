%Base
pertence(X, [X|_]).

%Recursivo
pertence(X, [_|T]):-
    pertence(X, T).