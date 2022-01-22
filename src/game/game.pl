:-use_module(library(random)).

gameInit(BoardSize, P1-P2) :-
    initialState(BoardSize, GameState),
    displayGame(GameState),
    gameLoop(GameState, P1, P1-P2).

gameLoop(GameState, PlayerType, GameType) :-
    gameOver(GameState, Winner), !,
    congratulateWinner(Winner, PlayerType, GameType).

gameLoop(GameState, PlayerType, GameType) :-
    chooseMove(GameState, PlayerType, Move),
    move(GameState, Move, NewGameState), !,
    nextPlayer(PlayerType, NewPlayerType, GameType),
    displayGame(NewGameState),
    gameLoop(NewGameState, NewPlayerType, GameType).

gameLoop(GameState, PlayerType, GameType) :-
    nl, write('Invalid Move! Please try again'),
    nl, nl,
    gameLoop(GameState, PlayerType, GameType). % Ask for another move

chooseMove((Board, Player), p, Move) :-
    playerString(Player, PString),
    askTypeOfMove(PString, Num),
    boardDimensions(Board, LineNumber, ColumnNumber),
    chooseTypeOfMove(Num, LineNumber, ColumnNumber, Move).

chooseMove(GameState, Level, Move) :-
    validMoves(GameState, Moves),
    chooseMove(Level, GameState, Moves, Move).

chooseMove(e, _GameState, Moves, Move) :-
    random_select(Move, Moves, _Rest).

chooseMove(h, GameState, Moves, Move) :-
    setof(Value-Mv, NewState^( member(Mv, Moves),
        move(GameState, Mv, (NewBoard, Opponent)), write('move: '), write(Mv), nl,
        switchColor(Opponent, Player),
        evaluateBoard((NewBoard, Player), Value) ), [V-Move|_]),
    write('chosen: '), write(Move), write(' '), write(V), skip_line.

nextPlayer(p, p, p-p).
nextPlayer(p, Level, p-Level).
nextPlayer(Level, p, p-Level).

nextPlayer(Level1, Level2, Level1-Level2).
nextPlayer(Level2, Level1, Level1-Level2).

chooseTypeOfMove(0, LineNumber, ColumnNumber, Move) :- 
    askForBoardPosition(LineNumber, ColumnNumber, Move).

chooseTypeOfMove(1, LineNumber, ColumnNumber, (X, Y)-(X1, Y1)) :-
    askForBoardPosition(LineNumber, ColumnNumber, (X, Y)),
    askForDirection((XOffset, YOffset)),
    X1 is X + XOffset,
    Y1 is Y + YOffset.

playerString(w, 'White').
playerString(b, 'Black').
