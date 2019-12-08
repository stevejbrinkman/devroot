//
//  Card.swift
//  DemoConcentration
//
//  Created by Steve Brinkman on 5/10/18.
//  Copyright © 2018 Steve Brinkman. All rights reserved.
//
//  Implements Hashable and Equateable protocols

//  *** this is part of a model ***

import Foundation

struct Card: Hashable
{
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    //Implementations of Hashable and Equatable
    //depricated: var hashValue: Int {return identifier}
    func hasher(into hasher :  inout Hasher) {
        hasher.combine(identifier)
    }
    
    //double equal implementation for Equatable protocol
    static func ==(lhs: Card, rhs: Card)-> Bool{
        return lhs.identifier == rhs.identifier
    }
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int    {
        identifierFactory += 1
        return identifierFactory
    }
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
