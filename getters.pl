
/*
Clause Name: getRoundNum
Purpose: This clause is responsible returning the round number
		  of the game.
Parameters:
        -GameList- a list containing all the information of the game.
		-RNum- will hold a number representing the round number.
*/
getRoundNum(GameList, RNum) :-
	[RNum | _ ] = GameList.

/*
Clause Name: getCGameScore
Purpose: This clause is responsible returning the computer's game
		  score.
Parameters:
        -GameList- a list containing all the information of the game.
		-CGScore- will hold a number representing the computer's game
					score.
*/
getCGameScore(GameList, CGScore) :-
	[_, CGScore | _ ] = GameList.

/*
Clause Name: getCRoundScore
Purpose: This clause is responsible returning the computer's round
		  score.
Parameters:
        -GameList- a list containing all the information of the game.
		-CRScore- will hold a number representing the computer's round
					score.
*/
getCRoundScore(GameList, CRScore) :-
	[_, _, CRScore | _ ] = GameList.

/*
Clause Name: getCHand
Purpose: This clause is responsible returning the computer's hand.
Parameters:
        -GameList- a list containing all the information of the game.
		-CHand- will hold a list of cards representing the computer's
				current hand.
*/
getCHand(GameList, CHand) :-
	[_, _, _, CHand | _ ] = GameList.

/*
Clause Name: getCCapture
Purpose: This clause is responsible returning the computer's
		  capture pile.
Parameters:
        -GameList- a list containing all the information of the game.
		-CCapture- will hold a list of cards representing the computer's
					current capture pile.
*/
getCCapture(GameList, CCapture) :-
	[_, _, _, _, CCapture | _ ] = GameList.

/*
Clause Name: getCMeld
Purpose: This clause is responsible returning the computer's previous
		  melds pile.
Parameters:
        -GameList- a list containing all the information of the game.
		-CMeld- will hold a list of cards representing the computer's
					current previous-melds list.
*/	
getCMeld(GameList, CMeld) :-
	[_, _, _, _, _, CMeld | _ ] = GameList.

/*
Clause Name: getHGameScore
Purpose: This clause is responsible returning the human's game
		  score.
Parameters:
        -GameList- a list containing all the information of the game.
		-HGScore- will hold a number representing the human's game
					score.
*/
getHGameScore(GameList, HGScore) :-
	[_, _, _, _, _, _, HGScore | _ ] = GameList.
/*
Clause Name: getHRoundScore
Purpose: This clause is responsible returning the human's round
		  score.
Parameters:
        -GameList- a list containing all the information of the game.
		-HRScore- will hold a number representing the human's round
					score.
*/	
getHRoundScore(GameList, HRScore) :-
	[_, _, _, _, _, _, _, HRScore | _ ] = GameList.
	
/*
Clause Name: getHHand
Purpose: This clause is responsible returning the human's hand.
Parameters:
        -GameList- a list containing all the information of the game.
		-HHand- will hold a list of cards representing the human's
				current hand.
*/
getHHand(GameList, HHand) :-
	[_, _, _, _, _, _, _, _, HHand | _ ] = GameList.

/*
Clause Name: getHCapture
Purpose: This clause is responsible returning the human's
		  capture pile.
Parameters:
        -GameList- a list containing all the information of the game.
		-HCapture- will hold a list of cards representing the human's
					current capture pile.
*/	
getHCapture(GameList, HCapture) :-
	[_, _, _, _, _, _, _, _, _, HCapture | _ ] = GameList.

/*
Clause Name: getHMeld
Purpose: This clause is responsible returning the human's previous
		  melds pile.
Parameters:
        -GameList- a list containing all the information of the game.
		-HMeld- will hold a list of cards representing the human's
					current previous-melds list.
*/	
getHMeld(GameList, HMeld) :-
	[_, _, _, _, _, _, _, _, _, _, HMeld | _ ] = GameList.

/*
Clause Name: getTrump
Purpose: This clause is responsible returning the trump card of
		  the current round.
Parameters:
        -GameList- a list containing all the information of the game.
		-Trump- will hold an atom that represents the trump card of the
				current round.
*/
getTrump(GameList, Trump) :-
	[_, _, _, _, _, _, _, _, _, _, _, Trump | _ ] = GameList.
	
/*
Clause Name: getStock
Purpose: This clause is responsible for returning the stock of
		  the current round.
Parameters:
        -GameList- a list containing all the information of the game.
		-Stock- will holed a list of atoms representing the cards in
				the stock of the current round.
*/
getStock(GameList, Stock) :-
	[_, _, _, _, _, _, _, _, _, _, _, _, Stock | _ ] = GameList.

/*
Clause Name: getNextP
Purpose: This clause is responsible for returning next player (the
		  player to play first on the current turn).
Parameters:
        -GameList- a list containing all the information of the game.
		-NextP- will hold the name of the next player (human or computer).
*/	
getNextP(GameList, NextP) :-
	[_, _, _, _, _, _, _, _, _, _, _, _, _, NextP | _ ] = GameList.

/*
Clause Name: getType
Purpose: This clause is responsible for returning the type of a given
		  card.
Parameters:
        -Card- an atom that represents a card.
		-Type- a character that represents the type of the card.
*/	
getType(Card, Type) :-
	sub_atom(Card, 0, 1, _, Type).
	
/*
Clause Name: getSuit
Purpose: This clause is responsible for returning the suit of a given
		  card.
Parameters:
        -Card- an atom that represents a card.
		-Suit- will hold a character that represents the suit of the
				card.
*/	
getSuit(Card, Suit) :-
	atom_length(Card, L),
	L = 2,
	sub_atom(Card, 1, 1, _, Suit).
getSuit(Card, Suit) :-
	atom_length(Card, L),
	L \= 2,
	sub_atom(Card, 0, 1, _, Suit).
	
/*
Clause Name: getCardIndex
Purpose: This clause is responsible for returning the type index
		  of the card.
Parameters:
        -Card- an atom that represents a card.
		-Index- will hold a number that represents the type index of
				the card.
*/	
getCardIndex(Card, Index) :-
	getType(Card, Type),
	Type = '9',
	Index is 0.
getCardIndex(Card, Index) :-
	getType(Card, Type),
	char_type(Type1, to_lower(Type)),
	Type1 = 'j',
	Index is 1.
getCardIndex(Card, Index) :-
	getType(Card, Type),
	char_type(Type1, to_lower(Type)),
	Type1 = 'q',
	Index is 2.
getCardIndex(Card, Index) :-
	getType(Card, Type),
	char_type(Type1, to_lower(Type)),
	Type1 = 'k',
	Index is 3.
getCardIndex(Card, Index) :-
	getType(Card, Type),
	char_type(Type1, to_lower(Type)),
	Type1 = 'x',
	Index is 4.
getCardIndex(Card, Index) :-
	getType(Card, Type),
	char_type(Type1, to_lower(Type)),
	Type1 = 'a',
	Index is 5.
	