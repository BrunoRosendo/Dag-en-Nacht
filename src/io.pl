:-use_module(library(between)).

% Clears the terminal screen
clear :- write('\e[2J').

readNumber(X) :- readNumber(X, 0).

readNumber(X, X) :-
    peek_code(10), !,
    skip_line.

readNumber(X, Acc) :-
    get_code(C),
    C >= 48,
    C =< 57, !,
    Real is C - 48,
    Tmp is Acc * 10,
    Acc1 is Tmp + Real,
    readNumber(X, Acc1).

readUntilBetween(Min, Max, Value) :-
    repeat, % until we find the solution
    readNumber(Value),
    between(Min, Max, Value), !.
