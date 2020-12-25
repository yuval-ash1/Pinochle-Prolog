% pinochle.pl
/*
     ************************************************************
     * Name:  Yuval Ashkenazi                                   *
     * Project:  Project #4 Prolog Pinochle                     *
     * Class:  CMPS366- Organization of Programming Languages   *
     * Date:  December 8th, 2020                                *
     ************************************************************
*/

/*
Clause Name: main
Purpose: This is the "main" for the program, it reads the
		 user input and initializes the appropriate clauses
Parameters:
        -none
*/
main() :-
	format("To start a new game press 1\n"),
	format("To load a game press 2\n"),
	format("--> "),
	read(Input),
	vali(Input, Output),
	takeAction(Output).

/*
Clause Name: takeAction
Purpose: This clause is responsible to call a new game or
		 load a game from a file depending on the user input.
Parameters:
        -Input- this hold the validated user input (1 or 2).
*/
takeAction(Input) :-
	Input = 1,
	game().
takeAction(Input) :-
	Input = 2,
	readFromFile(LoadedList),
	loadedGame(LoadedList).

/*
Clause Name: vali
Purpose: Validate the user's in many occurances 
		(using this function to validate morethan 1 scenario).
Parameters:
        -Input- the user's initial choice.
		-Output- the user's final choice (after validated).
*/
vali(Input, Output) :-
	Input \= 1,
	Input \= 2,
	format("Invalid input, try again\n"),
	format("Note: possible inputs are 1 or 2\n"),
	format("--> "),
	read(NewVal),
	vali(NewVal, Output).
vali(Input, Output) :-
	Input = 1,
	Output = 1 .
vali(Input, Output) :-
	Input = 2,
	Output = 2 .

/*
Clause Name: createMainList
Purpose: Initialize the deck of cards for the game.
Parameters:
        -none.
*/
createMainList(GameList) :-
	GameList = [1, 0, 0, [], [], [], 0, 0, [], [], [], [], [], []],
	write(GameList). %YUVYUV REMOVE THIS

/*
Clause Name: setDeck
Purpose: Initialize the game list.
Parameters:
        -none.
*/
setDeck(Deck) :-		  
	Deck = ['9s', '9c', '9d', '9h', '9s', '9c', '9d', '9h',
	  xs, xc, xd, xh, xs, xc, xd, xh,
	  js, jc, jd, jh, js, jc, jd, jh,	
	  qs, qc, qd, qh, qs, qc, qd, qh,
	  ks, kc, kd, kh, ks, kc, kd, kh,
	  as, ac, ad, ah, as, ac, ad, ah ].


/*
Clause Name: shuffleDeck
Purpose: To shuffle the deck for a new round.
Parameters:
        -Deck- the initial (unshuffled) deck.
		-NewDeck- the final (shuffled) deck.
*/
shuffleDeck(Deck, NewDeck) :-
	random_permutation(Deck, NewDeck).
	
/*
Clause Name: validateCoin
Purpose: To validate the user input for the coin choice.
Parameters:
        -Coin- the initial user input for the coin choice.
		-Output- the valiated coin.
*/
validateCoin(Coin, Output) :-
	Coin \= 0,
	Coin \= 1,
	write("Number has to be 0 or 1, try again: "),
	read(NewCoin),
	validateCoin(NewCoin, Output).
validateCoin(Coin, Output) :-
	Coin =:= 0,
	Output is 0.
validateCoin(Coin, Output) :-
	Coin =:= 1,
	Output is 1 .

/*
Clause Name: tossCoin
Purpose: Determine the who starts in case of a tie
		 as well as on the first turn of the first round.
Parameters:
        -Num- holds the validated user coin choice.
		-RandCoin- holds a random value (0 or 1)
				  representing the tossed coin.
		-Beginner- holds the name of the beginning user
				  according to the coin toss.
*/
tossCoin(Num, RandCoin, Beginner) :-
	read(Coin),
	validateCoin(Coin, Output),
	Num = Output,
	random(0, 1, RandCoin),
	format("Coin shows ~d\n", RandCoin),
	whoStarts(RandCoin, Num, Beginner),
	format("~s Starts\n", Beginner).

/*
Clause Name: whoStarts
Purpose: Determine the the beginner.
Parameters:
		-RandCoin- holds a random value (0 or 1)
				  representing the tossed coin.
		-Coin- holding the validated user's coin choice.
		-Beginner- holds the name of the beginning user
				  according to the coin toss.
*/
whoStarts(RandCoin, Coin, Beginner) :-
	RandCoin = Coin,
	Beginner = human.
whoStarts(RandCoin, Coin, Beginner) :-
	Beginner = computer.	

/*
Clause Name: game
Purpose: Initialize and start the game.
Parameters:
		-none.
*/
game() :-
	write("\nSince this is the first round, we will toss a coin to decide who starts\n"),
	write("Player 1, please enter 0 for heads or 1 for tails: \n"),
	tossCoin(Num, RandCoin, Beginner),
	createMainList(GameList),
	setDeck(NewDeck),
	shuffleDeck(NewDeck, FinalDeck),
	dealCards(GameList, FinalDeck, Beginner, UpdatedList),
	round(UpdatedList, EndGameList),
	getHGameScore(EndGameList, HGScore),
	getHRoundScore(EndGameList, HRScore),
	getCGameScore(EndGameList, CGScore),
	getCRoundScore(EndGameList, CRScore),
	
	HumanTotalScore is HGScore + HRScore,
	ComputerTotalScore is CGScore + CRScore,
	
	write("The game ended!"), nl, nl,
	write("Human Score: "), write(HumanTotalScore) , nl,
	write("Computer Score: "), write(ComputerTotalScore), nl,
	gameWinnerDeclaration(HumanTotalScore, ComputerTotalScore),
	write("Thank you for playing Pinochle :)"), nl.

/*
Clause Name: loadedGame
Purpose: Load a and start the loaded game.
Parameters:
		-GameList- a list holding the game info from the loaded file.
*/
loadedGame(GameList) :-
	round(GameList, EndGameList),
	getHGameScore(EndGameList, HGScore),
	getHRoundScore(EndGameList, HRScore),
	getCGameScore(EndGameList, CGScore),
	getCRoundScore(EndGameList, CRScore),
	
	HumanTotalScore is HGScore + HRScore,
	ComputerTotalScore is CGScore + CRScore,
	
	write("The game ended!"), nl, nl,
	write("Human Score: "), write(HumanTotalScore) , nl,
	write("Computer Score: "), write(ComputerTotalScore), nl,
	gameWinnerDeclaration(HumanTotalScore, ComputerTotalScore),
	write("Thank you for playing Pinochle :)"), nl.
	
