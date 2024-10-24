# Inteligência Artificial

### Prolog no VS Code 

- Baixe e instale o [SWI-Prolog](https://www.swi-prolog.org/download/stable);
- Nas opções de instalação, marque "Add swipl to the system PATH", ```for all users``` ou ```for current user``` a sua escolha;
- No VS Code, instale a extensão [Prolog](https://marketplace.visualstudio.com/items?itemName=rebornix.prolog);

Para utilizar:
- Abra o terminal no diretório do arquivo;
- Digite o comando ```swipl``` que abrirá um terminal para executar comandos de prolog;
- Para carregar o arquivo digite ```?- consult(nomeDoArquivo).```;
- Para dar comandos sempre termine com o ponto final;

### Arquivos

- Fatos <br>
Existem relações definidas por fatos. ```relaciona(objetoA, objetoB) = objeto A se relaciona com objeto B``` é diferente de ```relaciona(objetoB, objetoA) = objeto B se relaciona com objeto A```

- Regras <br>
Existem relações definidas por fatos.
Em português: se chover, então o chão fica molhado;
em prolog: o chão fica molhado se chover.

- Recursividade <br>
Relações recursivas são definidas por duas regras: o caso base e o caso recursivo.