/**
 * switchColor(?Player1, ?Player2)
*/
switchColor(w, b).
switchColor(b, w).

/**
 * first(+Tuple, -Elem)
*/
first(A-_, A).

/**
 * second(+Tuple, -Elem) 
*/
second(_-B, B).

/**
 * createLine(+N, +Color, -Line)
*/
createLine(N, Color, Line) :- createLine(N, Color, Line, []).
createLine(0, _, Acc, Acc).
createLine(N, Color, Line, Acc) :-
    N > 0,
    N1 is N - 1,
    append(Acc, [Color-e], Acc1),
    switchColor(Color, NextColor),
    createLine(N1, NextColor, Line, Acc1).

/**
 * createBoard(+N, -Board)
*/
createBoard(N, Board) :-
    %N >= 11,
    N =< 19,
    N mod 2 =:= 1, % N must be odd
    createBoard(N, Board, [], N, w).

createBoard(_, Acc, Acc, 0, _).
createBoard(N, Board, Acc, Counter, Color) :-
    Counter > 0,
    createLine(N, Color, Line),
    append(Acc, [Line], Acc1),
    C1 is Counter - 1,
    switchColor(Color, NextColor),
    createBoard(N, Board, Acc1, C1, NextColor).