/*
Clause Name: gameWinnerDeclaration
Purpose: Determine and prong the game winner.
Parameters:
		-HumanTotalScore- the human's total game score at the end of the game.
		-ComputerTotalScore- the computer's total game score at the end of the game.
*/
gameWinnerDeclaration(HumanTotalScore, ComputerTotalScore) :-
	HumanTotalScore > ComputerTotalScore,
	write("Human won this game!"), nl.
gameWinnerDeclaration(HumanTotalScore, ComputerTotalScore) :-
	ComputerTotalScore > HumanTotalScore,
	write("Computer won this game!"), nl.
gameWinnerDeclaration(HumanTotalScore, ComputerTotalScore) :-
	write("It's a tied game!"), nl.
	
/*
Clause Name: round
Purpose: Start a new round (ends when both players' hands are empty).
Parameters:
		-GameList- the list of the game (contains all the game's info).
		-EndRoundList- the updated game list at the end of the round.
*/
round(GameList, EndRoundList) :-
	printBeforeTurn(GameList),
	turn(GameList, EndRList),
	getHHand(GameList, HHand),
	getCHand(GameList, CHand),
	HHand \= [],
	CHand \= [],
	round(EndRList, EndRoundList).
round(GameList, EndRoundList) :-
	getRoundNum(GameList, RNum),
	getHRoundScore(GameList, HRScore),
	getCRoundScore(GameList, CRScore),
	HRScore > CRScore,
	nl, write("Round number: "), write(RNum), write(" ended"), nl,
	write("Human score: "), write(HRScore), nl,
	write("Computer score: "), write(CRScore), nl,
	write("Human Won!"), nl,
	write("To play another round press 1, otherwise press 2: "), nl,
	read(Input),
	vali(Input, Output),
	anotherRoundHelp(GameList, Output, EndRoundList, human).
round(GameList, EndRoundList) :-
	getRoundNum(GameList, RNum),
	getHRoundScore(GameList, HRScore),
	getCRoundScore(GameList, CRScore),
	HRScore < CRScore,
	nl, write("Round number: "), write(RNum), write(" ended"), nl,
	write("Human score: "), write(HRScore), nl,
	write("Computer score: "), write(CRScore), nl,
	write("Computer Won!"), nl,
	write("To play another round press 1, otherwise press 2: "), nl,
	read(Input),
	vali(Input, Output),
	anotherRoundHelp(GameList, Output, EndRoundList, human).
round(GameList, EndRoundList) :-
	getRoundNum(GameList, RNum),
	getHRoundScore(GameList, HRScore),
	getCRoundScore(GameList, CRScore),
	HRScore = CRScore,
	nl, write("Round number: "), write(RNum), write(" ended"), nl,
	write("Human score: "), write(HRScore), nl,
	write("Computer score: "), write(CRScore), nl,
	write("It's a tie!"), nl,
	write("To play another round press 1, otherwise press 2: "), nl,
	read(Input),
	vali(Input, Output),
	anotherRoundHelp(GameList, Output, EndRoundList, ee).

/*
Clause Name: anotherRoundHelp
Purpose: To initialize a new round if the user wants to (end game otherwise).
Parameters:
		-GameList- the list of the game (contains all the game's info).
		-UInput- holds the user input (1 or 2), representing if the
				 user wants to play another round or not.
		-EndRoundList- the updated game list at the end of the round.
		-Beginner- holds the winner of the last round, or ee if the
				 round ended with a tie.
*/
anotherRoundHelp(GameList, UInput, EndRoundList, ee) :-
	UInput = 1,
	write("Since it's a tie, we will toss a coin to decide who starts"), nl, 
	write("Player 1, please enter 0 for heads or 1 for tails: "), nl,
	tossCoin(Num, RandCoin, Beginner),
	createMainList(NewGameList),
	setDeck(NewDeck),
	shuffleDeck(NewDeck, FinalDeck),
	dealCards(NewGameList, FinalDeck, Beginner, UpdatedList),
	setListForNewRound(GameList, UpdatedList, NewRoundList),
	round(NewRoundList, EndRoundList).	
anotherRoundHelp(GameList, UInput, EndRoundList, Beginner) :-
	UInput = 1,
	createMainList(NewGameList),
	setDeck(NewDeck),
	shuffleDeck(NewDeck, FinalDeck),
	dealCards(NewGameList, FinalDeck, Beginner, UpdatedList),
	setListForNewRound(GameList, UpdatedList, NewRoundList),
	round(NewRoundList, EndRoundList).
anotherRoundHelp(GameList, UInput, EndRoundList, Beginner) :-
	UInput = 2, 
	EndRoundList = GameList.
	
/*
Clause Name: turn
Purpose: To play a turn (where both players play)
Parameters:
		-Round- the list of the game (contains all the game's info).
		-EndRoundList- the updated list after the turn, containing updated scores, meld lists, 
					   capture piles, deck, etc.
*/
turn(RoundList, EndRoundList) :-
	getHHand(RoundList, HHand),
	getCHand(RoundList, CHand),
	HHand \= [],
	CHand \= [],
	getNextP(RoundList, NextP),
	NextP = computer,
	computerPlay(RoundList, ee, LeadCard),
	humanPlay(RoundList, LeadCard, ChaseCard),
	cardPoints(LeadCard, LeadPoints),
	cardPoints(ChaseCard, ChasePoints),
	TurnPoints is LeadPoints + ChasePoints,
	updateHands(LeadCard, ChaseCard, RoundList, NewRoundList),
	getTrump(RoundList, Trump),
	winner(LeadCard, ChaseCard, Trump, CardWinner),
	winnerName(NextP, CardWinner, TurnWinner),
	meldName(NewRoundList, TurnWinner, MeldNameCode),
	wouldYouMeld(NewRoundList, MeldNameCode, TurnWinner, MeldList),
	pointsForMeld(MeldList, MeldNameCode, MeldPoints),
	dealTurnCards(NewRoundList, TurnWinner, TurnPoints, LeadCard, ChaseCard, MeldList, MeldPoints, EndTurnList),
	EndRoundList = EndTurnList.
