//
//  YLAlertHUD.swift
//  YLAlertHUD
//
//  Created by HeYilei on 7/03/2016.
//  Copyright © 2016 lionhylra. All rights reserved.
//

import UIKit

public enum YLAlertHUDBackgroundStyle:Int{
    case SolidColor, Blur
}

public enum YLAlertHUDPosition:Int {
    case Center, Top, Bottom, UpperLeft, UpperRight, LowerLeft, LowerRight
}

public typealias YLAlertHUDTheme = UIBlurEffectStyle

public class YLAlertHUD: UIView {
    // MARK: - Public Properties
    public let contentView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }()
    public let label:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.textAlignment = .Center
        return label
    }()
    public let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        return imageView
    }()
    
    /* configuration property */
    public var cornerRadius:CGFloat = 10 {
        willSet{
            layer.cornerRadius = newValue
            setNeedsDisplay()
        }
    }
    public var theme:YLAlertHUDTheme = .Light {
        willSet{
            updateTheme(newValue)
        }
    }
    public var backgroundStyle:YLAlertHUDBackgroundStyle = .Blur {
        willSet{
            updateBackgoundStyle(newValue)
        }
    }
    public var position:YLAlertHUDPosition = .Center {
        willSet{
            setNeedsUpdateConstraints()
        }
    }
    
    public var margin:CGFloat = 15 {
        willSet{
            setNeedsUpdateConstraints()
        }
    }
    
    public var adjustOffsetForNavigationBar:Bool = false {
        willSet{
            setNeedsUpdateConstraints()
        }
    }
    public var adjustOffsetForTabBar:Bool = false {
        willSet{
            setNeedsUpdateConstraints()
        }
    }
    public var adjustOffsetForStatusBar:Bool = true {
        willSet{
            setNeedsUpdateConstraints()
        }
    }
    
    public var showingAnimationDuration = 0.3
    public var hidingAnimationDuration = 0.3
    
    // MARK: - Private Properties
    private lazy var vibrancyView:UIVisualEffectView = {[unowned self] in
        let blurEffect = UIBlurEffect(style: self.theme)
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        return vibrancyView
        }()
    private lazy var blurView:UIVisualEffectView = {[unowned self] in
        let blurEffect = UIBlurEffect(style: self.theme)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
        }()
    
    private var verticalConstraint:NSLayoutConstraint?
    private var horizontalConstraint:NSLayoutConstraint?
    private var _navigationBarHeight:CGFloat = {
        return UINavigationController().navigationBar.frame.height
    }()
    private var _tabBarHeight = {
        return UITabBarController().tabBar.frame.height
    }()
    private var navigationBarHeight:CGFloat {
        return self.adjustOffsetForNavigationBar ? _navigationBarHeight : 0
    }
    private var tabBarHeight:CGFloat {
        return self.adjustOffsetForTabBar ? _tabBarHeight : 0
    }
    private var statusBarHeight:CGFloat{
        return (self.adjustOffsetForStatusBar && !UIApplication.sharedApplication().statusBarHidden) ? UIApplication.sharedApplication().statusBarFrame.height : 0
    }
    
    // MARK: - Initializer
    public override init(frame:CGRect){
        super.init(frame: frame)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        alpha = 0
        userInteractionEnabled = false
        #if swift(>=2.2)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.deviceOrientationDidChange(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
        #else
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("deviceOrientationDidChange:"), name: UIDeviceOrientationDidChangeNotification, object: nil)
        #endif
    }

    
    
    public convenience init(view:UIView , configuration configurate:((YLAlertHUD)->Void)?=nil){
        self.init(frame:view.bounds)
        configurate?(self)
        updateUI()
        setConstraintsInView(view)
    }

    //    required public init?(coder aDecoder: NSCoder) {
    //        super.init(coder: aDecoder)
    //        layer.cornerRadius = cornerRadius
    //        clipsToBounds = true
    //        alpha = 0
    //        updateUI()
    //    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        // MARK: - Layout
    override public func layoutSubviews() {
        super.layoutSubviews()
        /* vibrancyView */
        blurView.contentView.addSubview(vibrancyView)
        vibrancyView.translatesAutoresizingMaskIntoConstraints = false
        var vibrancyViewConstraints = [NSLayoutConstraint]()
        vibrancyViewConstraints.append(NSLayoutConstraint(item: vibrancyView, attribute: .Height, relatedBy: .Equal, toItem: blurView, attribute: .Height, multiplier: 1, constant: 0))
        vibrancyViewConstraints.append(NSLayoutConstraint(item: vibrancyView, attribute: .Width, relatedBy: .Equal, toItem: blurView, attribute: .Width, multiplier: 1, constant: 0))
        vibrancyViewConstraints.append(NSLayoutConstraint(item: vibrancyView, attribute: .CenterX, relatedBy: .Equal, toItem: blurView, attribute: .CenterX, multiplier: 1, constant: 0))
        vibrancyViewConstraints.append(NSLayoutConstraint(item: vibrancyView, attribute: .CenterY, relatedBy: .Equal, toItem: blurView, attribute: .CenterY, multiplier: 1, constant: 0))
        NSLayoutConstraint.activateConstraints(vibrancyViewConstraints)
        
        /* blurView */
        self.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        var blurViewConstraints = [NSLayoutConstraint]()
        blurViewConstraints.append(NSLayoutConstraint(item: blurView, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0))
        blurViewConstraints.append(NSLayoutConstraint(item: blurView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
        blurViewConstraints.append(NSLayoutConstraint(item: blurView, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0))
        blurViewConstraints.append(NSLayoutConstraint(item: blurView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
        NSLayoutConstraint.activateConstraints(blurViewConstraints)
        
        /* imageView */
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        var imageViewConstraints = [NSLayoutConstraint]()
        imageViewConstraints.append(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0))
        imageViewConstraints.append(NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        imageViewConstraints.append(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 0))
        imageView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: UILayoutConstraintAxis.Vertical)
        NSLayoutConstraint.activateConstraints(imageViewConstraints)
        
        /* label */
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        var labelConstraints = [NSLayoutConstraint]()
        labelConstraints.append(NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: contentView, attribute: .Width, multiplier: 1.0, constant: 0))
        labelConstraints.append(NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: imageView, attribute: .Bottom, multiplier: 1.0, constant: 0))
        labelConstraints.append(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1.0, constant: 0))
        labelConstraints.append(NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activateConstraints(labelConstraints)
        
        /* contentView */
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        var contentViewConstraints = [NSLayoutConstraint]()
        contentViewConstraints.append(NSLayoutConstraint(item: contentView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        contentViewConstraints.append(NSLayoutConstraint(item: contentView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0))
        contentViewConstraints.append(NSLayoutConstraint(item: contentView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1.0, constant: -30))
        contentViewConstraints.append(NSLayoutConstraint(item: contentView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1.0, constant: -30))
        NSLayoutConstraint.activateConstraints(contentViewConstraints)
    }
    
    override public func updateConstraints() {
        defer{
            super.updateConstraints()
        }
        guard let view = superview else {
            return
        }
        
        NSLayoutConstraint.deactivateConstraints([verticalConstraint!, horizontalConstraint!])
        switch self.position{
        case .Center, .Bottom, .Top:
            self.horizontalConstraint = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        case .LowerLeft, .UpperLeft:
            self.horizontalConstraint = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: margin)
        case .LowerRight, .UpperRight:
            self.horizontalConstraint = NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: -margin)
        }
        
        switch self.position {
        case .Center:
            self.verticalConstraint = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0)
        case .Bottom, .LowerLeft, .LowerRight:
            self.verticalConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -(margin+tabBarHeight))
        case .Top, .UpperLeft, .UpperRight:
            self.verticalConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: margin+navigationBarHeight+statusBarHeight)
        }
        NSLayoutConstraint.activateConstraints([verticalConstraint!, horizontalConstraint!])
        
    }
    
    public override func intrinsicContentSize() -> CGSize {
        return CGSizeMake(37.0, 37.0)
    }
    
    func deviceOrientationDidChange(notification:NSNotification){
        self._navigationBarHeight = UINavigationController().navigationBar.frame.height
        self._tabBarHeight = UITabBarController().tabBar.frame.height
    }
    

}

