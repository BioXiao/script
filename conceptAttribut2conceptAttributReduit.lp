% Facts
% concept(N,type,name).

% Define concepts
concept(N) :- concept(N,_,_).
% Define name
name(X) :- concept(_,_,X).

% Define top
top(N) :- concept(N), not concept(N,arnm,X):name(X).

% Define bottom
bot(N) :- concept(N), not concept(N,micro,X):name(X).


% Get reduce concept
% Keep all attributes
reduceConcept(N,attArnm,X)  :- concept(N,attArnm,X).
reduceConcept(N,attMicro,X) :- concept(N,attMicro,X).

% Get inclusion relation
include(N1,N2) :- arete(N1,N2).
include(N1,N3) :- include(N1,N2), include(N2,N3).

% Keep arnm in N if there are not presents in concepts including N
reduceConcept(N1,arnm,X) :- concept(N1,arnm,X), not concept(N2,arnm,X):include(N2,N1).

% Keep micro in N if there are not presents in concepts how are included in N
reduceConcept(N1,micro,X) :- concept(N1,micro,X), not concept(N2,micro,X):include(N1,N2).

#hide.
#show reduceConcept/3.