turn(RoundList, EndRoundList) :-
	getHHand(RoundList, HHand),
	getCHand(RoundList, CHand),
	HHand \= [],
	CHand \= [],
	getNextP(RoundList, NextP),
	NextP = human,
	humanPlay(RoundList, ee, LeadCard),
	computerPlay(RoundList, LeadCard, ChaseCard),
	cardPoints(LeadCard, LeadPoints),
	cardPoints(ChaseCard, ChasePoints),
	TurnPoints is LeadPoints + ChasePoints,
	updateHands(ChaseCard, LeadCard, RoundList, NewRoundList),
	getTrump(RoundList, Trump),
	winner(LeadCard, ChaseCard, Trump, CardWinner),
	winnerName(NextP, CardWinner, TurnWinner),
	meldName(NewRoundList, TurnWinner, MeldNameCode),
	wouldYouMeld(NewRoundList, MeldNameCode, TurnWinner, MeldList),
	pointsForMeld(MeldList, MeldNameCode, MeldPoints),
	dealTurnCards(NewRoundList, TurnWinner, TurnPoints, LeadCard, ChaseCard, MeldList, MeldPoints, EndTurnList),
	EndRoundList = EndTurnList.
turn(RoundList, EndRoundList) :-
	EndRoundList = RoundList.
	
/*
Clause Name: dealCards
Purpose: This clause assigns the cards at the beginning of a round
			  4 cards a player at a time (x3)
			  It also sets the trump card to be the 25th card in the stock
			  and deletes the first 25 cards from the deck.
Parameters:
		-PreviousList- the previous game list that holds the information.
		-Deck- a shuffled deck.
		-Beginner- the name of the player that begins this round
				(human or computer)
		-UpdatedList- the updated game list, containing: initialized
				values for the game
*/
dealCards(PreviousList, Deck, Beginner, UpdatedList) :-
	Beginner = computer,
	[One,Two,Three,Four,Five,Six,Seven,Eight,Nine, Ten, Eleven, Twelve,
	 ThirT, FourT,FifT,SixT,SevenT,EightT,NineT,Twenty,
	 Twenty1,Twenty2, Twenty3, Twenty4, Twenty5 | RestDeck]  = Deck,
	
	CHand = [One, Two, Three, Four, Nine, Ten, Eleven, Twelve,
					SevenT, EightT, NineT, Twenty],
	HHand = [Five, Six, Seven, Eight, ThirT, FourT, FifT, SixT,
					Twenty1, Twenty2, Twenty3, Twenty4],
	
	getRoundNum(PreviousList, RNum),
	getCGameScore(PreviousList, CGScore),
	getCRoundScore(PreviousList, CRScore),
	getCCapture(PreviousList, CCapture),
	getCMeld(PreviousList, CMeld),
	getHGameScore(PreviousList, HGScore),
	getHRoundScore(PreviousList, HRScore),
	getHCapture(PreviousList, HCapture),
	getHMeld(PreviousList, HMeld),
	Trump = Twenty5,
	
	UpdatedList = [RNum, CGScore, CRScore, CHand, CCapture, CMeld, HGScore,
					HRScore, HHand, HCapture, HMeld, Trump, RestDeck, Beginner].
	
	
dealCards(PreviousList, Deck, Beginner, UpdatedList) :-
	Beginner = human,
	[One,Two,Three,Four,Five,Six,Seven,Eight,Nine, Ten, Eleven, Twelve,
	 ThirT, FourT,FifT,SixT,SevenT,EightT,NineT,Twenty,
	 Twenty1,Twenty2, Twenty3, Twenty4, Twenty5 | RestDeck]  = Deck,
	 
	HHand = [One, Two, Three, Four, Nine, Ten, Eleven, Twelve,
					SevenT, EightT, NineT, Twenty],
	CHand = [Five, Six, Seven, Eight, ThirT, FourT, FifT, SixT,
					Twenty1, Twenty2, Twenty3, Twenty4],
	
	getRoundNum(PreviousList, RNum),
	getCGameScore(PreviousList, CGScore),
	getCRoundScore(PreviousList, CRScore),
	getCCapture(PreviousList, CCapture),
	getCMeld(PreviousList, CMeld),
	getHGameScore(PreviousList, HGScore),
	getHRoundScore(PreviousList, HRScore),
	getHCapture(PreviousList, HCapture),
	getHMeld(PreviousList, HMeld),
	Trump = Twenty5,
	
	UpdatedList = [RNum, CGScore, CRScore, CHand, CCapture, CMeld, HGScore,
					HRScore, HHand, HCapture, HMeld, Trump, RestDeck, Beginner].
	
/*
Clause Name: validateCMenu
Purpose: Validate the user's input for the menu displayed
			before the computer's turn
Parameters:
		-Input- the user's initial choice.
		-Output- the user's final choice (after validation).
*/
validateCMenu(Input, Output) :-
	Input \= 1,
	Input \= 2,
	Input \= 3,
	write("Invalid input, possible inputs are 1, 2, and 3. Please try again\n"),
	read(NewChoice),
	validateCMenu(NewChoice, Output).
validateCMenu(Input, Output) :-
	Output = Input.

/*
Clause Name: validateHMenu
Purpose: Validate the user's input for the menu displayed
			before the human's turn
Parameters:
		-Input- the user's initial choice.
		-Output- the user's final choice (after validation).
*/
validateHMenu(Input, Output) :-
	Choice \= 1,
	Choice \= 2,
	Choice \= 3,
	Choice \= 4,
	write("Invalid input, possible inputs are 1, 2, 3, and 4. Please try again\n"),
	read(NewChoice),
	validateHMenu(NewChoice, Output).
validateHMenu(Input, Output) :-
	Output = Input.

