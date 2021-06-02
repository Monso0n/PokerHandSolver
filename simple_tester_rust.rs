
#![allow(non_snake_case)]
#![allow(non_camel_case_types)]

pub mod Poker;

fn main() 
{
    let cards:[&str;52] = [ 
        "1C", "2C", "3C", "4C", "5C", "6C", "7C", "8C", "9C", "10C", "11C", "12C", "13C",
		"1D", "2D", "3D", "4D", "5D", "6D", "7D", "8D", "9D", "10D", "11D", "12D", "13D",
		"1H", "2H", "3H", "4H", "5H", "6H", "7H", "8H", "9H", "10H", "11H", "12H", "13H",
	    "1S", "2S", "3S", "4S", "5S", "6S", "7S", "8S", "9S", "10S", "11S", "12S", "13S" 
    ];

    let perms:[[u32;9]; 10] = [
        [ 9,  8,  7,  6,  5,  4,  3,  2,  1  ],  // 1   2-6 Straight flush VS 1-5 straight flush
        [ 40, 41, 42, 43, 48, 49, 50, 51, 52 ],  // 2   Royal flush VS straight flush
        [ 40, 41, 27, 28, 1,  14, 15, 42, 29 ],  // 3   Four aces VS 2-full-of-A
        [ 30, 13, 27, 44, 12, 17, 33, 41, 43 ],  // 4   3-fours VS 2-fours
        [ 27, 45, 3,  48, 44, 43, 41, 33, 12 ],  // 5   Flush VS straight
        [ 17, 31, 30, 51, 44, 43, 41, 33, 12 ],  // 6   3-fours VS 2-queens-2-fives
        [ 17, 39, 30, 52, 44, 25, 41, 51, 12 ],  // 7   Q-full-of-K VS Q-full-of-4
        [ 11, 25, 9,  39, 50, 48, 3,  49, 45 ],  // 8   9-K straight VS 9-J-two-pair
        [ 50, 26, 39, 3,  11, 27, 20, 48, 52 ],  // 9   J-K-two-pair VS K-pair
        [ 40, 52, 46, 11, 48, 27, 29, 32, 37 ]  // 10  A-pair VS J-pair
    ];

    let sols:[Vec<&str>; 10] = [
        vec![ "2C",  "3C",  "4C",  "5C",  "6C"  ],  // 1   2-6 Straight flush
        vec![ "10S", "11S", "12S", "13S", "1S"  ],  // 2   Royal flush
        vec![ "1C",  "1D",  "1H",  "1S"         ],  // 3   Four aces
        vec![ "4D",  "4H",  "4S"                ],  // 4   3-fours
        vec![ "2S",  "4S",  "5S",  "6S",  "9S"  ],  // 5   Flush
        vec![ "4D",  "4H",  "4S"                ],  // 6   3-fours
        vec![ "12C", "12D", "12S", "13H", "13S" ],  // 7   Q-full-of-K
        vec![ "10S", "11S", "12D", "13H", "9S"  ],  // 8   9-K straight
        vec![ "11C", "11S", "13H", "13S",       ],  // 9   J-K-two-pair
        vec![ "1H",  "1S"                       ]  // 10  Ace-pair
    ];

    let mut totalScore = 0.0;
    let mut totalTests = 0;
    
    for i in 0..perms.len()
    {
        let input = &perms[i];
        let shouldBe = &sols[i];
        let youSaid  = Poker::deal(*input).to_vec();  // Change this for fall term.

        let mut deal = Vec::new();
        for j in 0..9 {
            deal.push(cards[(input[j] - 1) as usize]);
        }
        
        let mut score = 0;
        for j in shouldBe {
            if youSaid.contains(&String::from(*j)) {
                score += 1;
            }
        }
        if youSaid.len() > 5 {
            score = 0;
        }
        
        let c = shouldBe.len();
        if score == c {
            println!("Test {} FULL MARKS  ({} of {} cards correct)", i+1, c, c);
        }
        else if score == 0 {
            println!("Test {} DICREPANCY: {:?}", i+1, input);
            println!("  P1:   {},{}", deal[0], deal[2]);
            println!("  P2:   {},{}", deal[1], deal[3]);
            println!("  Pool: {},{},{},{},{}", deal[4], deal[5], deal[6], deal[7], deal[8]);
            println!("  You returned:   {:?}", youSaid);
            println!("  Returned more than five cards! Test FAILED!");
        }
        else {
            println!("Test {} DICREPANCY: {:?}", i+1, input);
            println!("  P1:   {},{}", deal[0], deal[2]);
            println!("  P2:   {},{}", deal[1], deal[3]);
            println!("  Pool: {},{},{},{},{}", deal[4], deal[5], deal[6], deal[7], deal[8]);
            println!("  You returned:   {:?}", youSaid);
            println!("  Should contain: {:?}", shouldBe);
            println!("  {} of {} cards correct", score, c);
        }
            
        totalScore += score as f64 / shouldBe.len() as f64;
        totalTests += 1;
        
    }
    
    println!("\nTotal score: {:.1}% ({:.1}/{} points)\n", 100.0*totalScore/totalTests as f64, totalScore, totalTests);
}


