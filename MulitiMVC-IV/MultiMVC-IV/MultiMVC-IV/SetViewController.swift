//
//  SetViewController.swift
//  SetGame
//
//  Created by Steve Brinkman on 4/25/19.
//  Copyright © 2019 Steve Brinkman. All rights reserved.
//

import UIKit
import AVFoundation

class SetViewController: UIViewController {
    
    private lazy var myModel = setGame()
    
    private var seconds = 0
    private var timer = Timer()
    private var score = 0
    private var isTimerRunning = false
    lazy var deckFrame = deckStackView.convert(DeckButton.frame, to: self.view)
    lazy var discardFrame = deckStackView.convert(discardView.frame, to: self.view)
    var myDelay: TimeInterval = 0.25
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator)
    
    
    private var viewGrid = Grid(layout: Grid.Layout.aspectRatio(CGFloat(5.0 / 8.0)),
                                frame: CGRect(origin: CGPoint(x: 5, y: 25), size: CGSize(width: 365.0, height: 500.0)), reductionRate: 0.1)
                                
    //for this app, I will restrict rotation of the UI to focus on animation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
            
        }
    }
    
    //selectedCards - an array of setCards, the view for which is currently selected on the main view, either part of a complete set or not.
    private var selectedCards = [setCard]()
    
    //cardViews - an array of views currently in play
    private var cardViews: [setCardView?] = [setCardView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup swipe and rotate gestures
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleDealtCards(_:)))
        SetGameView.addGestureRecognizer(rotate)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeDeal(_:)))
        swipe.direction = .up
        SetGameView.addGestureRecognizer(swipe)
        
        animator.addBehavior(cardBehavior)
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self,   selector: (#selector(self.NewGame)), userInfo: nil, repeats: false)
        //self.NewGame()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator){
        super.viewWillTransition(to: size, with: coordinator)
        
        var targetWidth: CGFloat = 0.0
        var targetHeight: CGFloat = 0.0
        if UIDevice.current.orientation.isLandscape{
            targetWidth = view.frame.width * 0.7
            targetHeight = view.frame.height * 0.8
            
        }
        else{
            targetWidth = view.frame.width * 0.8
            targetHeight = view.frame.height * 0.7
            
        }
        viewGrid.frame = CGRect(x: view.frame.minX + 5, y: view.frame.minY + 5, width: targetWidth, height: targetHeight)
        rebuild()
    }
    
    @objc func swipeDeal(_ sender : UISwipeGestureRecognizer){
        switch sender.state{
        case .ended:
            deal(howMany: 3)
        default:
            return
        }
    }
    
    @objc private func shuffleDealtCards(_ sender : UIRotationGestureRecognizer){
        
        switch sender.state{
        case .ended:
            myModel.dealtCards = myModel.shuffleCards(for: myModel.dealtCards as! [setCard])
            for cardView in cardViews{
                cardView?.removeFromSuperview()
            }
            cardViews.removeAll()
            for index in 0..<myModel.dealtCards.count{
                if let rect = viewGrid[index]{
                    if let myCard = myModel.dealtCards[index]{
                        let myView = setCardView(frame: rect, forCard: myCard)
                        myView.backgroundColor = UIColor.clear
                        myView.addTarget(self, action: #selector(touchCard), for: .touchUpInside)
                        view.addSubview(myView)
                        cardViews.append(myView)
                    }
                }
            }
        default:
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print ("didReceive Memory Warning !!")
    }
    

    @IBAction func deal3(_ sender: UIButton) {
        deal(howMany: 3)
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        NewGame()
    }
 
    @IBOutlet weak var discardLabel: UILabel!
    @IBOutlet weak var DeckButton: UIButton!
    @IBOutlet weak var deckStackView: UIStackView!
    @IBOutlet weak var SetGameView: UIView!
    @IBOutlet weak var discardView: UIView!{
        didSet{updateScoreLabel()}
    }
    
    @objc private func deal(howMany: Int = 1){
        viewGrid.cellCount += howMany
        rebuild()
        var usedGridIndex = cardViews.count
        myDelay = 0.25
        for _ in 0..<howMany{
            if let rect = viewGrid[usedGridIndex]{
                if let myCard = myModel.drawCard(forId: usedGridIndex){
                    var myView = setCardView(frame: deckFrame, forCard: myCard)
                    myDelay += 0.15
                    myView = myView.dealMe( toLocation: rect, Delay: myDelay)
                    myView.addTarget(self, action: #selector(touchCard), for: .touchUpInside)
                    cardViews.append((myView))
                    view.addSubview(myView)
                }
                else
                {
                    print ("no cards left")
                }
                usedGridIndex += 1
            }
        }
    }
    
    private func updateScoreLabel(){
        //tutorial on NSAttributedString lecture 4
        let attributes: [NSAttributedString.Key:Any] =  [:]
        var AttributedString = NSAttributedString(string: "Discards", attributes: attributes)
        if myModel.gameScore > 0{
            AttributedString = NSAttributedString(string: "Sets: " + String(myModel.gameScore), attributes: attributes)
        }
        discardLabel.attributedText = AttributedString
        
    }
    
    private func renderUnusedSubView(forSubView myView: setCardView){
        myView.backgroundColor = UIColor.green
    }
    
    private func setButtonBorder(forButton button: UIButton, toColor color: CGColor, forWidth width: CGFloat){
        button.layer.borderWidth = width
        button.layer.borderColor = color
    }
    
    private func deSelectCards(forCards: [setCard]) ->[setCard]
    {
        for setCard in forCards
        {
            if let cardView = getCardView(sender: setCard){
                setButtonBorder(forButton: cardView, toColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), forWidth: 0.0)
                cardView.isSelected = false
            }
        }
        var cards = forCards
        cards.removeAll()
        return cards
    }
    
    func updateViewFromModel(){
        updateScoreLabel()
    }
 
    @objc private func rebuild(){
        for cardView in cardViews{
            cardView?.removeFromSuperview()
        }
        cardViews.removeAll()
        selectedCards.removeAll()
        for i in 0..<myModel.dealtCards.count{
            let cardView = setCardView(frame: viewGrid[i]!, forCard: myModel.dealtCards[i]!)
            cardView.frame = viewGrid[i]!
            cardView.backgroundColor = UIColor.clear
            cardView.addTarget(self, action: #selector(touchCard), for: .touchUpInside)
            cardView.isFaceUp = true
            cardViews.append(cardView)
            view.addSubview(cardView)
        }
    }
    
    @objc func touchCard(sender: UIButton!){
        let senderCardView: setCardView = sender as! setCardView
        
        //If already selected, de-select
        if sender.isSelected{
            sender.layer.borderWidth = 0.0
            sender.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            sender.isSelected = false
            selectedCards.removeAll(where:  {$0.identifier == senderCardView.card.identifier})
        }
        else{
            //touched card not already selected
            if let selectedCard = myModel.dealtCards.filter({ $0?.identifier == senderCardView.card.identifier}).first{
                selectedCards.append(selectedCard!)
                if selectedCards.count == 3{
                    if myModel.isSet(for: selectedCards){
                        for selectedCard in selectedCards{
                            if let button = cardViews.filter({$0?.card.identifier == selectedCard.identifier}).first{
                                button!.layer.borderWidth = 5.0
                                button!.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
                                button!.isSelected = true
                            }
                        }
                        AudioServicesPlayAlertSound (ViewConstants.SETSOUND)
                        myModel.addSet(forSet: selectedCards)
                        //Increment score
                        score += 1
                        animateRemoveSet()
                    }
                    else{// 3 cards selected but not a set
                        sender.isSelected = true
                        //Animate setting the selected card border yellow over a short duration, then do completion of animating removal all selected cards
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2.0, delay: 0.0, options: [], animations: {sender.layer.borderColor = UIColor.yellow.cgColor
                            sender.layer.borderWidth = 3.0
                        }, completion: {if $0 == .end {self.animateUnSelect()}})
                        AudioServicesPlayAlertSound (ViewConstants.NOTSETSOUND)
                    }
                }
                else{ //fewer than three cards so highlight as selected.
                    sender.layer.borderWidth = 3.0
                    sender.layer.borderColor = UIColor.yellow.cgColor
                    sender.isSelected = true}
                }//end Highlight yellow
            }//Selected card not already selected
            updateViewFromModel()
        }
    
    private func animateRemoveSet(){
        myDelay = 0.0
        for setPart in cardViews{
            if setPart!.isSelected{
                
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1.5,
                    delay: myDelay,
                    options: [],
                    animations: {[weak self] in self!.cardBehavior.addItem(setPart!)},
                    completion: nil)
            }
            myDelay += 2.0
        }
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self,   selector: (#selector(self.stopAnimation)), userInfo: nil, repeats: false)
        selectedCards.removeAll()
    }
    
    @objc private func stopAnimation(){
        for setPart in cardViews{
            if setPart!.isSelected{
                setPart!.layer.removeAllAnimations()
                self.cardBehavior.removeItem(setPart!)
                setPart!.removeSet(toLocation: self.discardFrame)
            }
        }
        cardViews.removeAll(where: {$0?.isSelected == true})
        viewGrid.cellCount -= 3
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self,   selector: (#selector(deal3)), userInfo: nil, repeats: false)
    }
    
    private func animateUnSelect(){
        for selectedCard in cardViews{
            if selectedCard!.isSelected{
                selectedCard!.viewUnselect()
                }
            }
       selectedCards.removeAll()
    }

    @objc private func NewGame(){
        myModel =  setGame()
        for cardView in cardViews{
            cardView?.removeFromSuperview()
        }
        viewGrid.cellCount = 0
        deal(howMany: modelConstants.FIRSTCARDCOUNT)
        myModel.gameScore = 0
        updateScoreLabel()
        selectedCards.removeAll()
    }

    private func getCardView(sender: setCard) -> setCardView?{
        if let cardView = cardViews.filter({ $0?.card.identifier == sender.identifier }).first
        {
            return cardView
        }
        return nil
    }
    
    private func formatCardFace(forCard: setCard) ->NSAttributedString{
        let font = UIFont.systemFont(ofSize: 20)
        var symbolColor: UIColor = UIColor.purple
        var alphaPercent: CGFloat = 0.0
        let symbolShape: String = forCard.myShape.rawValue
        let attribString = NSMutableAttributedString()
        
        switch forCard.myFill{
            case setGame.fill.solid: alphaPercent = 1.0
            case setGame.fill.stripes: alphaPercent = 0.15
            case setGame.fill.empty: alphaPercent = 0.0
        }
        
        switch forCard.myColor{
            case setGame.color.red : symbolColor = UIColor.red
            case setGame.color.green: symbolColor = UIColor.green
            case setGame.color.purple: symbolColor = UIColor.blue
        }
        
        for i in 1...forCard.myCount{
            let myAttributes: [NSAttributedString.Key:Any] = [
                .font : font,
                .foregroundColor : symbolColor.withAlphaComponent(alphaPercent),
                .strokeWidth : -5.0,  // use negative number here otherwise other attributes will not take effect.
                .strokeColor : symbolColor,
                ]
            
            attribString.append(NSMutableAttributedString(string: String(symbolShape), attributes: myAttributes))
            if i < forCard.myCount{
                attribString.append(NSMutableAttributedString(string: "\n"))
            }
        }
        return attribString
    }
}
//Extension
extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}



    
    


