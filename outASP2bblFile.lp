% To have the bbl file

% Facts extracted from data
element_type(T,E) :- concept(_,T,E).
type(T) :- element_type(T,_).
nbelements(T1,N1,T2,N2) :- N1=[element_type(T1,E)], N2=[element_type(T2,E)], type(T1), type(T2), (N1,T1)<(N2,T2).
types(T1,T2) :- nbelements(T1,_,T2,_).
% non empty concept
concept(C) :- concept(C,T1,_), concept(C,T2,_), types(T1,T2).
element(E) :- concept(C,T,E), concept(C).
edge(X,Y)  :- inter(X,Y), element_type(T1,X), element_type(T2,Y), element(X), element(Y), types(T1,T2).
edge(Y,X)  :- inter(X,Y), element_type(T1,Y), element_type(T2,X), element(X), element(Y), types(T1,T2).

% Define the inclusion link between two concepts 
% linked(N1, N2 included in N1)  (linked2 is oriented N1<N2)
linked(N1,N2) :- concept(N1,T1,E):concept(N2,T1,E), concept(N1), concept(N2), types(T1,_), N1!=N2.

linkedchosen(C1;C2) :- linkedchosen(C1,C2).


setNode(X;Y) :- edge(X,Y).

% Define the powernode
setPowernode(C,T1) :- chosenconcept(C), types(T1,_), 2{ concept(C,T1,E) }.
setPowernode(C,T2) :- chosenconcept(C), types(_,T2), 2{ concept(C,T2,E) }.
spePowernode(C,E,T) :- chosenconcept(C), not setPowernode(C,T), type(T), concept(C,T,E).
spePowernode(C,T) :- spePowernode(C,E,T).

% Define the IN for the powernode in the powergraphe (C2 is in C1)
%setIn(C1,C2,T1) :- linkedchosen(C1,C2), linked(C1,C2), types(T1,_).
setIn(pinp(C1,C2,T1)) :- linkedchosen(C1,C2), types(T1,_), not spePowernode(C1,T1), not spePowernode(C2,T1).


% Define the IN for the node in the powergraphe (E is in C2) for the type T1
setIn(einp(C1,E,T1)) :- chosenconcept(C1;C2), concept(C1,T1,E), not setIn(pinp(C1,C2,T1)):concept(C2), types(T1,_), not spePowernode(C1,T1).

% Define the IN for the node in the powergraphe (E is in C2) for the type T2
%setIn(einp(C1,E,T2)) :- chosenconcept(C1), concept(C1,T2,E), not setIn(pinp(C1,C2,T2)):concept(C2), types(_,T2), not spePowernode(C1,T2).
%setIn(einp(C1,E,T2)) :- chosenconcept(C1;C2), concept(C1,T2,E), concept(C2,T2,E), not linkedchosen(C1,C2).

setIn(einp(C1,E,T2)) :- chosenconcept(C1), concept(C1,T2,E), not linkedchosen(C2,C1):concept(C2,T2,E).
setIn(einp(C1,E,T2)) :- chosenconcept(C1), concept(C1,T2,E), not linkedchosen(C1,C2):concept(C2,T2,E).





% Define the set of EDGE between two element
setEdge(ele(X,Y)) :- edgeexcluded(X,Y).

% Define the set of EDGE between two powerNode
setEdge(pn(C,T1,T2)) :- setPowernode(C,T1;T2), types(T1,T2).

% Define the set of EDGE between one powerNode and one element
setEdge(ep(E,T1,C,T2)) :- chosenconcept(C), spePowernode(C,E,T1), setPowernode(C,T2), types(T1,T2).
setEdge(pe(C,T1,E,T2)) :- chosenconcept(C), spePowernode(C,E,T2), setPowernode(C,T1), types(T1,T2).




#hide.
#show setNode/1.
#show setPowernode/2.
#show setIn/1.
#show setEdge/1.





% VERIF %
%#show spePowernode/3.
%#show spePowernode/2.
%#show chosenconcept/1.
%#show concept(6,_,_).
%#show linkedchosen/2.
%#show linked/2.


% OLD %
%setEdge(ep(E,T1,C,T2)) :- chosenconcept(C), spePowernode(C,T1), concept(C,E,T1), setPowernode(C,T2), types(T1,T2).
%setEdge(pe(C,T1,E,T2)) :- chosenconcept(C), spePowernode(C,T2), concept(C,E,T2), setPowernode(C,T1), types(T1,T2).
%setEdge(ep(E,T1,C,T2)) :- chosenconcept(C), { concept(C,E,T1):element_type(T1,E) }1, types(T1,T2).
%setEdge(pe(C,T1,E,T2)) :- chosenconcept(C), { concept(C,E,T2):element_type(T2,E) }1, types(T1,T2).
%setEdge(pn(C,T1,T2)) :- chosenconcept(C), types(T1,T2).
%spePowernode(E,T) :- chosenconcept(C), concept(C,T1,E):chosenconcept(C), not setPowernode(C,T), type(T).
%spePowernode(C,T) :- chosenconcept(C), not setPowernode(C,T), type(T).
%setPowernode(C,T1;T2) :- concept(C), not linked(C), types(T1,T2).
%setPowernode(C2,T1) :- concept(C2), linkedchosen(_,C2), types(T1,_).
%setPowernode(C1,T2) :- concept(C1), linkedchosen(C1,_), types(_,T2).
