defmodule Poker do

	#Returns the suit associated with the number
	def getSuit(num) do
		temp = num / 13
		if temp <= 1 do
			 "C"
		else
			if temp > 1 && temp <= 2 do
				 "D"
			else
				if temp > 2 && temp <= 3 do
					 "H"
				else
					if temp > 3 && temp <= 4 do
						 "S"
					end
				end
			end
		end
	end

	# Returns the rank of the card as a number between 2-14
	def getRank(num) do
			temp = rem num, 13
			if temp > 1 && temp <= 12 do
				temp
			else
				case temp do
					0 -> 13
					1 -> 14
					_ -> nil
				end
			end
		end

	# Returs a list where each index represents how many cards of each suit are there
	def suitCounts(list) do
		suitCounter = [Enum.count(list, fn tuple -> (elem tuple, 1) == "C" end)]
		suitCounter = suitCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 1) == "D" end)]
		suitCounter = suitCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 1) == "H" end)]
		suitCounter = suitCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 1) == "S" end)]
		suitCounter
	end

# Returs a list where each index represents how many cards of each rank are there
	def rankCounts(list) do
		rankCounter = [Enum.count(list, fn tuple -> (elem tuple, 0) == 14 end)]
		rankCounter = rankCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 0) == 2 end)]
		rankCounter = rankCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 0) == 3 end)]
		rankCounter = rankCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 0) == 4 end)]
		rankCounter = rankCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 0) == 5 end)]
		rankCounter = rankCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 0) == 6 end)]
		rankCounter = rankCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 0) == 7 end)]
		rankCounter = rankCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 0) == 8 end)]
		rankCounter = rankCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 0) == 9 end)]
		rankCounter = rankCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 0) == 10 end)]
		rankCounter = rankCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 0) == 11 end)]
		rankCounter = rankCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 0) == 12 end)]
		rankCounter = rankCounter ++ [Enum.count(list, fn tuple -> (elem tuple, 0) == 13 end)]
		rankCounter
		end

	def getSuitFromCounter(suitCounter) do
			index = Enum.find_index(suitCounter, fn x -> x >= 5 end)
			case index do
				0 -> "C"
				1 -> "D"
				2 -> "H"
				3 -> "S"
				_-> nil
			end
		end

	def checkRoyalFlush(list) do

			suitCounter = suitCounts(list)
			commonSuit = getSuitFromCounter(suitCounter)

			if 	Enum.member?(list, {14, commonSuit}) && Enum.member?(list, {13, commonSuit}) &&
				Enum.member?(list, {12, commonSuit}) && Enum.member?(list, {11, commonSuit})
				&& Enum.member?(list, {10, commonSuit}) do
				newList = [{14, commonSuit}, {13, commonSuit}, {12, commonSuit},
				{11, commonSuit}, {10, commonSuit}]
				newList
			else
				false
			end
	end


	def checkFlush(suitCounterList) do
		if Enum.any?(suitCounterList, fn(n) -> n >= 5 end) do
			a = Enum.find_index(suitCounterList, fn(n) -> n >= 5 end)
			case a do
				0 -> "C"
				1 -> "D"
				2 -> "H"
				3 -> "S"
				_-> nil
			end
		else
			false
		end
	end

	def getFlush(playerHand) do
			suitCounterList = suitCounts(playerHand)
			b = checkFlush(suitCounterList)
			temp = Enum.filter(playerHand, fn x -> (elem x, 1) == b end)
			temp = Enum.slice(temp, 0..4)
			temp
		end

	def check4OfAKind(rankCounterList) do
			if Enum.any?(rankCounterList, fn(n) -> n == 4 end) do
				Enum.find_index(rankCounterList, fn(n) -> n == 4 end)
			else
				false
			end
		end

	def get4OfAKind(playerHand) do
			a = check4OfAKind(rankCounts(playerHand))
			tempPlayerHand = Enum.map(playerHand, fn {x, y} -> if x == 14, do: {1, y}, else: {x, y} end)
			a = a + 1
			list = Enum.filter(tempPlayerHand, fn x -> (elem x, 0) == a end)
			list
		end

	def check3OfAKind(rankCounterList) do
			if Enum.any?(rankCounterList, fn(n) -> n == 3 end) do
				a = Enum.find_index(rankCounterList, fn(n) -> n == 3 end)
				list = Enum.slice(rankCounterList, (a+1)..12)
				if Enum.any?(list, fn(n) -> n == 3 end) do
						b = Enum.find_index(list, fn(n) -> n == 3 end)
						b = b + a + 1
						if a == 0 do
							a
						else
							b
						end
				else
					a
				end
			else
				false
			end
		end
		def get3OfAKind(a, playerHand) do
			tempPlayerHand = Enum.map(playerHand, fn {x, y} -> if x == 14, do: {1, y}, else: {x, y} end)
			a = a + 1
			list = Enum.filter(tempPlayerHand, fn x -> (elem x, 0) == a end)
			list
		end

	def get3OfAKind(playerHand) do

			rankCounterList = rankCounts(playerHand)
			a = check3OfAKind(rankCounterList)

			tempPlayerHand = Enum.map(playerHand, fn {x, y} -> if x == 14, do: {1, y}, else: {x, y} end)
			a = a + 1
			list = Enum.filter(tempPlayerHand, fn x -> (elem x, 0) == a end)
			list
			#rank = to_string(a)
			#hand = [rank <> (elem (hd list), 1)]
			#hand = hand ++ [rank <> (elem (hd (tl list)), 1)]
			#hand = hand ++ [rank <> (elem (hd(tl(tl list))), 1)]
			#hand
		end

	def checkStraightHelper(list) do

			list = Enum.uniq_by(list, fn{x, _} -> x end)

			sequence1 = Enum.slice(list, 0, 5)
			sequence2 = Enum.slice(list, 1, 5)
			sequence3 = Enum.slice(list, 2, 6)

			if Enum.count(sequence1) == 5 do
				if Enum.map(sequence1, fn {x, _y} -> x end) == Enum.to_list( ((elem (hd sequence1), 0)..(elem (Enum.at(sequence1, 4)), 0)) ) do
				sequence1
				else
					if Enum.count(sequence2) == 5 do
						if Enum.map(sequence2, fn {x, _y} -> x end) == Enum.to_list( ((elem (hd sequence2), 0)..(elem (Enum.at(sequence2, 4)), 0)) ) do
							sequence2
						else
							if Enum.count(sequence3) == 5 do
								if Enum.map(sequence3, fn {x, _y} -> x end) == Enum.to_list( ((elem (hd sequence3), 0)..(elem (Enum.at(sequence3, 4)), 0)) ) do
									sequence3
								else
									false
								end
							else
								false
							end
						end
					else
						false
					end
				end
			else
				false
			end
		end


	def checkStraightFlushHelper(list) do
			suitCounter = suitCounts(list)
			commonSuit = getSuitFromCounter(suitCounter)
			list = Enum.filter(list, fn{_x, y} -> {y} == {commonSuit} end) |> Enum.uniq_by(fn{x, _} -> x end)


			sequence1 = Enum.slice(list, 0, 5)
			sequence2 = Enum.slice(list, 1, 5)
			sequence3 = Enum.slice(list, 2, 6)

			if Enum.count(sequence1) == 5 do
				if Enum.map(sequence1, fn {x, _y} -> x end) == Enum.to_list( ((elem (hd sequence1), 0)..(elem (Enum.at(sequence1, 4)), 0)) ) && Enum.all?(sequence1, fn{_x, y} -> {y} == {commonSuit} end) do
				sequence1
				else
					if Enum.count(sequence2) == 5 do
						if Enum.map(sequence2, fn {x, _y} -> x end) == Enum.to_list( ((elem (hd sequence2), 0)..(elem (Enum.at(sequence2, 4)), 0)) ) && Enum.all?(sequence2, fn{_x, y} -> {y} == {commonSuit} end) do
							sequence2
						else
							if Enum.count(sequence3) == 5 do
								if Enum.map(sequence3, fn {x, _y} -> x end) == Enum.to_list( ((elem (hd sequence3), 0)..(elem (Enum.at(sequence3, 4)), 0)) ) && Enum.all?(sequence3, fn{_x, y} -> {y} == {commonSuit} end) do
									sequence3
								else
									false
								end
							else
								false
							end
						end
					else
						false
					end
				end
			else
				false
			end
		end


	def checkStraightFlush(list) do
			if checkStraightFlushHelper(list) == false do
				tempList = Enum.map(list, fn {x, y} -> if x == 14, do: {1, y}, else: {x, y} end) |> Enum.sort() |> Enum.reverse()
				checkStraightFlushHelper(tempList)
			else
				checkStraightFlushHelper(list)
			end
		end


	def checkStraight(list) do
		if checkStraightHelper(list) == false do
			tempList = Enum.map(list, fn {x, y} -> if x == 14, do: {1, y}, else: {x, y} end) |> Enum.sort() |> Enum.reverse()
			checkStraightHelper(tempList)
		else
			checkStraightHelper(list)
		end
	end

	def checkFullHouse(list) do
		rankCounterList = rankCounts(list)
		index = check3OfAKind(rankCounterList)
		if index != false do
			tempList = get3OfAKind(index, list) |> Enum.map(fn {x, y} -> if x == 1, do: {14, y}, else: {x, y} end)
			tempList2 = list -- tempList
			tempMap = Enum.frequencies_by(tempList2, fn{x,_y} -> x end) |> Enum.sort |> Enum.reverse()
			tempMap = Enum.filter(tempMap, fn{_x,y} -> y >= 2 end)
			if Enum.count(tempMap) != 0 do
				rank = elem (hd tempMap), 0
				tempList2 = Enum.filter(tempList2, fn{x,_y} -> x == rank end) |> Enum.slice(0,2)
				tempList = tempList ++ tempList2 |> Enum.sort()
				tempList |> Enum.sort() |> Enum.reverse()
			else
				false
			end
		else
			false
		end
	end


	def checkPair(list) do
		cardFrequencies = Enum.frequencies_by(list, fn{x,_y} -> x end) |> Enum.sort |> Enum.reverse()
		cardFrequencies = Enum.filter(cardFrequencies, fn{_x,y} -> y == 2 end)
		if Enum.count(cardFrequencies) != 0 do
			rank = elem (hd cardFrequencies), 0
			list = Enum.filter(list, fn{x,_y} -> x == rank end)
			list
		else
			false
		end
	end

	def check2Pair(list) do
		cardFrequencies = Enum.frequencies_by(list, fn{x,_y} -> x end) |> Enum.sort |> Enum.reverse()
		cardFrequencies = Enum.filter(cardFrequencies, fn{_x,y} -> y == 2 end)
		if Enum.count(cardFrequencies) >= 2 do
			cardFrequencies = Enum.sort(cardFrequencies) |> Enum.reverse()
			rank = elem (hd cardFrequencies), 0
			rank2 = elem (hd (tl cardFrequencies)), 0
			list = Enum.filter(list, fn{x,_y} -> x == rank || x == rank2 end)
			list
		else
			false
		end
	end

