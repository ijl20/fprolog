
:- main.

%%%%%%%%%% ORACLE PRIMITIVES %%%%%%%%%%%%%%%%%%%%%%%%

o_build(N) :- pragma_c(o_build1).
o_build(_) :- pragma_c(o_build2).

o_follow(N) :- pragma_c(o_follow).

o_set_l(L) :- pragma_c(o_set_l).
o_read_l(L) :- pragma_c(o_read_l).

o_set_g(G) :- pragma_c(o_set_g).
o_read_g(G) :- pragma_c(o_read_g).

o_set_n(N) :- pragma_c(o_set_n).
o_read_n(N) :- pragma_c(o_read_n).

o_read_s(S) :- pragma_c(o_read_s).

o_init :- pragma_c(o_init).

o_set_current(I) :- pragma_c(o_set_current).
o_read_current(I) :- pragma_c(o_read_current).

o_sol_count(N) :- g_read(o_SolnCount,N).

%%%%%%%%%% UTILITY PREDS %%%%%%%%%%%%%%%%%%%%%%%%

o_read_orc(N,I,V) :- pragma_c(o_read_orc).

o_print_orcs :- o_read_s(S),
                o_print_orcs1(0,S).

o_print_orcs1(I,S) :- I < S,
                o_print_orc(I),
                I1 is I + 1,
                o_print_orcs1(I1,S),
                !.
o_print_orcs1(_,_).

o_print_orc(N) :- o_read_orc(N,0,Length),
                  write('['),
                  o_print_orc1(N,1,Length),
                  o_read_orc(N,Length,V),
                  write(V),
                  write(']'),
                  nl.

o_print_orc1(N,I,L) :- I < L,
                  o_read_orc(N,I,V),
                  write(V),
                  write(','),
                  I1 is I + 1,
                  o_print_orc1(N,I1,L),
                  !.
o_print_orc1(_,_,_).

/**************************************************************************/
/*                                                                        */
/*                    S T R A T E G I E S                                 */
/*                                                                        */
/**************************************************************************/
/*                                                                        */
/* Breadth First Partitioning                                             */
/*                                                                        */
/* Search to given depth (Limit) collecting open oracles in o_orcs        */
/* then search for unlimited depth from those oracles                     */
/*                                                                        */
/* Arguments to executable are (1) Pool size, (2) Proc number, (3) Limit  */
/*                                                                        */

o_get_oracle :- 
     o_read_current(I), 
     o_read_s(S),
     I < S.

o_get_oracle :- 
     o_read_current(I), 
     o_read_s(S),
     I < S,
     o_read_g(G),
     I1 is I+G, 
     o_set_current(I1),
     o_get_oracle.

o_soln(X) :- g_read(o_SolnCount,C), C1 is C + 1, g_assign(o_SolnCount,C1),
    write('delphi solution '), write(X), nl.

o_bfp_c :-        /* Phase 0: Collect oracles */
    o_init,
    g_assign(o_SolnCount,0),
    /* Arg1 = G, Arg2 = N, Arg3 = L */
    argv(1,Arg1), number_atom(G,Arg1), o_set_g(G),
    argv(2,Arg2), number_atom(N,Arg2), o_set_n(N),
    argv(3,Arg3), number_atom(L,Arg3), o_set_l(L),
      write('delphi bfp started '),
      write(N), write(' '), 
      write(G), write(' '),
      write(L), nl,
    cputime(T0), g_assign(o_BFstart,T0),
    b_query,                /* BUILD mode query */
    fail.

o_bfp_c :-       /* Phase 1: pick oracles and search */
    cputime(T1),
    argv(1, Arg1), number_atom(G,Arg1),
    argv(2, Arg2), number_atom(N,Arg2),
    argv(3, Arg3), number_atom(L,Arg3),
    o_print_orcs,
    o_set_l(10000),        /* no limit L */    
    o_read_s(S), g_read(o_BFstart,T0),
    BFtime is T1-T0, g_assign(o_BFtime,BFtime),
      write('delphi bfp oracles '),
      write(N), write(' '), 
      write(G), write(' '),
      write(L), write(' '),
      write(S), write(' '),
      write(BFtime), nl,
    cputime(T2), g_assign(o_Ftime,T2),
    o_set_current(N),
    o_get_oracle,
    o_read_current(I),
    o_print_orc(I),
    f_query,               /* FOLLOW mode query */
    fail.

o_bfp_c :-      /* Phase 2: Shutdown */
    cputime(T3), g_read(o_Ftime, T2), Ftime is T3-T2,
    argv(1, G),
    argv(2, N),
    argv(3, L),
    o_read_s(S),
    o_sol_count(C),
    g_read(o_BFtime, BFtime),
    Ttime is BFtime+Ftime,
      write('delphi bfp completed '),
      write(N), write(' '), 
      write(G), write(' '),
      write(L), write(' '),
      write(S), write(' '),
      write(C), write(' '),
      write(BFtime), write(' '),
      write(Ftime), write(' '),
      write(Ttime), nl,
    halt.    


%%%%%%%%%%  TEST PROG  %%%%%%%%%%%%%%%%%%%%%%%%

a(X) :- o_build(1),       % build code
        b(X),
        c(X),
        d(X).

b(a) :- o_build(1).
b(b) :- o_build(2).
b(c) :- o_build(3).

c(a) :- o_build(1).
c(c) :- o_build(2).

d(a) :- o_build(1).
d(c) :- o_build(2).

a(1,X) :- o_follow(N1),    % follow code
          b(N1,X),
          o_follow(N2),
          c(N2,X),
          o_follow(N3),
          d(N3,X).
a(0,X) :- a(X).            % tunnel code

b(1,a).
b(2,b).
b(3,c).
b(0,X) :- b(X).            % tunnel code

c(1,a).
c(2,c).
c(0,X) :- c(X).            % tunnel code

d(1,a).
d(2,c).
d(0,X) :- d(X).            % tunnel code

o_query :- true.

b_query :- a(X), o_soln(X).

f_query :- o_follow(N), a(N,X), o_soln(X).


