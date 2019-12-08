//
//  CardBehavior.swift
//  SetGameAnimatedIV
//
//  Created by Steve Brinkman on 9/3/19.
//  Copyright © 2019 Steve Brinkman. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {

    
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.2
        behavior.resistance = 0.3
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem){
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (2*CGFloat.pi).arc4random
        push.magnitude = CGFloat(1.0) + CGFloat(3.0).arc4random
        //note: push and self are variables used "in" the closure
        push.action = {[unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem){
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem){
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    
    
    override init(){
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator){
        self.init()
        animator.addBehavior(self)
        
    }
    
}
