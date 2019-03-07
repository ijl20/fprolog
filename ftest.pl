
% fprolog test script

fprolog_test :- nl, [fprolog] -> print('fprolog loaded ok') ; print('fprolog load FAILED').

fconsult_test :- nl, fconsult('examples/max.pl') -> print('max.pl consulted ok') ; print('max.pl consult FAILED').

max_test :- nl, max([1,6,3,7,5,6,3],7) -> print('max() test ok') ; print('max() test FAILED').

ftest :- fprolog_test, fconsult_test, max_test.

:- initialization(ftest).


