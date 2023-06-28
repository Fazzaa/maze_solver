% se a richiedere il calcolo è la posizione di partenza non aggiungiamo nulla
manhattan(pos(X, Y), pos(XF, YF), Fn, Visitati) :-
    iniziale(pos(X,Y)),
    XDiff is abs(X-XF),
    YDiff is abs(Y-YF),
    Hn is XDiff+YDiff,
    length(Visitati, Gn),
    Fn is Hn + Gn.
% se a richiedere il calcolo non è la posizione di partenza aggiungiamo un passo
manhattan(pos(X, Y), pos(XF, YF), Fn, Visitati) :-
    \+ iniziale(pos(X,Y)),
    XDiff is abs(X-XF),
    YDiff is abs(Y-YF),
    Hn is XDiff+YDiff,
    length(Visitati, Gn),
    Fn is Hn + Gn + 1.

initialize :- 
    retractall(current_depth(_)),
    retractall(next_depth(_)),
    iniziale(S),
    stato_finale_migliore(S, (_, DistanzaSFinaleMigliore), []), 
    assert(next_depth(DistanzaSFinaleMigliore)),
    assert(current_depth(DistanzaSFinaleMigliore)).
    
prova(Cammino) :-
    iniziale(S),
    current_depth(Dist),
    write('Profondità corrente:'), write(Dist), write('\n'), 
    risolvi(S, Cammino, [], Dist). 

prova(Cammino) :-
    next_depth(DNew),
    retractall(current_depth(_)),
    assert(current_depth(DNew)), 
    prova(Cammino). 

risolvi(S, [], _, _) :- finale(ListaFinali), member(S,ListaFinali), !. 

risolvi(S, [AzioneMigliore|ListaAzioni], Visitati, ProfMax) :-  
    ProfMax > 0,
    current_depth(D),
    stato_finale_migliore(S, (FinaleMigliore, _), Visitati),
    findall(Az, applicabile(Az, S), AzioniPossibili),
    merge_sort(AzioniPossibili, AzioniPossibiliOrdinate, S, FinaleMigliore, Visitati),
    member((AzioneMigliore, DistanzaStatoMigliore), AzioniPossibiliOrdinate),
    find_next_limit(D, AzioniPossibiliOrdinate),
    DistanzaStatoMigliore =< D,
    trasforma(AzioneMigliore, S, SNuovo),
    \+member(SNuovo, Visitati),
    NuovaProfMax is ProfMax-1,  
    risolvi(SNuovo, ListaAzioni, [S|Visitati], NuovaProfMax). 


merge_sort([],[], _, _, _).     % empty list is already sorted
merge_sort([X],[(X, DistanzaX)], pos(XAttuale, YAttuale), pos(XTarget, YTarget), Visitati) :-
    trasforma(X, pos(XAttuale, YAttuale), pos(XNuovoStatoX, YNuovoStatoX)),
    manhattan(pos(XNuovoStatoX, YNuovoStatoX), pos(XTarget, YTarget), DistanzaX, Visitati), !.   % single element list is already sorted
merge_sort(List,Sorted, pos(XAttuale, YAttuale), pos(XTarget, YTarget), Visitati):-
    List=[_,_|_],divide(List,L1,L2),     % list with at least two elements is divided into two parts
    merge_sort(L1,Sorted1, pos(XAttuale, YAttuale), pos(XTarget, YTarget), Visitati),merge_sort(L2,Sorted2, pos(XAttuale, YAttuale), pos(XTarget, YTarget), Visitati),  % then each part is sorted
    merge(Sorted1,Sorted2,Sorted, pos(XAttuale, YAttuale), pos(XTarget, YTarget), Visitati).                  % and sorted parts are merged
merge([],L,L, _, _).
merge(L,[],L, _, _):-L\=[].
merge([(X, DistanzaX)|T1],[(Y, DistanzaY)|T2],[(X, DistanzaX)|T], pos(XAttuale, YAttuale), pos(XTarget, YTarget), Visitati):-
    trasforma(X, pos(XAttuale, YAttuale), pos(XNuovoStatoX, YNuovoStatoX)),
    trasforma(Y, pos(XAttuale, YAttuale), pos(XNuovoStatoY, YNuovoStatoY)),
    manhattan(pos(XNuovoStatoX, YNuovoStatoX), pos(XTarget, YTarget), DistanzaX, Visitati),
    manhattan(pos(XNuovoStatoY, YNuovoStatoY), pos(XTarget, YTarget), DistanzaY, Visitati),
    DistanzaX=<DistanzaY,!,
    merge(T1,[(Y, DistanzaY)|T2],T).
merge([(X, DistanzaX)|T1],[(Y, DistanzaY)|T2],[(Y, DistanzaY)|T], pos(XAttuale, YAttuale), pos(XTarget, YTarget), Visitati):-
    trasforma(X, pos(XAttuale, YAttuale), pos(XNuovoStatoX, YNuovoStatoX)),
    trasforma(Y, pos(XAttuale, YAttuale), pos(XNuovoStatoY, YNuovoStatoY)),
    manhattan(pos(XNuovoStatoX, YNuovoStatoX), pos(XTarget, YTarget), DistanzaX, Visitati),
    manhattan(pos(XNuovoStatoY, YNuovoStatoY), pos(XTarget, YTarget), DistanzaY, Visitati),
    DistanzaX>DistanzaY, !,
    merge([(X, DistanzaX)|T1],T2,T).
    
divide(L,L1,L2):- 
    length(L, Len),
    Half is Len // 2,
    split_in_half(L,L1,L2, Half).

split_in_half(L,L1,L2, Half) :-  
    length(L1, Half),
    append(L1, L2, L).


stato_finale_migliore(pos(X,Y), (StatoFinale, Distanza_1), Visitati) :- 
    finale(ListaStatiFinali),
    member(StatoFinale, ListaStatiFinali),
    manhattan(pos(X,Y), StatoFinale, Distanza_1, Visitati),
    \+ (member(AltroStato, ListaStatiFinali), manhattan(pos(X, Y), AltroStato, Distanza_2, Visitati), Distanza_2 < Distanza_1), !. 

find_next_limit(SogliaAttuale, [(Az,D) | AzioniPossibiliOrdinate]) :-
    next_depth(NextDepth),
    member((_, NextFn), [(Az,D) | AzioniPossibiliOrdinate]), 
    NextFn > SogliaAttuale,
    NextFn > NextDepth,
    \+ (member((_, AltroFn), [(Az,D) | AzioniPossibiliOrdinate]), AltroFn > SogliaAttuale, AltroFn > NextDepth, AltroFn < NextFn), !,
    retractall(next_depth(_)),
    assert(next_depth(NextFn)).

find_next_limit(SogliaAttuale, [(Az,D) | AzioniPossibiliOrdinate]) :-
    next_depth(NextDepth),
    member((_, NextFn), [(Az,D) | AzioniPossibiliOrdinate]), !, 
    NextFn =< NextDepth,
    NextFn =< SogliaAttuale.