:- consult('board.pl').

/**
 * validatePlaceStone(+GameState, +Pos)
 */
validatePlaceStone((Board, _), (X, Y)) :-
    getCell(Board, X, Y, Cell),
    color(Cell, b), % Can only place a stone on black square
    state(Cell, e). % Can only place a stone on an empty square

/**
 * placeStone(+GameState, +Pos, -NewGameState)
 */
placeStone((Board, Player), (X, Y), (NewBoard, NextPlayer)) :-
    replaceCell(Board, X, Y, b-Player, NewBoard),
    switchColor(Player, NextPlayer).

/**
 * validateShiftStone(+GameState, +Pos, +NewPos)
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
 * shiftStone(+GameState, +Pos, +NewPos, -NewGameState)
 */
shiftStone((Board, Player), (X, Y), (NewX, NewY), (NewBoard, NextPlayer)) :-
    replaceCell(Board, X, Y, b-e, Board1),
    replaceCell(Board1, NewX, NewY, w-Player, NewBoard),
    switchColor(Player, NextPlayer).

/**
 * move(+GameState, +Move, -NewGameState)
 */
move(GameState, (X, Y), NewGameState) :-
    validatePlaceStone(GameState, Move),
    placeStone(GameState, (X, Y), NewGameState).

move(GameState, (X, Y)-(X1, Y1), NewGameState) :-
    validateShiftStone(GameState, (X, Y), (X1, Y1)),
    shiftStone(GameState, (X, Y), (X1, Y1), NewGameState).

/**
 * checkWin(+Vectors, +Player, +NumPieces)
 *
 * Check if the player won, by analyzing the list of vectors
 * A vector is either a row, line or diagonal
 */
checkWin(Vectors, Player, NumPieces) :- 
    getWinCondition(Player, NumPieces, WinCondition),
    checkWin(Vectors, WinCondition).

checkWin([Vector | T], WinCondition) :-
    sublist(Vector, WinCondition, _), ! ;
    checkWin(T, WinCondition).


/**
 * getWinCondition(+Player, +NumPieces, -WinCondition)
 *
 * Generates a win condition (list of player-owned cells) with the given number of pieces
 */
getWinCondition(Player, NumPieces, WinCondition) :- getWinCondition(Player, NumPieces, WinCondition, []).
getWinCondition(_, 0, WinCondition, WinCondition) :- !.
getWinCondition(Player, NumPieces, WinCondition, Acc) :-
    append(Acc, [_-Player], Acc1),
    NumPieces1 is NumPieces - 1,
    getWinCondition(Player, NumPieces1, WinCondition, Acc1).

/**
 * gameOver(+GameState, -Winner)
 */
gameOver((Board,Player), Player) :-
    transpose(Board, Cols),
    checkWin(Cols, Player, 5). % Columns

gameOver((Board,Player), Player) :-
    checkWin(Board, Player, 5).  % Rows

gameOver((Board,Player), Player) :-
    whiteDiagonals(Board, WhiteDiags),
    checkWin(whiteDiags, Player, 4). % White Diagonals


/**
 * initialState(+Size, -GameState)
 */
initialState(Size, (Board, b)) :- % Black always goes first
    createBoard(Size, Board).