/*
Clause Name: printBeforeTurn
Purpose: This clause is responsible printing all the round
			information nicely before the beginning of each turn.
Parameters:
		-GameList- a list containing all the information of the game.
*/
printBeforeTurn(GameList) :-
	getRoundNum(GameList, RNum),
	getTrump(GameList, Trump),
	getStock(GameList, Stock),
	
	getCHand(GameList, CHand),
	getCCapture(GameList, CCapture),
	getCMeld(GameList, CMeld),
	getCRoundScore(GameList, CRoundScore),
	
	getHHand(GameList, HHand),
	getHCapture(GameList, HCapture),
	getHMeld(GameList, HMeld),
	getHRoundScore(GameList, HRoundScore),
	
	nl,
	write("*----------------------------------------------------"), nl,
	write("				Round number: "), write(RNum), nl,
	write("Trump Card: "), write(Trump), nl,
	write("Deck: "), write(Stock), nl,
	
	write("Computer Hand: "), write(CHand), nl,
	write("Computer Capture: "), write(CCapture), nl,
	write("Computer Melds: "), write(CMeld), nl,
	write("Computer Score: "), write(CRoundScore), nl,
	
	write("Human Hand: "), write(HHand), nl,
	write("Human Capture: "), write(HCapture), nl,
	write("Human Melds: "), write(HMeld), nl,
	write("Human Score: "), write(HRoundScore), nl,
	write("----------------------------------------------------*"), nl.

/*
Clause Name: cardPoints
Purpose: To determine how many points a card is worth.
Parameters:
		-Card- a card played, in which we want to get the point value of.
		-Point- a variable to hold the number of points the card is worth.
*/
cardPoints(Card, Points) :-
	getType(Card, Type),
	Type = '9',
	Points is 0.
cardPoints(Card, Points) :-
	getType(Card, Type),
	char_type(Type1, to_lower(Type)),
	Type1 = 'j',
	Points is 2.
cardPoints(Card, Points) :-
	getType(Card, Type),
	char_type(Type1, to_lower(Type)),
	Type1 = 'q',
	Points is 3.
cardPoints(Card, Points) :-
	getType(Card, Type),
	char_type(Type1, to_lower(Type)),
	Type1 = 'k',
	Points is 4.
cardPoints(Card, Points) :-
	getType(Card, Type),
	char_type(Type1, to_lower(Type)),
	Type1 = 'x',
	Points is 10.
cardPoints(Card, Points) :-
	getType(Card, Type),
	char_type(Type1, to_lower(Type)),
	Type1 = 'a',
	Points is 11 .

/*
Clause Name: getACard
Purpose: To deal one card to a player.
Parameters:
		-Stock- the stock of the current round.
		-Trump- the trump card of the current round.
		-Card- will hold the card to be dealt.
*/
getACard(Stock, Trump, Card) :-
	Stock \= [],
	[First | Rest] = Stock,
	Card = First.
getACard(Stock, Trump, Card) :-
	Stock = [],
	getType(Trump, TrumpType),
	getSuit(Trump, TrumpSuit),
	TrumpType \= TrumpSuit,
	Card = Trump.
getACard(Stock, Trump, Card) :-
	Card = [].
	
/*
Clause Name: dealTurnCards
Purpose: This clause deals a card to each player's hand, and updates the
			list with all the new inpormation at the end of a turn.
Parameters:
		-GameList- the list of the game.
		-WinnerName- the name of the winner.
		-WinnerPoints- the number of points winner gets for lead and chase.
		-LeadCard-the card played by the first player.
		-ChaseCard- the card played by the second player.
		-MeldList- a list containing the meld card that has been performed by the
					winner of the turn.
		-MeldPoints- the number of point the winner of the turn got for a
					meld (if performed).
		-EndList- the updated list at the end of a turn.
*/
dealTurnCards(GameList, WinnerName, WinnerPoints, LeadCard, ChaseCard, MeldList, MeldPoints, EndList):-
	WinnerName = computer,
	getStock(GameList, Deck),
	getTrump(GameList, Trump),
	get2Cards(Deck, Trump, FirstCard, SecondCard),
	getRoundNum(GameList, RoundNumber),
	getCGameScore(GameList, CGameScore),
	getCRoundScore(GameList, CRoundScore),
	finalRS(CRoundScore, WinnerPoints, MeldPoints, FinalCRS),
	getCHand(GameList, CHand),
	finalHand(CHand, FirstCard, FinalCHand),
	getCCapture(GameList, CCapture),
	finalCapture(CCapture, LeadCard, ChaseCard, FinalCCapture),
	getCMeld(GameList, CMeld),
	finalMelds(CMeld, MeldList, FinalCMeld),
	getHGameScore(GameList, HGameScore),
	getHRoundScore(GameList, HRoundScore),
	getHHand(GameList, HHand),
	finalHand(HHand, SecondCard, FinalHHand),
	getHCapture(GameList, HCapture),
	getHMeld(GameList, HMeld),
	finalTrump(Trump, SecondCard, FinalTrump),
	finalDeck(Deck, FinalDeck),
	
	EndList = [RoundNumber, CGameScore, FinalCRS, FinalCHand, FinalCCapture, FinalCMeld,
				HGameScore, HRoundScore, FinalHHand, HCapture, HMeld, FinalTrump, FinalDeck,
				WinnerName].
dealTurnCards(GameList, WinnerName, WinnerPoints, LeadCard, ChaseCard, MeldList, MeldPoints, EndList):-
	WinnerName = human,
	getStock(GameList, Deck),
	getTrump(GameList, Trump),
	get2Cards(Deck, Trump, FirstCard, SecondCard),
	getRoundNum(GameList, RoundNumber),
	getCGameScore(GameList, CGameScore),
	getCRoundScore(GameList, CRoundScore),
	getCHand(GameList, CHand),
	finalHand(CHand, SecondCard, FinalCHand),
	getCCapture(GameList, CCapture),
	getCMeld(GameList, CMeld),
	getHGameScore(GameList, HGameScore),
	getHRoundScore(GameList, HRoundScore),
	finalRS(HRoundScore, WinnerPoints, MeldPoints, FinalHRS),
	getHHand(GameList, HHand),
	finalHand(HHand, FirstCard, FinalHHand),
	getHCapture(GameList, HCapture),
	finalCapture(HCapture, LeadCard, ChaseCard, FinalHCapture),
	getHMeld(GameList, HMeld),
	finalMelds(HMeld, MeldList, FinalHMeld),
	finalTrump(Trump, SecondCard, FinalTrump),
	finalDeck(Deck, FinalDeck),
	
	EndList = [RoundNumber, CGameScore, CRoundScore, FinalCHand, CCapture, CMeld,
				HGameScore, FinalHRS, FinalHHand, FinalHCapture, FinalHMeld, FinalTrump, FinalDeck,
				WinnerName].
	
