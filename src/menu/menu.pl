:- consult('../io.pl').
:- consult('./menu_io.pl').

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

    readUntilBetweenAndOdd(11, 19, BoardSize),
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
    % TODO: random to choose black or white (probably on another module)
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
    displayInstructions,
    menuEmptyLine,

    menuFill, nl,
    write('Press Enter to go back to the Main Menu'),
    skip_line,
    fail. % Go back to menu
