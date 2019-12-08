//
//  ConcentrationThemeChooserViewController.swift
//  DemoConcentration
//
//  Created by Steve Brinkman on 7/9/18.
//  Copyright © 2018 Steve Brinkman. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {
    let themes = [
        "Sports": "🏈⚾️🎾🏐🎱⚽️🏀🏉🏓🏸⛷🥊",
        "Animals": "🐶🐱🦋🐹🐰🦊🐻🐼🐨🐯🦁🐮",
        "Faces": "😀🤨😎😇🤬😰🤓🤥😩😍🤢🤮",
        "Flags": "🏴‍☠️🏁🏳️‍🌈🇦🇫🇦🇽🇦🇩🇧🇩🇨🇷🇧🇸🇨🇦🇨🇺🇨🇼"
    ]
    //**Assignment 1 extra credit 1
    let themeColors = [
        "Sports": #colorLiteral(red: 1, green: 0.9019543529, blue: 0.891679883, alpha: 1),
        "Animals": #colorLiteral(red: 0.9114038944, green: 0.957275331, blue: 1, alpha: 1),
        "Faces": #colorLiteral(red: 0.7410077453, green: 0.8074329495, blue: 1, alpha: 1),
        "Flags": #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
    ]
    
    
    private var lastSeguedToConcentrationViewController: concentrationViewController?
    
    var senderViewController : concentrationViewController = concentrationViewController()
    

    @IBAction func SetTheme(_ sender: UIButton) {
        changeTheme(sender)
    }
    
    func changeTheme(_ sender: Any) {
        if let themeName = (sender as? UIButton)?.currentTitle{
            senderViewController.theme = themes[themeName]
            if let mybutton = (sender as? UIButton){
                mybutton.setTitleColor(UIColor.darkGray, for: .normal)
            }
        }
    }
    
    
 
    /*if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
        // use as to downcast
        if let cvc = segue.destination as? concentrationViewController{
            cvc.theme = theme
            //**Assignment 1 extra credit 1
            cvc.themeColor = themeColors[themeName]
            lastSeguedToConcentrationViewController = cvc
        }
    }*/*/
    
    
    
    

 }
