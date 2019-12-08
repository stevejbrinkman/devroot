//
//  CardDeck.swift
//  SetGame
//
//  Created by Steve Brinkman on 4/28/19.
//  Copyright © 2019 Steve Brinkman. All rights reserved.
//

import Foundation
struct cardDeck{
    private var myDealtCards = [setCard?]()
    var dealtCards: [setCard?]
    {
        get{return myDealtCards}
        set (newValue){myDealtCards = newValue}
    }
    private(set) var myDeck = [setCard]()
    
    
   
    mutating func drawCards(thisMany: Int) -> [setCard?]
    {
        
        for _ in 0..<thisMany{
            var randomIndex: Int = 0
            randomIndex = myDeck.count.arc4random
            dealtCards.append(myDeck.remove(at: randomIndex))
        }
    
    return dealtCards
    }
    
    init(_ deck: [setCard]){
        myDeck = deck
        
    }
    private func shuffleCards(for unshuffled: [setCard]) -> [setCard]{
        var shuffledCards = [setCard]()
        var workCards = unshuffled
        var randomIndex: Int = 0
        while workCards.count > 0{
            randomIndex = workCards.count.arc4random
            shuffledCards.append(workCards.remove(at: randomIndex))
        }
        return shuffledCards
    }
    
}
//Extension example for class Int
/*
extension Int
{
    var arc4random: Int
    {
        if self > 0
        {
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if  self < 0
        {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }
        else
        {
            return 0
        }
    }
}*/