/*
Clause Name: get2Cards
Purpose: To save the two card to be dealt to the user based
			on the deck's "condition".
Parameters:
		-Deck- the deck of the current round.
		-Trump- the trump card of the current round.
		-FirstCard- will hold the first card to be dealt.
		-SecondCard- will hold the second card to be dealt.
*/
get2Cards(Deck, Trump, FirstCard, SecondCard) :-
	length(Deck, Len),
	Len >= 2,
	[FirstCard, SecondCard | Rest] = Deck.
get2Cards(Deck, Trump, FirstCard, SecondCard) :-
	length(Deck, Len),
	Len = 1,
	[FirstCard | Rest] = Deck,
	SecondCard = Trump.
get2Cards([], Trump, FirstCard, SecondCard) :-
	FirstCard = [],
	SecondCard = [].

/*
Clause Name: "Final" functions
Purpose: All of these functions are used for calculations before
			updating the list of the game in dealTurnCards.
*/
finalRS(CRoundScore, WinnerPoints, MeldPoints, Total):-
	Total is CRoundScore + WinnerPoints + MeldPoints.
	
/*------------------------------------------------------------------*/
finalHand(Hand, [], FinalHand) :-
	FinalHand = Hand.
finalHand(Hand, Card, FinalHand) :-
	FinalHand = [Card | Hand].
/*------------------------------------------------------------------*/
finalCapture(Capture, LeadCard, ChaseCard, FinalCapture) :-
	FinalCapture = [ LeadCard, ChaseCard | Capture].
	
/*------------------------------------------------------------------*/
finalMelds(PrevMelds, [], FinalMeld) :-
	FinalMeld = PrevMelds.
finalMelds(PrevMelds, CurrentMeld, FinalMeld) :-
	FinalMeld = [CurrentMeld | PrevMelds]. 
	
/*------------------------------------------------------------------*/
finalTrump(Trump, SecondCard, FinalTrump) :-
	SecondCard = [],
	FinalTrump = Trump.
finalTrump(Trump, SecondCard, FinalTrump) :-
	getSuit(Trump, TrumpS),
	getType(Trump, TrumpT),
	getSuit(SecondCard, SecondS),
	getType(SecondCard, SecondT),
	TrumpS = SecondS,
	TrumpT = SecondT,
	FinalTrump = TrumpS.
finalTrump(Trump, SecondCard, FinalTrump) :-
	FinalTrump = Trump.
	
/*------------------------------------------------------------------*/
finalDeck([], FinalDeck) :-
	FinalDeck = [].
finalDeck(Deck, FinalDeck) :-
	length(Deck, Len),
	Len = 2,
	FinalDeck = [].
finalDeck(Deck, FinalDeck) :-
	[_, _ | Rest] = Deck,
	FinalDeck = Rest.
	
/*
Clause Name: updateHands
Purpose: This function returns the game list, with upadted hands
			for both players the lead and chase cards dropped
			from each hand respectively.
Parameters:
		-ComputerCard- the card played by the computer.
		-HumanCard- the card played by the human.
		-GameList- the list of the game containing all the game's info.
		-FinalGameList- to hold the the updated list with the computer
				card dropped from the computer's hand and the humanCard
				dropped from the human's hand.
*/
updateHands(ComputerCard, HumanCard, GameList, FinalGameList) :-
	getHHand(GameList, HHand),
	getCHand(GameList, CHand),
	dropCard(HHand, HumanCard, NewHHand),
	dropCard(CHand, ComputerCard, NewCHand),
	
	getRoundNum(GameList, RNum),
	getCGameScore(GameList, CGScore),
	getCRoundScore(GameList, CRScore),
	getCCapture(GameList, CCapture),
	getCMeld(GameList, CMeld),
	getHGameScore(GameList, HGScore),
	getHRoundScore(GameList, HRScore),
	getHCapture(GameList, HCapture),
	getHMeld(GameList, HMeld),
	getTrump(GameList, Trump),
	getStock(GameList, Deck),
	getNextP(GameList, NextPlayer),
	
	FinalGameList = [RNum, CGScore, CRScore, NewCHand, CCapture, CMeld,
						   HGScore, HRScore, NewHHand, HCapture, HMeld,
						   Trump, Deck, NextPlayer].
					 
/*
Clause Name: winnerName
Purpose: To determine the winner of the turn, which is the first
			to play in the next turn.
Parameters:
		-NextP- the beginner of the previous turn.
		-CardWinner- the card that won the trn (lead or chase).
		-TurnWinner- will hold the name of the beginner of the next turn.
*/
winnerName(NextP, CardWinner, TurnWinner) :-
	NextP = computer,
	CardWinner = lead,
	write("Computer won this turn"), nl,
	TurnWinner = computer.
winnerName(NextP, CardWinner, TurnWinner) :-
	NextP = computer,
	CardWinner \= lead,
	write("Human won this turn"), nl,
	TurnWinner = human.
winnerName(NextP, CardWinner, TurnWinner) :-
	NextP = human,
	CardWinner = lead,
	write("Human won this turn"), nl,
	TurnWinner = human.
winnerName(NextP, CardWinner, TurnWinner) :-
	NextP = human,
	CardWinner \= lead,
	write("Computer won this turn"), nl,
	TurnWinner = computer.

/*
Clause Name: leadStrategy
Purpose: This clause determines the best card to play as a lead player.
Parameters:
		-GameList- the list of the game.
		-Hand- the hand of the player who is using the strategy.
		-BestCard a the best card to play from hand following the lead strategy.
*/
leadStrategy(GameList, Hand, BestCard) :-
	
	getTrump(GameList, Trump),
	getHighestNonT(Hand, Trump, ee, HighestNonT),
	getLowestTrump(Hand, Trump, ee, LowestT),
	%write(Trump),nl,nl,
	%write(HighestNonT),nl,nl,
	%write(LowestT),nl,nl.
	HighestNonT \= 'ee',
	write("	Strategy- playing the highest non trump card from hand: "),
	BestCard = HighestNonT,
	write(BestCard), nl.
