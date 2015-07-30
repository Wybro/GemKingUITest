//
//  CircularLoaderView.swift
//  BlurImageTest
//
//  Created by Connor Wybranowski on 7/28/15.
//  Copyright (c) 2015 Wybro. All rights reserved.
//

import UIKit

class CircularLoaderView: UIView {
    
    let customRedColor = UIColor(red: 240/255, green: 81/255, blue: 99/255, alpha: 1).CGColor

    let circlePathLayer = CAShapeLayer()
    let circleRadius: CGFloat = 30.0
    
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                circlePathLayer.strokeEnd = 1
//                circlePathLayer.removeFromSuperlayer()
            } else if (newValue < 0) {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        progress = 0
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 3
        circlePathLayer.fillColor = UIColor.clearColor().CGColor
        circlePathLayer.strokeColor = customRedColor
        layer.addSublayer(circlePathLayer)
        backgroundColor = UIColor.whiteColor()
    }
    
    func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2*circleRadius, height: 2*circleRadius)
        circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds) - CGRectGetMidX(circleFrame)
        circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds) - CGRectGetMidY(circleFrame)
        return circleFrame
    }
    
    func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalInRect: circleFrame())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().CGPath
    }

}
