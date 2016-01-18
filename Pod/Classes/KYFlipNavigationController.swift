//
//  KYFlipNavigationController.swift
//  KYFlipNavigationController
//
//  Created by Kyle on 15/12/17.
//  Copyright © 2015年 xiaoluuu. All rights reserved.
//  If you have any problem , please contact me
//  ********************************************
//  Version 0.1
//
//  Email: yangzychina@gmail.com
//  Github: https://github.com/kyleYang

import UIKit


public typealias KYFlipNavigationCompletionBlock = Void -> Void


public class KYFlipNavigationController: UIViewController {
    
    
    private enum KYFlipPanDirection {
        case None
        case Left
        case Right
    }
    
    private let minTouchX : CGFloat = 70.0
    private var _panOrigin : CGPoint = CGPointMake(0, 0)
    private var _percentageOffsetFromLeft : CGFloat = 0
    //MARK: public variable
    private var _viewControllers : NSMutableArray = NSMutableArray()
    public var viewControllers : Array<UIViewController>!{
        
        get{
            
            return _viewControllers as NSArray as! [UIViewController]
            
        }set(newValue){
            
            if newValue.count == 0 {
                print("set viewControllers count can not == 0")
                return
            }
            
            
            guard let oldController = (_viewControllers.lastObject as? UIViewController) else {
                
                return
            }
            
            guard let newViewController = newValue.last else {
                return
            }
            
            if oldController == newViewController {
                
                _viewControllers.removeAllObjects()
                
                for newController in newValue {
                    _viewControllers.addObject(newController)
                }
                
                return
            }
            
            
            oldController.willMoveToParentViewController(nil)
            newViewController.willMoveToParentViewController(self)
            oldController.removeFromParentViewController()
            self.addChildViewController(newViewController)
            oldController.view.removeFromSuperview()
            newViewController.view.frame = self.view.frame
            self.view.addSubview(newViewController.view)
            self.addPanGestureToView(newViewController.view)
            oldController.didMoveToParentViewController(nil)
            newViewController.didMoveToParentViewController(self)
            
            _viewControllers.removeAllObjects()
            
            for newController in newValue {
                _viewControllers.addObject(newController)
            }

            
            
        }
    }
    
    private(set) var currentViewController : UIViewController? {
        get{
            
            if self._viewControllers.count > 0 {
                return self._viewControllers.lastObject as? UIViewController
            }else{
                return nil
            }
            
        }set{
            
        }
    }
    
    
    private(set) var previousViewController : UIViewController? {
        get{
            
            if self._viewControllers.count > 1 {
                return self._viewControllers[self._viewControllers.count-2] as? UIViewController
            }else{
                return nil
            }
            
        }set{
            
        }
    }
    
    
    private(set) var rootViewController : UIViewController?{
        
        get{
            
            if self._viewControllers.count > 0 {
                
                return self._viewControllers[0] as? UIViewController
            }else{
                return nil
            }
            
            
        }set{
            
        }
        
    }

    
    
    // the max horizontal for previous move when push a new viewcontroller, the default value is 30
    public var moveOffset : CGFloat = 100
    // the animation duration when push a new viewcontroller, the default value is 0.5
    public var animationDuration : NSTimeInterval = 0.4
    // the aimation delay when push a new viewcontroller, the default value is 0.0
    public var animationDelay : NSTimeInterval = 0.0
    
