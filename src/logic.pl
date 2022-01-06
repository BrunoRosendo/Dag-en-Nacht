:- consult('board.pl').

/**
 * validatePlaceStone(+GameState, +Move)
 */
validatePlaceStone((Board, _), (X, Y)) :-
    getCell(Board, X, Y, Cell),
    color(Cell, b), % Can only place a stone on black square
    state(Cell, e). % Can only place a stone on an empty square

/**
 * placeStone(+GameState, +Move, -GameState)
 */
placeStone((Board, Player), (X, Y), (NewBoard, NextPlayer)) :-
    replaceCell(Board, X, Y, b-Player, NewBoard),
    switchColor(Player, NextPlayer).

/**
 * validateShiftStone(+GameState, +Move)
 */
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
    replaceCell(Board, X, Y, b-e, Board1),
    replaceCell(Board1, NewX, NewY, w-Player, NewBoard),
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

gameOver(GameState, )