//
//  AutoScrollLabel.swift
//  AutoScrollLabel
//
//  Created by  lifirewolf on 16/3/3.
//  Copyright © 2016年  lifirewolf. All rights reserved.
//

import UIKit

let kLabelCount = 2
let kDefaultFadeLength = CGFloat(7.0)
// pixel buffer space between scrolling label
let kDefaultLabelBufferSpace = CGFloat(20)
let kDefaultPixelsPerSecond = 30.0
let kDefaultPauseTime = 1.5

enum AutoScrollDirection {
    case Right
    case Left
}

class AutoScrollLabel: UIView {
    
    var scrollDirection = AutoScrollDirection.Right {
        didSet {
            scrollLabelIfNeeded()
        }
    }
    var scrollSpeed = 30.0 {// pixels per second, defaults to 30
        didSet {
            scrollLabelIfNeeded()
        }
    }
    var pauseInterval = 1.5 // defaults to 1.5
    var labelSpacing = CGFloat(20) // pixels, defaults to 20
    
    var animationOptions: UIViewAnimationOptions!
    
    /**
    * Returns YES, if it is actively scrolling, NO if it has paused or if text is within bounds (disables scrolling).
    */
    var scrolling = false
    var fadeLength = CGFloat(7) { // defaults to 7
        didSet {
            if oldValue != fadeLength {
                refreshLabels()
                applyGradientMaskForFadeLength(fadeLength, enableFade: false)
            }
        }
    }
    
    // UILabel properties
    var text: String? {
        get {
            return mainLabel.text
        }
        set {
            setText(newValue, refresh: true)
        }
    }
    
    func setText(text: String?, refresh: Bool) {
        // ignore identical text changes
        
        if text == self.text {
            return
        }
        
        for l in labels {
            l.text = text
        }
        
        if refresh {
            refreshLabels()
        }
    }
    
    var attributedText: NSAttributedString? {
        get {
            return mainLabel.attributedText
        }
        set {
            setAttributedText(newValue, refresh: true)
        }
    }
    
    func setAttributedText(text: NSAttributedString?, refresh: Bool) {
        if text == self.attributedText {
            return
        }
        
        for l in labels {
            l.attributedText = text
        }
        
        if refresh {
            refreshLabels()
        }
    }
    
    var textColor: UIColor! {
        get {
            return self.mainLabel.textColor
        }
        set {
            for lab in labels {
                lab.textColor = newValue
            }
        }
    }
    
    var font: UIFont! {
        get {
            return mainLabel.font
        }
        set {
            mainLabel.font = newValue
            refreshLabels()
            invalidateIntrinsicContentSize()
        }
    }
    
    var shadowColor: UIColor? {
        get {
            return self.mainLabel.shadowColor
        }
        set {
            for lab in labels {
                lab.shadowColor = newValue
            }
        }
    }
    
    var shadowOffset: CGSize {
        get {
            return self.mainLabel.shadowOffset
        }
        set {
            for lab in labels {
                lab.shadowOffset = newValue
            }
        }
    }
    
    var textAlignment: NSTextAlignment! // only applies when not auto-scrolling
    
    // views
    var labels = [UILabel]()
    var mainLabel: UILabel! {
        if labels.count > 0 {
            return labels[0]
        }
        return nil
    }
    
    private var sv: UIScrollView!
    var scrollView: UIScrollView! {
        get {
            if sv == nil {
                sv = UIScrollView(frame: self.bounds)
                sv.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
                sv.backgroundColor = UIColor.clearColor()
            }
            
            return sv
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        addSubview(scrollView)
        
        // create the labels
        for _ in 0 ..< kLabelCount {
            let label = UILabel()
            label.backgroundColor = UIColor.clearColor()
            label.autoresizingMask = autoresizingMask
            
            // store labels
            self.scrollView.addSubview(label)
            labels.append(label)
        }
        
        // default values
        scrollDirection = AutoScrollDirection.Left
        scrollSpeed = kDefaultPixelsPerSecond
        self.pauseInterval = kDefaultPauseTime
        self.labelSpacing = kDefaultLabelBufferSpace
        self.textAlignment = NSTextAlignment.Left
        self.animationOptions = UIViewAnimationOptions.CurveLinear
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.scrollEnabled = false
        self.userInteractionEnabled = false
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = true
        self.fadeLength = kDefaultFadeLength
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            didChangeFrame()
        }
    }
    