    //MARK: private variable
    private var _maskView : UIView = UIView(frame: CGRectZero)
    private var _animationInProgress : Bool = false
    private var _panGestures : Array<UIPanGestureRecognizer> = []
    //MARK:
    //MARK: init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(rootViewCotroller : UIViewController){
        self.init()
        _viewControllers.addObject(rootViewCotroller)
    }
    
 
    //MARK:
    //MARK: loadview
    override public func loadView() {
        super.loadView()
        
        let rect = self.viewBounds(self.preferredInterfaceOrientationForPresentation())
        
        let rootViewController = _viewControllers[0] as! UIViewController
        rootViewController.willMoveToParentViewController(self)
        self.addChildViewController(rootViewController)
        
        let rootView = rootViewController.view
        rootView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        rootView.frame = rect
        self.view.addSubview(rootView)
        
        rootViewController.didMoveToParentViewController(self)
        
        _maskView.frame = rect
        _maskView.backgroundColor = UIColor.clearColor()
        _maskView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        self.view.insertSubview(_maskView, atIndex: 0)
        
        self.view.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        
        
    }
    

    //roll back to previous state. like pangesture pop a ViewController cancle 
    //then a pop should return  to previous state
    private func rollBackViewController() {
        
        guard let current = self.currentViewController  else {
            return
        }
        
        guard let previous = self.previousViewController else{
            return
        }
        
        let rect = CGRectMake(0,0,current.view.frame.width,current.view.frame.height)
        let finishFrame = CGRectOffset(self.view.bounds, -moveOffset, 0)
        
        _animationInProgress = true
    
        
        UIView .animateWithDuration(animationDuration/2, delay: animationDelay/2, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            current.view.frame = rect
            previous.view.frame = finishFrame
            
            }, completion: { (finish) -> Void in
                
                if finish {
                    
                    self._animationInProgress = false
                    
                    previous.view.removeFromSuperview()
    
                    
                }
                
                
        })
        
    }
    
    
    private func rollForwardViewController() {
        
        guard let current = self.currentViewController  else {
            return
        }
        
        guard let previous = self.previousViewController else{
            return
        }
        
        let finishFrame = CGRectMake(0,0,current.view.frame.width,current.view.frame.height)
        let rect = CGRectOffset(self.view.bounds, self.view.frame.width, 0)
        
        _animationInProgress = true
    
        previous.willMoveToParentViewController(self)
        self.addChildViewController(previous)
        
        current.willMoveToParentViewController(nil)
        current.removeFromParentViewController()
        
        UIView .animateWithDuration(animationDuration/2, delay: animationDelay/2, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            current.view.frame = rect
            previous.view.frame = finishFrame
            
            }, completion: { (finish) -> Void in
                
                if finish {
                    
                    self._animationInProgress = false
                    
                    previous.didMoveToParentViewController(self)
                   
                    current.didMoveToParentViewController(nil)
                    current.view.removeFromSuperview()
                    self._viewControllers.removeObject(current)
                    
    
                }
                
                
        })
        
    }

    
    
    private func removeViewControllersAfterViewController(viewController : UIViewController){
        
        let idx = self._viewControllers.indexOfObject(viewController)
        
        if idx == NSNotFound {
            
            print("self.viewController not contains object \(viewController)")
            return

        }
        
        while self._viewControllers.count > idx + 2 {
            
            let removedVC = self._viewControllers[idx+1] as! UIViewController
            removedVC.view.removeFromSuperview()
            removedVC.willMoveToParentViewController(nil)
            removedVC.removeFromParentViewController()
            removedVC.didMoveToParentViewController(nil)
            self._viewControllers.removeObjectAtIndex(idx+1)
        }
        
        
    }

    
    private func addPanGestureToView(view : UIView?) {
        
        guard let view = view else{
            return
        }
        
//        print("ADD PAN GESTURE $$### \(_panGestures.count)")
        let panGesture = UIPanGestureRecognizer(target: self, action: "gestureRecognizerDidPan:")
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        _panGestures.append(panGesture)
        
    }
    
    func gestureRecognizerDidPan(panGesture : UIPanGestureRecognizer) {
        
        if _animationInProgress {
            return
        }
        
       
        
        let currentPoint = panGesture.translationInView(self.view)
        let x = currentPoint.x + _panOrigin.x
        
        var panDirection : KYFlipPanDirection = .None
        
        let vel = panGesture.velocityInView(self.view)
        if vel.x > 0{
            panDirection = .Right
        }else{
            panDirection = .Left
        }
        
        var offset : CGFloat = 0

        
        guard let current = self.currentViewController else {
            return
        }
        
        guard let previous = self.previousViewController else {
            return
        }
        
        if panGesture.state == .Began {
           
            self.view.addSubview(previous.view)
            self.view.bringSubviewToFront(current.view)
          
        }
        
        
        offset = self.view.frame.width - x
        
        _percentageOffsetFromLeft = offset/self.viewBounds(self.preferredInterfaceOrientationForPresentation()).width
        
        current.view.frame = self.getSlidingRectWithPercentageOffset(_percentageOffsetFromLeft, orientation: self.preferredInterfaceOrientationForPresentation())
        previous.view.frame = self.getPreviousRectPrecentageOffset(_percentageOffsetFromLeft, orientation: self.preferredInterfaceOrientationForPresentation())
        
        if panGesture.state == .Ended || panGesture.state == .Cancelled {
            
            if abs(vel.x) > 100 {
                self.completeSlidingAnimationWithDirection(panDirection)
            }else{
                self.completeSlidingAnimationWithOffset(offset)
            }
            
        }
    }
    
    private func getSlidingRectWithPercentageOffset(percentage : CGFloat, orientation : UIInterfaceOrientation) -> CGRect {
    
        let viewRect = self.viewBounds(orientation)
        var rectToReturn = CGRectZero
        rectToReturn.size = viewRect.size
        rectToReturn.origin = CGPointMake(max(0, (1-percentage)*viewRect.size.width), 0)
        return rectToReturn
        
    }
    
    private func getPreviousRectPrecentageOffset(percentage : CGFloat, orientation : UIInterfaceOrientation) -> CGRect{
        
        let viewRect = self.viewBounds(orientation)
        var rectToReturn = CGRectZero
        rectToReturn.size = viewRect.size
        let precentOffst = moveOffset * percentage
        rectToReturn.origin = CGPointMake(max(-moveOffset, -precentOffst), 0)
        return rectToReturn
    }
    
    private func completeSlidingAnimationWithDirection(driection : KYFlipPanDirection){
        
        if driection == .Right  {
            self.rollForwardViewController()
        }else {
            self.rollBackViewController()
        }
        
        
    }
    
    private func completeSlidingAnimationWithOffset(offset : CGFloat){
        
        if offset < self.viewBounds(self.preferredInterfaceOrientationForPresentation()).size.width/2 {
            self.rollForwardViewController()
        }else{
            self.rollBackViewController()
        }
    }
    
   
    
    
    
    public override func shouldAutorotate() -> Bool {
        
        guard let current = self.currentViewController else{
            return false
        }
        
        //current is kind of UINavigationController Class , find the top ViewController
        if current .isKindOfClass(UINavigationController.self) {
            
            let currentNavi = current as! UINavigationController
            let topVC = currentNavi.topViewController
            
            guard let top = topVC else {
                return false
            }
            
            return top.shouldAutorotate()
        //current is kind of UITabBarController class , find the selected ViewController
        }else if current.isKindOfClass(UITabBarController.self) {
            
            let currentTab = current as! UITabBarController
            let selectVC = currentTab.selectedViewController
            
            guard let select = selectVC else{
                return false
            }
            
            if select.isKindOfClass(UINavigationController.self) {
                
                let selectTapNavi = select as! UINavigationController
                let selectTopVC = selectTapNavi.topViewController
                
                guard let selectTop = selectTopVC else {
                    return false
                }
                
                return selectTop.shouldAutorotate()
        
            }
            
            return select.shouldAutorotate()
    
        }else{
            
            return current.shouldAutorotate()
        }
        
        
        
    }
    
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}

