

/*
Clause Name: getHighestNonT
Purpose: This clause is responsible for finding the highest non trump
			card in the player's hand.
Parameters:
       -Hand- a list of atoms which represent the cards in the hand of
			the player.
	   -Trump- an atom card which holds the trump card of the round.
	   -BestCard- a variable to temporarily hold the card we are looking
				for.
	   -FinalCard- will oventually hold the best card of all the cards
				in the hand.
*/
getHighestNonT([], Trump, BestCard, FinalCard) :-
	FinalCard = BestCard.
getHighestNonT(Hand, Trump, BestCard, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Trump, TrumpSuit),
	getSuit(First, FirstSuit),
	BestCard = 'ee',
	FirstSuit \= TrumpSuit,
	NewBest = First,
	getHighestNonT(Rest, Trump, NewBest, FinalCard).
getHighestNonT(Hand, Trump, BestCard, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Trump, TrumpSuit),
	getSuit(First, FirstSuit),
	BestCard = 'ee',
	FirstSuit = TrumpSuit,
	getHighestNonT(Rest, Trump, BestCard, FinalCard).
getHighestNonT(Hand, Trump, BestCard, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Trump, TrumpSuit),
	getSuit(First, FirstSuit),
	getCardIndex(BestCard, BestCardIndex),
	getCardIndex(First, FirstIndex),
	BestCard \= 'ee',
	FirstSuit \= TrumpSuit,
	FirstIndex > BestCardIndex,
	NewBest = First,
	getHighestNonT(Rest, Trump, NewBest, FinalCard).
getHighestNonT(Hand, Trump, BestCard, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Trump, TrumpSuit),
	getSuit(First, FirstSuit),
	BestCard \= 'ee',
	getHighestNonT(Rest, Trump, BestCard, FinalCard).

/*
Clause Name: getLowestNonTrump
Purpose: This clause is responsible for finding the lowest non trump card 
			in the player's hand.
Parameters:
       -Hand- a list of atoms which represent the cards in the hand of
			the player.
	   -Trump- an atom card which holds the trump card of the round.
	   -BestCard- a variable to temporarily hold the card we are looking
				for.
	   -FinalCard- will oventually hold the best card of all the cards
				in the hand.
*/
getLowestNonTrump([], Trump, BestCard, FinalCard) :-
	FinalCard = BestCard.
getLowestNonTrump(Hand, Trump, BestCard, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Trump, TrumpSuit),
	getSuit(First, FirstSuit),
	BestCard = 'ee',
	FirstSuit \= TrumpSuit,
	NewBest = First,
	getLowestNonTrump(Rest, Trump, NewBest, FinalCard).
getLowestNonTrump(Hand, Trump, BestCard, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Trump, TrumpSuit),
	getSuit(First, FirstSuit),
	BestCard = 'ee',
	FirstSuit = TrumpSuit,
	getLowestNonTrump(Rest, Trump, BestCard, FinalCard).
getLowestNonTrump(Hand, Trump, BestCard, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Trump, TrumpSuit),
	getSuit(First, FirstSuit),
	getCardIndex(BestCard, BestCardIndex),
	getCardIndex(First, FirstIndex),
	BestCard \= 'ee',
	FirstSuit \= TrumpSuit,
	FirstIndex < BestCardIndex,
	NewBest = First,
	getLowestNonTrump(Rest, Trump, NewBest, FinalCard).
getLowestNonTrump(Hand, Trump, BestCard, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Trump, TrumpSuit),
	getSuit(First, FirstSuit),
	BestCard \= 'ee',
	getLowestNonTrump(Rest, Trump, BestCard, FinalCard).
	
	
/*
Clause Name: getLowestTrump
Purpose: This clause is responsible for finding the lowest trump card 
			in the player's hand.
Parameters:
       -Hand- a list of atoms which represent the cards in the hand of
			the player.
	   -Trump- an atom card which holds the trump card of the round.
	   -BestCard- a variable to temporarily hold the card we are looking
				for.
	   -FinalCard- will oventually hold the best card of all the cards
				in the hand.
*/
getLowestTrump([], Trump, BestCard, FinalCard) :-
	FinalCard = BestCard.