// MARK: - Public Method
extension YLAlertHUD{
//    public static func showHUDAddedToView(view:UIView, animated:Bool = true, hideAfterDelay delay:NSTimeInterval? = 1.5, multipleInstances:Bool = false, configuration:((YLAlertHUD)->Void)?=nil) -> YLAlertHUD{
//        let HUD:YLAlertHUD
//        let currentHUD = HUDForView(view)
//        if !multipleInstances && currentHUD != nil{
//            HUD = currentHUD!
//            configuration?(HUD)
//        }else{
//            HUD = YLAlertHUD(view: view, configuration: configuration)
//        }
//        if let delay = delay {
//            HUD.show(animated:animated, hideAfterDelay: delay)
//        }else{
//            HUD.show(animated:animated)
//        }
//        return HUD
//    }
    
    public static func showHUDaddedToView(
        view:UIView,
        title:String?,
        image:UIImage? = nil,
        animated:Bool = true,
        hidesAfterDelay delay:NSTimeInterval? = 1.5,
        replaceExisting:Bool = false,
        theme:YLAlertHUDTheme = .Light,
        backgroundStyle:YLAlertHUDBackgroundStyle = .Blur,
        position:YLAlertHUDPosition = .Center) ->YLAlertHUD{
            
            let configuration = {(HUD:YLAlertHUD)->Void in
                HUD.label.text = title
                HUD.imageView.image = image
                HUD.theme = theme
                HUD.backgroundStyle = backgroundStyle
                HUD.position = position
            }
            let HUD:YLAlertHUD
            let currentHUD = HUDForView(view)
            if !replaceExisting && currentHUD != nil {
                HUD = currentHUD!
                configuration(HUD)
            }else{
                
                if currentHUD != nil {
                    currentHUD?.hide(animated: false)
                }
                
                HUD = YLAlertHUD(view: view, configuration: configuration)
                
            }
            
            if let delay = delay {
                HUD.show(animated:animated, hideAfterDelay: delay)
            }else{
                HUD.show(animated:animated)
            }
            return HUD
    }
    
