
/*
Clause Name: readMeldList
Purpose: This function is responsible reading the user's meld list.
Parameters:
       -L1- the list of cards the user is inputting.
			the player.
	   -FinalList- will hold a list containing the user's complete list
			representing the meld list
*/
readMeldList(L1, FinalList) :-
	read(Card1),
	Card1 \= 'm',
	NewList = [Card1 | L1],
	readMeldList(NewList, FinalList).
readMeldList(NewList, FinalList) :-
	FinalList = NewList.
	
/*
Clause Name: wouldYouMeld
Purpose: This function is responsible telling the player if it can
		perform a meld.
Parameters:
		-NewRoundList- a list that contains all the round information.
		-MeldNameCode- a number associated with the meld's name.
		-TurnWinner- the name of the player that is making the meld
			(human or computer).
		-OutputList- will hold a list containing the meld cards if a
			meld is possible, false otherwise.
*/
wouldYouMeld(NewRoundList, MeldNameCode, TurnWinner, OutputList) :-
	MeldNameCode = 0,
	OutputList = [].
wouldYouMeld(NewRoundList, MeldNameCode, TurnWinner, OutputList) :-
	TurnWinner = computer,
	getCHand(NewRoundList, CHand),
	getTrump(NewRoundList, Trump),
	getCMeld(NewRoundList, CMeld),
	wouldYouHelp(CHand, CMeld, Trump, MeldNameCode, OutputList).
wouldYouMeld(NewRoundList, MeldNameCode, TurnWinner, OutputList) :-
	TurnWinner = human,
	write("Enter the meld cards, when you are done, enter 'm'"), nl,
	readMeldList([], HList),
	getTrump(NewRoundList, Trump),
	getHMeld(NewRoundList, HMeld),
	wouldYouHelp(HList, HMeld, Trump, MeldNameCode, OutputList).	
	
/*
Clause Name: wouldYouHelp
Purpose: This is a helper function for wouldYouMeld. This function actually calls
		  the try meld clauses and returns the meld list.
Parameters:
		-MeldList- a list that contains the cards for the meld.
		-PrevMelds- a list that contains the user's previous melds.
		-Trump- the trump card of the current round.
		-MeldNameCode- a number associated with the meld the player
			is trying to perform.
		-FinalList- will hold a list containing the meld cards if a
			meld is possible, or an empty list of no meld is possible.
*/
wouldYouHelp(MeldList, PrevMelds, Trump, MeldNameCode, FinalList) :-
	MeldNameCode = 1,
	tryFlush(MeldList, Trump, PrevMelds, FinalList).
wouldYouHelp(MeldList, PrevMelds, Trump, MeldNameCode, FinalList) :-
	MeldNameCode = 2,
	tryFourA(MeldList, PrevMelds, FinalList).
wouldYouHelp(MeldList, PrevMelds, Trump, MeldNameCode, FinalList) :-
	MeldNameCode = 3,
	tryFourK(MeldList, PrevMelds, FinalList).
wouldYouHelp(MeldList, PrevMelds, Trump, MeldNameCode, FinalList) :-
	MeldNameCode = 4,
	tryFourQ(MeldList, PrevMelds, FinalList).
wouldYouHelp(MeldList, PrevMelds, Trump, MeldNameCode, FinalList) :-
	MeldNameCode = 5,
	tryRoyalMarriage(MeldList, Trump, PrevMelds, FinalList).
wouldYouHelp(MeldList, PrevMelds, Trump, MeldNameCode, FinalList) :-
	MeldNameCode = 6,
	tryFourJ(MeldList, PrevMelds, FinalList).
wouldYouHelp(MeldList, PrevMelds, Trump, MeldNameCode, FinalList) :-
	MeldNameCode = 7,
	tryPinochle(MeldList, PrevMelds, FinalList).
wouldYouHelp(MeldList, PrevMelds, Trump, MeldNameCode, FinalList) :-
	MeldNameCode = 8,
	tryMarriage(MeldList, PrevMelds, FinalList).
wouldYouHelp(MeldList, PrevMelds, Trump, MeldNameCode, FinalList) :-
	MeldNameCode = 9,
	tryDix(MeldList, Trump, PrevMelds, FinalList).

/*
Clause Name: meldName
Purpose: This function is responsible for finding the best meld to perform
		using the computer's strategy.
Parameters:
		-GameList- a list of lists and numbers that contain all the game
				infrmation.
		-TurnWinner- the name of the player won the last turn and has the
				option of making a meld (human or computer).
		-MeldNum- will hold a number associated with the best meld the
				computer or human can perform (0 if no possible meld).
*/
meldName(GameList, TurnWinner, MeldNum) :-
	TurnWinner = computer,
	computerPlayingMeld(GameList, ComputerChoice),
	ComputerChoice = 1,
	write(TurnWinner),
	write(", if you want to play a meld press 1, otherwise press 2: "),
	write(ComputerChoice), nl,
	getCHand(GameList, CHand),
	getTrump(GameList, Trump),
	getCMeld(GameList, CMeld),
	
	computerMeldNumber(CHand, CMeld, Trump, MeldNum),
	write("Please enter the number associated with the meld name: "), nl,
	write("1 - Flush Meld"), nl,
	write("2 - Four Aces Meld"), nl,
	write("3 - Four Kings Meld"), nl,
	write("4 - Four Queens Meld"), nl,
	write("5 - Royal Marriage Meld"), nl,
	write("6 - Four Jacks Meld"), nl,
	write("7 - Pinochle Meld"), nl,
	write("8 - Marriage Meld"), nl,
	write("9 - Dix Meld"), nl,
	write(MeldNum), nl.
meldName(GameList, TurnWinner, MeldNum) :-
	TurnWinner = computer,
	write(TurnWinner),
	computerPlayingMeld(GameList, ComputerChoice),
	ComputerChoice \= 1,
	write(", if you want to play a meld press 1, otherwise press 2: "),
	write(ComputerChoice),
	MeldNum = 0.
meldName(GameList, TurnWinner, MeldNum) :-
	TurnWinner = human,
	write(TurnWinner),
	write(", if you want help with the best meld press 1, otherwise press 2: "),
	read(Choice1),
	vali(Choice1, FinalChoice1),
	meldHelper(FinalChoice1, GameList),
	write("If you want to play a meld press 1, otherwise press 2: "),
	read(Choice2),
	vali(Choice2, FinalChoice2),
	meldMelder(FinalChoice2, MeldNum).	

