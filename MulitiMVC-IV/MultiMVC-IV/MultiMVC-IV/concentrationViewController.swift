//
//  ViewController.swift
//  DemoConcentration
//
//  Created by Steve Brinkman on 5/9/18.
//  Copyright © 2018 Steve Brinkman. All rights reserved.
//
//  From Stanford University school of engineering
//  Developing apps for iOS CS193p lecture by Michel Deiman - youtube
//

import UIKit

class concentrationViewController : UIViewController {
    
    // Initialization is done by calling the class initializer - (No need for = "new" concentration, just concentration())
    //lazy variables won't instantiate until they are referenced (used)
    private lazy var game = concentration(numberOfPairsOfCards: numberOfPairsOfCards )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }
    
    var numberOfPairsOfCards: Int{
        get {
            return (cardButtons.count + 1) / 2
        }
    }
    //************************
    // MARK: Update Label functions
    //************************
    func updateFlipCountLabel(){
        //tutorial on NSAttributedString lecture 4
        let attributes: [NSAttributedString.Key:Any] =  [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        ]
        let AttributedString = NSAttributedString(string: "Flips \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = AttributedString
        
        
    }
    func updateScoreLabel(){
        //tutorial on NSAttributedString lecture 4
        let attributes: [NSAttributedString.Key:Any] =  [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            
        ]
        let AttributedString = NSAttributedString(string: "Score: \(game.score)", attributes: attributes)
        scoreLabel.attributedText = AttributedString
        
        
    }
    func updateTimeLabel(){
        let attributes: [NSAttributedString.Key:Any] =  [
            .strokeColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            .font : UIFont .systemFont(ofSize: 12.0)
            
        ]
        let AttributedString = NSAttributedString(string: "Time: \(abs(Int(game.elapsed)))", attributes: attributes)
        timeLabel.attributedText = AttributedString
    }
    
    
    //*********************
    // MARK: Outlets and Action hookups
    //*********************
    
    @IBAction private func Reset(_ sender: UIButton) {
        //simple demo of super/sub views
        if let myParent = sender.superview{
            print("myParent subviews: \(myParent.subviews.count)")
        }
        
        newGame()
    }
    
    
   @IBOutlet weak var scoreLabel: UILabel!{
        didSet
        {updateScoreLabel()
            
        }
    }
    
    // weak
    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet{
            //can do this because the outlet gets hooked up for you and this fires.
            updateFlipCountLabel()
        }
    }
    
    //Array
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet weak var timeLabel: UILabel!{
        didSet{
            updateTimeLabel()
        }
    }
    
    
    
    //Action event procedure
    @IBAction private func touchCard(_ sender: UIButton) {
        
        game.flipCount += 1
 
        //Constant holding optional using "if let"
        if let cardNumber = cardButtons.firstIndex(of: sender){
            print (cardNumber)
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
        else{
            print ("Chosen card was not in cardButtons")
        }
        
    }
    //MARK: funcs and vars
    //Go to the model to find the state of cards and update the buttons accordingly
    func updateViewFromModel()
    {
        if cardButtons != nil{
            for index in cardButtons.indices{
                let button = cardButtons[index]
                let card = game.cards[index]
                //This is information in the model (Whether the card is faceup or not)
                if card.isFaceUp{
                    
                    print(card)
                    print (emoji(for: card));
                    
                    button.setTitle(emoji(for: card), for: UIControl.State.normal);
                    button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
                else{
                    button.setTitle("", for: .normal);
                    //Note: to specify color from color picker place insertion point in valid location and
                    // use intellisense to select "color literal".  double click on the color square to open the
                    // color picker and select color.
                    button.backgroundColor =   card.isMatched ? #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                    
                }
            }
            updateScoreLabel()
            updateTimeLabel()
            updateFlipCountLabel()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "Choose Theme"){
            //important to understand how the sender is cast to UIButton:
            if let cvc = segue.destination as? ConcentrationThemeChooserViewController{
                cvc.senderViewController = self
            }
         
            
        }
    }
    
    private func newGame(){
        game = concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        game.flipCount = 0
        updateFlipCountLabel()
        emojiChoices = ""
        if (lastTheme == ""){
            theme = defaultConcentrationTheme
        }
        else {
            theme = lastTheme
        }
        if let myTopview = self.view{
            print ("top view subviews count: \(myTopview.subviews.count)")
        }
    }
    
    var lastTheme: String = ""
    //**Assignment 1 extra credit 1
    var themeColor: UIColor?{
        didSet{
            self.view.backgroundColor = themeColor
        }
    }
    var theme: String?{
        didSet{
            if cardButtons != nil{
                game = concentration(numberOfPairsOfCards: numberOfPairsOfCards)
            }
            emojiChoices = theme ?? ""
            lastTheme = theme ?? ""
            emoji = [:]
            updateViewFromModel()
            print(emojiChoices)
        }
    }
    //emoji's are actually unicode text with a presentation modifier
    private var emojiChoices = ""
    
    //var emoji = Dictionary<Int,String>() //variation of the following
    private var emoji = [Int:String]()
    
    private func emoji(for card: Card) -> String
    {
       
        //Composite if statement using "," as divider (AND)
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            //NOTE: Strings are not indexed by integers, so we need to create a variable/constant of type string index to make this work
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            // need to convert the character extracted by the remove() function to a string
            emoji[card.identifier] = String(emojiChoices.remove(at: randomStringIndex))
            
        }
        //"default operator" '??' ->a ?? b is value of a (i.e. a!), unless a is nil, in which case it yields b
        // AKA nil coalescing operator
       
        return emoji[card.identifier] ?? "?"
    }
}

//MARK: Extensions
//Extension example for class Int
/*extension Int{
    var arc4random: Int{
        if self > 0{
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

