:- consult('utils.pl').

/**
 * switchColor(?Player1, ?Player2)
*/
switchColor(w, b).
switchColor(b, w).

/**
 * color(+Cell, -Elem)
 * Gets the color of the cell
*/
color(A-_, A).

/**
 * state(+Cell, -Elem) 
 * Gets the state of the cell (empty or either of the players)
*/
state(_-B, B).

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
    N >= 11,
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


/**
 * inBounds(+Board, +X, +Y)
*/
inBounds(Board, X, Y) :-
    length(Board, LineNumber),
    nth0(0, Board, Line),
    length(Line, ColumnNumber),
    X >= 0,
    Y >= 0,
    X < ColumnNumber,
    Y < LineNumber.

/**
 * getCell(+Board, +X, +Y, -Cell)
*/
getCell(Board, X, Y, Cell) :-
    inBounds(Board, X, Y),
    nth0(Y, Board, Line),
    nth0(X, Line, Cell).

replaceCell(Board, X, Y, NewCell, NewBoard) :-
    nth0(Y, Board, Line),
    replace(X, Line, NewCell, NewLine),
    replace(Y, Board, NewLine, NewBoard).

/**
 * isAdjacentOrthogonally(+X1, +Y1, +X2, +Y2)
*/
isAdjacentOrthogonally(X1, Y, X2, Y) :- X2 =:= X1 + 1.
isAdjacentOrthogonally(X1, Y, X2, Y) :- X2 =:= X1 - 1.
isAdjacentOrthogonally(X, Y1, X, Y2) :- Y2 =:= Y1 + 1.
isAdjacentOrthogonally(X, Y1, X, Y2) :- Y2 =:= Y1 - 1.

/**
 * boardDimensions(+Board, -LineNumber, -ColumnNumber)
*/
boardDimensions(Board, LineNumber, ColumnNumber) :-
    length(Board, LineNumber),
    nth0(0, Board, Line),
    length(Line, ColumnNumber).

/**
 * diagonal(+Board, +X, +Y, +XBound, +YBound, +YStep, -Diag)
 * Gets a diagonal starting at (X, Y) and ending at XBound or YBound
 * The slope is defined by the YStep
*/
diagonal(Board, X, Y, XBound, YBound, YStep, Diag) :-
    diagonal(Board, X, Y, XBound, YBound, YStep, Diag, []).

diagonal(Board, X, Y, XBound, YBound, YStep, Diag, Acc) :-
    getCell(Board, X, Y, Cell),
    append(Acc, [Cell], Acc1),
    NewY is Y+YStep,
    NewX is X+1,
    diagonal(Board, NewX, NewY, XBound, YBound, YStep, Diag, Acc1).

diagonal(Board, XBound, Y, XBound, _, _, Diag, Acc) :- 
    getCell(Board, XBound, Y, Cell),
    append(Acc, [Cell], Diag), !.

diagonal(Board, X, YBound, _, YBound, _, Diag, Acc) :- 
    getCell(Board, X, YBound, Cell),
    append(Acc, [Cell], Diag), !.

/**
 * posSlopeDiagonal(+Board, +X, +Y, Diag)
*/
posSlopeDiagonal(Board, X, Y, Diag) :-
    boardDimensions(Board, _, ColumnNumber),
    XBound is ColumnNumber - 1,
    diagonal(Board, X, Y, XBound, 0, -1, Diag).

/**
 * negSlopeDiagonal(+Board, +X, +Y, Diag)
*/
negSlopeDiagonal(Board, X, Y, Diag) :-
    boardDimensions(Board, LineNumber, ColumnNumber),
    XBound is ColumnNumber - 1,
    YBound is LineNumber - 1, 
    diagonal(Board, X, Y, XBound, YBound, 1, Diag).

/**
 * whiteDiagonals(+Board, -Diags)
 * Gets all the board's white diagonals
*/
whiteDiagonals(Board, Diags) :-
    boardDimensions(Board, RowNumber, ColumnNumber),

    upperAndLeftCoords(ColumnNumber, RowNumber, DescCoords),
    lowerAndLeftCoords(ColumnNumber, RowNumber, AscCoords),

    diagonalsByCoords(Board, DescCoords, desc, DescDiags),
    diagonalsByCoords(Board, AscCoords, asc, AscDiags),

    append(DescDiags, AscDiags, Diags).

/**
 * 
 * Gets a list of diagonals, given the list of starting coordinates
*/

diagonalsByCoords(Board, Coords, Direction, Diags) :- diagonalsByCoords(Board, Coords, Direction, Diags, []).
diagonalsByCoords(_, [], _, Acc, Acc).

% Descending diagonals
diagonalsByCoords(Board, [(X, Y) | T], desc, Diags, Acc) :-
    negSlopeDiagonal(Board, X, Y, Diagonal),
    append(Acc, [Diagonal], Acc1),
    diagonalsByCoords(Board, T, desc, Diags, Acc1).

% Ascending diagonals
diagonalsByCoords(Board, [(X, Y) | T], asc, Diags, Acc) :-
    posSlopeDiagonal(Board, X, Y, Diagonal),
    append(Acc, [Diagonal], Acc1),
    diagonalsByCoords(Board, T, asc, Diags, Acc1).


/**
 * upperAndLeftCoords(+ColumnNumber, +RowNumber, -Coords)
 * Gets the coordinates of the upper row and left column cells
*/
upperAndLeftCoords(ColumnNumber, RowNumber, Coords) :-
    UpperX is ColumnNumber-1,
    UpperY is RowNumber-1,
    bagof((X, 0), betweenAndEven(0, UpperX, X), UpperRow), 
    bagof((0, Y), betweenAndEven(2, UpperY, Y), LeftColumn),
    append(UpperRow, LeftColumn, Coords).

/**
 * lowerAndLeftCoords(+ColumnNumber, +RowNumber, -Coords)
 * Gets the coordinates of the lower row and left column cells
*/
lowerAndLeftCoords(ColumnNumber, RowNumber, Coords) :-
    UpperX is ColumnNumber-1,
    UpperY is RowNumber-1,
    bagof((X, UpperY), betweenAndEven(2, UpperX, X), LowerRow), 
    bagof((0, Y), betweenAndEven(0, UpperY, Y), LeftColumn),
    append(LowerRow, LeftColumn, Coords).
