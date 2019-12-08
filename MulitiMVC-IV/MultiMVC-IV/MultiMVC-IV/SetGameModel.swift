//
//  SetGameModel.swift
//  SetGame
//
//  Created by Steve Brinkman on 4/25/19.
//  Copyright © 2019 Steve Brinkman. All rights reserved.
//

import Foundation
struct setGame{
    enum shape: String, CaseIterable{
        case diamond
        case squiggle
        case oval
    }
   
    
    enum fill: Int, CaseIterable {
        case empty
        case stripes
        case solid
    }
    
    enum color: String, CaseIterable{
        case red 
        case green
        case purple
    }
    
    var symbolCount = 0
   
    private lazy var myWatch: watch = watch()
    private  (set) var myCardDeck = [setCard]()
    private var sets = [[setCard]]() //An array of arrays
    var dealtCards = [setCard?]()
    var elapsed: Double {
        mutating get{
            return Double(myWatch.Interval())
        }
    }
    var gameScore = 0
    
   
    
    init(){
        var cards = [setCard]()
        var IdCounter = 0
        //populate card deck
        for Shape in shape.allCases{
            for Fill in fill.allCases{
                for Color in color.allCases{
                    for myCount in 1...ViewConstants.MAX_SYMBOLS{
                        var myCard = setCard(Shape, Color, Fill, myCount)
                        IdCounter += 1
                        myCard.identifier = IdCounter
                        cards.append(myCard)
                    }
                    
                }
            }
        }
        myCardDeck = cards
        myWatch.start()
    }
    
    
    //Set Determiner parent
    mutating func isSet(for selectedCards: [setCard], update: Bool = true) -> Bool{
        var bIsSet = false
        
        if (selectedCards.count == 3){

            
        
        bIsSet = (
                (isFeatureSet(card1: selectedCards[0].myCount, card2: selectedCards[1].myCount, card3: selectedCards[2].myCount))
                && (isFeatureSet(card1: selectedCards[0].myColor.rawValue, card2: selectedCards[1].myColor.rawValue, card3: selectedCards[2].myColor.rawValue))
                && (isFeatureSet(card1: selectedCards[0].myFill.rawValue, card2: selectedCards[1].myFill.rawValue, card3: selectedCards[2].myFill.rawValue))
                && (isFeatureSet(card1: selectedCards[0].myShape.rawValue, card2: selectedCards[1].myShape.rawValue, card3: selectedCards[2].myShape.rawValue))
            )
            if bIsSet == true && update == true{
                setGameScore()
                myWatch.start()
                
            }
        }
        return bIsSet
        
        }
    //Set Feature Determiner
    private func isFeatureSet(card1: String, card2: String, card3: String) -> Bool{
        //Each feature in the three cards is all the same or all different, evaluated one at a time
        return ((card1 == card2) && (card1 == card3)) || ((card1 != card2) && (card1 != card3) && (card2 != card3))
    
    }
    
    mutating func setGameScore(){
        gameScore += 1
        /*switch dealtCards.count{
        case 3...6:
            gameScore += 5
        case 7...12:
            gameScore += 4
        case 13...18:
            gameScore += 3
        case 19...24:
            gameScore += 2

        default: gameScore += 0
            
        }
        let timeSinceStartTimer = abs(Int(self.elapsed))
        if timeSinceStartTimer >= 60{
            gameScore -= 1
        }*/
        
    }
    
    //Set Feature Determiner for type symbolCount (enum type)
    private func isFeatureSet(card1: Int, card2: Int, card3: Int) -> Bool{
        //Each feature in the three cards is all the same or all different, evaluated one at a time
        return ((card1 == card2) && (card1 == card3)) || ((card1 != card2) && (card1 != card3) && (card2 != card3))
        
    }
    
    mutating func drawCard(forId: Int)->setCard?{
        if myCardDeck.count > 0{
            var randomIndex: Int = 0
            randomIndex = myCardDeck.count.arc4random
            let myCard = myCardDeck.remove(at: randomIndex)
            dealtCards.append(myCard)
            
            return myCard
        }
        else {return nil}
        
        
    }
    mutating func addSet(forSet: [setCard]){
        var setArray = [setCard]()
        
        for setCard in 0..<forSet.count{
            setArray.append(forSet[setCard])
            dealtCards.removeAll(where: {$0?.identifier == forSet[setCard].identifier})
        }
        sets.append(setArray)
    }
    
    func shuffleCards(for unshuffled: [setCard]) -> [setCard]{
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





extension Int{
    var tostring: String{
        return {String(self)}()
        
    }
}
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
}