leadStrategy(GameList, Hand, BestCard) :-
	getTrump(GameList, Trump),
	getHighestNonT(Hand, Trump, ee, HighestNonT),
	getLowestTrump(Hand, Trump, ee, LowestT),
	HighestNonT = 'ee',
	write("	Strategy- no non-trump cards in hand, playing lowest trump in hand: "),
	BestCard = LowestT,
	write(BestCard), nl.
	
/*
Clause Name: chaseStrategy
Purpose: This clause determines the best card to play as a chase player.
Parameters:
		-GameList- the list of the game.
		-Hand- the hand of the player who is using the strategy.
		-BestCard a the best card to play from hand following the chase strategy.
*/
chaseStrategy(GameList, Lead, Hand, BestCard) :-
	getTrump(GameList, Trump),
	getSuit(Lead, LeadSuit),
	getSuit(Trump, TrumpSuit),
	getLowestLeadGTLead(Hand, Lead, ee, LowestLeadType),
	getLowestNonTrump(Hand, Trump, ee, LowestNonTrump),
	getLowestTrump(Hand, Trump, ee, LowestTrump),
	chaseStrategyHelp(LeadSuit, TrumpSuit, Trump, LowestLeadType, LowestNonTrump, LowestTrump, BestCard).
	
/*
Clause Name: prepareHPlay, prepareCPlay
Purpose: These clauses find out the player's best meld and "gets rid"
			of the cards of the best possible meld cards (if any), this
			way, melds are taken into account before playing a turn. If
			this results in an empty list, the original hand is sent.
			One for human, one for computer.
Parameters:
		-GameList- the list of the game.
		-FinalHand- will hold the hand of the player after removing meld cards.
*/
prepareHPlay(GameList, FinalHand) :-
	getHHand(GameList, HHand),
	getHMeld(GameList, HMeld),
	getTrump(GameList, Trump),
	computerMeldNumber(HHand, HMeld, Trump, MeldNumber),
	getMeldList(MeldNum, HHand, HMeld, MeldList),
	getRidOfMeldCards(HHand, MeldNum, Trump, MeldList, FinalHand).

prepareCPlay(GameList, FinalHand) :-
	getCHand(GameList, CHand),
	getCMeld(GameList, CMeld),
	getTrump(GameList, Trump),
	computerMeldNumber(CHand, CMeld, Trump, MeldNumber),
	getMeldList(MeldNum, CHand, CMeld, MeldList),
	getRidOfMeldCards(CHand, MeldNum, Trump, MeldList, FinalHand).

/*
Clause Name: getMeldList
Purpose: This clasue will return the user's meld list if the best meld is marriage
			(this will be used when removing a marriage meld from hand- to find
			out the suit of the marriage cards.
Parameters:
		-MeldNum- the number associated with the best meld.
		-Hand- the player's hand.
		-Meld- the player's previous melds list.
		-MeldList- will hold a list with the marriage meld
					or and empty list of the best meld is not a
					marriage meld.
*/
getMeldList(MeldNum, Hand, Meld, MeldList) :-
	meldNum = 8,
	tryMarriage(Hand, Meld, MeldList).
getMeldList(MeldNum, Hand, Meld, MeldList) :-
	MeldList = [].

	
/*
Clause Name: chaseStrategyHelp
Purpose: This clasue will help the chase strategy to determing the best card to play.
Parameters:
		-LeadSuit- the suit of the lead card.
		-TrumpSuit- the suit of the trump card.
		-Trump- the trump card.
		-LowestLeadType- a card that will contain the lowest lead suited card that is higher
					than lead type.
		-LowestNonTrump-lowest card in hand that is not of trump suit.
		-LowestTrump-lowest trump card in hand that.
		-BestCard- the best card to play as a chase player according to the strategy.
*/
chaseStrategyHelp(LeadSuit, TrumpSuit, Trump, LowestLeadType, LowestNonTrump, LowestTrump, BestCard) :-
	LeadSuit = TrumpSuit,
	LowestLeadType \= ee,
	write("	Strategy- playing the lowest trump possible to win the turn: "),
	BestCard = LowestLeadType,
	write(BestCard), nl.
chaseStrategyHelp(LeadSuit, TrumpSuit, Trump, LowestLeadType, LowestNonTrump, LowestTrump, BestCard) :-
	LeadSuit = TrumpSuit,
	LowestNonTrump \= ee,
	write("	Strategy- can't win the turn, playing the least valuable non trump: "),
	BestCard = LowestNonTrump,
	write(BestCard), nl.
chaseStrategyHelp(LeadSuit, TrumpSuit, Trump, LowestLeadType, LowestNonTrump, LowestTrump, BestCard) :-
	LeadSuit = TrumpSuit,
	write("	Strategy- can't win the turn, but don't have any non trumps,"), nl,
	write("	playing the least valuable trump: "),
	BestCard = LowestTrump,
	write(BestCard), nl.
chaseStrategyHelp(LeadSuit, TrumpSuit, Trump, LowestLeadType, LowestNonTrump, LowestTrump, BestCard) :-
	LeadSuit \= TrumpSuit,
	LowestLeadType \= ee,
	write("	Strategy- playing the lowest lead type possible to win the turn: "),
	BestCard = LowestLeadType,
	write(BestCard), nl.
chaseStrategyHelp(LeadSuit, TrumpSuit, Trump, LowestLeadType, LowestNonTrump, LowestTrump, BestCard) :-
	LeadSuit \= TrumpSuit,
	LowestTrump \= ee,
	write("	Strategy- don't have any non trumps that can win the turn,"), nl,
	write("	playing lowest trump in hand to win the turn: "),
	BestCard = LowestTrump,
	write(BestCard), nl.
chaseStrategyHelp(LeadSuit, TrumpSuit, Trump, LowestLeadType, LowestNonTrump, LowestTrump, BestCard) :-
	LeadSuit \= TrumpSuit,
	LowestNonTrump \= ee,
	write("	Strategy- can't win the turn, playing least valuable non trump card:"),
	BestCard = LowestNonTrump,
	write(BestCard), nl.

/*
Clause Name: computerPlay
Purpose: This clasue is responsible for the computer playing a card on its turn.
Parameters:
		-GameList- the list of the game.
		-Lead- the lead card played by the first player (ee if computer is lead).
		-BestCard- the best card from the computer's hand using the computer
					strategy functions.
*/
computerPlay(GameList, Lead, BestCard) :-
	write("1. Save the game"), nl,
	write("2. Make a move"), nl,
	write("3. Quit the game"), nl,
	read(Choice),
	validateCMenu(Choice, FinalChoice),
	computerPlayHelp(FinalChoice, GameList, Lead, BestCard).

