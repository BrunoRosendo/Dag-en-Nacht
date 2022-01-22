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
move(GameState, Move, NewGameState) :-
    validatePlaceStone(GameState, Move),
    placeStone(GameState, Move, NewGameState).

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
    checkWin(WhiteDiags, Player, 4). % White Diagonals


/**
 * initialState(+Size, -GameState)
 */
initialState(Size, (Board, b)) :- % Black always goes first
    createBoard(Size, Board).

validMoves(GameState, Moves):-
    findall(Move, move(GameState, Move, NewState), Moves).


/**
 * evaluateVector(+Vector, +Player, +WinNum, -Value)
 *
 * Evaluates a vector by counting how many pieces you need to place in order to win in that vector.
 * If the opponent is blocking, Value is WinNum + minimum number of pieces the opponent needs to take out
 */
evaluateVector(Vector, Player, WinNum, Value) :-
    evaluateVectorSimmetric(Vector, Player, WinNum, Max),
    Value is WinNum - Max.

/**
 * evaluateVectorSimmetric(+Vector, +Player, +WinNum, -Max)
 *
 * Simetric of the evaluateVector function, to ease calculations
 */
evaluateVectorSimmetric(Vector, Player, WinNum, Max) :-
    Min is 0 - WinNum,
    evaluateVectorSimmetric(Vector, Player, WinNum, Max, 0, Min).
evaluateVectorSimmetric(Vector, _, WinNum, Max, Before, Max) :-
    length(Vector, Len),
    Len is Before + WinNum - 1.

evaluateVectorSimmetric(Vector, Player, WinNum, Max, Before, CurMax) :-
    sublist(Vector, SubVector, Before, WinNum),
    countFreePieces(SubVector, Player, Num),
    max_member(NewMax, [CurMax, Num]),
    Before1 is Before + 1,
    evaluateVectorSimmetric(Vector, Player, WinNum, Max, Before1, NewMax).

/**
 * countFreePieces(+List, +Player, -Num)
 *
 * Counts the number of player owned pieces not interrupted by the opponent
 * If the opponent has pieces in the list, Num is the simmetric of the opponent's number of pieces
 */
countFreePieces(List, Player, Num) :-
    switchColor(Player, Opponent),
    member(Opponent, List),
    countOcurrences(List, Opponent, OpponentOcurrences),
    Num is 0 - OpponentOcurrences, !.

countFreePieces(List, Player, Num) :-
    countOcurrences(List, Player, Num), !.

/**
 * evaluateBoard(+State, -Value)
 *
 * The board is better with a smaller Value (0 is a win)
 */
evaluateBoard((Board, Player), Value) :-
    transpose(Board, Cols),
    % These 2 are separated because the win condition is different
    whiteDiagonals(Board, WhiteDiagsOptions),
    append(Board, Cols, LinearOptions),

    mapsublist(state, LinearOptions, Linear),
    mapsublist(state, WhiteDiagsOptions, WhiteDiags),

    % Player Side
    setof(Val, Vector^( member(Vector, Linear), evaluateVector(Vector, Player, 5, Val) ), [ValueLinear|_]),
    setof(Val, Vector^( member(Vector, WhiteDiags), evaluateVector(Vector, Player, 4, Val) ), [ValueDiag|_]),
    min_member(PlayerValue, [ValueDiag, ValueLinear]),

    % Opponent Side
    switchColor(Player, Opponent),
    setof(Val, Vector^( member(Vector, Linear), evaluateVector(Vector, Opponent, 5, Val) ), OppLinearList),
    setof(Val, Vector^( member(Vector, WhiteDiags), evaluateVector(Vector, Opponent, 4, Val) ), OppDiagList),
    append(OppLinearList, OppDiagList, OpponentList),
    min_member(OpponentValue, OpponentList),

    overallValue(PlayerValue, OpponentValue, Value),
    write('value: '), write(Value), skip_line.

overallValue(0, _, 0). % win
overallValue(PlayerValue, OpponentValue, Value) :-
    PlayerValue >= OpponentValue, % bad position, block opponent instead
    Value is 20 - OpponentValue.

overallValue(PlayerValue, OpponentValue, Value) :-
    PlayerValue < OpponentValue, % good position, play for yourself
    Value is PlayerValue + OpponentValue. % It's still better to block opponent if possible