//MARK:
//MARK: Public Method
extension KYFlipNavigationController {
    
    public func pushViewController(viewController : UIViewController, animated : Bool, completed : KYFlipNavigationCompletionBlock?){
        
        
        viewController.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.width, 0)
        viewController.view.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
        
        viewController.willMoveToParentViewController(self)
        self.addChildViewController(viewController)
        self.view.bringSubviewToFront(_maskView)
        self.view.addSubview(viewController.view)
        
        let finishFrame = CGRectOffset(self.view.bounds, -moveOffset, 0)
        self.currentViewController?.willMoveToParentViewController(nil)
        if animated {
            
            _animationInProgress = true
            UIView .animateWithDuration(animationDuration, delay: animationDelay, options: UIViewAnimationOptions(), animations: { () -> Void in

                self.currentViewController?.view.frame = finishFrame
                viewController.view.frame = self.view.bounds
                
                }, completion: { (finish) -> Void in
                    
                    if finish {
                        self.currentViewController?.removeFromParentViewController()
                        self.currentViewController?.didMoveToParentViewController(nil)
                        self.currentViewController?.view.removeFromSuperview()
                        self._viewControllers.addObject(viewController)
                        viewController.didMoveToParentViewController(self)
                        self._animationInProgress = false
                        self.addPanGestureToView(self.currentViewController?.view)
                        if let _ = completed {
                            completed!()
                        }
                        
                    }
                    
                    
            })
            
        }else{
            self.currentViewController?.removeFromParentViewController()
            self.currentViewController?.view.frame = finishFrame
            self.currentViewController?.view.removeFromSuperview()
            self.currentViewController?.didMoveToParentViewController(nil)

            viewController.view.frame = self.view.bounds
            self._viewControllers.addObject(viewController)
            viewController.didMoveToParentViewController(self)
            self.addPanGestureToView(self.currentViewController?.view)
            if let _ = completed {
                completed!()
            }

        }
        
    }
    
    
    public func pushViewController(viewController : UIViewController , animated: Bool) {
        self.pushViewController(viewController, animated: animated, completed: nil)
    }
    
    public func popToRootViewControllerAnimated(animated : Bool ,completed : KYFlipNavigationCompletionBlock?){
        
        guard let rootVC = self.rootViewController else {
            return
        }
        self.popToViewController(rootVC, animated: animated, completed: completed)
        
    }
   
    
    
    public func popToViewController(viewController : UIViewController, animated : Bool, completed : KYFlipNavigationCompletionBlock?){
        
        if self._viewControllers.count < 2 {
            print("self.viewControllers.count : \(self._viewControllers.count) < 2")
            return
        }
    
        guard let current = self.currentViewController else {
            return
        }
        self.removeViewControllersAfterViewController(current)
        let previousVC = self.previousViewController
        
        guard let previous = previousVC else {
            return
        }
        
        previous.willMoveToParentViewController(self)
        self.addChildViewController(previous)
        self.view.addSubview(previous.view)
        
        self.view.bringSubviewToFront(current.view)
        current.willMoveToParentViewController(nil)
        current.removeFromParentViewController()
        if animated {
            _animationInProgress = true
            UIView.animateWithDuration(animationDuration, delay: animationDelay, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                current.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.width, 0)
                previous.view.frame = self.view.bounds
                
                }, completion: { (finished) -> Void in
                    
                    if finished {
                        
                        self._animationInProgress = false
                        current.view.removeFromSuperview()
                        self.view.bringSubviewToFront(previousVC!.view)
                        
                        current.didMoveToParentViewController(nil)
                        self._viewControllers.removeObject(current)
                        previous.didMoveToParentViewController(self)
                        
                        if let _ = completed {
                            completed!()
                        }
                        
                        
                    }
            })
            
        }else{
            
            previous.view.frame = self.view.bounds
            current.view.removeFromSuperview()
            self.view.bringSubviewToFront(previousVC!.view)
            current.didMoveToParentViewController(nil)
            self._viewControllers.removeObject(current)
            previous.didMoveToParentViewController(self)
            
            if let _ = completed {
                completed!()
            }
        }

        
       
    }
    
    public func popViewController(animated : Bool, completed : KYFlipNavigationCompletionBlock?){
        
        if self._viewControllers.count < 2 {
            print("self.viewControllers.count : \(self._viewControllers.count) < 2")
            return
        }
        
        guard let previous = self.previousViewController else {
            return
        }
        
        guard let current = self.currentViewController else {
            return
        }
        
        previous.willMoveToParentViewController(self)
        self.addChildViewController(previous)
        self.view.addSubview(previous.view)
        
        self.view.bringSubviewToFront(current.view)
        current.willMoveToParentViewController(nil)
        current.removeFromParentViewController()
        if animated {
            _animationInProgress = true
            UIView.animateWithDuration(animationDuration, delay: animationDelay, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                current.view.frame = CGRectOffset(self.view.bounds, self.view.bounds.width, 0)
                previous.view.frame = self.view.bounds
                
                }, completion: { (finished) -> Void in
                    
                    if finished {
                        
                        self._animationInProgress = false
                        current.view.removeFromSuperview()
                        self.view.bringSubviewToFront(previous.view)
                        current.didMoveToParentViewController(nil)
                        self._viewControllers.removeObject(current)
                        previous.didMoveToParentViewController(self)
                        
                        if let _ = completed {
                            completed!()
                        }
                        
                        
                    }
            })
            
        }else{
            
            previous.view.frame = self.view.bounds
            current.view.removeFromSuperview()
            self.view.bringSubviewToFront(previous.view)
            current.didMoveToParentViewController(nil)
            self._viewControllers.removeObject(current)
            previous.didMoveToParentViewController(self)

            if let _ = completed {
                completed!()
            }
        }
        
        
    }
    
    
    public func popViewController(animated : Bool){
        
        self.popViewController(animated, completed:  nil)
        
    }
    
    
}