/*
Clause Name: computerPlayHelp
Purpose: This clause is responsible interpresing and performing the user's choice.
Parameters:
		-Choice- the validated user's choice.
		-GameList- the list of the game.
		-Lead- the lead card played by the first player (ee if computer is lead).
		-Out- will hold the Comptuer's card choice.
*/
computerPlayHelp(Choice, GameList, Lead, Out) :-
	Choice = 1,
	nl, write("Please enter a file name: "),
	read(FileName), 
	saveToFile(FileName, GameList),
	write("file saved!"), nl,
	halt(0).
computerPlayHelp(Choice, GameList, Lead, Out) :-
	getNextP(GameList, NextP),
	NextP = computer,
	Choice = 2,
	write("Computer please play a card: "), nl,
	getCHand(GameList, CHand),
	prepareCPlay(GameList, ImprovedHand),
	getBetterHand(CHand, ImprovedHand, FinalHand),
	leadStrategy(GameList, FinalHand, Out),
	write(Out), nl,nl.
computerPlayHelp(Choice, GameList, Lead, Out) :-
	getNextP(GameList, NextP),
	NextP = human,
	Choice = 2,
	write("Computer please play a card: "), nl,
	getCHand(GameList, CHand),
	chaseStrategy(GameList, Lead, CHand, Out).
computerPlayHelp(Choice, GameList, Lead, Out) :-
	Choice = 3,
	write("Thank you for playing, exiting game"), nl,
	halt(0).
	
/*
Clause Name: humanPlay
Purpose: This clasue is responsible for the human playing a card on its turn.
Parameters:
		-GameList- the list of the game.
		-Lead- the lead card played by the first player (ee if computer is lead).
		-BestCard- the best card from the human's hand.
*/
humanPlay(GameList, Lead, HumanCard) :-
	write("1. Save the game"), nl,
	write("2. Make a move"), nl,
	write("3. Quit the game"), nl,
	write("4. Ask for help"), nl,
	read(Choice),
	validateHMenu(Choice, FinalChoice),
	humanPlayHelp(FinalChoice, GameList, Lead, HumanCard).
	
/*
Clause Name: humanPlayHelp
Purpose: This clause is responsible interpresing and performing the user's choice.
Parameters:
		-Choice- the validated user's choice.
		-GameList- the list of the game.
		-Lead- the lead card played by the first player (ee if human is lead).
		-Out- will hold the human's card choice.
*/
humanPlayHelp(Choice, GameList, Lead, Out) :-	
	Choice = 1,
	nl, write("Please enter a file name: "),
	read(FileName), 
	saveToFile(FileName, GameList),
	write("file saved!"), nl,
	halt(0).
humanPlayHelp(Choice, GameList, Lead, Out) :-
	Choice = 2,
	getHHand(GameList, HHand),
	write("Human please play a card: "),
	read(Input),
	validateCard(HHand, Input, Out).
humanPlayHelp(Choice, GameList, Lead, Out) :-
	Choice = 3,
	write("Thank you for playing, exiting game"), nl,
	halt(0).
humanPlayHelp(Choice, GameList, Lead, Out) :-
	Choice = 4,
	getNextP(GameList, NextP),
	NextP = human,
	write("Computer recommends: "), nl,
	getHHand(GameList, HHand),
	leadStrategy(GameList, HHand, Reccomanded),
	write("Human please play a card: "),
	read(Input),
	validateCard(HHand, Input, Out).
humanPlayHelp(Choice, GameList, Lead, Out) :-
	Choice = 4,
	getNextP(GameList, NextP),
	NextP = computer,
	write("Computer recommends: "), nl,
	getHHand(GameList, HHand),
	prepareHPlay(GameList, ImprovedHand),
	getBetterHand(HHand, ImprovedHand, FinalHand),
	chaseStrategy(GameList, Lead, FinalHand, Reccomanded),
	write("Human please play a card: "),
	read(Input),
	validateCard(HHand, Input, Out).

/*
Clause Name: getBetterHand
Purpose: This clause is will make sure the player's hand is not an empty list after
			removing the meld cards.
Parameters:
		-Hand- the player's initial hand.
		-ImprovedHand- the player's hand after removing the meld cards.
		-FinalHand- the final hand (will be improved hand if it's not
				empty, hand otherwise).
*/
getBetterHand(Hand, ImprovedHand, FinalHand) :-
	ImprovedHand = [],
	FinalHand = Hand.
getBetterHand(Hand, ImprovedHand, FinalHand) :-
	FinalHand = ImprovedHand.

/*
Clause Name: validateCard
Purpose: This clause is responsible validating the card the user's inputed
			exists in the human's hand.
Parameters:
		-Hand- the player's hand.
		-UserCard- the card that the user inputted.
		FinalCard- will hold a validated user card (if it exists in the user's hand).
*/
validateCard(Hand, UserCard, FinalCard) :-
	isCardValid(Hand, UserCard, Result),
	Result = 1,
	FinalCard = UserCard.
validateCard(Hand, UserCard, FinalCard) :-
	isCardValid(Hand, UserCard, Result),
	Result = 0,
	write("card is not valid, please try again: "),
	read(NewCard),
	validateCard(Hand, NewCard, FinalCard).

/*
Clause Name: isCardValid
Purpose: This clause is responsible going over the player's hand recursively and determine if a
			specific card exists in the player's hand.
Parameters:
		-List1- a list conaining the cards from the player's hand.
		-Card1-the card that needs to be validated.
		-Result- 1 if the card exists in hand, 0 otherwise.
*/
isCardValid([], Card1, Result) :-
	Result = 0.
isCardValid(List1, Card1, Result) :-
	[First | Rest] = List1,
	First = Card1,
	Result = 1.
isCardValid(List1, Card1, Result) :-
	[First | Rest] = List1,
	First \= Card1,
	isCardValid(Rest, Card1, Result).

