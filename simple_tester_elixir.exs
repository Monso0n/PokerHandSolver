
cards = [ "1C", "2C", "3C", "4C", "5C", "6C", "7C", "8C", "9C", "10C", "11C", "12C", "13C",
		  "1D", "2D", "3D", "4D", "5D", "6D", "7D", "8D", "9D", "10D", "11D", "12D", "13D",
		  "1H", "2H", "3H", "4H", "5H", "6H", "7H", "8H", "9H", "10H", "11H", "12H", "13H",
	      "1S", "2S", "3S", "4S", "5S", "6S", "7S", "8S", "9S", "10S", "11S", "12S", "13S" 
        ]
        
perms = [ [ 9,  8,  7,  6,  5,  4,  3,  2,  1  ],  # 1   2-6 Straight flush VS 1-5 straight flush
          [ 40, 41, 42, 43, 48, 49, 50, 51, 52 ],  # 2   Royal flush VS straight flush
          [ 40, 41, 27, 28, 1,  14, 15, 42, 29 ],  # 3   Four aces VS 2-full-of-A
          [ 30, 13, 27, 44, 12, 17, 33, 41, 43 ],  # 4   3-fours VS 2-fours
          [ 27, 45, 3,  48, 44, 43, 41, 33, 12 ],  # 5   Flush VS straight
          [ 17, 31, 30, 51, 44, 43, 41, 33, 12 ],  # 6   3-fours VS 2-queens-2-fives
          [ 17, 39, 30, 52, 44, 25, 41, 51, 12 ],  # 7   Q-full-of-K VS Q-full-of-4
          [ 11, 25, 9,  39, 50, 48, 3,  49, 45 ],  # 8   9-K straight VS 9-J-two-pair
          [ 50, 26, 39, 3,  11, 27, 20, 48, 52 ],  # 9   J-K-two-pair VS K-pair
          [ 40, 52, 46, 11, 48, 27, 29, 32, 37 ],  # 10  A-pair VS J-pair
        ]
         
sols  = [ [ "2C",  "3C",  "4C",  "5C",  "6C"  ],   # 1   2-6 Straight flush
          [ "10S", "11S", "12S", "13S", "1S"  ],   # 2   Royal flush
          [ "1C",  "1D",  "1H",  "1S"         ],   # 3   Four aces
          [ "4D",  "4H",  "4S"                ],   # 4   3-fours
          [ "2S",  "4S",  "5S",  "6S",  "9S"  ],   # 5   Flush
          [ "4D",  "4H",  "4S"                ],   # 6   3-fours
          [ "12C", "12D", "12S", "13H", "13S" ],   # 7   Q-full-of-K
          [ "10S", "11S", "12D", "13H", "9S"  ],   # 8   9-K straight
          [ "11C", "11S", "13H", "13S"        ],   # 9   J-K-two-pair
          [ "1H",  "1S"                       ],   # 10  A-pair   
        ]

allScores = for test <- 0..(length(perms)-1) do

    input = Enum.at(perms, test)
    deal = for id <- input do Enum.at(cards, id-1) end
    
    try do
        youSaid = Poker.deal(input) 
        shouldBe = Enum.sort(Enum.at(sols, test))
        common = Enum.sort(youSaid -- (youSaid -- shouldBe))
        
		cond do
			length(youSaid) > 5 ->
				IO.puts "Test #{test+1} DISCREPANCY: " <> inspect(input)   
				IO.puts "  P1:   " <> inspect([Enum.at(deal, 0), Enum.at(deal, 2)])
				IO.puts "  P2:   " <> inspect([Enum.at(deal, 1), Enum.at(deal, 3)])
				IO.puts "  Pool: " <> inspect(Enum.drop(deal, 4))
				IO.puts "  You returned:   " <> inspect(youSaid)
				IO.puts "  Returned more than five cards! Test FAILED!"
				0
			common == shouldBe ->
				c = length(common)
				IO.puts "Test #{test+1} FULL MARKS  (#{c} of #{c} cards correct)"
				1
            true ->
				IO.puts "Test #{test+1} DISCREPANCY: " <> inspect(input)   
				IO.puts "  P1:   " <> inspect([Enum.at(deal, 0), Enum.at(deal, 2)])
				IO.puts "  P2:   " <> inspect([Enum.at(deal, 1), Enum.at(deal, 3)])
				IO.puts "  Pool: " <> inspect(Enum.drop(deal, 4))
				IO.puts "  You returned:   " <> inspect(youSaid)
				IO.puts "  Should contain: " <> inspect(shouldBe)
				IO.puts "  #{length common} of #{length shouldBe} cards correct"
				length(common) / length(shouldBe)    
		end 
    rescue    
        _ -> 
            IO.puts "Test #{test+1} ERROR - Runtime error on input " <> inspect(input); 0
    end
end

allScores = List.flatten(allScores)
scorePct = 100*Enum.sum(allScores) / length(allScores)
IO.puts "\nTotal score: #{scorePct}%  (#{Enum.sum allScores}/#{length allScores} points)"













