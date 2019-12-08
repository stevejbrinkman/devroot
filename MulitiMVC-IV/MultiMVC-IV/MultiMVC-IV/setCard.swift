//
//  Card.swift
//  SetGame
//
//  Created by Steve Brinkman on 4/25/19.
//  Copyright © 2019 Steve Brinkman. All rights reserved.
//

import Foundation
struct setCard: Hashable{
    
    var myCount: Int
    var myShape: setGame.shape
    var myFill: setGame.fill
    var myColor: setGame.color
    var isFaceUp = false
    var buttonIndex: Int? = nil
    
    
    init(_ Shape: setGame.shape, _ Color: setGame.color, _ Fill: setGame.fill, _ SymbolCount: Int)
    {
        myCount = SymbolCount
        myShape = Shape
        myColor = Color
        myFill = Fill
        
        //identifier = card.getUniqueIdentifier()  ** will assign as card assigns to button
        identifier = nil
       
            
        }
  
    var identifier: Int?
    
    //double equal implementation for Equatable protocol
    static func ==(lhs: setCard, rhs: setCard)-> Bool{
        return lhs.identifier == rhs.identifier
    }
    
    //Implementations of Hashable and Equatable
    //depricated: var hashValue: Int {return identifier}
    func hash(into hasher : inout Hasher ){
        hasher.combine(identifier)
    }
    
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int    {
        identifierFactory += 1
        return identifierFactory
    }
    
    
    
}