    override var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            super.bounds = newValue
            didChangeFrame()
        }
    }
    
    func didChangeFrame() {
        refreshLabels()
        applyGradientMaskForFadeLength(self.fadeLength, enableFade: self.scrolling)
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(0.0, self.mainLabel.intrinsicContentSize().height)
    }
    
    
    func observeApplicationNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "scrollLabelIfNeeded", name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "scrollLabelIfNeeded", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    func enableShadow() {
        scrolling = true
        self.applyGradientMaskForFadeLength(self.fadeLength, enableFade: true)
    }
    
    func scrollLabelIfNeeded() {
        if text == nil || text!.characters.count == 0 {
            return
        }
        
        let labelWidth = CGRectGetWidth(mainLabel.bounds)
        if labelWidth <= CGRectGetWidth(self.bounds) {
            return
        }
        
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "scrollLabelIfNeeded", object: nil)
        NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "enableShadow", object: nil)
        
        scrollView.layer.removeAllAnimations()
        
        let doScrollLeft = scrollDirection == AutoScrollDirection.Left
        self.scrollView.contentOffset = doScrollLeft ? CGPointZero : CGPointMake(labelWidth + labelSpacing, 0)
        
        performSelector("enableShadow", withObject: nil, afterDelay: self.pauseInterval)
        
        // animate the scrolling
        let duration = Double(labelWidth) / scrollSpeed
        
        UIView.animateWithDuration(duration, delay: pauseInterval, options: [self.animationOptions, UIViewAnimationOptions.AllowUserInteraction],
            animations: { () -> Void in
                // adjust offset
                self.scrollView.contentOffset = doScrollLeft ? CGPointMake(labelWidth + self.labelSpacing, 0) : CGPointZero
                
            }, completion: {finished in
                self.scrolling = false
                
                // remove the left shadow
                self.applyGradientMaskForFadeLength(self.fadeLength, enableFade: false)
                
                // setup pause delay/loop
                if finished {
                    self.performSelector("scrollLabelIfNeeded", withObject: nil)
                }

            }
        )
    }
    
    func refreshLabels() {
        var offset = CGFloat(0)
        
        if mainLabel == nil {
            return
        }
        
        for lab in labels {
            lab.sizeToFit()
            
            var frame = lab.frame
            frame.origin = CGPoint(x: offset, y: 0)
            frame.size.height = bounds.height
            lab.frame = frame
            
            lab.center = CGPoint(x: lab.center.x, y: round(center.y - CGRectGetMinY(self.frame)))
            
            offset += CGRectGetWidth(lab.bounds) + labelSpacing
            
            lab.hidden = false
        }
        
        scrollView.contentOffset = CGPointZero
        scrollView.layer.removeAllAnimations()
        
        // if the label is bigger than the space allocated, then it should scroll
        if CGRectGetWidth(mainLabel.bounds) > CGRectGetWidth(bounds) {
            var size = CGSize(width: 0, height: 0)
            size.width = CGRectGetWidth(self.mainLabel.bounds) + CGRectGetWidth(self.bounds) + self.labelSpacing
            size.height = CGRectGetHeight(self.bounds)
            self.scrollView.contentSize = size
            
            self.applyGradientMaskForFadeLength(self.fadeLength, enableFade: self.scrolling)
            
            scrollLabelIfNeeded()
        } else {
            for lab in labels {
                lab.hidden = lab != mainLabel
            }
            
            // adjust the scroll view and main label
            self.scrollView.contentSize = self.bounds.size
            self.mainLabel.frame = self.bounds
            self.mainLabel.hidden = false
            self.mainLabel.textAlignment = self.textAlignment
            
            // cleanup animation
            scrollView.layer.removeAllAnimations()
            
            applyGradientMaskForFadeLength(0, enableFade: false)
        }
        
    }
    
    func applyGradientMaskForFadeLength(var fadeLength: CGFloat, enableFade fade: Bool) {
        
        if mainLabel == nil {
            return
        }
        
        let labelWidth = CGRectGetWidth(mainLabel.bounds)
        if labelWidth <= CGRectGetWidth(self.bounds) {
            fadeLength = 0
        }
        
        if fadeLength != 0 {
            // Recreate gradient mask with new fade length
            let gradientMask = CAGradientLayer()
            
            gradientMask.bounds = self.layer.bounds
            gradientMask.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
            
            gradientMask.shouldRasterize = true
            gradientMask.rasterizationScale = UIScreen.mainScreen().scale
            
            gradientMask.startPoint = CGPointMake(0, CGRectGetMidY(self.frame))
            gradientMask.endPoint = CGPointMake(1, CGRectGetMidY(self.frame))
            
            // setup fade mask colors and location
            let transparent = UIColor.clearColor().CGColor
            
            let opaque = UIColor.blackColor().CGColor
            gradientMask.colors = [transparent, opaque, opaque, transparent]
            
            // calcluate fade
            let fadePoint = fadeLength / CGRectGetWidth(self.bounds)
            var leftFadePoint = fadePoint
            var rightFadePoint = 1 - fadePoint
            if !fade {
                switch (self.scrollDirection) {
                case .Left:
                    leftFadePoint = 0
                    
                case .Right:
                    leftFadePoint = 0
                    rightFadePoint = 1
                }
            }
            
            // apply calculations to mask
            gradientMask.locations = [0, leftFadePoint, rightFadePoint, 1]
            
            // don't animate the mask change
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.layer.mask = gradientMask
            CATransaction.commit()
        } else {
            layer.mask = nil
        }
    }
    
    func onUIApplicationDidChangeStatusBarOrientationNotification(notification: NSNotification) {
        // delay to have it re-calculate on next runloop
        performSelector("refreshLabels", withObject: nil, afterDelay: 0.1)
        performSelector("scrollLabelIfNeeded", withObject: nil, afterDelay: 0.1)
    }

}
