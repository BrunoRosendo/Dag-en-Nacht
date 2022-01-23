/**
 * displayGame(+GameState)
 *
 * Displays a given game state
*/
displayGame((Board, Player)) :-
    boardDimensions(Board, LineNumber, ColumnNumber),
    clear,
    displayColumns(ColumnNumber),
    displayBoard(Board, LineNumber, ColumnNumber).

/**
 * displayColumns(+N)
 *
 * Displays the header for the columns
*/
displayColumns(N) :-
    headerBorder(N),
    write('      |'),
    displayColumns(N, 0),
    headerBorder(N),
    nl.

displayColumns(N, N) :- nl, !.
displayColumns(N, Acc) :-
    Code is Acc + 65,
    char_code(C, Code),
    write(' '), write(C), write(' |'),
    Acc1 is Acc + 1,
    displayColumns(N, Acc1).

/**
 * displayBoard(+Board, +Lines, +Cols)
 *
 * Displays the main board of the game
*/
displayBoard(Board, Lines, Cols) :-
    boardDelimiter(Cols),
    displayLines(Board, Lines, Cols, 1),
    boardDelimiter(Cols), nl.

/**
 * displayLines(+Board, +Lines, +Cols, +Acc)
 *
 * Displays the lines of the game board
*/
displayLines(Board, Lines, Cols, Lines) :-
    boardLine(Board, Lines, Cols), !.

displayLines(Board, Lines, Cols, Acc) :-
    boardLine(Board, Acc, Cols),
    boardDelimiter(Cols),
    Acc1 is Acc + 1,
    displayLines(Board, Lines, Cols, Acc1).

/**
 * boardLine(+Board, +Line, +Cols)
 *
 * Displays a line of the game board
*/
boardLine(Board, Line, Cols) :-
    format('~t~d~t~3||', [Line]),
    write('  |'),

    LineIdx is Line - 1,
    boardLine(Board, LineIdx, Cols, 0).

boardLine(Board, LineIdx, Cols, Cols) :- nl, !.
boardLine(Board, LineIdx, Cols, Acc) :-
    getCell(Board, Acc, LineIdx, (Color-Player)),
    cellSymbol(Color, Player, Symbol),
    printCell(Color, Symbol),
    Acc1 is Acc + 1,
    boardLine(Board, LineIdx, Cols, Acc1).

/**
 * printCell(+Color, +Symbol)
 *
 * Displays a cell of the game board
*/
printCell(b, Symbol) :- format('#~p#|', [Symbol]).
printCell(w, Symbol) :- format(' ~p |', [Symbol]).

/**
 * boardDelimiter(+Cols)
 *
 * Displays a delimiter of the game board
*/
boardDelimiter(Cols) :-
    write('---|  |'),
    boardDelimiter(Cols, 1).

boardDelimiter(Cols, Cols) :- write('---|'), nl, !.
boardDelimiter(Cols, Acc) :-
    write('---+'),
    Acc1 is Acc + 1,
    boardDelimiter(Cols, Acc1).

/**
 * boardDelimiter(+Cols)
 *
 * Displays the border for a header (e.g. columns)
*/
headerBorder(N) :-
    write('      |'),
    headerBorder(N, 1).

headerBorder(N, N) :- write('---|'), nl, !.
headerBorder(N, Acc) :-
    write('---+'),
    Acc1 is Acc + 1,
    headerBorder(N, Acc1).

/**
 * cellSymbol(+Color, +Player, -Char)
 */
cellSymbol(_, w, 'w').
cellSymbol(_, b, 'b').
cellSymbol(w, e, ' ').
cellSymbol(b, e, '#').

/**
 * displayBotMove(+Move, +Player)
 *
 * Displays information about the bot's move
*/
displayBotMove((X, Y), Player) :-
    playerString(Player, PString),
    write(PString),
    write(' chose to place a stone in the cell '),
    Col is X + 65, put_code(Col),
    write('-'), Row is Y + 1, write(Row),
    skip_line, !.

displayBotMove((X, Y)-(X1, Y1), Player) :-
    playerString(Player, PString),
    write(PString),
    write(' chose to shift a stone from the cell '),
    Col is X + 65, put_code(Col),
    write('-'), Row is Y + 1, write(Row),
    write(' to '),
    Col1 is X1 + 65, put_code(Col1),
    write('-'), Row1 is Y1 + 1, write(Row1),
    skip_line, !.
