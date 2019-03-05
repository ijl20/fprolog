  
/***************************************************************************/
/* f_utils: utility relations for function processing                      */
/***************************************************************************/

% 2019-03-05 syntax fixes for swipl
% 2018-07-25 syntax fixes for gprolog
% 1997-06-05 original file from ijl20 PhD - designed to work with wamcc Prolog  compiler

/* function application operator - also defined in wamcc_fcode.pl */

:- op(600,yfx,@).

/* 'fun' operator, and 'if..then..else' operators */

:- op(675,fx,if).
:- op(650,xfx,then).
:- op(625,xfx,else).

:- op(1200,fx,fun).

:- public(fmangle/2).

/***************************************************************************/
/* GLOBAL: def_fun: used to record functor status as defined function      */
/*                  used in wamcc_fcode                                    */

:- initialization(assign_global_var(def_funs, [=,+,-,*,/,<,>,=<,>=,=..,if])).

/***************************************************************************/
/* Utility functions                                                       */

assign_global_var(Atom,Value) :- /* if */ current_predicate(nb_setval/_) ->
                                 /* then */ nb_setval(Atom,Value);
                                 /* else */ g_assign(Atom,Value).

read_global_var(Atom,Value) :- /* if */ current_predicate(nb_setval/_) ->
                                 /* then */ nb_getval(Atom,Value);
                                 /* else */ g_read(Atom,Value).



/***************************************************************************/

:- public( [ '$fun_='/2, 
             '$fun_+'/2, 
             '$fun_-'/2, 
             '$fun_*'/2,
             '$fun_/'/2,
             '$fun_<'/2,
             '$fun_>'/2,
             '$fun_=<'/2,
             '$fun_>='/2,
             '$fun_=..'/2 ]).

/***************************************************************************/
/* Various pre-defined functions in fprolog relational format              */

'$fun_='([X,X],true) :- !.
'$fun_='(_, false).

'$fun_+'([X,Y],Z) :- Z is X + Y, !.
'$fun_+'(PartArgs,lambda(RemArgs,'$fun_+'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_-'([X,Y],Z) :- Z is X - Y, !.
'$fun_-'(PartArgs,lambda(RemArgs,'$fun_-'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_*'([X,Y],Z) :- Z is X * Y, !.
'$fun_*'(PartArgs,lambda(RemArgs,'$fun_*'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_/'([X,Y],Z) :- Z is X // Y, !.
'$fun_/'(PartArgs,lambda(RemArgs,'$fun_/'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_<'([X,Y],true) :- X < Y, !.
'$fun_<'([_,_],false) :- !.
'$fun_<'(PartArgs,lambda(RemArgs,'$fun_<'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_>'([X,Y],true) :- X > Y, !.
'$fun_>'([_,_],false) :- !.
'$fun_>'(PartArgs,lambda(RemArgs,'$fun_>'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_=<'([X,Y],true) :- X =< Y, !.
'$fun_=<'([_,_],false) :- !.
'$fun_=<'(PartArgs,lambda(RemArgs,'$fun_=<'([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_>='([X,Y],true) :- X >= Y, !.
'$fun_>='([_,_],false) :- !.
'$fun_>='(PartArgs,lambda(RemArgs,'$fun_>='([X,Y],Z),Z)) :-
    append(PartArgs,RemArgs,[X,Y]),
    !.

'$fun_=..'([X],Y) :- Y =.. X, !.
'$fun_=..'(PartArgs,lambda(RemArgs,'$fun_=..'([X],Z),Z)) :-
    append(PartArgs,RemArgs,[X]),
    !.

/***************************************************************************/
/* If-then-else support                                                    */
/***************************************************************************/
%
%  example:
%    fun(fact @ [X], if @ [ X = 1,
%                           1,
%                           '*' @ [X, fact @ [foo @ [X,1]]]
%                         ]).
%  transforms to:
%    fact([X],Z) :- $fun_aux_if( X = 1,
%                                Z = 1,
%                                ($fun_-([X,1],Z1),
%                                 $fun_fact([Z1],Z2),
%                                 $fun_*([X,Z2],Z))).
%
/***************************************************************************/

:- public('$fun_aux_if'/3).

'$fun_aux_if'(R,Goal_true,_) :- 
    call(R),
    !,
    call(Goal_true).

'$fun_aux_if'(_,_,Goal_false) :- 
    call(Goal_false).

/***************************************************************************/
/* Higher order programming */
/***************************************************************************/
%  example:  
%     fun(plus_3 @ [X,Y,Z], sys_add @ [sys_add @ [X,Y],Z]).
%
%  transforms to:
%     fun_plus_3([X,Y,Z], A) :- sys_add([X,Y],A1), sys_add([A1,Z],A), !.
%
%     fun_plus_3(Args,lambda(Rargs, fun_plus_3([X,Y,Z],A),A)) :- 
%        append(Args,Rargs,[X,Y,Z]), !.
%
%  with the second rule generating:
%
%     fun_plus_3([X,Y], lambda([Z],fun_plus_3([X,Y,Z],A),A)), !.
%
%     fun_plus_3([X], lambda([Y,Z],fun_plus_3([X,Y,Z],A),A)), !.
%
/***************************************************************************/

/***************************************************************************/
/* note 'fmangle/2' also used in 'wamcc_fcode.pl' */

fmangle(Func,Func1) :-
    atom_chars(Func,Fs),
    atom_chars(Func1,['$',f,u,n,'_'|Fs]).

:- public('$fun_eval'/2).

'$fun_eval'(F @ X, F @ X) :-     % F a variable => residuation
    var(F),
    !. 

'$fun_eval'(F @ Args, Z) :-      % F an atom => call(F...)
    atom(F),
    fmangle(F,F1),
    FCall =.. [F1,Args,Z],
    call(FCall),
    !.

'$fun_eval'(F @ G @ Args, Z) :-  % nested applications
    '$fun_eval'(F @ G, Z1),
    '$fun_eval'(Z1 @ Args, Z),
    !.

                % Lambda functions:

                % all args => call
'$fun_eval'(lambda(Args,F,Z) @ Args1, Z1) :-
    copy_term(lambda(Args,F,Z), lambda(Args1,F1,Z1)),
    call(F1),
    !.
                % length(Args2) > length(Args)
                % e.g. lambda([X],$fun_compose([append,i,X],Z),Z) @ [1,2]
'$fun_eval'(lambda(Args,F,Z) @ Args2, Z2) :-
    copy_term(lambda(Args,F,Z), lambda(Args1,F1,Z1)),          % rename
    append(Args1,RemArgs,Args2),              % match outermost args
    call(F1),
    '$fun_eval'(Z1 @ RemArgs, Z2),
    !.

                                 % too few args => return lambda func
'$fun_eval'(lambda(AllArgs,F,Z) @ ActualArgs, lambda(RemArgs,F1,Z1)) :-
    copy_term(lambda(AllArgs,F,Z), lambda(AllArgs1,F1,Z1)),
    append(ActualArgs, RemArgs, AllArgs1),
    !. 



  
