//
//  GameUIViewController.swift
//  BlurImageTest
//
//  Created by Connor Wybranowski on 7/29/15.
//  Copyright (c) 2015 Wybro. All rights reserved.
//

import UIKit

class GameUIViewController: UIViewController {

    @IBOutlet var auctionHouseButton: UIButton!
    @IBOutlet var shopButton: UIButton!
    @IBOutlet var collectButton: UIButton!
    @IBOutlet var equipmentButton: UIButton!
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var gemBehavior: UIDynamicItemBehavior!
    
    // Testing Elements
    @IBOutlet var numberOfGemsSlider: UISlider!
    @IBOutlet var numberOfGemsLabel: UILabel!
    @IBOutlet var temporaryView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auctionHouseButton.layer.shadowOpacity = 1
        auctionHouseButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        auctionHouseButton.layer.shadowRadius = 2
        
        shopButton.layer.shadowOpacity = 1
        shopButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        shopButton.layer.shadowRadius = 2
        
        collectButton.layer.shadowOpacity = 1
        collectButton.layer.shadowColor = UIColor.yellowColor().CGColor
        collectButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        collectButton.layer.shadowRadius = 5
        
        equipmentButton.layer.shadowOpacity = 1
        equipmentButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        equipmentButton.layer.shadowRadius = 2
        
        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        gravity = UIGravityBehavior()
        gravity.gravityDirection = CGVector(dx: 0, dy: 1)
        gravity.action = { [unowned self] in
            let itemsToRemove = self.gravity.items.filter() { !CGRectIntersectsRect(self.view.bounds, $0.frame) }
            for item in itemsToRemove {
                self.gravity.removeItem(item as! UIDynamicItem)
                item.removeFromSuperview()
            }
        }
        animator.addBehavior(gravity)
        
        gemBehavior = UIDynamicItemBehavior()
        gemBehavior.allowsRotation = true
        gemBehavior.density = 10
        gemBehavior.action = { [unowned self] in
            let itemsToRemove = self.gemBehavior.items.filter() { !CGRectIntersectsRect(self.view.bounds, $0.frame) }
            for item in itemsToRemove {
                self.gemBehavior.removeItem(item as! UIDynamicItem)
                item.removeFromSuperview()
            }
        }
        animator.addBehavior(gemBehavior)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.alpha = 0
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.view.alpha = 1
            }, completion: { (completed) -> Void in
                //
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonTouchStarted(sender: UIButton) {
        sender.transform = CGAffineTransformMakeScale(0.9, 0.9)
    }
    
    @IBAction func buttonTouchFinished(sender: UIButton) {
        sender.transform = CGAffineTransformMakeScale(1, 1)
        
        switch sender.tag {
            // Auction House Button
        case 0:
            println("Auction House Button Pressed")
            
            // Collect Button
        case 1:
            println("Collect Button Pressed")
            spewGems(Double(numberOfGemsSlider.value))
            
            // Shop Button
        case 2:
            println("Shop Button Pressed")
            
            // Equipment Button
        case 3:
            println("Equipment Button Pressed")
            
        default:
            break
        }
    }
    
    @IBAction func buttonTouchEnded(sender: UIButton) {
        sender.transform = CGAffineTransformMakeScale(1, 1)
    }
    
    func collectScaleAnimation() {
        UIView.animateWithDuration(0.4, delay: 0, options: .Repeat | .Autoreverse, animations: { () -> Void in
            self.collectButton.transform = CGAffineTransformMakeScale(0.9, 0.9)
        }, completion: nil)
    }
    
    func spewGems(amount: Double) {
        var startingX = self.collectButton.center.x
        var startingY = self.collectButton.center.y
        
        var usedGems = [UIView]()
        
        var possibleGems = [UIImage(named: "smallBlueGem"), UIImage(named: "smallGreenGem"), UIImage(named: "smallOrangeGem"), UIImage(named: "smallRedGem")]
        for index in 0..<Int(amount) {
            var gemImage = possibleGems[index % possibleGems.count] as UIImage!
            var gemImageView = UIImageView(image: gemImage) as UIImageView
            var gemUIView = UIView(frame: CGRect(x: startingX - gemImage.size.width/2, y: startingY, width: gemImage.size.width, height: gemImage.size.height))
            gemUIView.addSubview(gemImageView)
            self.view.addSubview(gemUIView)
            
            gravity.addItem(gemUIView)
            gemBehavior.addItem(gemUIView)
            
            var gemFactorAngle = -1.0 + (2.0*(1.0)*Double(index)/amount)
            var gemFactorXDirection = -0.5 + (2.0*(0.5)*Double(index)/amount)
            var gemFactorYDirection = -randomDouble(2, upper: 3.6)
            var gemFactorOffSetHorizontal = 0.8 - (2.0*(0.8)*Double(index)/amount)
            
//            println("Gem: \(index) | Angle: \(gemFactorAngle) | X-Direction: \(gemFactorXDirection) | Y-Direction: \(gemFactorYDirection) | Horizontal OS: \(gemFactorOffSetHorizontal)")
//            println()
            
            let instantaneousPush: UIPushBehavior = UIPushBehavior(items: [gemUIView], mode: UIPushBehaviorMode.Instantaneous)
            instantaneousPush.setAngle(CGFloat(gemFactorAngle), magnitude: 1)
            instantaneousPush.pushDirection = CGVector(dx: CGFloat(gemFactorXDirection), dy: CGFloat(gemFactorYDirection))
            instantaneousPush.setTargetOffsetFromCenter(UIOffset(horizontal: CGFloat(gemFactorOffSetHorizontal), vertical: 0), forItem: gemUIView)
            animator.addBehavior(instantaneousPush)
            
            usedGems.append(gemUIView)
        }
        

        
        fadeGems(usedGems)
    }
    
    func fadeGems(gems: [UIView]) {
        UIView.animateWithDuration(1, animations: { () -> Void in
            for gem in gems {
                gem.alpha = 0
            }
        })
    }
    
    func randomDouble(lower: Double, upper: Double) -> Double {
        let arc4RandoMax: Double = 0x100000000
        return ((Double(arc4random()) / arc4RandoMax) * (upper - lower) + lower)
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        numberOfGemsLabel.text = Int(sender.value).description
    }
    
    @IBAction func showTempElements(sender: AnyObject) {
        if temporaryView.hidden == false {
            temporaryView.hidden = true
        }
        else {
           temporaryView.hidden = false
        }
    }
    
}
