
:- main([o_utils]).

a(X) :- b(X), c(X).
b(X) :- e(X).
c(1).
e(X) :- f(X).
e(X) :- g(X).
f(2).
g(1).

o_query :- a(X), o_send_soln(X).