    public static func HUDForView(view:UIView) -> YLAlertHUD? {
        for subview in view.subviews {
            if let hud = subview as? YLAlertHUD {
                return hud
            }
        }
        return nil
    }
    
    // MARK: Show HUD
    public func show(animated animated:Bool){
        if animated {
            UIView.animateWithDuration(showingAnimationDuration, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState], animations: { () -> Void in
                self.alpha = 1
                }, completion: nil)
        }else{
            self.alpha = 1
        }
    }
    
    public func show(animated animated:Bool, hideAfterDelay delay:NSTimeInterval){
        
        if animated {
            UIView.animateWithDuration(showingAnimationDuration, delay: 0, options: [UIViewAnimationOptions.BeginFromCurrentState], animations: { () -> Void in
                self.alpha = 1
                }, completion: {[unowned self] (completed) -> Void in
                    if completed {
                        UIView.animateWithDuration(self.hidingAnimationDuration, delay: delay, options: [], animations: {() -> Void in
                            self.alpha = 0
                            }, completion: {[weak self] (completed) -> Void in
                                if completed {
                                    self?.removeFromSuperview()
                                }
                            })
                    }
                })
        }else{
            self.alpha = 1
            let popTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC)))
            
            dispatch_after(popTime, dispatch_get_main_queue()) {
                self.alpha = 0
                self.removeFromSuperview()
            }
        }
        
    }
    
    // MARK: Hide HUD
    public func hide(animated animated:Bool){
        if animated {
            UIView.animateWithDuration(self.hidingAnimationDuration, delay: 0, options: [], animations: {() -> Void in
                self.alpha = 0
                }, completion: {[unowned self] (completed) -> Void in
                    if completed {
                        self.removeFromSuperview()
                    }
                })
        }else{
            self.alpha = 0
            self.removeFromSuperview()
        }
    }
}

// MARK: - Private Method
extension YLAlertHUD {
    // MARK: Setup constraints
    private func setConstraintsInView(view:UIView) {
        view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        var myConstraints = [NSLayoutConstraint]()
        
        /* Horizontal Position */
        switch self.position{
        case .Center, .Bottom, .Top:
            self.horizontalConstraint = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        case .LowerLeft, .UpperLeft:
            self.horizontalConstraint = NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: margin)
        case .LowerRight, .UpperRight:
            self.horizontalConstraint = NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: -margin)
        }
        
        /* Vertical Position */
        switch self.position {
        case .Center:
            self.verticalConstraint = NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0)
        case .Bottom, .LowerLeft, .LowerRight:
            self.verticalConstraint = NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -(margin+tabBarHeight))
        case .Top, .UpperLeft, .UpperRight:
            self.verticalConstraint = NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: margin+navigationBarHeight+statusBarHeight)
        }
        
        myConstraints.append(self.verticalConstraint!)
        myConstraints.append(self.horizontalConstraint!)
        myConstraints.append(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: view, attribute: .Width, multiplier: 0.9, constant: 0))
        myConstraints.append(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .LessThanOrEqual, toItem: view, attribute: .Height, multiplier: 0.8, constant: 0))
        NSLayoutConstraint.activateConstraints(myConstraints)
    }
    
    // MARK: Update UI
    private func updateUI(){
        updateTheme(theme)
        updateBackgoundStyle(backgroundStyle)
        setNeedsUpdateConstraints()
    }
    
    private func updateTheme(theme:YLAlertHUDTheme){
        let blurEffect = UIBlurEffect(style: theme)
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        blurView.effect = blurEffect
        vibrancyView.effect = vibrancyEffect
        switch theme {
        case .Light, .ExtraLight:
            tintColor = UIColor.blackColor()
        case .Dark:
            tintColor = UIColor.whiteColor()
        }
        updateColor()
    }
    
    private func updateColor(){
        label.textColor = tintColor
        imageView.tintColor = tintColor
        setNeedsDisplay()
    }
    
    private func updateBackgoundStyle(style:YLAlertHUDBackgroundStyle){
        switch style {
        case .Blur:
            blurView.hidden = false
            self.backgroundColor = UIColor.clearColor()
        case .SolidColor:
            blurView.hidden = true
            switch theme {
            case .Light, .ExtraLight:
                self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
            case .Dark:
                self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            }
        }
        setNeedsDisplay()
        
    }



}
