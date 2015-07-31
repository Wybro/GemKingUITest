//
//  LoadingScreenViewController.swift
//  BlurImageTest
//
//  Created by Connor Wybranowski on 7/28/15.
//  Copyright (c) 2015 Wybro. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {
    
    @IBOutlet var loaderView: CircularLoaderView!
    @IBOutlet var loadingDiamond: UIImageView!
    @IBOutlet var gemKingTitleImage: UIImageView!
    @IBOutlet var loadingImage: UIImageView!
    
    @IBOutlet var titleBottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideElements()
        
        gemKingTitleImage.layer.shadowOpacity = 0.6
        gemKingTitleImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        gemKingTitleImage.layer.shadowRadius = 1
        
        loadingImage.layer.shadowOpacity = 0.4
        loadingImage.layer.shadowOffset = CGSize(width: 0, height: 2)
        loadingImage.layer.shadowRadius = 1

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
//        unhideElements()
        animateTitleIn()
    }
    
    func update(timer: NSTimer) {
        loaderView.progress += 0.1
        
        UIView.animateWithDuration(0.6, delay: 0, options: .Repeat | .Autoreverse, animations: { () -> Void in
            self.loadingDiamond.transform = CGAffineTransformMakeScale(0.5, 0.5)
        }, completion: nil)
//        loaderView.transform = CGAffineTransformMakeScale(2.0, 2.0)
        if loaderView.progress == 1 {
            animateView()
            self.loadingImage.alpha = 0
            timer.invalidate()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateView() {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.loaderView.transform = CGAffineTransformMakeScale(0.5, 0.5)
            self.loadingDiamond.transform = CGAffineTransformMakeScale(0.5, 0.5)
            }) { (completed) -> Void in
                self.titleBottomConstraint.constant = self.view.frame.height
                
                UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    
                    self.loaderView.transform = CGAffineTransformMakeScale(4.0, 4.0)
                    self.loadingDiamond.transform = CGAffineTransformMakeScale(2.0, 2.0)
                    
                    self.loaderView.alpha = 0
                    self.loadingDiamond.alpha = 0
                    
                    }) { (completed) -> Void in
                        UIView.animateWithDuration(0.4, animations: { () -> Void in
                            self.view.alpha = 0
                            }, completion: { (completed) -> Void in
                                //
                                var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                var vc: GameUIViewController = storyboard.instantiateViewControllerWithIdentifier("inventoryView") as! GameUIViewController
                                self.presentViewController(vc, animated: false, completion: nil)
                        })
                }
                
        }
    }
    
    func hideElements() {
        self.loaderView.alpha = 0
        self.loadingDiamond.alpha = 0
        self.gemKingTitleImage.alpha = 0
        self.loadingImage.alpha = 0
    }
    
    func unhideElements() {
//        self.gemKingTitleImage.transform = CGAffineTransformMakeScale(2, 2)
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.loaderView.alpha = 1
            self.loadingDiamond.alpha = 1
//            self.gemKingTitleImage.alpha = 1
        }) { (completed) -> Void in
            var timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("update:"), userInfo: nil, repeats: true)

        }
    }
    
    func animateTitleIn() {
        self.gemKingTitleImage.transform = CGAffineTransformMakeScale(2, 2)
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .CurveEaseIn, animations: { () -> Void in
            self.gemKingTitleImage.transform = CGAffineTransformMakeScale(1, 1)
            self.gemKingTitleImage.alpha = 1
        }) { (completed) -> Void in
            self.unhideElements()
            self.loadingFade()
                
        }
    }
    
    func loadingFade() {
        UIView.animateWithDuration(0.6, delay: 0, options: .Repeat | .Autoreverse | .CurveEaseInOut, animations: { () -> Void in
            self.loadingImage.alpha = 1
            }, completion: nil)
    }
    

}