//MARK:
//MARK: UIGestureRecognizerDelegate
extension KYFlipNavigationController : UIGestureRecognizerDelegate {
    
    
    
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.isKindOfClass(UIPanGestureRecognizer.self) {
            
            let panGestureRecoginizer = gestureRecognizer as! UIPanGestureRecognizer
            let translation =  panGestureRecoginizer.translationInView(self.view)
            
            if translation.x > translation.y {
                return true
            }
            
        }
        
        return false
        
        
    }
    
    
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        guard let current = self.currentViewController else {
            return false
        }
        
        if current .isKindOfClass(UINavigationController.self) {
            
            let currentNavi = current as! UINavigationController
            
            let currentNaviControllers = currentNavi.viewControllers
            if currentNaviControllers.count != 1{ // the navigation viewcontroller statck has more than one viewcontroller , should not pan the naviationcontroller
                return false
            }
            
            if currentNavi.navigationBar.hidden == false {
                
                if CGRectContainsPoint(currentNavi.navigationBar.frame,touch.locationInView(currentNavi.view)) {
                    
                    return false
                }
                
            }
            
        }else if current.isKindOfClass(UITabBarController.self) {
            
            let currentTab = current as! UITabBarController
            let selectVC = currentTab.selectedViewController
            
            if let select = selectVC {
                
                if select.isKindOfClass(UINavigationController.self) {
                    
                    let selectTapNavi = select as! UINavigationController
                    let currentNaviControllers = selectTapNavi.viewControllers
                    if currentNaviControllers.count != 1{ // the navigation viewcontroller statck has more than one viewcontroller , should not pan the naviationcontroller
                        return false
                    }
                    
                    if selectTapNavi.navigationBar.hidden == false {
                        
                        if CGRectContainsPoint(selectTapNavi.navigationBar.frame,touch.locationInView(selectTapNavi.view)) {
                            
                            return false
                        }
                        
                    }
                    
                }
                
            }
            
            if !currentTab.tabBar.hidden {
                
                if CGRectContainsPoint(currentTab.tabBar.frame,touch.locationInView(currentTab.view)) {
                    
                    return false
                }
                
                
            }
            
        }
        
        
        _panOrigin = current.view.frame.origin
        gestureRecognizer.enabled = true
        return  !_animationInProgress
    }
    
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    
}


