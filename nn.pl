:- module(_, _, [classic, assertions]).
%:- use_package(trace).

% P01 (*) Find the last element of a list.
my_last(H, [H]).
my_last(X, [_|T]) :- my_last(X, T).

% P02 (*) Find the last but one element of a list.
my_last_but_one(H, [H, _ ]).
my_last_but_one(X, [_ | T]) :- my_last_but_one(X, T).

% P03 (*) Find the K'th element of a list. 
element_at(H, [H | _], 1).
element_at(X, [_ | T], Y) :- Z is Y-1, element_at(X, T, Z).

% P04 (*) Find the number of elements of a list.
size(0, []).
size(X, [_|T]) :- size(Y, T), X is Y+1.

% P05 (*) Reverse a list.
my_reverse(X, L) :- my_reverse_aux(X, L, []).
my_reverse_aux(X, [], X).
my_reverse_aux(X, [H|T], Y) :- my_reverse_aux(X, T, [H|Y]).

% P06 (*) Find out whether a list is a palindrome. 
palindrome(L) :- my_reverse(L, L).

% P07 (**) Flatten a nested list structure.
my_flatten([], []).
my_flatten([H|T1], [H|T2]) :- \+ list(H), my_flatten(T1, T2).
my_flatten([H|T1], L) :- my_flatten(H, R1), my_flatten(T1, R2), append(R1, R2, L).

% P08 (**) Eliminate consecutive duplicates of list elements.
compress([], []).
compress([H], [H]).
compress([H,H|T], X) :- compress([H|T], X).
compress([H,I|T], [H|X]) :- H \= I, compress([I|T], X).

% P09 (**) Pack consecutive duplicates of list elements into sublists.
pack([], []).
pack([H], [[H]]).
pack([H,H|T], [[H|T1]|T2]) :- pack([H|T], [T1|T2]).
pack([H,I|T], [[H]|T1]) :- H \= I, pack([I|T], T1).

% P10 (*) Run-length encoding of a list.
encode(L, R) :- pack(L, R1), encode_aux(R1, R).
encode_aux([], []).
encode_aux([[Elem|T]|T1], [[Len, Elem]|T2]) :- length([Elem|T], Len), encode_aux(T1, T2).

% P11 (*) Modified run-length encoding.
encode_modified(L, R) :- pack(L, R1), encode_modified_aux(R1, R).
encode_modified_aux([], []).
encode_modified_aux([[E]|T1], [E|T2]) :- encode_modified_aux(T1, T2).
encode_modified_aux([[E1,E2|T]|T1], [[Len, E1]|T2]) :- length([E1,E2|T], Len), encode_modified_aux(T1, T2).

% P12 (**) Decode a run-length encoded list.
decode([], []).
decode([E|T], [E|R]) :- \+ list(E), decode(T, R).
decode([[1,E]|T], [E|R]) :- decode(T, R).
decode([[Len,E]|T], [E|R]) :- Len > 1, NewLen is Len-1, decode([[NewLen,E]|T], R).

% P13 (**) Run-length encoding of a list (direct solution).
encode_direct(L, R) :- encode_direct_aux(L, R, 1).
encode_direct_aux([], [], _).
encode_direct_aux([H], [H], 1).
encode_direct_aux([H], [[N, H]], N) :- N > 1.
encode_direct_aux([H,H|T], R, N) :- NewN is N+1, encode_direct_aux([H|T], R, NewN).
encode_direct_aux([H,I|T], [H|R], 1) :- H \= I, encode_direct_aux([I|T], R, 1).
encode_direct_aux([H,I|T], [[N,H]|R], N) :- H \= I, N > 1, encode_direct_aux([I|T], R, 1).

% P14 (*) Duplicate the elements of a list.
dupli([], []).
dupli([H|T], [H,H|R]) :- dupli(T, R).

% P15 (**) Duplicate the elements of a list a given number of times.
dupli2(L, N, R) :- dupli2_aux(L, N, R, N).
dupli2_aux([], _, [], _).
dupli2_aux([H|T], N, [H|R], 1) :- dupli2_aux(T, N, R, N).
dupli2_aux([H|T], N, [H|R], Ncur) :- Ncur > 1, NewN is Ncur-1, dupli2_aux([H|T], N, R, NewN).

% P16 (**) Drop every N'th element from a list.
drop(L, N, R) :- drop_aux(L, N, R, N).
drop_aux([], _, [], _).
drop_aux([_|T], N, R, 1) :- drop_aux(T, N, R, N).
drop_aux([H|T], N, [H|R], Ncur) :- Ncur > 1, NewN is Ncur-1, drop_aux(T, N, R, NewN).

% P17 (*) Split a list into two parts; the length of the first part is given.
split(L, 0, [], L).
split([H|T], N, [H|R1], R2) :- N > 0, NewN is N-1, split(T, NewN, R1, R2).

% P18 (**) Extract a slice from a list.
slice([H|_], 1, 1, [H]).
slice([H|T], 1, To, [H|R]) :- To > 1, NewTo is To-1, slice(T, 1, NewTo, R).
slice([_|T], From, To, R) :- From > 1, NewFrom is From-1, NewTo is To-1, slice(T, NewFrom, NewTo, R).

% P19 (**) Rotate a list N places to the left.
rotate(L, N, R) :- length(L, Len), Nsplit is (N mod Len), split(L, Nsplit, R1, R2), append(R2, R1, R).

% P20 (*) Remove the K'th element from a list.
remove_at(H, [H|T], 1, T).
remove_at(X, [H|T], N, [H|R]) :- N > 1, NewN is N-1, remove_at(X, T, NewN, R).









