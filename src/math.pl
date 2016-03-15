%
% Copyright 2016 Octavian Hasna
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%         http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%

%
% Arithmetic operations on numbers represented as lists.
%

%
% add_list(+A:List, +B:List, -Sum:List)
%
% Examples of use:
% ?- add_list([1,2], [3], R).
% R=[1,5].
%
% ?- add_list([1,2], [0], R).
% R=[1,2].
%
add_list(A,B,Sum):-
	reverse(A,RA),
	reverse(B,RB),
	greater_rev(RA,RB),!, % used to simplify add_rev
	add_rev(RA,RB,0,RS),
	reverse(RS,Sum).	

add_list(A,B,Sum):-
	reverse(A,RA),
	reverse(B,RB),
	add_rev(RB,RA,0,RS),
	reverse(RS,Sum).

add_rev([],[],Acc,[Acc]):-!.
add_rev(A,[],0,A):-!.
add_rev([X|A],[],1,[S|A]):-S is X+1, S =< 9,!.
add_rev([9|A],[],1,[0|R]):-add_rev(A,[],1,R).
add_rev([X|A],[Y|B],Acc,[S|R]):-S is X+Y+Acc, S =< 9,!, add_rev(A,B,0,R).	
add_rev([X|A],[Y|B],Acc,[S|R]):-S is X+Y+Acc-10, add_rev(A,B,1,R).


%
% substract_list(+A:List, +B:List, -Diff:List)
%
% Examples of use:
% ?- substract_list([1,2], [3], R).
% R=[9].
%
% ?- substract_list([3], [1,2], R).
% R=[-,9].
% 
substract_list(A,B,[0]):-A=B,!.
substract_list(A,B,Diff):-
	reverse(A,RA),
	reverse(B,RB),
	greater_rev(RA,RB),!,
	substract_rev(RA,RB,0,RD),
	reverse(RD,D),
	left_zero_trim(D,Diff).

substract_list(A,B,[-|Diff]):-
	reverse(A,RA),
	reverse(B,RB),
	substract_rev(RB,RA,0,RD),
	reverse(RD,D),
	left_zero_trim(D,Diff).

substract_rev(A,[],0,A):-!.
substract_rev([X|A],[],1,[D|A]):-D is X-1, D >= 0,!.
substract_rev([X|A],[],1,[D|R]):-D is X+9, substract_rev(A,[],1,R).	
substract_rev([X|A],[Y|B],Acc,[D|R]):-D is X-Y-Acc, D >= 0,!, substract_rev(A,B,0,R).	
substract_rev([X|A],[Y|B],Acc,[D|R]):-D is X+10-Y-Acc, substract_rev(A,B,1,R).


%
% multiply_list(+A:List, +B:List, -Product:List)
%
% Examples of use:
% ?- multiply_list([1,2], [3], R).
% R=[3,6].
%
% ?- multiply_list([1,2], [0], R).
% R=[0].
%
multiply_list(A,B,Product):-
	reverse(A,RA),
	reverse(B,RB),
	multiply_rev(RA,RB,[0],[],RP),
	reverse(RP,P),		
	left_zero_trim(P,Product).

multiply_rev(_,[],Acc,_,Acc):-!.
multiply_rev(A,[Y|B],Acc,P,R):-
	multiply_rev_line(A,Y,0,Rline),
	append(P,Rline,NRline),
	add_rev_start(Acc,NRline,NAcc),
	multiply_rev(A,B,NAcc,[0|P],R).

multiply_rev_line([],_,Acc,[Acc]):-!.
multiply_rev_line([X|A],Y,Acc,[H|Rez]):-
	M is X*Y+Acc,
	H is M mod 10,
	NAcc is (M-H)/10,
	multiply_rev_line(A,Y,NAcc,Rez).

add_rev_start(A,B,Rez):-greater_rev(A,B),!,	add_rev(A,B,0,Rez).
add_rev_start(A,B,Rez):-add_rev(B,A,0,Rez).


%
% Utilities
%
left_zero_trim([0],[0]):-!.
left_zero_trim([0|T],R):-!,left_zero_trim(T,R).
left_zero_trim(R,R).

greater_rev([_],[]):-!.
greater_rev([X],[Y]):-X>Y,!.
greater_rev([_|A],[_|B]):-greater_rev(A,B).
