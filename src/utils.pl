:-use_module(library(lists)).
:-use_module(library(between)).

/**
 * replace(+Idx, +L1, +Val, -L2)
 */
replace(Idx, L1, Val, L2) :-
    length(L1, Length),
    Length > Idx,
    replace(Idx, L1, Val, L2, []).

replace(0, [_ | T], Val, L2, Acc) :-
    append(Acc, [Val], Acc1),
    append(Acc1, T, L2), !.

replace(Idx, [H | T], Val, L2, Acc) :-
    Idx > 0,
    append(Acc, [H], Acc1),
    Idx1 is Idx - 1,
    replace(Idx1, T, Val, L2, Acc1).

/**
 * betweenAndEven(+Lower, +Upper, ?X)
 *
 * Generator/verifier of even numbers between lower and upper
 */
betweenAndEven(Lower, Upper, X) :-
    between(Lower, Upper, X),
    X mod 2 =:= 0.

/**
 * betweenAndOdd(+Lower, +Upper, ?X)
 *
 * Generator/verifier of odd numbers between lower and upper
 */
betweenAndOdd(Lower, Upper, X) :-
    between(Lower, Upper, X),
    X mod 2 =\= 0.


firstNletters(N, Letters) :-
    findall(Letter, isLetterAndBounded(Letter, N), Letters).

isLetterAndBounded(Letter, N) :-
    UpperBound is N+97-1, % code('a') = 97
    between(97, UpperBound, Code),
    char_code(Letter, Code).

isValidDirection(t).
isValidDirection(b).
isValidDirection(l).
isValidDirection(r).

directionToOffsets(t, 0, -1).
directionToOffsets(b, 0, 1).
directionToOffsets(l, -1, 0).
directionToOffsets(r, 1, 0).
