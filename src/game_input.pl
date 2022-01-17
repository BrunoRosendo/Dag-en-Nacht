:- consult('io.pl').
:- consult('utils.pl').

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

moveOption(Option, Caption) :-
    format('#|~t~p~t~5|~t~p~t~5+~t |#~10|~n', [Option, Caption]).

askTypeOfMove(Num) :-
    write('Moves:'), nl,
    moveOption(0, 'Place stone'), nl,
    moveOption(1, 'Shift stone'), nl,
    readUntilBetween(0, 1, Num),
    moveChoice(Num).

askForBoardPosition(X, Y, LineNumber, ColumnNumber) :-
    readUntilValidCol(ColumnNumber, X),
    readUntilValidRow(LineNumber, Y).

askForDirection(DirX, DirY) :-
    readUntilValidDir(Dir),
    directionToOffsets(Dir, DirX, DirY).

readUntilValidDir(Dir) :-
    write('Choose a direction [t (top), b (bottom), l (left), r (right)]: '), 
    get_char(Dir),
    skip_line,
    isValidDirection(Dir), !.

readUntilValidDir(Dir) :-
    write('Invalid direction! Please choose one of the following: t, b, l, r'), nl,
    readUntilValidDir(Dir).