/*
Clause Name: meldHelper
Purpose: This function is a helpter function for the meldName function. It
		  is responsible to act according to the user input
Parameters:
		-Input- a number representing the user's choice (of whether they
				want help with a meld or not).
		-GameList- a list of lists and numbers that contain all the game
				infrmation.
*/
meldHelper(Input, GameList) :-
	Input \= 1.
meldHelper(Input, GameList) :-
	Input = 1,
	getHHand(GameList, HHand), getTrump(GameList, Trump), getHMeld(GameList, HMeld),
	computerMeldNumber(HHand, HMeld, Trump, MeldNum),
	MeldNum = 1,
	write("Computer recommends: Flush Meld"), nl.
meldHelper(Input, GameList) :-
	Input = 1,
	getHHand(GameList, HHand), getTrump(GameList, Trump), getHMeld(GameList, HMeld),
	computerMeldNumber(HHand, HMeld, Trump, MeldNum),
	MeldNum = 2,
	write("Computer recommends: Four Aces Meld"), nl.
meldHelper(Input, GameList) :-
	Input = 1,
	getHHand(GameList, HHand), getTrump(GameList, Trump), getHMeld(GameList, HMeld),
	computerMeldNumber(HHand, HMeld, Trump, MeldNum),
	MeldNum = 3,
	write("Computer recommends: Four Kings Meld"), nl.
meldHelper(Input, GameList) :-
	Input = 1,
	getHHand(GameList, HHand), getTrump(GameList, Trump), getHMeld(GameList, HMeld),
	computerMeldNumber(HHand, HMeld, Trump, MeldNum),
	MeldNum = 4,
	write("Computer recommends: Four Queens Meld"), nl.
meldHelper(Input, GameList) :-
	Input = 1,
	getHHand(GameList, HHand), getTrump(GameList, Trump), getHMeld(GameList, HMeld),
	computerMeldNumber(HHand, HMeld, Trump, MeldNum),
	MeldNum = 5,
	write("Computer recommends: Royal Marriage"), nl.
meldHelper(Input, GameList) :-
	Input = 1,
	getHHand(GameList, HHand), getTrump(GameList, Trump), getHMeld(GameList, HMeld),
	computerMeldNumber(HHand, HMeld, Trump, MeldNum),
	MeldNum = 6,
	write("Computer recommends: Four Jacks Meld"), nl.
meldHelper(Input, GameList) :-
	Input = 1,
	getHHand(GameList, HHand), getTrump(GameList, Trump), getHMeld(GameList, HMeld),
	computerMeldNumber(HHand, HMeld, Trump, MeldNum),
	MeldNum = 7,
	write("Computer recommends: Pinochle Meld"), nl.
meldHelper(Input, GameList) :-
	Input = 1,
	getHHand(GameList, HHand), getTrump(GameList, Trump), getHMeld(GameList, HMeld),
	computerMeldNumber(HHand, HMeld, Trump, MeldNum),
	MeldNum = 8,
	write("Computer recommends: Marriage Meld"), nl.
meldHelper(Input, GameList) :-
	Input = 1,
	getHHand(GameList, HHand), getTrump(GameList, Trump), getHMeld(GameList, HMeld),
	computerMeldNumber(HHand, HMeld, Trump, MeldNum),
	MeldNum = 9,
	write("Computer recommends: Dix Meld"), nl.
meldHelper(Input, GameList) :-
	Input = 1,
	getHHand(GameList, HHand), getTrump(GameList, Trump), getHMeld(GameList, HMeld),
	computerMeldNumber(HHand, HMeld, Trump, MeldNum),
	MeldNum = 0,
	write("No possible melds at the moment"), nl.
	
/*
Clause Name: meldHelper
Purpose: This function is another helper function for the meldName
		  function. It is responsible to act according to the user input.
Parameters:
		-Input- a number representing the user's choice (of whether they
			want to perform a or not).
		-MeldNum- a number representing the meld they user is trying to
			make.
*/
meldMelder(Input, MeldNum) :-
	Input \= 1,
	MeldNum = 0.
meldMelder(Input, MeldNum) :-
	Input = 1,
	write("Please enter the number associated with the meld name: "), nl,
	write("1 - Flush Meld"), nl,
	write("2 - Four Aces Meld"), nl,
	write("3 - Four Kings Meld"), nl,
	write("4 - Four Queens Meld"), nl,
	write("5 - Royal Marriage Meld"), nl,
	write("6 - Four Jacks Meld"), nl,
	write("7 - Pinochle Meld"), nl,
	write("8 - Marriage Meld"), nl,
	write("9 - Dix Meld"), nl,
	write("-->"),
	read(Choice),
	validateMeldNumber(Choice, MeldNum).
	
/*
Clause Name: computerMeldNumber
Purpose: This function is responsible for figuring out what is the best
		  meld to perform with the player's hand.
Parameters:
		-Hand- a list of atoms representing the hand of the player that
			is trying to perform a meld.
		-PreviousMelds- a list representing the player's previous melds.
		-MeldList- a list of atoms representing the cards for the user's
			meld.
		-Trump- an atom representing the trump card of the game.
		-MeldNumber- will hold a number associated with the best meld to perform,
			or 0 if no meld is possible.
*/
computerMeldNumber(Hand, PreviousMelds, Trump, MeldNumber) :-
	tryFlush(Hand, Trump, PreviousMelds, FlushList),
	FlushList \= [],
	MeldNumber = 1.
computerMeldNumber(Hand, PreviousMelds, Trump, MeldNumber) :-
	tryFourA(Hand, PreviousMelds, FourAList),
	FourAList \= [],
	MeldNumber = 2.
computerMeldNumber(Hand, PreviousMelds, Trump, MeldNumber) :-
	tryFourK(Hand, PreviousMelds, FourKList),
	FourKList \= [],
	MeldNumber = 3.
computerMeldNumber(Hand, PreviousMelds, Trump, MeldNumber) :-
	tryFourQ(Hand, PreviousMelds, FourQList),
	FourQList \= [],
	MeldNumber = 4.
computerMeldNumber(Hand, PreviousMelds, Trump, MeldNumber) :-
	tryRoyalMarriage(Hand, Trump, PreviousMelds, RoyalMList),
	RoyalMList \= [],
	MeldNumber = 5.
