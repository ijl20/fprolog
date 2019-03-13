% ijl20 pentominoes unify patterns with board
% Pieces are e.g.

pent('C',[['C','C'],
          ['C', _ ],
          ['C','C']]).

pent('C',[['C','C','C'],
          ['C', _ ,'C']]).

pent('t',[[ _ ,'t'],
          ['t','t'],
          [ _ ,'t'],
          [ _ ,'t']]).

pent('t',[[ _ ,'t'],
          [ _ ,'t'],
          ['t','t'],
          [ _ ,'t']]).

pent('t',[['t'],
          ['t','t'],
          ['t'],
          ['t']]).

pent('t',[['t'],
          ['t'],
          ['t','t'],
          ['t']]).

pent('t',[['t','t','t','t'],
          [ _ ,'t']]).

pent('t',[['t','t','t','t'],
          [ _ , _ ,'t']]).

pent('t',[[ _ ,'t'],
          ['t','t','t','t']]).

pent('t',[[ _ , _ ,'t'],
          ['t','t','t','t']]).

pent('l',[['l','l','l','l'],
          ['l']]).

pent('l',[['l','l','l','l'],
          [ _ , _ , _ ,'l']]).

pent('l',[['l'],
          ['l','l','l','l']]).

pent('l',[[ _ , _ , _ ,'l'],
          ['l','l','l','l']]).

pent('l',[['l'],
          ['l'],
          ['l'],
          ['l','l']]).

pent('l',[['l','l'],
          ['l'],
          ['l'],
          ['l']]).

pent('l',[[ _ ,'l'],
          [ _ ,'l'],
          [ _ ,'l'],
          ['l','l']]).

pent('l',[['l'],
          ['l'],
          ['l'],
          ['l','l']]).

pent('B',[[ _ ,'B','B'],
          ['B','B','B']]).

pent('B',[['B','B','B'],
          ['B','B']]).

pent('B',[['B','B','B'],
          [ _ ,'B','B']]).

pent('B',[['B','B'],
          ['B','B','B']]).

pent('B',[['B'],
          ['B','B'],
          ['B','B']]).

pent('B',[[ _ ,'B'],
          ['B','B'],
          ['B','B']]).

pent('B',[['B','B'],
          ['B','B'],
          ['B']]).

pent('B',[['B','B'],
          ['B','B'],
          [ _ ,'B']]).

pent('S',[[ _ ,'S'],
          ['S','S'],
          ['S'],
          ['S']]).

pent('S',[['S', _ ],
          ['S','S'],
          [ _ ,'S'],
          [ _ ,'S']]).

pent('S',[[ _ ,'S'],
          [ _ ,'S'],
          ['S','S'],
          ['S']]).

pent('S',[['S'],
          ['S'],
          ['S','S'],
          [ _ ,'S']]).

% pents(['C','t','B','S','l']).
pents(P) :- setof(Pent,Pattern^pent(Pent,Pattern),P).

board([[_,_,_],
       [_,_,_],
       [_,_,_],
       [_,_,_],
       [_,_,_]]).

% board(Rows,Cols,Board).
board(0,_,[]).
board(Rows,Cols,[Row|Board]) :- 
    Rows > 0,
    board_row(Cols,Row),
    Rem_rows is Rows-1,
    board(Rem_rows, Cols, Board).

board_row(0,[]).
board_row(Cols,[_|Row]) :- 
    Cols > 0,
    Rem_cols is Cols-1,
    board_row(Rem_cols,Row).

% place_row_col(Pattern,Board,Row,Col)
% Succeeds if can place (i.e. unify) a 'Piece Pattern' on the Board with first 'empty' cell (i.e.
% a free variable) at Row,Col within Board.
place_row_col([],_,0,_).
place_row_col([P|Ps],[B|Bs],0,Col) :- place_row(P,B,Col), place_row_col(Ps,Bs,0,Col).
place_row_col(P,[_|Bs],Row,Col) :- Row > 0, NextRow is Row-1, place_row_col(P,Bs,NextRow,Col).

% place_row(Pattern_row,Board_row,Col)
% Succeeds if Pattern_row can be unified with Board_row from column Col
place_row(P,P1,0) :- append(P,_,P1).
place_row(P,[_|Bs],Col) :- Col > 0, NextCol is Col-1, place_row(P,Bs,NextCol).

% free_row_col(Board,Row,Column)
% Succeeds if first free variable on the Board is at indexes Row, Column
free_row_col([B|_],0,Col) :- free_col(B,Col), !.
free_row_col([_|Bs],Row,Col) :- free_row_col(Bs,R,Col), Row is R + 1.

% free_col(Board_row,Col)
% Succeeds if first free variable in the Board_row is at index Col
free_col([B|_],0) :- \+ atom(B), !.
free_col([_|Bs],Col) :- free_col(Bs,C), Col is C + 1.

% offset(P, N) succeeds if first occupied cell of pattern P row 0 is at index N.
offset([R|_],Offset) :- row_offset(R,Offset).

row_offset([P|_],0) :- atom(P).
row_offset([X|P],Offset) :- \+ atom(X), row_offset(P,N), Offset is N+1.

% place(Pieces,Board) succeeds if we can fill Board with unique Pieces
place([Piece|Pieces],Board) :- 
    free_row_col(Board,Free_row,Free_col), 
    select(Pn,[Piece|Pieces],Rem_pieces),
    pent(Pn,Pattern),
    offset(Pattern,Offset),
    Col is Free_col-Offset,
    Col >= 0,
    place_row_col(Pattern,Board,Free_row,Col), 
    print_board(Board),nl,
    place(Rem_pieces,Board).

% Ultimate success condition is there are no free cells left in Board
% Note an alternative success condition is 
% place([],_).
% i.e. we have placed ALL the pieces - this is only suitable for a 60-cell Board.
place(_,Board) :- \+ free_row_col(Board,_,_).

print_board([Board_row|Board_rows]) :-
    print_board_row(Board_row),
    print_board(Board_rows).
print_board([]).

print_board_row([Cell|Cells]) :- print_cell(Cell), print_board_row(Cells).
print_board_row([]) :- nl.

print_cell(C) :- atom(C), print(' '), print(C).
print_cell(C) :- \+ atom(C), print(' '), print('_').

solution(Board) :- board(4,5,Board),pents(Pents),place(Pents,Board).

