/* BANCO DE FATOS DA RELAÇÃO "família" */

/* Sara é progenitora de Isaque */
progenitor(sara,isaque).
/* Abraão é progenitor de Isaque */
progenitor(abraao,isaque).
/* Abraão é progenitor de Ismael */
progenitor(abraao,ismael).
/* Isaque é progenitor de Esaú */
progenitor(isaque,esau).
/* Isaque é progenitor de Jacó */
progenitor(isaque,jaco).
/* Jacó é progenitor de José */
progenitor(jaco,jose).

/* PERGUNTAS
Isaque é pai de Jacó?
?- progenitor(isaque,jaco).
?- true.

Ismael é pai de Jacó?
?- progenitor(ismael,jaco).
?- false.

Jacó é pai de Moisés?
?- progenitor(jaco,moises).
?- false.

Quem é pai de Ismael?
?- progenitor(X,ismael).
?- X = abraao.

Quem é filho de Isaque? ou De quem Isaque é pai?
?- progenitor(isaque, _x).
?- _x = esau (se 'enter' fim; se ';' próximo)

Quem é pai de quem?
?- progenitor(_varA, _varB).
?- _varA = sara _varB = isaque (se 'enter' fim; se ';' próximo)
*/