getLowestTrump(Hand, Trump, BestCard, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Trump, TrumpSuit),
	getSuit(First, FirstSuit),
	BestCard = 'ee',
	FirstSuit = TrumpSuit,
	NewBest = First,
	getLowestTrump(Rest, Trump, NewBest, FinalCard).
getLowestTrump(Hand, Trump, BestCard, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Trump, TrumpSuit),
	getSuit(First, FirstSuit),
	BestCard = 'ee',
	FirstSuit \= TrumpSuit,
	getLowestTrump(Rest, Trump, BestCard, FinalCard).
getLowestTrump(Hand, Trump, BestCard, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Trump, TrumpSuit),
	getSuit(First, FirstSuit),
	getCardIndex(BestCard, BestCardIndex),
	getCardIndex(First, FirstIndex),
	BestCard \= 'ee',
	FirstSuit = TrumpSuit,
	FirstIndex < BestCardIndex,
	NewBest = First,
	getLowestTrump(Rest, Trump, NewBest, FinalCard).
getLowestTrump(Hand, Trump, BestCard, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Trump, TrumpSuit),
	getSuit(First, FirstSuit),
	BestCard \= 'ee',
	getLowestTrump(Rest, Trump, BestCard, FinalCard).
	
/*
Clause Name: getLowestLeadGTLead
Purpose: This clause is responsible for finding the lowest lead-suit
			card that is greater than lead.
Parameters:
       -Hand- a list of atoms which represent the cards in the hand of
			the player.
	   -Trump- an atom card which holds the trump card of the round.
	   -LowestType- a variable to temporarily hold the card we are looking
				for.
	   -FinalCard- will oventually hold the best card of all the cards
				in the hand.
*/
getLowestLeadGTLead([], Lead, LowestType, FinalCard) :-
	FinalCard = LowestType.
getLowestLeadGTLead(Hand, Lead, LowestType, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Lead, LeadSuit),
	getSuit(First, FirstSuit),
	getCardIndex(Lead, LeadIndex),
	getCardIndex(First, FirstIndex),
	LowestType = 'ee',
	FirstSuit = LeadSuit,
	FirstIndex > LeadIndex,
	NewLowestLead = First,
	getLowestLeadGTLead(Rest, Lead, NewLowestLead, FinalCard).
getLowestLeadGTLead(Hand, Lead, LowestType, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Lead, LeadSuit),
	getSuit(First, FirstSuit),
	getCardIndex(Lead, LeadIndex),
	getCardIndex(First, FirstIndex),
	LowestType = 'ee',
	getLowestLeadGTLead(Rest, Lead, LowestType, FinalCard).
getLowestLeadGTLead(Hand, LowestType, Lead, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Lead, LeadSuit),
	getSuit(First, FirstSuit),
	getCardIndex(Lead, LeadIndex),
	getCardIndex(LowestType, LowestTypeIndex),
	getCardIndex(First, FirstIndex),
	LowestType \= 'ee',
	FirstSuit = LeadSuit,
	FirstIndex > LeadIndex,
	FirstIndex < LowestTypeIndex,
	NewLowestType = First,
	getLowestLeadGTLead(Rest, Lead, NewLowestType, FinalCard).
getLowestLeadGTLead(Hand, Lead, LowestType, FinalCard) :-
	[First | Rest] = Hand,
	getSuit(Lead, LeadSuit),
	getSuit(First, FirstSuit),
	getCardIndex(Lead, LeadIndex),
	getCardIndex(LowestType, LowestTypeIndex),
	getCardIndex(First, FirstIndex),
	LowestType \= 'ee',
	getLowestLeadGTLead(Rest, Lead, LowestType, FinalCard).	
	
	
	
	
	
	
	
	
	
	