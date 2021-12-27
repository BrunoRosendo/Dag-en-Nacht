:-use_module(library(lists)).

replace(Idx, L1, Val, L2) :-
  length(L1, Length),
  Length > Idx,
  replace(Idx, L1, Val, L2, []).

replace(0, [_ | T], Val, L2, Acc) :-
  append(Acc, [Val], Acc1),
  append(Acc1, T, L2).

replace(Idx, [H | T], Val, L2, Acc) :-
  Idx > 0,
  append(Acc, [H], Acc1),
  Idx1 is Idx - 1,
  replace(Idx1, T, Val, L2, Acc1).
