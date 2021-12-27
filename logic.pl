:- consult('board.pl').

validatePlaceStone((Board, _), (X, Y)) :-
    getCell(Board, X, Y, Cell),
    color(Cell, b),
    state(Cell, e).

/**
 * placeStone(+GameState, +Move, -GameState)
 */
placeStone((Board, Player), (X, Y), (NewBoard, NextPlayer)) :-
    nth0(Y, Board, Line),
    nth0(X, Line, Cell),
    replace(X, Line, b-Player, LRes),
    replace(Y, Board, LRes, NewBoard),
    switchColor(Player, NextPlayer).


validateShiftStone((Board, Player), (X, Y), (NewX, NewY)) :-
    getCell(Board, X, Y, Cell),
    color(Cell, b), % Can only shift a stone on a black square
    state(Cell, Player), % Can only shift an owned stone

    isAdjacentOrthogonally(X, Y, NewX, NewY),

    getCell(Board, NewX, NewY, NewCell),
    color(NewCell, w), % Can only shift to a white square
    state(NewCell, e). % Can only shift to an empty cell

/**
 * shiftStone(+GameState, +Move, +Pos, -NewGameState)
 */
shiftStone((Board, Player), (X, Y), (NewX, NewY), (NewBoard, NextPlayer)) :-
    nth0(Y, Board, Line),

    replace(X, Line, b-e, Line1),
    replace(Y, Board, Line1, Board1),

    nth0(NewY, Board1, NewLine),

    replace(NewX, NewLine, w-Player, NewLine1),
    replace(NewY, Board1, NewLine1, NewBoard),
    switchColor(Player, NextPlayer).

/**
 * move(+GameState, +Move, -NewGameState)
 */
move(GameState, Move, NewGameState) :-
    validatePlaceStone(GameState, Move),
    placeStone(GameState, Move, NewGameState).

move(GameState, (X, Y), NewGameState) :-
    X1 is X - 1,
    validateShiftStone(GameState, (X, Y), (X1, Y)),
    % The position must be given by input. This is just a placeholder
    shiftStone(GameState, (X, Y), (X1, Y), NewGameState).
