// Done solo by Mayank Kainth (500 950 561)

fn getSuit(card:u32) -> &'static str{
    if card >= 0 && card < 14{
        return "C";
    }
    else if card >=14 && card <= 26{
        return "D";
    }
    else if card>=27 && card <= 39{
        return "H";
    }
    else{
        return "S";
    }
}
fn getRank(card:u32) -> String{
    let rem = card % 13;

    if rem > 1 && rem <= 12{
        let returnVar = rem.to_string();
        return returnVar;
    }
    else if rem == 0{
        return "13".to_string();
    }
    else {
        return "1".to_string();
    }
}
fn cardFormat(mut hand:[&u32; 7]) -> [String;7]{
    let mut returnHand: [String; 7] = ["".to_string(), "".to_string(), "".to_string(), "".to_string(), "".to_string(), "".to_string(), "".to_string()];
    let mut temp;

    hand.sort();
    hand.reverse();

    let mut newHand = hand;

    if hand[6] % 13 == 1{
        newHand = [hand[6], hand[0], hand[1], hand[2], hand[3], hand[4], hand[5]];
    }
    //println!("in: {:?}", hand);
    for i in 0..7{
        temp = (getRank(*newHand[i])) + &getSuit(*newHand[i]).to_string();
        returnHand[i] = temp;
    }

    //println!("out: {:?}", returnHand);    
    return returnHand;
}
fn getSuitCount(hand:[String;7]) -> [u32;4]{
    let mut count = [0,0,0,0];
    let mut temp:char = 'E';
    for i in 0..7{
        temp = hand[i].chars().nth(hand[i].len() - 1).unwrap();
        //println!("{:?}", temp);
        if temp == 'C'{
            count[0] = count[0] + 1;
        }
        else if temp == 'D'{
            count[1] = count[1] + 1;
        }
        else if temp =='H'{
            count[2] = count[2] + 1;
        }
        else{
            count[3] = count[3] + 1;
        }
    }
    //println!("{:?}", count);
    return count;
}
fn getRankCount(hand:[String;7]) -> [u32;13]{
    let mut count = [0,0,0,0,0,0,0,0,0,0,0,0,0];
    let mut num = 0;

    for i in 0..7{
        num = hand[i][..hand[i].len()-1].parse::<u32>().unwrap();

        if num == 1{
            count[0] += 1;
        }
        else if num>1 && num < 14{
            count[(num-1) as usize] += 1;
        }
    }
    //println!("{:?}", count);
    return count;
}
fn getSuitOfFlush(hand:[String;7]) -> &'static str{
    let suitCounterList = getSuitCount(hand);
    for i in 0..4{
        if suitCounterList[i] >= 5{
            if i==0{
                return "C";
            }
            else if i == 1{
                return "D"
            }
            else if i == 2{
                return "H";
            }
            else if i == 3{
                return "S";
            }
        }
    }
    return "None";
}
fn checkRoyalflush(hand:[String;7]) ->Vec<String>{
    let commonSuit = getSuitOfFlush(hand.clone());
    if commonSuit != "None"{
        if 
            hand.contains(&("1".to_string()+commonSuit)) &&
            hand.contains(&("13".to_string()+commonSuit)) &&
            hand.contains(&("12".to_string()+commonSuit)) &&
            hand.contains(&("11".to_string()+commonSuit)) &&
            hand.contains(&("10".to_string()+commonSuit))
        {
            return vec![("1".to_string()+commonSuit), ("13".to_string()+commonSuit), ("12".to_string()+commonSuit), ("11".to_string()+commonSuit), ("10".to_string()+commonSuit)];
        }
        else{
            return vec![];
        }
    }
    else{
        return vec![];
    }

}
fn checkStraightFlush(hand:[String;7]) -> Vec<String>{

    //!("GIVEN HAND: {:?}", hand);
    let mut h = hand.clone();
    let commonSuit = getSuitOfFlush(hand.clone());
    let mut rankCountList = getRankCount(hand);

    rankCountList.reverse();
    //println!("RANK COUNT LIST: {:?}", rankCountList);
    let mut consecutiveCount = 0;
    let mut returnVector = Vec::new();

    if commonSuit != "None"{
        for i in 0..13{
             if consecutiveCount == 5{
                returnVector.reverse();
                return returnVector;
             }
             else if rankCountList[i] >= 1{
                if i == 13 && h.contains(&("1".to_string()+commonSuit)){
                    consecutiveCount+=1;
                    returnVector.push("1".to_string()+commonSuit);
                }
                else if h.contains((&((13-i).to_string()+commonSuit))){
                    returnVector.push((13-i).to_string()+commonSuit);
                    consecutiveCount+=1;
                }
                else{
                    consecutiveCount = 0;
                    returnVector = vec![];
                }
             }
             else {
                 consecutiveCount = 0;
                 returnVector = vec![];
             }
        }
        return vec![];
    }
    else{ 
        return vec![];
    }
}
fn checkFourOfAKind(hand:[String;7]) -> Vec<String>{
    let rankCountList = getRankCount(hand);
    println!("{:?}", rankCountList);
    for i in 0..13{
        if rankCountList[i]>=4{
            return vec![(i+1).to_string()+"C", (i+1).to_string()+"D", (i+1).to_string()+"H", (i+1).to_string()+"S"];
        }
        else{
            continue;
        }
    }
    return vec![]

}
fn checkFullHouse(hand:[String;7]) -> Vec<String>{
    let mut rankCount = getRankCount(hand.clone());
    rankCount.reverse();
    let mut threeRank = false;
    let mut twoRank = false;
    let mut threeRankIndex = 21;
    let mut twoRankIndex = 21;

    if rankCount[12] >= 3{
        threeRank = true;
        threeRankIndex = 12;
    }
    else if rankCount[12] >=2{
        twoRank = true;
        twoRankIndex = 12;
    }
    //println!("{:?}", rankCount);
    for i in 0..12{
        if rankCount[i] >=  3 &&  threeRank == false{
            //println!("yeye 3");
            threeRank = true;
            threeRankIndex = 13-i; 
            //println!("{}",threeRankIndex);
        }
        else if rankCount[i] >= 2 && twoRank == false{
            //println!("yeye 2");
            twoRank = true;
            twoRankIndex = 13 - i;
            //println!("{}",twoRankIndex);
        }
    }
    //println!("{}", threeRankIndex);
    //println!("{}", twoRankIndex);

    let mut returnVector = Vec::new();

    if twoRank==false || threeRank == false{
        return vec![];
    }
    else{
        for i in 0..7{
            if hand[i][..hand[i].len()-1].parse::<u32>().unwrap() == twoRankIndex as u32 || hand[i][..hand[i].len()-1].parse::<u32>().unwrap() == threeRankIndex as u32{
                returnVector.push(hand[i].clone());
            }
        }
        returnVector.sort();
        return returnVector;
    }
}
fn checkFlush(hand:[String;7]) -> Vec<String>{
    let suit = getSuitOfFlush(hand.clone());
    let mut returnVector = Vec::new();
    let mut count = 0;
    let mut temp = 'E';

    if suit != "None"{

        for i in 0..7{
            temp = hand[i].chars().nth(hand[i].len() - 1).unwrap();
            if temp.to_string() == suit{
                returnVector.push(hand[i].clone());
                count+=1;
            }
            if count==5{
                break;
            }
        }
        returnVector.reverse();
        return returnVector;
    }
    else{
        return vec![];
    }
}
fn checkStraight(hand:[String;7]) -> Vec<String>{   
    //println!("PASSED HAND: {:?}", hand);
    let mut rankCountList = getRankCount(hand.clone());
    let mut consecutiveCount = 0;
    let mut returnVector = Vec::new();
    rankCountList.reverse();
    let mut num = 0;


    //println!("rankcoutn list: {:?}", rankCountList);

    for i in 0..13{
        if consecutiveCount == 5{
            //println!("FIVE FOUND");
            //println!("returnVector {:?}", returnVector);
            returnVector.reverse();
            return returnVector;
        }
        else if i == 4 && consecutiveCount == 4 && rankCountList[12] >= 1{
            println!("i:{}", i);
            consecutiveCount+=1;
            for o in 0..7{
                num = hand[o][..hand[o].len()-1].parse::<u32>().unwrap();
                if num as u32 == i as u32{
                    returnVector.push(hand[o].clone());
                    break;
                }
            } 
        }
        else if rankCountList[i] >= 1{
            consecutiveCount+=1;
            for o in 0..7{
                num = hand[o][..hand[o].len()-1].parse::<u32>().unwrap();

                if num as u32 == (13 - i) as u32{
                    returnVector.push(hand[o].clone());
                    break;
                }
            }
        }
        else{
            consecutiveCount = 0;
            returnVector = vec![];
        }
    }
    return vec![];
}
fn checkThreeOfAKind(hand:[String;7]) -> Vec<String>{
    let mut rankCount = getRankCount(hand.clone());
    let mut threeRank = false;
    let mut threeRankIndex = 0;
    rankCount.reverse();

    let mut num = 0;
    let mut returnVector = Vec::new();

    if rankCount[12] >= 3{
        threeRank = true;
        threeRankIndex = 12;
    }
    for i in 0..12{
        if rankCount[i]>=3 && threeRank == false{
            threeRank = true;
            threeRankIndex = 13 - i;
            break;
        }
    }

    if threeRank == true{
        for i in 0..7{
            num = hand[i][..hand[i].len()-1].parse::<u32>().unwrap();
    
            if num == threeRankIndex as u32{
                returnVector.push(hand[i].clone());
            }
        }
        return returnVector;
    }
    else{
        return vec![];
    }
    
}   
fn checkTwoPair(hand:[String;7]) -> Vec<String>{

    //println!("PASSED HAND {:?}", hand);
    let mut rankCountList = getRankCount(hand.clone());
    rankCountList.reverse();
    let mut returnVector = Vec::new();
    
    let mut numOfPairs = 0;

    for i in 0..13{
        if rankCountList[i]>=2{
            numOfPairs+=1;
        }
    }

    if numOfPairs>=2{
        let mut pair1:u32 = 69;
        let mut pair2:u32 = 69;
        let mut foundPair1 = false;
        let mut foundPair2 = false;
        let mut num;


        if rankCountList[12] >= 2{
            pair1 = 14;
            foundPair1 = true;
        }

        for i in 0..12{
            if rankCountList[i] >= 2{
                if foundPair1 == false{
                    foundPair1 = true;
                    pair1 = (13 - i) as u32;
                }
                else if foundPair2 == false{
                    foundPair2 = true;
                    pair2 = (13 - i) as u32;
                }
            }
            else if foundPair1 == true && foundPair2 == true{
                break;
            }
        }
        for o in 0..7{
            num = hand[o][..hand[o].len()-1].parse::<u32>().unwrap();
    
            if num == pair1 as u32 || num == pair2 as u32{
                returnVector.push(hand[o].clone());
            }
        }
        returnVector.sort();
        return returnVector;
    }
    else {
        return vec![];
    }
}
fn checkPair(hand:[String;7]) -> Vec<String>{
    //println!("\nPASSED HAND {:?}", hand);
    let mut rankCountList = getRankCount(hand.clone());
    rankCountList.reverse();
    let mut returnVector = Vec::new();

    //println!("Rank Count List {:?}\n", rankCountList);
    
    let mut numOfPairs = 0;

    for i in 0..13{
        if rankCountList[i]>=2{
            numOfPairs+=1;
        }
    }

    if numOfPairs>=1{
        let mut pair:u32 = 69;
        let mut foundPair = false;
        let mut num;

        if rankCountList[12] >= 2{
            pair = 1;
            foundPair = true;
        }

        for i in 0..12{
            if foundPair{
                break;
            }
            else if rankCountList[i] >= 2{
                if foundPair == false{
                    foundPair = true;
                    pair = (13 - i) as u32;
                }
            }
        }
        for o in 0..7{
            num = hand[o][..hand[o].len()-1].parse::<u32>().unwrap();
    
            if num == pair as u32{
                returnVector.push(hand[o].clone());
            }
        }
        returnVector.sort();
        return returnVector;
    }
    else {
        return vec![];
    }
}
fn checkHighCard(hand:[String;7]) -> Vec<String>{
    let mut highest = 69;
    let mut num;
    let mut returnVector = vec![];

    for i in 0..hand.len(){
        num = hand[i][..hand[i].len()-1].parse::<u32>().unwrap();

        if highest == 69 || num > highest{
            highest = num;
            returnVector = vec![hand[i].clone()];
        }
    }
    return returnVector;
}
fn getHighCard(hand:Vec<String>) ->u32{
    let mut highest = 69;
    let mut num;

    for i in 0..hand.len(){
        num = hand[i][..hand[i].len()-1].parse::<u32>().unwrap();

        if highest == 69 || num > highest{
            highest = num;
        }
    }
    return highest;

}
fn determineHand(hand:[String;7]) ->([String;7],u32){
    if checkRoyalflush(hand.clone()).len() > 0{
        return (hand.clone(), 10);
    }
    else if checkStraightFlush(hand.clone()).len() > 0{
        return (hand.clone(), 9);
    }
    else if checkFourOfAKind(hand.clone()).len() > 0{
        return (hand.clone(), 8);
    }
    else if checkFullHouse(hand.clone()).len() > 0{
        return (hand.clone(), 7);
    }
    else if checkFlush(hand.clone()).len() > 0{
        return (hand.clone(), 6);
    }
    else if checkStraight(hand.clone()).len() > 0{
        println!("STRAIGHT {:?}",checkStraight(hand.clone()));
        return (hand.clone(), 5);
    }
    else if checkThreeOfAKind(hand.clone()).len() > 0{
        return (hand.clone(), 4);
    }
    else if checkTwoPair(hand.clone()).len() >0 {
        return (hand.clone(), 3);
    }
    else if checkPair(hand.clone()).len() >0{
        return (hand.clone(), 2);
    }
    else{
        return (hand.clone(), 1)
    }
}
fn tieBreakerStraightFlush(hand1:[String;7],hand2:[String;7]) -> Vec<String>{
    let h1 = checkStraightFlush(hand1.clone());
    let h2 = checkStraightFlush(hand2.clone());

    let highestRank1 = getHighCard(h1.clone());
    let highestRank2 = getHighCard(h2.clone());


    if highestRank1 > highestRank2{
        return h1.clone();
    } 
    else if highestRank2 > highestRank1{
        return h2.clone();
    }
    else{
        return h1.clone();
    }

}
fn tieBreakerFourOfAKind(hand1:[String;7],hand2:[String;7]) -> Vec<String>{
    let h1 = checkFourOfAKind(hand1.clone());
    let h2 = checkFourOfAKind(hand2.clone());

    let highestRank1 = getHighCard(h1.clone());
    let highestRank2 = getHighCard(h2.clone());

    
    if highestRank1 > highestRank2{
        return h1.clone();
    } 
    else if highestRank2 > highestRank1{
        return h2.clone();
    }
    else{
        return h1.clone();
    }
}
fn subtract(a: &Vec<String>, b: &Vec<String>) -> Vec<String> {
    let mut c = a.clone();
    c.retain(|x| !b.contains(x));
    return c;
}
fn tieBreakerFullHouse(hand1:[String;7],hand2:[String;7]) -> Vec<String>{
    let h1 = checkFullHouse(hand1.clone());
    let h2 = checkFullHouse(hand2.clone());

    let threeKind1 = checkThreeOfAKind(hand1.clone());
    let threeKind2 = checkThreeOfAKind(hand2.clone());

    let pair1 = subtract(&h1, &threeKind1);
    let pair2 = subtract(&h2, &threeKind2);

    let num1 = pair1[0][..pair1[0].len()-1].parse::<u32>().unwrap();
    let num2 = pair2[0][..pair2[0].len()-1].parse::<u32>().unwrap();

    if num1 > num2{
        return h1.clone();
    } 
    else if num2 > num1{
        return h2.clone();
    }
    else{
        return h1.clone();
    }
}
fn tieBreakerFlush(hand1:[String;7],hand2:[String;7]) -> Vec<String>{
    let h1 = checkFlush(hand1.clone());
    let h2 = checkFlush(hand2.clone());

    let x = subtract(&h1, &h2);
    let y = subtract(&h2, &h1);

    if x.len() == 0{
        return h1;
    }
    else{
        let highestRank1 = getHighCard(x);
        let highestRank2 = getHighCard(y);

        if highestRank1 > highestRank2{
            return h1;
        }
        else{
            return h2;
        }
    }
}
fn tieBreakerStraight(hand1:[String;7],hand2:[String;7]) -> Vec<String>{
    let h1 = checkStraight(hand1.clone());
    let h2 = checkStraight(hand2.clone());

    let highestRank1 = getHighCard(h1.clone());
    let highestRank2 = getHighCard(h2.clone());

    if highestRank1 > highestRank2{
        return h1;
    }
    else{
        return h2;
    }
}
fn tieBreakerThreeOfAKind(hand1:[String;7],hand2:[String;7]) -> Vec<String>{
    let h1 = checkThreeOfAKind(hand1);
    let h2 = checkThreeOfAKind(hand2);

    let highestRank1 = getHighCard(h1.clone());
    let highestRank2 = getHighCard(h2.clone());


    if highestRank1>highestRank2{
        return h1;
    }
    else{
        return h2;
    }
}
fn tieBreakerTwoPair(hand1:[String;7],hand2:[String;7]) -> Vec<String>{
    let h1 = checkTwoPair(hand1.clone());
    let h2 = checkTwoPair(hand2.clone());

    let rank1 = getHighCard(h1.clone());
    let rank2 = getHighCard(h2.clone());


    if rank1>rank2{
        return h1;
    }
    else{
        return h2;
    }
}