/*
Clause Name: winner
Purpose: This clause is responsible for determining the winner of the turn
		(lead or chase player).
Parameters:
		-Lead- a card holding the lead card of the turn.
		-Chase- a card holding the chase	card of the turn.
		-Trump- a card holding the trump card of the current round.
		-Winner- will hold lead if lead player won, or chase if
				chase player won.
*/
winner(Lead, Chase, Trump, Winner) :-
	getSuit(Lead, LeadSuit),
	getSuit(Chase, ChaseSuit),
	getSuit(Trump, TrumpSuit),
	getCardIndex(Lead, LeadIndex),
	getCardIndex(Chase, ChaseIndex),
	winnerHelp(LeadSuit, ChaseSuit, TrumpSuit, LeadIndex, ChaseIndex, Winner).
	
/*
Clause Name: winner
Purpose: This clause is responsible will help the winner clause to determine
			the winner.
Parameters:
		-LeadSuit- the suit of the lead card.
		-ChaseSuit- the suit of the chase card.
		-TrumpSuit- the suit of the trump card.
		-LeadIndex- the index of the lead card.
		-ChaseIndex- the index of the chase card.
		-Winner- will hold lead if lead player won, or chase if
				chase player won.
*/
winnerHelp(LeadSuit, ChaseSuit, TrumpSuit, LeadIndex, ChaseIndex, Winner) :-
	LeadSuit = TrumpSuit,
	ChaseSuit = TrumpSuit,
	ChaseIndex > LeadIndex,
	Winner = chase.
winnerHelp(LeadSuit, ChaseSuit, TrumpSuit, LeadIndex, ChaseIndex, Winner) :-
	LeadSuit = TrumpSuit,
	ChaseSuit = TrumpSuit,
	ChaseIndex =< LeadIndex,
	Winner = lead.
winnerHelp(LeadSuit, ChaseSuit, TrumpSuit, LeadIndex, ChaseIndex, Winner) :-
	LeadSuit = TrumpSuit,
	ChaseSuit \= TrumpSuit,
	Winner = lead.
winnerHelp(LeadSuit, ChaseSuit, TrumpSuit, LeadIndex, ChaseIndex, Winner) :-
	LeadSuit \= TrumpSuit,
	ChaseSuit = LeadSuit,
	ChaseIndex > LeadIndex,
	Winner = chase.
winnerHelp(LeadSuit, ChaseSuit, TrumpSuit, LeadIndex, ChaseIndex, Winner) :-
	LeadSuit \= TrumpSuit,
	ChaseSuit = LeadSuit,
	ChaseIndex =< LeadIndex,
	Winner = lead.
winnerHelp(LeadSuit, ChaseSuit, TrumpSuit, LeadIndex, ChaseIndex, Winner) :-
	LeadSuit \= TrumpSuit,
	ChaseSuit = TrumpSuit,
	Winner = chase.
winnerHelp(LeadSuit, ChaseSuit, TrumpSuit, LeadIndex, ChaseIndex, Winner) :-
	LeadSuit \= TrumpSuit,
	ChaseSuit \= TrumpSuit,
	ChaseSuit \= LeadSuit,
	Winner = lead.

/*
Clause Name: saveToFile
Purpose: This clause is responsible for saving the current game
			(game list) into a file.
Parameters:
		-FileName-the name of the file to save the game into.
		-GameList- the list of the game in which we are saving.
*/
saveToFile(FileName, GameList) :-
	getRoundNum(GameList, RNum),
	getTrump(GameList, Trump),
	getStock(GameList, Stock),
	
	getCHand(GameList, CHand),
	getCCapture(GameList, CCapture),
	getCMeld(GameList, CMeld),
	getCRoundScore(GameList, CRoundScore),
	getCGameScore(GameList, CGameScore),
	
	getHHand(GameList, HHand),
	getHCapture(GameList, HCapture),
	getHMeld(GameList, HMeld),
	getHRoundScore(GameList, HRoundScore),
	getHGameScore(GameList, HGameScore),
	getNextP(GameList, NextP),
	
	open(FileName, write, Out),
	write(Out, '['), nl(Out),
	write(Out, '   % round:'), nl(Out),
	write(Out, '   '), write(Out, RNum), write(Out, ','), nl(Out),
	
	nl(Out),
	
	write(Out, '   % computer score'), nl(Out),
	write(Out, '   '), write(Out, CGameScore), write(Out, ', '), write(Out, CRoundScore), write(Out, ', '), nl(Out),
	write(Out, '   % computer hand'), nl(Out),
	write(Out, '   '), write(Out, CHand), write(Out, ', '), nl(Out),
	write(Out, '   % computer capture pile'), nl(Out),
	write(Out, '   '), write(Out, CCapture), write(Out, ', '), nl(Out),
	write(Out, '   % computer melds'), nl(Out),
	write(Out, '   '), write(Out, CMeld), write(Out, ', '), nl(Out),
	
	nl(Out),
	
	write(Out, '   % human score'), nl(Out),
	write(Out, '   '), write(Out, HGameScore), write(Out, ', '), write(Out, HRoundScore), write(Out, ', '), nl(Out),
	write(Out, '   % human hand'), nl(Out),
	write(Out, '   '), write(Out, HHand), write(Out, ', '), nl(Out),
	write(Out, '   % human capture pile'), nl(Out),
	write(Out, '   '), write(Out, HCapture), write(Out, ', '), nl(Out),
	write(Out, '   % human melds'), nl(Out),
	write(Out, '   '), write(Out, HMeld), write(Out, ', '), nl(Out),
	
	nl(Out),
	
	write(Out, '   % trump card'), nl(Out),
	write(Out, '   '), write(Out, Trump), write(Out, ', '), nl(Out),
	
	nl(Out),
	
	write(Out, '   % stock pile'), nl(Out),
	write(Out, '   '), write(Out, Stock), write(Out, ', '), nl(Out),
	
	nl(Out),
	
	write(Out, '   % next player'), nl(Out),
	write(Out, '   '), write(Out, NextP), nl(Out),
	
	write(Out, '].'), nl(Out),
	
	close(Out).

/*
Clause Name: readFromFile
Purpose: This clause is responsible for reading a file namee and then
				reading a game from a file into a list.
Parameters:
		-LoadedList- will hold the game list containing the
			information from the file. 
*/
readFromFile(LoadedList) :-
	write("Please enter a file name: "),
	read(FileName),
	open(FileName, read, In),
	read(In, LoadedList),
	close(In).

























	 
	
	
	
	
	