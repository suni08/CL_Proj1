%Loading the unigram and bigram files
:- ['bigram_sunitapa.pl'].
:- ['unigram_sunitapa.pl'].

%Converting a file to a list
file_to_list(FILE,LIST) :- 
   see(FILE), 
   inquire([],R), 
   reverse(R,LIST),
   seen.

inquire(IN,OUT):-
   read(Data), 
   (Data == end_of_file ->   
      OUT = IN 
        ;    
      inquire([Data|IN],OUT) ) . 

%Concatenate 2 lists
concat_list([],L,L).
concat_list([X|L1],L2,[X|L3]) :- concat_list(L1,L2,L3).   

%Calculating the no of words in unigram file(Value of V)
calc_vocab([], 0).
calc_vocab([X|Q], N) :- calc_vocab(Q, N1), N is N1+1.

%Calculating smoothing Laplace probability
calc_prob(ListOfWords,SmoothedLog10Probability) :- calc_prob(ListOfWords,0,SmoothedLog10Probability).

calc_prob([],N,N).

calc_prob([W1,W2|L],Ptemp,Pfinal) :- 
	bigram(D,W1,W2),                                 %Calculating C(Wn-1,Wn)
	unigram(C,W1),                                   %Calculating C(Wn-1)
	file_to_list('unigram_sunitapa.pl',LIST),	 %Converting file to list
	calc_vocab(LIST,V),				 %Count no. of distinct words(V)
	Pnext is Ptemp+log10((D+1)/(C+V)),		 %Calc prob
	( L \= [] 					 %Handling if end of list
	-> concat_list([W2],L,R),			 %All consecutive elements
	calc_prob(R,Pnext,Pfinal)
	; calc_prob(L,Pnext,Pfinal)
	).