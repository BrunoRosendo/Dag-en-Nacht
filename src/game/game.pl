:- consult('./game_io.pl').
:- consult('../logic.pl').

gameLoop(GameState, PlayerType, GameType) :-
    gameOver(GameState, Winner), !,
    congratulateWinner(Winner, PlayerType, GameType).

gameLoop(GameState, PlayerType, GameType) :-
    chooseMove(GameState, PlayerType, Move),
    move(GameState, Move, NewGameState),
    nextPlayer(PlayerType, NewPlayerType, GameType),
    displayGame(NewGameState, NewPlayerType),  % player type might not be needed
    gameLoop(NewGameState, NewPlayerType, GameType).

chooseMove((Board, Player), p, Move) :-
    playerString(Player, PString),
    askTypeOfMove(PString, Num),
    boardDimensions(Board, LineNumber, ColumnNumber),
    chooseTypeOfMove(Num, LineNumber, ColumnNumber, Move).

chooseMove(GameState, computer-Level, Move) :-
    validMoves(GameState, Moves),
    chooseMove(Level, GameState, Moves, Move).

nextPlayer(p, p, p-p).

nextPlayer(p, Level, p-Level).
nextPlayer(Level, p, p-Level).

nextPlayer(Level1, Level2, Level1-Level2).
nextPlayer(Level2, Level1, Level1-Level2).

chooseTypeOfMove(0, LineNumber, ColumnNumber, Move) :- 
    askForBoardPosition(LineNumber, ColumnNumber, Move).

chooseTypeOfMove(1, LineNumber, ColumnNumber, Pos-Dir) :-
    askForBoardPosition(LineNumber, ColumnNumber, Pos),
    askForDirection(Dir).

chooseMove(e, _GameState, Moves, Move):-
    random_select(Move, Moves, _Rest).

playerString(w, 'White').
playerString(b, 'Black').
