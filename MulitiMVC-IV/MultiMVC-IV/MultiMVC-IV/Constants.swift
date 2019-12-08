//
//  Constants.swift
//  SetGame
//
//  Created by Steve Brinkman on 5/27/19.
//  Copyright © 2019 Steve Brinkman. All rights reserved.
//

import Foundation
import AVFoundation

struct ViewConstants{
    static let SETSOUND:SystemSoundID = 1025
    static let NOTSETSOUND:SystemSoundID = 1024
    static let MAX_SYMBOLS = 3
    static let SYMBOL_X_OFFSET_FACTOR: CGFloat = 0.1
    static let STRIPE_SPACE: CGFloat = 7.0
}


struct modelConstants{
    static let TOTALCARDS = 81
    static let MAXCARDS = 24
    static let FIRSTCARDCOUNT = 15
}

let titleString: String = "Set Scoring: \n"
let rulesString = "5 points if up to 6 cards displayed \n"
    + "4 points if 7-12 cards displayed \n"
    + "3 points if 13-18 cards displayed \n"
    + "2 points if 19-24 cards displayed \n\n"
    + "-1 point penalty if more than 60 seconds \n to make a set"

let defaultConcentrationTheme: String  = "🏴‍☠️🏁🏳️‍🌈🇦🇫🇦🇽🇦🇩🇧🇩🇨🇷🇧🇸🇨🇦🇨🇺🇨🇼"

extension CGFloat
{
    var arc4random: CGFloat
    {
        if self > 0
        {
            return CGFloat(arc4random_uniform(UInt32(self)))
        }
        else if  self < 0
        {
            return -CGFloat(arc4random_uniform(UInt32(abs(self))))
        }
        else
        {
            return 0
        }
    }
}
