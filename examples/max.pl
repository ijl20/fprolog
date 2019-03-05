
fun max([X]) = X;
    max([X|L]) = max2(X,max(L)).

fun max2(X,Y) = if (X > Y) then X else Y.

max(L,N) :- N = max(L).

