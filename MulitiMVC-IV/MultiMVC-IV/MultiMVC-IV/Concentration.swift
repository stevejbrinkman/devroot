//
//  Concentration.swift
//  DemoConcentration
//
//  Created by Steve Brinkman on 5/10/18.
//  Copyright © 2018 Steve Brinkman. All rights reserved.
//
//  *** this is part of a model  ***

import Foundation
//class Concentration
struct concentration{
    
    private(set) var cards = [Card]()
    //Assignment 1 #8
    var flipCount: Int = 0
    
    //Extra Credit #2
    private lazy var myWatch: watch = watch()
    var elapsed: Double = 0.0
    
    
    private var IndexOfTheOneAndOnlyFaceUpCard: Int?
    {
        get{
            //using extension oneAndOnly defined in this file
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
        

        }

        set(newValue){
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    private var selectedNoMatches = [Int:Card]()
    //private var selectedNoMatches = [Card:String]()
    var score = 0
    
    mutating func chooseCard(at index: Int)
    {
        assert(cards.indices.contains(index), "Concentration.chooseCard: \(index)): chosen index not in the cards!")
        elapsed = myWatch.Interval()
        
        if !cards[index].isMatched{
            if let matchIndex = IndexOfTheOneAndOnlyFaceUpCard, matchIndex != index{
                //check if cards match
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 1 //
                    selectedNoMatches.removeValue(forKey: index) //
                    selectedNoMatches.removeValue(forKey: matchIndex) //
                }
                else{
                    if (selectedNoMatches.index(forKey: index) != nil){
                        score -= 1
                    }
                    else
                    {
                        selectedNoMatches[index] = cards[index]
                        
                    }
                    if (selectedNoMatches.index(forKey: matchIndex) != nil){
                            score -= 1
                    }
                    else{
                        selectedNoMatches[matchIndex] = cards[matchIndex]
                    }
                    
                }
                cards[index].isFaceUp = true
                
            }
            else {
                //either 2 cards or no cards are face up
                IndexOfTheOneAndOnlyFaceUpCard = index
            }
        }
        
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.numberOfPairsOfCards: Must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards
        {
            let card = Card()
            cards += [card, card]  //append an array to an array
        }
       
        cards = shuffleCards(for: cards)
        myWatch.start()
        
        
      
        
        
    }
    private func shuffleCards(for unshuffled: [Card]) -> [Card]{
        var shuffledCards = [Card]()
        var workCards = unshuffled
        var randomIndex: Int = 0
        while workCards.count > 0{
            randomIndex = workCards.count.arc4random
            shuffledCards.append(workCards.remove(at: randomIndex))
        }
        return shuffledCards
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
