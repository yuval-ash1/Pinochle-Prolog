
/*
Clause Name: dropCard
Purpose: This clause is responsible for dropping a card from a
		  player's hand.
Parameters:
        -List1- a list of cards representing the player's hand.
		-Element- an atom representing a card from the player's hand.
		-NewResult- will hold the list of cards, the player's hand,
				after the Element has been removed.
*/
dropCard([], Element, []).
dropCard([Element | Rest], Element, Rest).
dropCard([First | Rest], Element, Result):-
	dropCard(Rest, Element, NewResult),
	Result = [First | NewResult].
	
/*
Clause Name: setNextP
Purpose: This clause is responsible for updating the next player
		  in the gameList.
Parameters:
        -GameList- a list containing all the information of the game.
		-NextP- an atom containing the next player (which is also the
				winner of the current round).
		-FinalGameList- will hold a list containing the game info with
				the updated	next player.
*/
setNextP(GameList, NextP, FinalGameList):-
	[RNum, CGScore, CRScore, CHand, CCapture, CMeld,
		   HGScore, HRScore, HHand, HCapture, HMeld,
		   Trump, Stock, _] = GameList,
	
	FinalGameList = [RNum, CGScore, CRScore, CHand, CCapture, CMeld,
						   HGScore, HRScore, HHand, HCapture, HMeld,
						   Trump, Stock, NextP].
						   
/*
Clause Name: setListForNewRound
Purpose: This clause is responsible for setting all the necessary
		 information from the previous round into the new game list.
Parameters:
        -PrevRList- the list from the last round played.
		-NewRlist-a new list conaining the new shuffled and player's hands.
		-FinalList- will hold a list containing the game info with the
				updated next player.
*/
setListForNewRound(PrevList, NewRList, FinalList) :-
	[RNum1, CGScore1, CRScore1, CHand1, CCapture1, CMeld1,
		   HGScore1, HRScore1, HHand1, HCapture1, HMeld1,
		   Trump1, Stock1, NextP1] = PrevList,
	
	[RNum, CGScore2, CRScore2, CHand2, CCapture2, CMeld2,
		   HGScore2, HRScore2, HHand2, HCapture2, HMeld2,
		   Trump2, Stock2, NextP2] = NewRList,
	
	FinalRNum is RNum1 + 1,
	FinaCGScore is CGScore1 + CRScore1,
	FinalHGScore is HGScore1 + HRScore1,
	
	FinalList = [FinalRNum, FinaCGScore, CRScore2, CHand2, CCapture2, CMeld2,
				 FinalHGScore, HRScore2, HHand2, HCapture2, HMeld2,
				 Trump2, Stock2, NextP2].
		   
	