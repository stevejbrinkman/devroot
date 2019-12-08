//
//  setCardView.swift
//  SetGame
//
//  Created by Steve Brinkman on 4/29/19.
//  Copyright © 2019 Steve Brinkman. All rights reserved.
//

import UIKit

class setCardView: UIButton {
   
    @IBInspectable
    var count: Int = 1 {
        didSet {setNeedsDisplay(); setNeedsLayout()}
    }
    
    private var color = Colors.red {
        didSet { setNeedsDisplay(); setNeedsLayout()}
    }
    private var fill = setGame.fill.stripes {
        didSet { setNeedsDisplay(); setNeedsLayout()}
    }
    private var symbol = setGame.shape.squiggle {
        didSet { setNeedsDisplay(); setNeedsLayout()}
    }
    
    
    var isFaceUp: Bool = false{
        didSet{setNeedsDisplay(); setNeedsLayout()}
    }
    
    var card: setCard{
        didSet {
            self.color = resolveUIColor(forColor: card.myColor)
            self.fill = card.myFill
            self.symbol = card.myShape
            self.count = card.myCount
            setNeedsDisplay(); setNeedsLayout()}
    }
    
    
   
    struct Colors {
        static let green = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        static let red = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        static let purple = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
        static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        static let selected = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1).cgColor
        static let matched = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1).cgColor
        static var misMatched = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        static let hint = #colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1).cgColor
    }
    
        
    init(frame myFrame: CGRect, forCard myCard: setCard, bgColor myColor: UIColor = UIColor.clear ) {
        self.card = myCard
        super.init(frame: myFrame)
        self.backgroundColor = myColor
        self.contentMode = .redraw
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        if !isFaceUp{
            // Draw backside
            let  roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 16.0)
            UIColor.purple.setFill()
            roundedRect.fill()
            let lblRect = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: self.bounds.width, height: self.bounds.height * 0.5)
            let lbl = UILabel(frame: lblRect)
            lbl.adjustsFontSizeToFitWidth = true
            lbl.center.x = self.bounds.midX
            
            self.addSubview(lbl)
            
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.center
            
            let attributes: [NSMutableAttributedString.Key:Any] =  [
                .paragraphStyle:  style,
                .font : UIFont(name: "Palatino-Bold", size: 16)!,
                .foregroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                
            ]
            let AttributedString = NSMutableAttributedString(string: "S E T", attributes: attributes)
            //let deckString: NSAttributedString = NSMutableAttributedString(string: " Deck")
            //AttributedString.append(deckString)
            lbl.attributedText = AttributedString
 
            
            
        }
        else
        {
            //Draw face
            let  roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 16.0)
            UIColor.white.setFill()
            roundedRect.fill()
            //remove back of card label
            if self.subviews.count > 0 {
                self.subviews[0].removeFromSuperview()
            }
            let shapeWidth = rect.width * 0.8
            let shapeHeight = rect.height * 0.8 / 3
            //let shapeSeparation = shapeHeight * 0.1
            let ShapeCenterPointHeight = CGFloat(rect.height / CGFloat(card.myCount + 1))
          
            for symbolCount in 1...card.myCount{
                let x = rect.minX + rect.width * ViewConstants.SYMBOL_X_OFFSET_FACTOR
                let y = rect.minY + rect.height - (ShapeCenterPointHeight * (CGFloat(symbolCount))) - (shapeHeight / 2)
                let shapeRect = CGRect(x: x, y: y, width: shapeWidth, height: shapeHeight)
                let shapeColor = resolveUIColor(forColor: card.myColor)
                var myShape = createShape(forShape: card.myShape, in: shapeRect, inPath: roundedRect)
                
                let context = UIGraphicsGetCurrentContext()
                context?.saveGState()
                
                myShape.addClip()
                switch card.myFill{
                    case .solid:
                        shapeColor.setFill()
                        myShape.fill()
                    case .stripes:
                        myShape = fillRectWithLines(inPath: myShape, rect: shapeRect)
                    default: break
                    
                }
                
                shapeColor.setStroke()
                myShape.stroke()
                
                context?.restoreGState()
                
            }
        }
    }
    
    private func createShape(forShape: setGame.shape, in rect: CGRect, inPath: UIBezierPath) ->UIBezierPath{
        resolveUIColor(forColor: card.myColor).setStroke()
        let origx = rect.width * 0.1
        let origy = rect.height * 0.2
        let yOffset = rect.height * 0.09
        
        
        //UIColor.cyan.setFill()
        //UIRectFill(rect)
        //inPath.lineWidth = (CGFloat(2.0))
        
        switch forShape{
        case setGame.shape.diamond :
            let myDiamond = UIBezierPath()
            
            myDiamond.move(to: CGPoint(x: rect.midX, y: rect.minY + yOffset))
            myDiamond.addLine(to: CGPoint(x: rect.minX,  y: rect.midY ))
            myDiamond.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - yOffset))
            myDiamond.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            
            myDiamond.close()
            
            return myDiamond
            
            
            //inPath.append(myDiamond)
            //return inPath
        case setGame.shape.oval:
            let ovalRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - yOffset)
            let ovaLinPath = UIBezierPath(ovalIn: ovalRect)

            return ovaLinPath
        case setGame.shape.squiggle:
            let squigPath = UIBezierPath()
            squigPath.move(to: CGPoint(x: rect.minX, y: rect.midY + 1.0))  //add 1.0 to assure overlap of top and bottom
            
            
            //ANALYZE THIS AND UNDERSTAND IT BEFORE MOVING FORWARD
            squigPath.addCurve(to:
                CGPoint(x: rect.minX + rect.width * 1/2, y: rect.minY + rect.height / 8),
                            controlPoint1: CGPoint(x: rect.minX, y: rect.minY),
                            controlPoint2: CGPoint(x: rect.minX + rect.width * 1/2 - origx,
                                                   y: rect.minY + rect.height / 8 - origy))
            
            squigPath.addCurve(to:
                CGPoint(x: rect.minX + rect.width * 4/5,
                        y: rect.minY + rect.height / 8),
                                   controlPoint1: CGPoint(x: rect.minX + rect.width * 1/2 + origx,
                                                          y: rect.minY + rect.height / 8 + origy),
                                   controlPoint2: CGPoint(x: rect.minX + rect.width * 4/5 - origx,
                                                          y: rect.minY + rect.height / 8 + origy))
            
            squigPath.addCurve(to:
                CGPoint(x: rect.minX + rect.width,
                        y: rect.minY + rect.height / 2),
                                   controlPoint1: CGPoint(x: rect.minX + rect.width * 4/5 + origx,
                                                          y: rect.minY + rect.height / 8 - origy ),
                                   controlPoint2: CGPoint(x: rect.maxX,
                                                          y: rect.minY))
            
            let lowHalf = UIBezierPath(cgPath: squigPath.cgPath)
            lowHalf.apply(CGAffineTransform.identity.rotated(by: CGFloat.pi))
            lowHalf.apply(CGAffineTransform.identity.translatedBy(x: bounds.width, y: bounds.height))
            squigPath.move(to: CGPoint(x: rect.minX, y: rect.midY))
            squigPath.append(lowHalf)
            return squigPath
            
        }
        
        
    }
    
    func fillRectWithLines(inPath: UIBezierPath, rect: CGRect) -> UIBezierPath
    {
  
        // create a UIBezierPath for the fill pattern
        let stripes = inPath
        stripes.lineWidth = CGFloat(2.0)
        
        let stripeCount = (rect.width / ViewConstants.STRIPE_SPACE)
        
        
        
        for i in 1...Int(stripeCount)    //( int x = 0; x < bounds.size.width; x += 20 )
        {
            let xCoord = rect.minX + CGFloat(i)  * ViewConstants.STRIPE_SPACE
            stripes.move(to: CGPoint(x: xCoord, y: bounds.minY))
            stripes.addLine(to: CGPoint(x: xCoord , y: bounds.maxY))
        }
        
        //inPath.append(stripes)
        return inPath
    }
    private func resolveUIColor(forColor: setGame.color) ->UIColor
    {
        switch forColor{
        case setGame.color.green:
            return UIColor.green
        case setGame.color.purple:
            return UIColor.purple
        case setGame.color.red:
            return UIColor.red
        }
    }
    func viewUnselect(){
        
        UIView.transition(with: self, duration: 2.0,  options: .transitionCrossDissolve, animations: {
            
            self.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            self.layer.borderWidth = 3.0
            
        }, completion: {finished in self.layer.borderWidth = 0})
        
        self.isSelected = false
    }
   
    func removeSet(toLocation: CGRect){
       UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 2.0,
            delay: 0.0, options: [],
            animations: {self.frame = toLocation},
            completion: {if $0 == .end {
                                        self.removeFromSuperview()}
            })
        self.isSelected = false
    }
 
    func dealMe(toLocation: CGRect, Delay: TimeInterval = 1.0)->setCardView{
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1.0,
            delay: Delay,
            options: [.curveEaseInOut],
            animations: {
                
                self.frame = toLocation},
            completion: {if $0 == .end {
                UIView.transition(with: self, duration: 0.5, options: [.transitionFlipFromLeft], animations:
                    {
                    self.isFaceUp = true
                    },
                completion: nil)
            }})
        self.isSelected = false
        
        return self
        
    }
    func discard(toLocation :CGRect){
        
    }
}
