:- consult('../io.pl').
:- consult('../utils.pl').

/*********************/
/****** INPUT *******/
/*******************/


/**
 * readUntilBetweenAndOdd(+Min, +Max, -Value)
 *
 * Reads a number from input until the user inserts an odd one between two values
 */
readUntilBetweenAndOdd(Min, Max, Value) :-
    format('Choose an odd number between ~d and ~d: ', [Min, Max]),
    readNumber(Value),
    betweenAndOdd(Min, Max, Value), !.

readUntilBetweenAndOdd(Min, Max, Value) :-
    write('Invalid option! Remember it has to be an odd number'),
    nl,
    readUntilBetweenAndOdd(Min, Max, Value).



/*********************/
/****** OUTPUT ******/
/*******************/


/**
 * menuTitle(+Title)
 *
 * Displays the menu's title, formatted with 75 chars of width
 */
menuTitle(Title) :-
    format('~n~`*t ~p ~`*t~75|~n', [Title]).


/**
 * menuOptionsHeader(+Options, +Captions)
 *
 * Displays the menu's options header, formatted with 75 chars of width
 * The two headers serve as descriptions for the options/captions
 */
menuOptionsHeader(Options, Captions) :-
    format('*~t~p~t~37+~t~p~t~37+~t*~75|~n', [Options, Captions]).


/**
 * menuEmptyLine/0
 *
 * Displays an empty line of the menu, formatted with 75 chars of width
 */
menuEmptyLine :-
    format('*~t*~75|~n', []).


/**
 * menuOption(+Option, +Caption)
 *
 * Displays a menu's option, formatted with 75 chars of width
 * Takes an option and the corresponding caption
 */
menuOption(Option, Caption) :-
    format('*~t~p~t~37|~t~p~t~37+~t*~75|~n', [Option, Caption]).


/**
 * menuTitle(+Title)
 *
 * Displays regular text in the menu, formatted with 75 chars of width
 */
menuText(Text) :-
    format('*~t~p~t*~75|~n', [Text]).


/**
 * menuFill/0
 *
 * Displays the filled line of the menu, formatted with 75 chars of width
 */
menuFill :-
    format('~`*t~75|~n', []).


/**
 * displayInstructions/0
 *
 * Displays the game's instructions
 */
displayInstructions :-
    menuText('------------------------ Game Board ------------------------'),
    menuEmptyLine,
    menuText('The board is an NxN squared board, where N is an'),
    menuText('odd number between 11 and 19. The board has a checkered'),
    menuText('pattern of black and white spaces, with the four'),
    menuText('corners all being white. It starts off empty.'),
    menuEmptyLine,

    menuText('------------------------ Gameplay ------------------------'),
    menuEmptyLine,
    menuText('The players are Black and White, with Black going first.'),
    menuText('Each has a supply of stones in their color.'),
    menuText('On each turn, a player can take one of the following actions:'),
    menuEmptyLine,
    menuText('->Drop a stone of his color onto a black square. A stone'),
    menuText('may never be placed in a white square.'),
    menuText('->Shift a stone of his color already on the board, in a black'),
    menuText('square, to an adjacent white square.'),
    menuEmptyLine,

    menuText('------------------------ How to Win ------------------------'),
    menuEmptyLine,
    menuText('The winner is the first player to get five of their stones in a row'),
    menuText('horizontally or vertically, or four stones in row diagonally on white'),
    menuText('spaces. Stones on black spaces cannot win with a diagonal line.').