//MARK:
//MARK: private calculate
extension KYFlipNavigationController {
    
    //Not Support Version < 7.0
    private func viewBounds(orientation : UIInterfaceOrientation) -> CGRect {
        
        var bounds = UIScreen.mainScreen().bounds
        if UIInterfaceOrientationIsLandscape(orientation){
            let width = bounds.width
            bounds.size.width = bounds.height
            bounds.size.height = width
        }
        return bounds
    }
    
    
}


//MARK:
//MARK: UIViewController KYFlipNavigationController
extension UIViewController{
    
    public var flipNavigationController : KYFlipNavigationController? {
        get{
            
            if let _ = self.parentViewController {
                
                if self.parentViewController!.isKindOfClass(KYFlipNavigationController.self) {
                    return self.parentViewController as? KYFlipNavigationController
                }
                if self.parentViewController!.isKindOfClass(UINavigationController.self){
                    if let _ = self.parentViewController!.parentViewController {
                        
                        if self.parentViewController!.parentViewController!.isKindOfClass(KYFlipNavigationController.self){
                            return self.parentViewController!.parentViewController as? KYFlipNavigationController
                        }
                        
                    }
                }
            }
            return nil
        }set{
            
        }
    }
    

    
}




//MARK:
//MARK: Array Flip Extension

extension Array {
    
    mutating func flip_RemoveObject<U: Equatable>(object: U) -> Bool {
        for index in 0..<self.count {
            let objectToCompare = self[index]
            if let to = objectToCompare as? U {
                if object == to {
                    self.removeAtIndex(index)
                    return true
                }
            }
        }
        return false
    }
    
}


