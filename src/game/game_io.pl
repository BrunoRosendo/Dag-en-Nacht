/**
 * moveOption(+Option, +Caption)
 *
 * Displays a player's move option
*/
moveOption(Option, Caption) :-
    format('   | ~p | ~p ~n', [Option, Caption]).


/**
 * printAskPlayer(+Player)
 *
 * Displays the player's turn message
*/
printAskPlayer(Player) :-
    format('>> Your turn, ~p <<~n~n', [Player]).

/**
 * readUntilValidDir(-Dir)
 *
 * Asks the user for a direction and reads it
*/
readUntilValidDir(Dir) :-
    write('Choose a direction [t (top), b (bottom), l (left), r (right)]: '), 
    get_char(Dir),
    skip_line,
    isValidDirection(Dir), !.


readUntilValidDir(Dir) :-
    write('Invalid direction! Please choose one of the following: t, b, l, r'), nl,
    readUntilValidDir(Dir).

/**
 * readUntilValidRow(+RowNumber, -Row)
 *
 * Asks the user for a row and reads it
*/
readUntilValidRow(RowNumber, Row) :-
    format('Choose a row [1-~d]: ', [RowNumber]),
    readNumber(Row1),
    Row is Row1-1,
    between(1, RowNumber, Row1), !.

readUntilValidRow(RowNumber, Row) :-
    format('Invalid row! Please choose one between 1 and ~d~n', [RowNumber]),
    readUntilValidRow(RowNumber, Row).


/**
 * readUntilValidCol(+ColumnNumber, -Col)
 *
 * Asks the user for a column and reads it
*/
readUntilValidCol(ColumnNumber, Col) :-
    LastLetterCode is ColumnNumber+65-1,
    char_code(LastLetter, LastLetterCode),
    format('Choose a column [A-~p]: ', [LastLetter]),
    get_char(Char),
    skip_line,
    char_code(Char, CharCode),
    Col is CharCode-65,
    isLetterAndBounded(Char, ColumnNumber), !.

readUntilValidCol(ColumnNumber, Col) :-
    LastLetterCode is ColumnNumber+65-1,
    char_code(LastLetter, LastLetterCode),
    format('Invalid column! Please choose one between A and ~p~n', [LastLetter]),
    readUntilValidCol(ColumnNumber, Col).


/**
 * askTypeOfMove(+Player, -Num)
 *
 * Asks the user for the type of his move
*/
askTypeOfMove(Player, Num) :-
    printAskPlayer(Player),
    moveOption(0, 'Place stone'), nl,
    moveOption(1, 'Shift stone'), nl,
    readUntilBetween(0, 1, Num).

/**
 * askForBoardPosition(+LineNumber, +ColumnNumber, Pos)
 *
 * Asks the user for a board position and reads it
*/
askForBoardPosition(LineNumber, ColumnNumber, (X, Y)) :-
    readUntilValidCol(ColumnNumber, X),
    readUntilValidRow(LineNumber, Y).

/**
 * askForDirection(-Direction)
 *
 * Asks the user for a directions reads it
*/
askForDirection((DirX, DirY)) :-
    readUntilValidDir(Dir),
    directionToOffsets(Dir, DirX, DirY).

/**
 * printInvalidMove/0
 *
 * Informs the user of an invalid move
*/
printInvalidMove :-
    nl, write('Invalid move.'), nl,
    write('Remember the rules and please try again'), nl, nl.

/**
 * congratulateWinner(+Winner)
 *
 * Congratulates the winner
*/
congratulateWinner(Winner) :-
    playerString(Winner, PString),
    write('Congratulations, '),
    write(PString),
    write('! You won the game!'), skip_line.

playerString(w, 'White').
playerString(b, 'Black').
