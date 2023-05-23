manhattan(pos(X, Y), pos(XF, YF), Dist) :-
    XDiff is abs(X-XF),
    YDiff is abs(Y-YF),
    Dist is XDiff+YDiff.

initialize :- 
    retractall(current_depth(_)),
    iniziale(S0),
    finale(SF),
    manhattan(S0, SF, Dist),
    assert(current_depth(Dist)).

prova(Cammino) :-
    iniziale(S0), 
    current_depth(D),
    write('Profondità corrente:'), write(D), write('\n'), 
    risolvi(S0, Cammino, [], D). 

prova(Cammino) :-
    current_depth(D),
    DNew is D+1, 
    DNew < 101,
    retractall(current_depth(_)),
    assert(current_depth(DNew)), 
    prova(Cammino). 

risolvi(S, [], _, _) :- finale(S), !. 

risolvi(S, [Az|ListaAzioni], Visitati, ProfMax) :-  
    ProfMax > 0, 
    applicabile(Az, S),

    trasforma(Az, S, SNuovo),
    \+member(SNuovo, Visitati),
    NuovaProfMax is ProfMax-1,  
    risolvi(SNuovo, ListaAzioni, [S|Visitati], NuovaProfMax). 