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
 * mainMenu/0
 *
 * Displays the main menu of the game
 */
mainMenu :-
    repeat, % Coming back to the menu
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
    menuFill, nl,

    readUntilBetween(0, 4, Num),
    mainMenuChoice(Num).

/**
 * mainMenuChoice(+Choice)
 *
 * Processes a choice made on the main menu
 */
mainMenuChoice(0) :- exitGame.
mainMenuChoice(1) :- startGame(p-p). % Player vs Player
mainMenuChoice(2) :- pcGame. % Player vs Computer
mainMenuChoice(3) :- ccGame. % Computer vs Computer
mainMenuChoice(4) :- instructions.

/**
 * startGame(+Type)
 *
 * Starts game of the given Type
 *
 * Type -> p-p, p-[e,h] or [e,h]-[e,h]
 * p = player, e = easy bot, h = hard bot
 */
startGame(Type) :-
    clear,
    menuTitle('Board Size'),
    menuEmptyLine,
    menuText('Choose a size for the Game Board (NxN)'),
    menuEmptyLine,
    menuFill, nl,

    readUntilBetweenAndOdd(11, 19, Num),
    % TODO: call initial state and game loop (not in input.pl)
    fail. % Go back to menu

/**
 * difficultyMap(+Num, -Difficulty)
 *
 * Maps a number to the respective difficulty
 */
difficultyMap(1, e).
difficultyMap(2, h).

/**
 * pcGame/0
 *
 * Starts a game between a player and the computer
 * Asks the user to choose the difficulty and board size first
 */
pcGame :-
    chooseDifficulty('Choose the difficulty for your opponent', Choice),
    startGame(p-Choice).

/**
 * pcGame/0
 *
 * Starts a game between two computers
 * Asks the user to choose the difficulty of each PC and board size first
 */
ccGame :-
    chooseDifficulty('Choose the difficulty for computer 1', Choice1),
    chooseDifficulty('Choose the difficulty for computer 2', Choice2),
    startGame(Choice1-Choice2).

/**
 * chooseDifficulty(+Text, -Choice)
 *
 * Asks the user to choose a difficulty for the computer
 *
 * Text -> text explaining which computer's difficulty he's choosing
 */
chooseDifficulty(Text, Choice) :-
    clear,
    menuTitle('Choose Difficulty'),
    menuEmptyLine,

    menuText(Text),
    menuEmptyLine,
    menuOptionsHeader('Options', 'Description'),
    menuEmptyLine,

    menuOption(1, 'Easy (Random)'),
    menuOption(2, 'Hard (Greedy)'),
    menuEmptyLine,

    menuFill, nl,
    readUntilBetween(1, 2, Num),
    difficultyMap(Num, Choice).

exitGame :-
    clear, nl,
    menuFill,
    menuText('Thanks for playing!'),
    menuFill.

instructions :-
    clear,
    menuTitle('Instructions'),
    menuEmptyLine,

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
    menuText('spaces. Stones on black spaces cannot win with a diagonal line.'),
    menuEmptyLine,

    menuFill, nl,
    write('Press Enter to go back to the Main Menu'),
    skip_line,
    fail. % Go back to menu
