% applicabile(AZ,S)
applicabile(nord,pos(Riga,Colonna)):-
    Riga > 1,
    RigaNord is Riga - 1,
    \+occupata(pos(RigaNord,Colonna)).

applicabile(sud,pos(Riga,Colonna)):-
    num_righe(NR),
    Riga < NR,
    RigaSud is Riga + 1,
    \+occupata(pos(RigaSud,Colonna)).

applicabile(ovest,pos(Riga,Colonna)):-
    Colonna > 1,
    ColonnaOvest is Colonna - 1,
    \+occupata(pos(Riga,ColonnaOvest)).

applicabile(est,pos(Riga,Colonna)):-
    num_col(NC),
    Colonna < NC,
    ColonnaEst is Colonna + 1,
    \+occupata(pos(Riga,ColonnaEst)).

% trasforma(AZ,S,S_Nuovo)
trasforma(nord,pos(Riga,Colonna),pos(RigaNord,Colonna)):-
    RigaNord is Riga - 1.

trasforma(sud,pos(Riga,Colonna),pos(RigaSud,Colonna)):-
    RigaSud is Riga + 1.

trasforma(ovest,pos(Riga,Colonna),pos(Riga,ColonnaOvest)):-
    ColonnaOvest is Colonna - 1.

trasforma(est,pos(Riga,Colonna),pos(Riga,ColonnaEst)):-
    ColonnaEst is Colonna + 1.