def getHighestCard(list) do
		list = Enum.sort(list) |> Enum.reverse()
		hd list

end

def toString(list) do
	list = Enum.sort(list) |> Enum.map(fn {x, y} -> if x == 14, do: {1, y}, else: {x, y} end) |> Enum.map(fn{x, y} -> (to_string(x) <> y) end)
	list
end

# straightflush - highest rank at the top of the sequence wins.

def tieBreakerStraightFlush(hand1, hand2) do
	hand1 = checkStraightFlush(hand1)
	hand2 = checkStraightFlush(hand2)

	highestRank1 = elem (hd hand1), 0
	highestRank2 = elem (hd hand2), 0

	if (highestRank1 > highestRank2) do
		hand1
	else
		hand2
	end
end
# fourofakind - Highest four of a kind wins. If same four of a kind, the highest fifth side card ('kicker') wins.

def tieBreakerFourOfAKind(hand1, hand2) do

		# get the 4ofakind tuple
		tempHand1 = get4OfAKind(hand1) |> Enum.map(fn {x, y} -> if x == 1, do: {14, y}, else: {x, y} end)
		tempHand2 = get4OfAKind(hand2) |> Enum.map(fn {x, y} -> if x == 1, do: {14, y}, else: {x, y} end)

		# Get the rank of the 4ofakind for each player
		highestRank1 = elem (hd tempHand1), 0
		highestRank2 = elem (hd tempHand2), 0

		#highest 4ofakind wins
		if (highestRank1 > highestRank2) do
			tempHand1 |> Enum.map(fn {x, y} -> if x == 14, do: {1, y}, else: {x, y} end)
		else
			tempHand2 |> Enum.map(fn {x, y} -> if x == 14, do: {1, y}, else: {x, y} end)
		end
	end

