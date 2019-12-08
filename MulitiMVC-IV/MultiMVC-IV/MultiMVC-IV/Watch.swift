//
//  Watch.swift
//  DemoConcentration
//
//  Created by Steve Brinkman on 4/20/19.
//  Copyright © 2019 Steve Brinkman. All rights reserved.
//

import Foundation
struct watch{
    private var myDate:  Date = Date()
    private var GameDuration: TimeInterval = 0
    
    mutating func start(){
        myDate = Date()
    }
    func Interval() -> Double
    {
        return  myDate.timeIntervalSinceNow
    }
}
