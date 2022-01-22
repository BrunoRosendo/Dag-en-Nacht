% Necessary consults
:- consult('utils.pl').
:- consult('io.pl').

:- consult('board/board.pl').
:- consult('board/logic.pl').

:- consult('game/game_io.pl').
:- consult('game/display.pl').
:- consult('game/game.pl').

:- consult('menu/menu_io.pl').
:- consult('menu/menu.pl').

play :- mainMenu.