# Full House: Highest three matching cards wins. If three matching cards are the same, the highest value of the two matching cards wins

def tieBreakerFullHouse(hand1, hand2) do
		tempHand1 = checkFullHouse(hand1)
		tempHand2 = checkFullHouse(hand2)

		cardHand1Three = Enum.frequencies_by(tempHand1, fn{x, _y} -> x end) |> Enum.filter(fn{_x, y} -> y == 3 end)
		cardHand1Three = elem (hd cardHand1Three), 0

		cardHand2Three = Enum.frequencies_by(tempHand2, fn{x, _y} -> x end) |> Enum.filter(fn{_x, y} -> y == 3 end)
		cardHand2Three = elem (hd cardHand2Three), 0

		if cardHand1Three > cardHand2Three do
			tempHand1
		else
			if cardHand1Three < cardHand2Three do
				tempHand2
			else
				twoHand1 = Enum.frequencies_by(tempHand1, fn{x, _y} -> x end) |> Enum.filter(fn{_x, y} -> y == 2 end)
				twoHand1  = elem (hd twoHand1 ), 0

				twoHand2  = Enum.frequencies_by(tempHand2, fn{x, _y} -> x end) |> Enum.filter(fn{_x, y} -> y == 2 end)
				twoHand2 = elem (hd twoHand2), 0
				if twoHand1  > twoHand2 do
					tempHand1
				else
					tempHand2
				end
			end
		end
	end

