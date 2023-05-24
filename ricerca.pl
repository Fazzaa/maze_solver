manhattan(pos(X, Y), pos(XF, YF), Dist) :-
    XDiff is abs(X-XF),
    YDiff is abs(Y-YF),
    Dist is XDiff+YDiff.

initialize :- 
    retractall(current_depth(_)),
    iniziale(S0),
    finale(F), 
    stato_finale_vicino(S0, F, FinaleMigliore, 100),
    write(FinaleMigliore),
    manhattan(S0, FinaleMigliore, Dist),
    assert(current_depth(Dist)).
    
prova(Cammino) :-
    iniziale(S0),
    current_depth(Dist),
    write('Profondità corrente:'), write(Dist), write('\n'), 
    risolvi(S0, Cammino, [], Dist). 

prova(Cammino) :-
    current_depth(D),
    DNew is D+1, 
    DNew < 101,
    retractall(current_depth(_)),
    assert(current_depth(DNew)), 
    prova(Cammino). 

risolvi(S, [], _, _) :- finale(S), !. 

risolvi(S, [AzioneMigliore|ListaAzioni], Visitati, ProfMax) :-  
    ProfMax > 0,
    %write('Prof:'), write(ProfMax), write('\n'),
    finale(F), 
    stato_finale_vicino(S, F, FinaleMigliore, 100),
    %Qui dovremmo calcolare manhattan per decidere su quale finale puntare
    findall(Az, applicabile(Az, S), AzioniPossibili),
    %ordinare la lista di azioni possibili in base all'euristica nello stato di destinazione
    merge_sort(AzioniPossibili, AzioniPossibiliOrdinate, S, FinaleMigliore),
    member(AzioneMigliore, AzioniPossibiliOrdinate),
    %applicabile(AzioneMigliore, S),
    trasforma(AzioneMigliore, S, SNuovo),
    %write('Eseguita azione:'), write(AzioneMigliore),write(', da posizione:'), write(S),write(', a posizione:'), write(SNuovo), write('\n'),
    \+member(SNuovo, Visitati),
    NuovaProfMax is ProfMax-1,  
    risolvi(SNuovo, ListaAzioni, [S|Visitati], NuovaProfMax). 


merge_sort([],[], _, _).     % empty list is already sorted
merge_sort([X],[X], _, _).   % single element list is already sorted
merge_sort(List,Sorted, pos(XAttuale, YAttuale), pos(XTarget, YTarget)):-
    List=[_,_|_],divide(List,L1,L2),     % list with at least two elements is divided into two parts
    merge_sort(L1,Sorted1, pos(XAttuale, YAttuale), pos(XTarget, YTarget)),merge_sort(L2,Sorted2, pos(XAttuale, YAttuale), pos(XTarget, YTarget)),  % then each part is sorted
    merge(Sorted1,Sorted2,Sorted, pos(XAttuale, YAttuale), pos(XTarget, YTarget)).                  % and sorted parts are merged
merge([],L,L, _, _).
merge(L,[],L, _, _):-L\=[].
merge([X|T1],[Y|T2],[X|T], pos(XAttuale, YAttuale), pos(XTarget, YTarget)):-
    trasforma(X, pos(XAttuale, YAttuale), pos(XNuovoStatoX, YNuovoStatoX)),
    trasforma(Y, pos(XAttuale, YAttuale), pos(XNuovoStatoY, YNuovoStatoY)),
    manhattan(pos(XNuovoStatoX, YNuovoStatoX), pos(XTarget, YTarget), DistanzaX),
    manhattan(pos(XNuovoStatoY, YNuovoStatoY), pos(XTarget, YTarget), DistanzaY),
    DistanzaX=<DistanzaY,
    merge(T1,[Y|T2],T).
merge([X|T1],[Y|T2],[Y|T], pos(XAttuale, YAttuale), pos(XTarget, YTarget)):-
    trasforma(X, pos(XAttuale, YAttuale), pos(XNuovoStatoX, YNuovoStatoX)),
    trasforma(Y, pos(XAttuale, YAttuale), pos(XNuovoStatoY, YNuovoStatoY)),
    manhattan(pos(XNuovoStatoX, YNuovoStatoX), pos(XTarget, YTarget), DistanzaX),
    manhattan(pos(XNuovoStatoY, YNuovoStatoY), pos(XTarget, YTarget), DistanzaY),
    DistanzaX>DistanzaY,
    merge([X|T1],T2,T).
    
divide(L,L1,L2):- 
    length(L, Len),
    Half is Len // 2,
    split_in_half(L,L1,L2, Half).

split_in_half(L,L1,L2, Half) :-  
    length(L1, Half),
    append(L1, L2, L).

stato_finale_vicino(_, [], _, _).

stato_finale_vicino(pos(XAttuale,YAttuale), [Finale | AltriFinali], FinaleMigliore, DistanzaMinima) :-
    manhattan(pos(XAttuale,YAttuale), Finale, Distanza),
    Distanza >= DistanzaMinima,
    stato_finale_vicino(pos(XAttuale,YAttuale), AltriFinali, FinaleMigliore, DistanzaMinima).

stato_finale_vicino(pos(XAttuale,YAttuale), [Finale | AltriFinali], FinaleMigliore, DistanzaMinima) :-
    manhattan(pos(XAttuale,YAttuale), Finale, Distanza),
    Distanza < DistanzaMinima,
    FinaleMigliore is Finale,
    stato_finale_vicino(pos(XAttuale,YAttuale), AltriFinali, FinaleMigliore, Distanza).


    