fn tieBreaker(hand1:[String;7],hand2:[String;7],x:u32) -> Vec<String>{
    
    if x == 10 { return checkRoyalflush(hand1.clone());}
    else if x == 9 { return tieBreakerStraightFlush(hand1.clone(), hand2.clone());}
    else if x == 8{ return tieBreakerFourOfAKind(hand1.clone(), hand2.clone());}
    else if x == 7{ return tieBreakerFullHouse(hand1.clone(), hand2.clone());}
    else if x == 6{ return tieBreakerFlush(hand1.clone(), hand2.clone());}
    else if x == 5{ return tieBreakerStraight(hand1.clone(), hand2.clone());}
    else if x == 4{ return tieBreakerThreeOfAKind(hand1.clone(), hand2.clone());}
    else if x == 3{ return tieBreakerTwoPair(hand1.clone(), hand2.clone());}
    else if x == 2{ return checkPair(hand1.clone());}
    else { return checkHighCard(hand1.clone());}
}

fn determineWinner(hand1:[String;7], hand2:[String;7]) -> Vec<String>{
    let player1Hand = determineHand(hand1.clone());
    let player2Hand = determineHand(hand2.clone());
    println!("Player 1 {}", player1Hand.1);
    println!("Player 2 {}", player2Hand.1);

    if player1Hand.1 > player2Hand.1 {
        let x = player1Hand.1;
        //println!("PLAYER 1");
        //println!("x:{}",x);
        if x == 10 { return checkRoyalflush(hand1.clone());}
        else if x == 9 { return checkStraightFlush(hand1.clone());}
        else if x == 8{ return checkFourOfAKind(hand1.clone());}
        else if x == 7{ return checkFullHouse(hand1.clone());}
        else if x == 6{ return checkFlush(hand1.clone());}
        else if x == 5{ return checkStraight(hand1.clone());}
        else if x == 4{ return checkThreeOfAKind(hand1.clone());}
        else if x == 3{ return checkTwoPair(hand1.clone());}
        else if x == 2{ return checkPair(hand1.clone());}
        else { return checkHighCard(hand1.clone());}
    }
    else if player2Hand.1 > player1Hand.1 {
        //println!("PLAYER 2");
        let x = player2Hand.1;
        //println!("x:{}",x);
        if x == 10 { return checkRoyalflush(hand2.clone());}
        else if x == 9 { return checkStraightFlush(hand2.clone());}
        else if x == 8{ return checkFourOfAKind(hand2.clone());}
        else if x == 7{ return checkFullHouse(hand2.clone());}
        else if x == 6{ return checkFlush(hand2.clone());}
        else if x == 5{ return checkStraight(hand2.clone());}
        else if x == 4{ return checkThreeOfAKind(hand2.clone());}
        else if x == 3{ return checkTwoPair(hand2.clone());}
        else if x == 2{ return checkPair(hand2.clone());}
        else { return checkHighCard(hand2.clone());}
    }
    else{
        return tieBreaker(hand1.clone(), hand2.clone(), player1Hand.1);
    }
}
pub fn deal(perm:[u32;9])->Vec<String>{
    println!("in fn");

    let pool = &perm[4..8];
   // println!("{:?}", pool);

    let p1Hand = [perm[0], perm[2]];
    let p2Hand = [perm[1], perm[3]];

    let p1FullHand = [&perm[0],&perm[2],&perm[4], &perm[5], &perm[6], &perm[7], &perm[8]];
   // println!("Player 1 Hand: {:?}", p1FullHand);
    let p2FullHand = [&perm[1],&perm[3],&perm[4], &perm[5], &perm[6], &perm[7], &perm[8]];
   // println!("Player 2 Hand: {:?}", p2FullHand);

    
    let x = cardFormat(p1FullHand);
    let z = x.clone();
    let y = x.clone();
    println!("Player1 Formatted Hand: {:?}", x);
    println!("Player2 Formatted Hand: {:?}", cardFormat(p2FullHand));

   
    let a = getSuitCount(x);
    let b = getRankCount(y);
    let c = getSuitOfFlush(z);

    //println!("{}", c);
    //println!("{:?}",cardFormat(p1FullHand).contains(&("14".to_string()+c)));
    
    let d = checkRoyalflush(cardFormat(p1FullHand));
    //println!("CHECK {:?}", checkRoyalflush(cardFormat(p1FullHand)).len());

    //println!("equality test {:?}", vec!["AD"]);

    let returnHand = determineWinner(cardFormat(p1FullHand), cardFormat(p2FullHand));
    println!("WINNING HAND: {:?}", returnHand);
    return returnHand;
}

fn main(){
    println!("Hello World!");
    
    let perm:[u32;9]= [ 40, 52, 46, 11, 48, 27, 29, 32, 37 ] ;
    let winner:Vec<String> = deal(perm);

    println!("Winner: {:?}", winner);
}