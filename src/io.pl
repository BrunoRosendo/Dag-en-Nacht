:-use_module(library(between)).
:- consult('utils.pl').

% Clears the terminal screen
clear :- write('\e[2J').

/**
 * invalidDigit(+C)
 *
 * Checks if the char is an invalid digit and clears input if so
 */
invalidDigit(C) :-
    (C < 48 ; C > 57),
    skip_line.

validDigit(C) :- not(invalidDigit(C)), !.

/**
 * readNumber(-X)
 *
 * Reads a number from input
 */
readNumber(X) :- readNumber(X, 0).

readNumber(X, X) :-
    peek_code(10), !,
    skip_line.

readNumber(X, Acc) :-
    get_code(C),
    validDigit(C),
    Real is C - 48,
    Tmp is Acc * 10,
    Acc1 is Tmp + Real,
    readNumber(X, Acc1).

/**
 * readUntilBetween(+Min, +Max, -Value)
 *
 * Reads a number from input until the user inserts one between two values
 */
readUntilBetween(Min, Max, Value) :-
    format('Chose an option [~d-~d]: ', [Min, Max]),
    readNumber(Value),
    between(Min, Max, Value), !.

readUntilBetween(Min, Max, Value) :-
    format('Invalid option! Please choose between ~d and ~d~n', [Min, Max]),
    readUntilBetween(Min, Max, Value).
