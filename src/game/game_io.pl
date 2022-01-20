:- consult('../io.pl').
:- consult('../utils.pl').


moveOption(Option, Caption) :-
    format('   | ~p | ~p ~n', [Option, Caption]).


printAskPlayer(Player) :-
    format('>> Your turn, ~p <<~n~n', [Player]).


readUntilValidDir(Dir) :-
    write('Choose a direction [t (top), b (bottom), l (left), r (right)]: '), 
    get_char(Dir),
    skip_line,
    isValidDirection(Dir), !.


readUntilValidDir(Dir) :-
    write('Invalid direction! Please choose one of the following: t, b, l, r'), nl,
    readUntilValidDir(Dir).


readUntilValidRow(RowNumber, Row) :-
    format('Choose a row [1-~d]: ', [RowNumber]),
    readNumber(Row1),
    Row is Row1-1,
    between(1, RowNumber, Row1), !.

readUntilValidRow(RowNumber, Row) :-
    format('Invalid row! Please choose one between 1 and ~d~n', [RowNumber]),
    readUntilValidRow(RowNumber, Row).


readUntilValidCol(ColumnNumber, Col) :-
    LastLetterCode is ColumnNumber+97-1,
    char_code(LastLetter, LastLetterCode),
    format('Choose a column [a-~p]: ', [LastLetter]),
    get_char(Char),
    skip_line,
    char_code(Char, CharCode),
    Col is CharCode-97,
    isLetterAndBounded(Char, ColumnNumber), !.

readUntilValidCol(ColumnNumber, Col) :-
    LastLetterCode is ColumnNumber+97-1,
    char_code(LastLetter, LastLetterCode),
    format('Invalid column! Please choose one between a and ~p~n', [LastLetter]),
    readUntilValidCol(ColumnNumber, Col).


askTypeOfMove(Player, Num) :-
    printAskPlayer(Player),
    moveOption(0, 'Place stone'), nl,
    moveOption(1, 'Shift stone'), nl,
    readUntilBetween(0, 1, Num).


askForBoardPosition(LineNumber, ColumnNumber, (X, Y)) :-
    readUntilValidCol(ColumnNumber, X),
    readUntilValidRow(LineNumber, Y).



askForDirection((DirX, DirY)) :-
    readUntilValidDir(Dir),
    directionToOffsets(Dir, DirX, DirY).