# flush - player with the highest ranking unique card in their hand wins

def tieBreakerFlush(hand1, hand2) do
		flush1 = getFlush(hand1)
		flush2 = getFlush(hand2)

		x = flush1 -- flush2
		y = flush2 -- flush1

		highestFlush1 = elem (hd x), 0
		highestFlush2 = elem (hd y), 0

		if highestFlush1 > highestFlush2 do
			flush1
		else
			flush2
		end
end


# straight - highest ranking card at the top of the sequence wins

def tieBreakerStraight(hand1, hand2) do
	straight1 = checkStraight(hand1)
	straight2 = checkStraight(hand2)

	highestStraight1 = elem (hd straight1), 0
	highestStraight2 = elem (hd straight2), 0

	if highestStraight1 > highestStraight2 do
		straight1
	else
		straight2
	end
end

# Three of a kind - Highest ranking three of a kind wins. If three of a kind cards are the same,
	#the highest side card, and if necessary, the second-highest side card wins

def tieBreaker3OfAKind(hand1, hand2) do
	threeOfAKind1 = get3OfAKind(hand1)
	threeOfAKind2 = get3OfAKind(hand2)

	highest1 = elem (hd threeOfAKind1), 0
	highest2 = elem (hd threeOfAKind2), 0

	if highest1 > highest2 do
		threeOfAKind1
	else
		if highest1 < highest2 do
			threeOfAKind2
		else
			remainingCards1 = hand1 -- threeOfAKind1 |> Enum.sort() |> Enum.reverse() |> Enum.slice(0, 2)
			remainingCards2 = hand2 -- threeOfAKind2 |> Enum.sort() |> Enum.reverse() |> Enum.slice(0, 2)

			x = remainingCards1 -- remainingCards2
			y = remainingCards2 -- remainingCards1


			if Enum.count(x) != 0 do
				highest1 = elem (hd x), 0
				highest2 = elem (hd y), 0

				if highest1 > highest2 do
					threeOfAKind1
				else
					threeOfAKind2
				end

			else
				false
			end

		end
	end
