:- consult('io.pl').

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
 * menuBottom/0
 *
 * Displays the bottom line of the menu, formatted with 75 chars of width
 */
menuBottom :-
    format('~`*t~75|~n', []).

/**
 * mainMenu/0
 *
 * Displays the main menu of the game
 */
mainMenu :-
    clear,
    menuTitle('Main Menu'),
    menuEmptyLine,
    menuOptionsHeader('Options', 'Description'),
    menuEmptyLine,
    menuOption(1, 'Player vs Player'),
    menuOption(2, 'Player vs Computer'),
    menuOption(3, 'Computer vs Computer'),
    menuOption(4, 'Instructions'),
    menuEmptyLine,
    menuOption(0, 'Exit Game'),
    menuEmptyLine,
    menuBottom.