computerMeldNumber(Hand, PreviousMelds, Trump, MeldNumber) :-
	tryFourJ(Hand, PreviousMelds, FourJList),
	FourJList \= [],
	MeldNumber = 6.
computerMeldNumber(Hand, PreviousMelds, Trump, MeldNumber) :-
	tryPinochle(Hand, PreviousMelds, PinochleList),
	PinochleList \= [],
	MeldNumber = 7.
computerMeldNumber(Hand, PreviousMelds, Trump, MeldNumber) :-
	tryMarriage(Hand, PreviousMelds, MarriageList),
	MarriageList \= [],
	MeldNumber = 8.
computerMeldNumber(Hand, PreviousMelds, Trump, MeldNumber) :-
	tryDix(Hand, Trump, PreviousMelds, DixList),
	DixList \= [],
	MeldNumber = 9.
computerMeldNumber(Hand, PreviousMelds, Trump, MeldNumber) :-
	MeldNumber = 0.

tryingNew(Hand, PreviousMelds, Trump, MeldNumber) :-
	tryFlush(Hand, Trump, PreviousMelds, FlushList),
	write(FlushList), nl.

/*
Clause Name: validateMeldNumber
Purpose: This function is responsible for validating the meld number
		  (should be 1-9).
Parameters:
		-Choice- the number (user input) to be validated.
		-Final- the validaed user choice.
*/
validateMeldNumber(Choice, Final) :-
	Choice \= 1,
	Choice \= 2,
	Choice \= 3,
	Choice \= 4,
	Choice \= 5,
	Choice \= 6,
	Choice \= 7,
	Choice \= 8,
	Choice \= 9,
	write("Input is not valid, please try again: \n"),
	read(NewChoice),
	validateMeldNumber(NewChoice, Final).

validateMeldNumber(Choice, Final) :-
	Final = Choice.

/*
Clause Name: pointsForMeld
Purpose: This function is responsible for evaluating the point
		  for a performed meld.
Parameters:
		-MeldList- a list of (atom) cards, representing the cards used
			to perform the meld.
		-MeldNameCode- a number associated with the name of the meld that
			was performed.
		-Points- will hold a nubmer representing the amount of point the
			player is getting for performing the meld.
*/
pointsForMeld(MeldList, MeldNamecode, Points) :-
	MeldList \= [],
	MeldNamecode = 1,
	Points = 150.
pointsForMeld(MeldList, MeldNamecode, Points) :-
	MeldList \= [],
	MeldNamecode = 2,
	Points = 100.
pointsForMeld(MeldList, MeldNamecode, Points) :-
	MeldList \= [],
	MeldNamecode = 3,
	Points = 80.
pointsForMeld(MeldList, MeldNamecode, Points) :-
	MeldList \= [],
	MeldNamecode = 4,
	Points = 60.
pointsForMeld(MeldList, MeldNamecode, Points) :-
	MeldList \= [],
	MeldNamecode = 5,
	Points = 40.
pointsForMeld(MeldList, MeldNamecode, Points) :-
	MeldList \= [],
	MeldNamecode = 6,
	Points = 40.
pointsForMeld(MeldList, MeldNamecode, Points) :-
	MeldList \= [],
	MeldNamecode = 7,
	Points = 40.
pointsForMeld(MeldList, MeldNamecode, Points) :-
	MeldList \= [],
	MeldNamecode = 8,
	Points = 20.
pointsForMeld(MeldList, MeldNamecode, Points) :-
	MeldList \= [],
	MeldNamecode = 9,
	Points = 10.
pointsForMeld(MeldList, MeldNamecode, Points) :-
	Points = 0 .

/*
Clause Name: computerPlayingMeld
Purpose: This function is responsible for checking whether any meld is possible
		  or not with the computer's hand.
Parameters:
		-GameList- a list of lists and numbers that contain all the game
			infrmation.
		-Answer- will hold a number representing whether or not the computer
			can perform a meld (1 if it can, 2 if it can't).
*/
computerPlayingMeld(GameList, Answer) :-
	getCHand(GameList, CHand),
	getTrump(GameList, Trump),
	getCMeld(GameList, CMeld),
	tryFlush(CHand, Trump, CMeld, FlushList),
	FlushList \= [],
	Answer = 1.
computerPlayingMeld(GameList, Answer) :-
	getCHand(GameList, CHand),
	getCMeld(GameList, CMeld),
	tryFourA(CHand, CMeld, FourAList),
	FourAList \= [],
	Answer = 1.
computerPlayingMeld(GameList, Answer) :-
	getCHand(GameList, CHand),
	getCMeld(GameList, CMeld),
	tryFourK(CHand, CMeld, FourKList),
	FourKList \= [],
	Answer = 1.
computerPlayingMeld(GameList, Answer) :-
	getCHand(GameList, CHand),
	getCMeld(GameList, CMeld),
	tryFourQ(CHand, CMeld, FourQList),
	FourQList \= [],
	Answer = 1.
computerPlayingMeld(GameList, Answer) :-
	getCHand(GameList, CHand),
	getTrump(GameList, Trump),
	getCMeld(GameList, CMeld),
	tryRoyalMarriage(CHand, Trump, CMeld, RoyalMList),
	RoyalMList \= [],
	Answer = 1.	
computerPlayingMeld(GameList, Answer) :-
	getCHand(GameList, CHand),
	getCMeld(GameList, CMeld),
	tryFourJ(CHand, CMeld, FourJList),
	FourJList \= [],
	Answer = 1.
computerPlayingMeld(GameList, Answer) :-
	getCHand(GameList, CHand),
	getCMeld(GameList, CMeld),
	tryPinochle(CHand, CMeld, PinochleList),
	PinochleList \= [],
	Answer = 1.
computerPlayingMeld(GameList, Answer) :-
	getCHand(GameList, CHand),
	getCMeld(GameList, CMeld),
	tryMarriage(CHand, CMeld, MarriageList),
	MarriageList \= [],
	Answer = 1.
computerPlayingMeld(GameList, Answer) :-
	getCHand(GameList, CHand),
	getTrump(GameList, Trump),
	getCMeld(GameList, CMeld),
	tryDix(CHand, Trump, CMeld, DixList),
	DixList \= [],
	Answer = 1.
computerPlayingMeld(GameList, Answer) :-
	Answer = 2 .
	