end

# Two pair - In the event of a tie: Highest pair wins. If players have the same highest pair,
	#highest second pair wins. If both players have two identical pairs, highest side card wins.

	def tieBreaker2Pair(hand1, hand2) do
			twoPair1 = check2Pair(hand1)
			twoPair2 = check2Pair(hand2)

			highest1 = elem (hd twoPair1), 0
			highest2 = elem (hd twoPair2), 0

			if highest1 > highest2 do
				twoPair1
			else
				if highest1 < highest2 do
					twoPair2
				else

					highest1 = elem ( hd (Enum.slice(twoPair1, 2, 3)) ), 0
					highest2 = elem ( hd (Enum.slice(twoPair2, 2, 3)) ), 0

					if highest1 > highest2 do
						twoPair1
					else
						if highest1 < highest2 do
							twoPair2
						else
							 hand1 = hand1 -- twoPair1
							 hand2 = hand2 -- twoPair2

							 x = hand1 -- hand2
							 y = hand2 -- hand1

							 highest1 = elem (hd x), 0
							 highest2 = elem (hd y), 0

							 if highest1 > highest2 do
								twoPair1
							else
								twoPair2
							end
						end
					end
				end
			end
		end
# One pair - Two cards of a matching rank, and three unrelated side cards. In the event of a tie: Highest pair wins.
	#If players have the same pair, the highest side card wins, and if necessary, the second-highest
	#and third-highest side card can be used to break the tie.

	def tieBreakerPair(hand1, hand2) do
		pair1 = checkPair(hand1)
		pair2 = checkPair(hand2)

		highest1 = elem (hd pair1), 0
		highest2 = elem (hd pair2), 0

		if highest1 > highest2 do
			pair1
		else
			if highest1 < highest2 do
				pair2
			else
				hand1 = hand1 -- pair1
				hand2 = hand2 -- pair2

				x = hand1 -- hand2
				y = hand2 -- hand1

				highest1 = elem (hd x), 0
				highest2 = elem (hd y), 0

				if highest1 > highest2 do
					pair1
			 	else
					pair2
			 	end
			end
		end
	end

# In the event of a tie: Highest card wins, and if necessary, the second-highest, third-highest,
	#fourth-highest and smallest card can be used to break the tie.

	def tieBreakerHighCard(hand1, hand2) do
		x = hand1 -- hand2
		y = hand2 -- hand1

		highest1 = elem (hd x), 0
		highest2 = elem (hd y), 0

		if highest1 > highest2 do
		 	Enum.slice(hand1, 0, 5)
		else
			Enum.slice(hand2, 0, 5)
		end
	end

	def determineHand(hand) do
		if checkRoyalFlush(hand) != false do
			{hand, 10}
		else
			if checkStraightFlush(hand) != false do
				{hand, 9}
			else
				if check4OfAKind(rankCounts(hand)) != false do
					{hand, 8}
				else
					if checkFullHouse(hand) != false do
						{hand, 7}
					else
						if checkFlush(suitCounts(hand)) != false do
							{hand, 6}
						else
							if checkStraight(hand) != false do
								{hand, 5}
							else
								if check3OfAKind(rankCounts(hand)) != false do
									{hand, 4}
								else
									if check2Pair(hand) != false do
										{hand, 3}
									else
										if checkPair(hand) != false do
											{hand, 2}
										else
											{hand, 1}
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

