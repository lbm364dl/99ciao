:- module(_, _, [classic, assertions]).
:- use_module(library(random)).
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

% P21 (*) Insert an element at a given position into a list.
insert_at(X, L, N, R) :- remove_at(X, R, N, L).

% P22 (*) Create a list containing all integers within a given range.
range(Right, Right, [Right]).
range(Left, Right, [Left|R]) :- Left < Right, NewLeft is Left+1, range(NewLeft, Right, R).

% P23 (**) Extract a given number of randomly selected elements from a list.
rnd_select(L, N, R) :- length(L, Len), rnd_select_aux(L, N, Len, R).
rnd_select_aux(_, 0, _, []).
rnd_select_aux(L, N, Len, [E|R]) :- 
	N > 0, 
	random(1, Len, Rand),
	remove_at(E, L, Rand, NewL), 
	NewN is N-1,
	NewLen is Len-1,
	rnd_select_aux(NewL, NewN, NewLen, R).

% P24 (*) Lotto: Draw N different random numbers from the set 1..M.
rnd_select2(N, Top, R) :- range(1, Top, L), rnd_select(L, N, R).

% Using Ciao predicate random/3
rnd_select3(0, _, []).
rnd_select3(N, Top, [Rand|R]) :- N > 0, random(1, Top, Rand), NewN is N-1, rnd_select3(NewN, Top, R).

% P25 (*) Generate a random permutation of the elements of a list.
rnd_permu(L, R) :- length(L, Len), rnd_select(L, Len, R).

% P26 (**) Generate the combinations of K distinct objects chosen from the N elements of a list
combination(0, _, []).
combination(N, [H|T], [H|R]) :- N > 0, NewN is N-1, combination(NewN, T, R).
combination(N, [_|T], R) :- N > 0, combination(N, T, R).

% P27 (**) Group the elements of a set into disjoint subsets.
group([], [], []).
group(L, [H|T], [G|Gs]) :- comb_n_rest(H, L, G, R), group(R, T, Gs).

comb_n_rest(0, L, [], L).
comb_n_rest(N, [H|T], [H|C], R) :- N > 0, NewN is N-1, comb_n_rest(NewN, T, C, R).
comb_n_rest(N, [H|T], C, [H|R]) :- N > 0, comb_n_rest(N, T, C, R).

% P28 (**) Sorting a list of lists according to length of sublists
% Quicksort
% a)
lsort(L, R) :- lsort_aux(L, R-[]).
lsort_aux([], X-X).
lsort_aux([H|T], RR1-X) :- length(H, Len), divide(T, Len, R1, R2), lsort_aux(R1, RR1-[H|RR2]), lsort_aux(R2, RR2-X). 

divide([], _, [], []).
divide([H|T], Len, R1, R2) :- length(H, Len2), place(H, Len, Len2, T, R1, R2).

place(H, Len, Len2, T, [H|R1], R2) :- Len2 =< Len, divide(T, Len, R1, R2).
place(H, Len, Len2, T, R1, [H|R2]) :- Len2 > Len, divide(T, Len, R1, R2).

% b)
:- dynamic occs/2.

lfsort(L, R) :- count_occs(L), lfsort_aux(L, R-[]), retractall(occs(X,Y)).
count_occs([]).
count_occs([H|T]) :- length(H, Len), \+ occs(Len, Occ), assert(occs(Len, 1)), count_occs(T).
count_occs([H|T]) :- length(H, Len), occs(Len, Occ), NewOcc is Occ+1, retract(occs(Len, Occ)), assert(occs(Len, NewOcc)), count_occs(T).

lfsort_aux([], X-X).
lfsort_aux([H|T], RR1-X) :- length(H, Len), occs(Len, Occ), divide2(T, Occ, R1, R2), lfsort_aux(R1, RR1-[H|RR2]), lfsort_aux(R2, RR2-X). 

divide2([], _, [], []).
divide2([H|T], Occ, R1, R2) :- length(H, Len2), occs(Len2, Occ2), place2(H, Occ, Occ2, T, R1, R2).

place2(H, Len, Len2, T, [H|R1], R2) :- Len2 =< Len, divide2(T, Len, R1, R2).
place2(H, Len, Len2, T, R1, [H|R2]) :- Len2 > Len, divide2(T, Len, R1, R2).