/*
Clause Name: getRidOfMeldCards
Purpose: This function will remove the cards of the best possible meld from the
		  player's hand before playing the turn (providing this doesn't leave
		  the user with an empty hand. This way, possible are taken into
		  consideration before playing the turn.
Parameters:
		-Hand- a list of atoms representing the hand of the player that
			is trying to perform a meld.
		-MeldNum- a number representing the best meld possible for the player.
		-Trump- an atom representing the trump card of the game.
		-MeldList- a list of atoms representing the cards for the user's
			meld.
		-FinalHand-will hold the player's hand minus the best meld cards,
			if removing the meld cards results in an empty hand, this will
			hold the player's original hand.
*/
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 1,
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'h',
	dropCard(Hand, ah, Hand2),
	dropCard(Hand2, xh, Hand3),
	dropCard(Hand3, kh, Hand4),
	dropCard(Hand4, qh, Hand5),
	dropCard(Hand5, jh, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 1,
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 's',
	dropCard(Hand, as, Hand2),
	dropCard(Hand2, xs, Hand3),
	dropCard(Hand3, ks, Hand4),
	dropCard(Hand4, qs, Hand5),
	dropCard(Hand5, js, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 1,
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'c',
	dropCard(Hand, ac, Hand2),
	dropCard(Hand2, xc, Hand3),
	dropCard(Hand3, kc, Hand4),
	dropCard(Hand4, qc, Hand5),
	dropCard(Hand5, jc, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 1,
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'd',
	dropCard(Hand, ad, Hand2),
	dropCard(Hand2, xd, Hand3),
	dropCard(Hand3, kd, Hand4),
	dropCard(Hand4, qd, Hand5),
	dropCard(Hand5, jd, FinalHand).	
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 2,	
	dropCard(Hand, ah, Hand2),
	dropCard(Hand2, as, Hand3),
	dropCard(Hand3, ac, Hand4),
	dropCard(Hand4, ad, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 3,	
	dropCard(Hand, kh, Hand2),
	dropCard(Hand2, ks, Hand3),
	dropCard(Hand3, kc, Hand4),
	dropCard(Hand4, kd, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 4,	
	dropCard(Hand, qh, Hand2),
	dropCard(Hand2, qs, Hand3),
	dropCard(Hand3, qc, Hand4),
	dropCard(Hand4, qd, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 5,
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'h',
	dropCard(Hand, kh, Hand2),
	dropCard(Hand2, qh, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 5,
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 's',
	dropCard(Hand, ks, Hand2),
	dropCard(Hand2, qs, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 5,
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'c',
	dropCard(Hand, kc, Hand2),
	dropCard(Hand2, qc, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 5,
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'd',
	dropCard(Hand, kd, Hand2),
	dropCard(Hand2, qd, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 6,	
	dropCard(Hand, jh, Hand2),
	dropCard(Hand2, js, Hand3),
	dropCard(Hand3, jc, Hand4),
	dropCard(Hand4, jd, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 7,	
	dropCard(Hand, qs, Hand2),
	dropCard(Hand2, jd, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 8,
	[First | _] = MeldList,
	getSuit(First, FirstSuit),
	FirstSuit = 'h',
	dropCard(Hand, kh, Hand2),
	dropCard(Hand2, qh, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 8,
	[First | _] = MeldList,
	getSuit(First, FirstSuit),
	FirstSuit = 's',
	dropCard(Hand, ks, Hand2),
	dropCard(Hand2, qs, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 8,
	[First | _] = MeldList,
	getSuit(First, FirstSuit),
	FirstSuit = 'c',
	dropCard(Hand, kc, Hand2),
	dropCard(Hand2, qc, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 8,
	[First | _] = MeldList,
	getSuit(First, FirstSuit),
	FirstSuit = 'd',
	dropCard(Hand, kd, Hand2),
	dropCard(Hand2, qd, FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 9,
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'h',
	dropCard(Hand, '9h', FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 9,
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 's',
	dropCard(Hand, '9s', FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 9,
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'c',
	dropCard(Hand, '9c', FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	MeldNum = 9,
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'd',
	dropCard(Hand, '9d', FinalHand).
getRidOfMeldCards(Hand, MeldNum, Trump, MeldList, FinalHand) :-
	FinalHand = Hand.
	
/*
Clause Name: didPerform clauses
Purpose: The purpose of these clauses is to determine whether or not the player
			has already performed that specific meld.
Parameters:
		Trump- the trump card of the current round (only sent in the functions
			of a meld that depends on the trump card (ex. flush).
		-PlayerPreviousMelds- a list of lists, each inner list contains a list
			of atoms, each representing the cards of a meld that player has
			performed. This	is the previous	melds list of the player.
		-Result- will hold 1 if the meld exists in the playerPreviousMelds list,
			0 otherwise.
		
*/
didPerformFlush(Trump, [], Result) :-
	Result = 0 .
didPerformFlush(Trump, PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck = [],
	Result = 0 .
didPerformFlush(Trump, PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck \= [],
	length(CurrentCheck, CurrentLength),
	CurrentLength = 5,
	aceOfTrump(CurrentCheck, Trump, AT),
	tenOfTrump(CurrentCheck, Trump, XT),
	kingOfTrump(CurrentCheck, Trump, KT),
	queenOfTrump(CurrentCheck, Trump, QT),
	jackOfTrump(CurrentCheck, Trump, JT),
	AT = 1,
	XT = 1,
	KT = 1,
	QT = 1,
	JT = 1,
	Result = 1.
didPerformFlush(Trump, PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	didPerformFlush(Trump, Rest, Result).
	
/*------------------------------------------------------------------*/
didPerformFourA([], Result) :-
	Result = 0.
didPerformFourA(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck = [],
	Result = 0.
didPerformFourA(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck \= [],
	length(CurrentCheck, CurrentLength),
	CurrentLength = 4,
	aceOfHearts(CurrentCheck, AH),
	aceOfSpades(CurrentCheck, AS),
	aceOfClubs(CurrentCheck, AC),
	aceOfDiamonds(CurrentCheck, AD),
	AH = 1,
	AS = 1,
	AC = 1,
	AD = 1,
	Result = 1.
didPerformFourA(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	didPerformFourA(Rest, Result).
	
/*------------------------------------------------------------------*/
didPerformFourK([], Result) :-
	Result = 0.
didPerformFourK(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck = [],
	Result = 0.
didPerformFourK(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck \= [],
	length(CurrentCheck, CurrentLength),
	CurrentLength = 4,
	kingOfHearts(CurrentCheck, KH),
	kingOfSpades(CurrentCheck, KS),
	kingOfClubs(CurrentCheck, KC),
	kingOfDiamonds(CurrentCheck, KD),
	KH = 1,
	KS = 1,
	KC = 1,
	KD = 1,
	Result = 1.
didPerformFourK(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	didPerformFourK(Rest, Result).

/*------------------------------------------------------------------*/
didPerformFourQ([], Result) :-
	Result = 0.
didPerformFourQ(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck = [],
	Result = 0.
didPerformFourQ(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck \= [],
	length(CurrentCheck, CurrentLength),
	CurrentLength = 4,
	queenOfHearts(CurrentCheck, QH),
	queenOfSpades(CurrentCheck, QS),
	queenOfClubs(CurrentCheck, QC),
	queenOfDiamonds(CurrentCheck, QD),
	QH = 1,
	QS = 1,
	QC = 1,
	QD = 1,
	Result = 1.
didPerformFourQ(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	didPerformFourQ(Rest, Result).

/*------------------------------------------------------------------*/
didPerformRoyalM(Trump, [], Result) :-
	Result = 0.
didPerformRoyalM(Trump, PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck = [],
	Result = 0.
didPerformRoyalM(Trump, PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck \= [],
	length(CurrentCheck, CurrentLength),
	CurrentLength = 2,
	kingOfTrump(CurrentCheck, Trump, KT),
	queenOfTrump(CurrentCheck, Trump, QT),
	KT = 1,
	QT = 1,
	Result = 1.
didPerformRoyalM(Trump, PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	didPerformRoyalM(Trump, Rest, Result).

/*------------------------------------------------------------------*/
didPerformFourJ([], Result) :-
	Result = 0.
didPerformFourJ(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck = [],
	Result = 0.
didPerformFourJ(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck \= [],
	length(CurrentCheck, CurrentLength),
	CurrentLength = 4,
	jackOfHearts(CurrentCheck, JH),
	jackOfSpades(CurrentCheck, JS),
	jackOfClubs(CurrentCheck, JC),
	jackOfDiamonds(CurrentCheck, JD),
	JH = 1,
	JS = 1,
	JC = 1,
	JD = 1,
	Result = 1.
didPerformFourJ(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	didPerformFourJ(Rest, Result).
	
/*------------------------------------------------------------------*/
didPerformPinochle([], Result) :-
	Result = 0.
didPerformPinochle(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck = [],
	Result = 0.
didPerformPinochle(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck \= [],
	length(CurrentCheck, CurrentLength),
	CurrentLength = 2,
	queenOfSpades(CurrentCheck, QS),
	jackOfDiamonds(CurrentCheck, JD),
	QS = 1,
	JD = 1,
	Result = 1.
didPerformPinochle(PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	didPerformPinochle(Rest, Result).
	
/*------------------------------------------------------------------*/
didPerformMarriage([], Type, Result) :-
	Result = 0.
didPerformMarriage(PlayerPreviousMelds, Type, Result) :-
	Type = h,
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	length(CurrentCheck, CurrentLength),
	CurrentLength = 2,
	kingOfHearts(CurrentCheck, KH),
	queenOfHearts(CurrentCheck, QH),
	KH = 1,
	QH = 1,
	Result = 1.
didPerformMarriage(PlayerPreviousMelds, Type, Result) :-
	Type = s,
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	length(CurrentCheck, CurrentLength),
	CurrentLength = 2,
	kingOfSpades(CurrentCheck, KS),
	queenOfSpades(CurrentCheck, QS),
	KS = 1,
	QS = 1,
	Result = 1.
didPerformMarriage(PlayerPreviousMelds, Type, Result) :-
	Type = c,
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	length(CurrentCheck, CurrentLength),
	CurrentLength = 2,
	kingOfClubs(CurrentCheck, KC),
	queenOfClubs(CurrentCheck, QC),
	KC = 1,
	QC = 1,
	Result = 1.
didPerformMarriage(PlayerPreviousMelds, Type, Result) :-
	Type = d,
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	length(CurrentCheck, CurrentLength),
	CurrentLength = 2,
	kingOfDiamonds(CurrentCheck, KD),
	queenOfDiamonds(CurrentCheck, QD),
	KD = 1,
	QD = 1,
	Result = 1.
didPerformMarriage(PlayerPreviousMelds, Type, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	didPerformMarriage(Rest, Type, Result).
	
/*------------------------------------------------------------------*/
didPerformDix(Trump, [], Result) :-
	Result = 0.
didPerformDix(Trump, PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck = [],
	Result = 0.
didPerformDix(Trump, PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	CurrentCheck \= [],
	length(CurrentCheck, CurrentLength),
	CurrentLength = 1,
	nineOfTrump(CurrentCheck, Trump, NT),
	NT = 1,
	Result = 1.
didPerformDix(Trump, PlayerPreviousMelds, Result) :-
	[CurrentCheck | Rest] = PlayerPreviousMelds,
	didPerformDix(Trump, Rest, Result).

/*
Clause Name: try clauses
Purpose: The purpose of these clauses is to determine whether a meld is possible
		  with a user provided meld list (list of cards).
Parameters:
		-MeldList- a list of atoms, erpresenting the player's cards in which
			they are trying to perform the meld.
	    -Trump- the trump card of the current round (only sent in the functions
			of a meld that	depends on the trump card (ex. flush).
	    -PreviousMelds- a list of lists, each inner list contains a list of
			cards, each representing a meld that player has performed. This is
			the previous melds list of the player.
		-EndList- will hold a list containing the meld cards if the meld is
			possible, or an empty list if the meld is not possible.
*/
tryFlush(MeldList, Trump, PreviousMelds, EndList) :-
	didPerformFlush(Trump, PreviousMelds, WasPerformed),
	WasPerformed = 1,
	EndList = [].
tryFlush(MeldList, Trump, PreviousMelds, EndList) :-
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'h',
	aceOfTrump(MeldList, Trump, AT),
	tenOfTrump(MeldList, Trump, XT),
	kingOfTrump(MeldList, Trump, KT),
	queenOfTrump(MeldList, Trump, QT),
	jackOfTrump(MeldList, Trump, JT),
	AT = 1,
	XT = 1,
	KT = 1,
	QT = 1,
	JT = 1,
	EndList = [ah, xh, kh, qh, jh].
tryFlush(MeldList, Trump, PreviousMelds, EndList) :-
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 's',
	aceOfTrump(MeldList, Trump, AT),
	tenOfTrump(MeldList, Trump, XT),
	kingOfTrump(MeldList, Trump, KT),
	queenOfTrump(MeldList, Trump, QT),
	jackOfTrump(MeldList, Trump, JT),
	AT = 1,
	XT = 1,
	KT = 1,
	QT = 1,
	JT = 1,
	EndList = [as, xs, ks, qs, js].
tryFlush(MeldList, Trump, PreviousMelds, EndList) :-
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'c',
	aceOfTrump(MeldList, Trump, AT),
	tenOfTrump(MeldList, Trump, XT),
	kingOfTrump(MeldList, Trump, KT),
	queenOfTrump(MeldList, Trump, QT),
	jackOfTrump(MeldList, Trump, JT),
	AT = 1,
	XT = 1,
	KT = 1,
	QT = 1,
	JT = 1,
	EndList = [ac, xc, kc, qc, jc].
tryFlush(MeldList, Trump, PreviousMelds, EndList) :-
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'd',
	aceOfTrump(MeldList, Trump, AT),
	tenOfTrump(MeldList, Trump, XT),
	kingOfTrump(MeldList, Trump, KT),
	queenOfTrump(MeldList, Trump, QT),
	jackOfTrump(MeldList, Trump, JT),
	AT = 1,
	XT = 1,
	KT = 1,
	QT = 1,
	JT = 1,
	EndList = [ad, xd, kd, qd, jd].
tryFlush(MeldList, Trump, PreviousMelds, EndList) :-
	EndList = [].

/*------------------------------------------------------------------*/	
tryFourA(MeldList, PreviousMelds, EndList) :-
	didPerformFourA(PreviousMelds, WasPerformed),
	WasPerformed = 1,
	EndList = [].
tryFourA(MeldList, PreviousMelds, EndList) :-
	aceOfHearts(MeldList, AH),
	aceOfSpades(MeldList, AS),
	aceOfClubs(MeldList, AC),
	aceOfDiamonds(MeldList, AD),
	AH = 1,
	AS = 1,
	AC = 1,
	AD = 1,
	EndList = [ah, as, ac, ad].
tryFourA(MeldList, PreviousMelds, EndList) :-
	EndList = [].
	
/*------------------------------------------------------------------*/
tryFourK(MeldList, PreviousMelds, EndList) :-
	didPerformFourK(PreviousMelds, WasPerformed),
	WasPerformed = 1,
	EndList = [].
tryFourK(MeldList, PreviousMelds, EndList) :-
	kingOfHearts(MeldList, KH),
	kingOfSpades(MeldList, KS),
	kingOfClubs(MeldList, KC),
	kingOfDiamonds(MeldList, KD),
	KH = 1,
	KS = 1,
	KC = 1,
	KD = 1,
	EndList = [kh, ks, kc, kd].
tryFourK(MeldList, PreviousMelds, EndList) :-
	EndList = [].
	
/*------------------------------------------------------------------*/
tryFourQ(MeldList, PreviousMelds, EndList) :-
	didPerformFourQ(PreviousMelds, WasPerformed),
	WasPerformed = 1,
	EndList = [].
tryFourQ(MeldList, PreviousMelds, EndList) :-
	queenOfHearts(MeldList, QH),
	queenOfSpades(MeldList, QS),
	queenOfClubs(MeldList, QC),
	queenOfDiamonds(MeldList, QD),
	QH = 1,
	QS = 1,
	QC = 1,
	QD = 1,
	EndList = [qh, qs, qc, qd].
tryFourQ(MeldList, PreviousMelds, EndList) :-
	EndList = [].

/*------------------------------------------------------------------*/
tryRoyalMarriage(MeldList, Trump, PreviousMelds, EndList) :-
	didPerformRoyalM(Trump, PreviousMelds, WasPerformed),
	WasPerformed = 1,
	EndList = [].
tryRoyalMarriage(MeldList, Trump, PreviousMelds, EndList) :-
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'h',
	kingOfTrump(MeldList, Trump, KT),
	queenOfTrump(MeldList, Trump, QT),
	KT = 1,
	QT = 1,
	EndList = [kh, qh].
tryRoyalMarriage(MeldList, Trump, PreviousMelds, EndList) :-
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 's',
	kingOfTrump(MeldList, Trump, KT),
	queenOfTrump(MeldList, Trump, QT),
	KT = 1,
	QT = 1,
	EndList = [ks, qs].
tryRoyalMarriage(MeldList, Trump, PreviousMelds, EndList) :-
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'c',
	kingOfTrump(MeldList, Trump, KT),
	queenOfTrump(MeldList, Trump, QT),
	KT = 1,
	QT = 1,
	EndList = [kc, qc].
tryRoyalMarriage(MeldList, Trump, PreviousMelds, EndList) :-
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'd',
	kingOfTrump(MeldList, Trump, KT),
	queenOfTrump(MeldList, Trump, QT),
	KT = 1,
	QT = 1,
	EndList = [kd, qd].
tryRoyalMarriage(MeldList, Trump, PreviousMelds, EndList) :-
	EndList = [].
	
/*------------------------------------------------------------------*/
tryFourJ(MeldList, PreviousMelds, EndList) :-
	didPerformFourJ(PreviousMelds, WasPerformed),
	WasPerformed = 1,
	EndList = [].
tryFourJ(MeldList, PreviousMelds, EndList) :-
	jackOfHearts(MeldList, JH),
	jackOfSpades(MeldList, JS),
	jackOfClubs(MeldList, JC),
	jackOfDiamonds(MeldList, JD),
	JH = 1,
	JS = 1,
	JC = 1,
	JD = 1,
	EndList = [jh, js, jc, jd].
tryFourJ(MeldList, PreviousMelds, EndList) :-
	EndList = [].
	
/*------------------------------------------------------------------*/
tryPinochle(MeldList, PreviousMelds, EndList) :-
	didPerformPinochle(PreviousMelds, WasPerformed),
	WasPerformed = 1,
	EndList = [].
tryPinochle(MeldList, PreviousMelds, EndList) :-
	queenOfSpades(MeldList, QS),
	jackOfDiamonds(MeldList, JD),
	QS = 1,
	JD = 1,
	EndList = [qs, jd].
tryPinochle(MeldList, PreviousMelds, EndList) :-
	EndList = [].
	
/*------------------------------------------------------------------*/
tryMarriage([], PreviousMelds, EndList) :-
	EndList = [].
tryMarriage(MeldList, PreviousMelds, EndList) :-
	[First | _] = MeldList,
	getSuit(First, Type),
	Type = 'h',
	didPerformMarriage(PreviousMelds, h, WasPerformed),
	WasPerformed = 1,
	EndList = [].
tryMarriage(MeldList, PreviousMelds, EndList) :-
	[First | _] = MeldList,
	getSuit(First, Type),
	Type = 's',
	didPerformMarriage(PreviousMelds, s, WasPerformed),
	WasPerformed = 1,
	EndList = [].
tryMarriage(MeldList, PreviousMelds, EndList) :-
	[First | _] = MeldList,
	getSuit(First, Type),
	Type = 'c',
	didPerformMarriage(PreviousMelds, c, WasPerformed),
	WasPerformed = 1,
	EndList = [].
tryMarriage(MeldList, PreviousMelds, EndList) :-
	[First | _] = MeldList,
	getSuit(First, Type),
	Type = 'd',
	didPerformMarriage(PreviousMelds, d, WasPerformed),
	WasPerformed = 1,
	EndList = [].
tryMarriage(MeldList, PreviousMelds, EndList) :-
	kingOfHearts(MeldList, KH),
	queenOfHearts(MeldList, QH),
	KH = 1,
	QH = 1,
	EndList = [kh, qh].
tryMarriage(MeldList, PreviousMelds, EndList) :-
	kingOfSpades(MeldList, KS),
	queenOfSpades(MeldList, QS),
	KS = 1,
	QS = 1,
	EndList = [ks, qs].
tryMarriage(MeldList, PreviousMelds, EndList) :-
	kingOfClubs(MeldList, KC),
	queenOfClubs(MeldList, QC),
	KC = 1,
	QC = 1,
	EndList = [kc, qc].
tryMarriage(MeldList, PreviousMelds, EndList) :-
	kingOfDiamonds(MeldList, KD),
	queenOfDiamonds(MeldList, QD),
	KD = 1,
	QD = 1,
	EndList = [kd, qd].
	
/*------------------------------------------------------------------*/
tryDix(MeldList, Trump, PreviousMelds, EndList) :-
	didPerformDix(Trump, PreviousMelds, WasPerformed),
	WasPerformed = 1,
	EndList = [].
tryDix(MeldList, Trump, PreviousMelds, EndList) :-
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'h',
	nineOfTrump(MeldList, Trump, NT),
	NT = 1,
	EndList = ['9h'].
tryDix(MeldList, Trump, PreviousMelds, EndList) :-
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 's',
	nineOfTrump(MeldList, Trump, NT),
	NT = 1,
	EndList = ['9s'].
tryDix(MeldList, Trump, PreviousMelds, EndList) :-
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'c',
	nineOfTrump(MeldList, Trump, NT),
	NT = 1,
	EndList = ['9c'].
tryDix(MeldList, Trump, PreviousMelds, EndList) :-
	getSuit(Trump, TrumpSuit),
	TrumpSuit = 'd',
	nineOfTrump(MeldList, Trump, NT),
	NT = 1,
	EndList = ['9d'].
tryDix(MeldList, Trump, PreviousMelds, EndList) :-
	EndList = [].
	
/*
Clause Name: card clauses
Purpose: The purpose of these clauses is to determine whether specific card
		  exists in a list (the meld list).
Parameters:
		-List1- a list of atom cards, holding the player's cards in which
			they are trying to perform the meld with.
	   -Trump- the trump card of the current round (only sent in the
			functions of a card that is a trump card (ex. aceOfTrump).
		-Result- 1 if te card was founf in te list, 0 otherwise.
*/
aceOfHearts([], Result) :-
	Result = 0.
aceOfHearts(List1, Result) :-
	[First | Rest] = List1,
	First = ah,
	Result = 1.
aceOfHearts(List1, Result) :-
	[First | Rest] = List1,
	aceOfHearts(Rest, Result).
	
/*------------------------------------------------------------------*/
aceOfSpades([], Result) :-
	Result = 0.
aceOfSpades(List1, Result) :-
	[First | Rest] = List1,
	First = as,
	Result = 1.
aceOfSpades(List1, Result) :-
	[First | Rest] = List1,
	aceOfSpades(Rest, Result).
	
/*------------------------------------------------------------------*/
aceOfClubs([], Result) :-
	Result = 0.
aceOfClubs(List1, Result) :-
	[First | Rest] = List1,
	First = ac,
	Result = 1.
aceOfClubs(List1, Result) :-
	[First | Rest] = List1,
	aceOfClubs(Rest, Result).
	
/*------------------------------------------------------------------*/
aceOfDiamonds([], Result) :-
	Result = 0.
aceOfDiamonds(List1, Result) :-
	[First | Rest] = List1,
	First = ad,
	Result = 1.
aceOfDiamonds(List1, Result) :-
	[First | Rest] = List1,
	aceOfDiamonds(Rest, Result).
	
/*------------------------------------------------------------------*/
kingOfHearts([], Result) :-
	Result = 0.
kingOfHearts(List1, Result) :-
	[First | Rest] = List1,
	First = kh,
	Result = 1.
kingOfHearts(List1, Result) :-
	[First | Rest] = List1,
	kingOfHearts(Rest, Result).
	
/*------------------------------------------------------------------*/
kingOfSpades([], Result) :-
	Result = 0.
kingOfSpades(List1, Result) :-
	[First | Rest] = List1,
	First = ks,
	Result = 1.
kingOfSpades(List1, Result) :-
	[First | Rest] = List1,
	kingOfSpades(Rest, Result).
	
/*------------------------------------------------------------------*/
kingOfClubs([], Result) :-
	Result = 0.
kingOfClubs(List1, Result) :-
	[First | Rest] = List1,
	First = kc,
	Result = 1.
kingOfClubs(List1, Result) :-
	[First | Rest] = List1,
	kingOfClubs(Rest, Result).
	
/*------------------------------------------------------------------*/
kingOfDiamonds([], Result) :-
	Result = 0.
kingOfDiamonds(List1, Result) :-
	[First | Rest] = List1,
	First = kd,
	Result = 1.
kingOfDiamonds(List1, Result) :-
	[First | Rest] = List1,
	kingOfDiamonds(Rest, Result).
	
/*------------------------------------------------------------------*/
queenOfHearts([], Result) :-
	Result = 0.
queenOfHearts(List1, Result) :-
	[First | Rest] = List1,
	First = qh,
	Result = 1.
queenOfHearts(List1, Result) :-
	[First | Rest] = List1,
	queenOfHearts(Rest, Result).
/*------------------------------------------------------------------*/
queenOfSpades([], Result) :-
	Result = 0.
queenOfSpades(List1, Result) :-
	[First | Rest] = List1,
	First = qs,
	Result = 1.
queenOfSpades(List1, Result) :-
	[First | Rest] = List1,
	queenOfSpades(Rest, Result).
	
/*------------------------------------------------------------------*/
queenOfClubs([], Result) :-
	Result = 0.
queenOfClubs(List1, Result) :-
	[First | Rest] = List1,
	First = qc,
	Result = 1.
queenOfClubs(List1, Result) :-
	[First | Rest] = List1,
	queenOfClubs(Rest, Result).
	
/*------------------------------------------------------------------*/
queenOfDiamonds([], Result) :-
	Result = 0.
queenOfDiamonds(List1, Result) :-
	[First | Rest] = List1,
	First = qd,
	Result = 1.
queenOfDiamonds(List1, Result) :-
	[First | Rest] = List1,
	queenOfDiamonds(Rest, Result).
	
/*------------------------------------------------------------------*/
jackOfHearts([], Result) :-
	Result = 0.
jackOfHearts(List1, Result) :-
	[First | Rest] = List1,
	First = jh,
	Result = 1.
jackOfHearts(List1, Result) :-
	[First | Rest] = List1,
	jackOfHearts(Rest, Result).
	
/*------------------------------------------------------------------*/
jackOfSpades([], Result) :-
	Result = 0.
jackOfSpades(List1, Result) :-
	[First | Rest] = List1,
	First = js,
	Result = 1.
jackOfSpades(List1, Result) :-
	[First | Rest] = List1,
	jackOfSpades(Rest, Result).
	
/*------------------------------------------------------------------*/
jackOfClubs([], Result) :-
	Result = 0.
jackOfClubs(List1, Result) :-
	[First | Rest] = List1,
	First = jc,
	Result = 1.
jackOfClubs(List1, Result) :-
	[First | Rest] = List1,
	jackOfClubs(Rest, Result).
	
/*------------------------------------------------------------------*/
jackOfDiamonds([], Result) :-
	Result = 0.
jackOfDiamonds(List1, Result) :-
	[First | Rest] = List1,
	First = jd,
	Result = 1.
jackOfDiamonds(List1, Result) :-
	[First | Rest] = List1,
	jackOfDiamonds(Rest, Result).
	
/*------------------------------------------------------------------*/
nineOfTrump([], Trump, Result) :-
	Result = 0.
nineOfTrump(List1, Trump, Result) :-
	[First | Rest] = List1,
	getType(First, CurrentType),
	getSuit(First, CurrentSuit),
	getSuit(Trump, TrumpSuit),
	CurrentType = '9',
	CurrentSuit = TrumpSuit,
	Result = 1.
nineOfTrump(List1, Trump, Result) :-
	[First | Rest] = List1,
	nineOfTrump(Rest, Trump, Result).
	
/*------------------------------------------------------------------*/
jackOfTrump([], Trump, Result) :-
	Result = 0.
jackOfTrump(List1, Trump, Result) :-
	[First | Rest] = List1,
	getType(First, CurrentType),
	getSuit(First, CurrentSuit),
	getSuit(Trump, TrumpSuit),
	CurrentType = 'j',
	CurrentSuit = TrumpSuit,
	Result = 1.
jackOfTrump(List1, Trump, Result) :-
	[First | Rest] = List1,
	jackOfTrump(Rest, Trump, Result).
	
/*------------------------------------------------------------------*/
queenOfTrump([], Trump, Result) :-
	Result = 0.
queenOfTrump(List1, Trump, Result) :-
	[First | Rest] = List1,
	getType(First, CurrentType),
	getSuit(First, CurrentSuit),
	getSuit(Trump, TrumpSuit),
	CurrentType = 'q',
	CurrentSuit = TrumpSuit,
	Result = 1.
queenOfTrump(List1, Trump, Result) :-
	[First | Rest] = List1,
	queenOfTrump(Rest, Trump, Result).
	
/*------------------------------------------------------------------*/
kingOfTrump([], Trump, Result) :-
	Result = 0.
kingOfTrump(List1, Trump, Result) :-
	[First | Rest] = List1,
	getType(First, CurrentType),
	getSuit(First, CurrentSuit),
	getSuit(Trump, TrumpSuit),
	CurrentType = 'k',
	CurrentSuit = TrumpSuit,
	Result = 1.
kingOfTrump(List1, Trump, Result) :-
	[First | Rest] = List1,
	kingOfTrump(Rest, Trump, Result).
	
/*------------------------------------------------------------------*/
tenOfTrump([], Trump, Result) :-
	Result = 0.
tenOfTrump(List1, Trump, Result) :-
	[First | Rest] = List1,
	getType(First, CurrentType),
	getSuit(First, CurrentSuit),
	getSuit(Trump, TrumpSuit),
	CurrentType = 'x',
	CurrentSuit = TrumpSuit,
	Result = 1.
tenOfTrump(List1, Trump, Result) :-
	[First | Rest] = List1,
	tenOfTrump(Rest, Trump, Result).
	
/*------------------------------------------------------------------*/
aceOfTrump([], Trump, Result) :-
	Result = 0.
aceOfTrump(List1, Trump, Result) :-
	[First | Rest] = List1,
	getType(First, CurrentType),
	getSuit(First, CurrentSuit),
	getSuit(Trump, TrumpSuit),
	CurrentType = 'a',
	CurrentSuit = TrumpSuit,
	Result = 1.
aceOfTrump(List1, Trump, Result) :-
	[First | Rest] = List1,
	aceOfTrump(Rest, Trump, Result).
	
/*------------------------------------------------------------------*/



















