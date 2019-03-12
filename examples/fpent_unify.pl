% ijl20 pentominoes unify patterns with board
% Pieces are e.g.

pent('C',[['C','C','C'],
          ['C', _ ,'C']]).

pent('t',[[ _ ,'t'],
          ['t','t'],
          [ _ ,'t'],
          [ _ ,'t']]).

pent('B',[['B','B'],
          ['B','B','B']]).

pents(['C','t','B']).

board([[_,_,_],
       [_,_,_],
       [_,_,_],
       [_,_,_],
       [_,_,_]]).

% u_board(Piece,Board,Row,Col)
u_board([],_,0,_).
u_board([P|Ps],[B|Bs],0,Col) :- u_row(P,B,Col), u_board(Ps,Bs,0,Col).
u_board(P,[_|Bs],Row,Col) :- Row > 0, NextRow is Row-1, u_board(P,Bs,NextRow,Col).

% u_row(Piece,Board,Col,OrigCol).
u_row(P,P1,0) :- append(P,_,P1).
u_row(P,[_|Bs],Col) :- Col > 0, NextCol is Col-1, u_row(P,Bs,NextCol).

% next_move(Board,Row,Column)
next_move([B|_],0,Col) :- free_col(B,Col), !.
next_move([_|Bs],Row,Col) :- next_move(Bs,R,Col), Row is R + 1.

free_col([B|_],0) :- \+ atom(B), !.
free_col([_|Bs],Col) :- free_col(Bs,C), Col is C + 1.

% solve(Board,Pieces) :- select(P,Pieces,PiecesLeft), 
