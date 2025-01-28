%Rotação das caixas 90°...
rotaciona([L, A, P], [L, P, A]). %em torno de X
rotaciona([L, A, P], [P, A, L]). %em torno de Y
rotaciona([L, A, P], [A, L, P]). %em torno de Z
rotaciona([L, A, P], [A, P, L]). %em torno de X->Y, Y-> Z, Z->X
rotaciona([L, A, P], [P, L, A]). %em torno de X->Z, Y->X, Z->Y