def tieBreaker(player1Hand, player2Hand) do
	x = elem player1Hand, 1
	case x do
		10 -> checkRoyalFlush((elem player2Hand, 0))
		9 -> tieBreakerStraightFlush((elem player1Hand, 0), (elem player2Hand, 0))
		8 -> tieBreakerFourOfAKind((elem player1Hand, 0), (elem player2Hand, 0))
		7 -> tieBreakerFullHouse((elem player1Hand, 0), (elem player2Hand, 0))
		6 -> tieBreakerFlush((elem player1Hand, 0), (elem player2Hand, 0))
		5 -> tieBreakerStraight((elem player1Hand, 0), (elem player2Hand, 0))
		4 -> tieBreaker3OfAKind((elem player1Hand, 0), (elem player2Hand, 0))
		3 -> tieBreaker2Pair((elem player1Hand, 0), (elem player2Hand, 0))
		2 -> tieBreakerPair((elem player1Hand, 0), (elem player2Hand, 0))
		1 -> tieBreakerHighCard((elem player1Hand, 0), (elem player2Hand, 0))
	end
end

def determineWinner(hand1, hand2) do

	player1Hand = determineHand(hand1)
	player2Hand = determineHand(hand2)

	if (elem player1Hand, 1) > (elem player2Hand, 1) do
		x = elem player1Hand, 1
		case x do
			10 -> checkRoyalFlush(hand1)
			9 -> checkStraightFlush(hand1)
			8 -> get4OfAKind(hand1)
			7 -> checkFullHouse(hand1)
			6 -> getFlush(hand1)
			5 -> checkStraight(hand1)
			4 -> get3OfAKind(hand1)
			3 -> check2Pair(hand1)
			2 -> checkPair(hand1)
			1 -> getHighestCard(hand1)
		end
	else
		if (elem player1Hand, 1) < (elem player2Hand, 1) do
			x = elem player2Hand, 1
			case x do
				10 -> checkRoyalFlush(hand2)
				9 -> checkStraightFlush(hand2)
				8 -> get4OfAKind(hand2)
				7 -> checkFullHouse(hand2)
				6 -> getFlush(hand2)
				5 -> checkStraight(hand2)
				4 -> get3OfAKind(hand2)
				3 -> check2Pair(hand2)
				2 -> checkPair(hand2)
				1 -> getHighestCard(hand2)
			end
		else
			if (elem player1Hand, 1) == (elem player2Hand, 1) do
				tieBreaker(player1Hand, player2Hand)
			else
				"Error"
			end
		end
	end
end


	def deal(list) do

			# Create two lists of player1's hand and player2's hands
			player1Hand = [Enum.at(list, 0), Enum.at(list, 2)]
			player2Hand = [Enum.at(list, 1), Enum.at(list, 3)]
			pool = list -- (player1Hand ++ player2Hand)
			player1Hand = player1Hand ++ pool
			player2Hand = player2Hand ++ pool


			# Organize each player's hand into a list of tuples containing rank and suit, where the list is sorted from highest rank to lowest
			card = fn(n) -> {getRank(n), getSuit(n)} end
			list1 = Enum.map(player1Hand, card) |> Enum.sort() |> Enum.reverse()
			list2 = Enum.map(player2Hand, card) |> Enum.sort() |> Enum.reverse()

			determineWinner(list1, list2) |> toString()

	end
end
