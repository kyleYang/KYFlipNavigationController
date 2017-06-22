//
//  KYFlipNavigationController.swift
//  KYFlipNavigationController
//
//  Created by Kyle on 15/12/17.
//  Copyright © 2015年 xiaoluuu. All rights reserved.
//  If you have any problem , please contact me
//  ********************************************
//  Version 0.2.0
//
//  Email: yangzychina@gmail.com
//  Github: https://github.com/kyleYang

import UIKit

public typealias KYFlipNavigationCompletionBlock = (Void) -> Void

open class KYFlipNavigationController: UIViewController {

    fileprivate enum KYFlipPanDirection {
        case none
        case left
        case right
    }
    
    fileprivate let minTouchX : CGFloat = 70.0
    fileprivate var _panOrigin : CGPoint = CGPoint(x: 0, y: 0)
    fileprivate var _percentageOffsetFromLeft : CGFloat = 0
    //MARK: public variable
    fileprivate var _viewControllers : Array<UIViewController> = []

    //reset the viewControllers
    open var viewControllers : Array<UIViewController>!{
        get{
            return _viewControllers

        }set(newValue){
            
            if newValue.count == 0 {
                fatalError("set viewControllers count can not == 0 ")
            }
            guard let oldController = _viewControllers.last else {
                return
            }

            guard let newViewController = newValue.last else {
                return
            }
            
            if oldController == newViewController {
                
                _viewControllers.removeAll()
                
                for newController in newValue {
                    _viewControllers.append(newController)
                }
                
                return
            }

            oldController.willMove(toParentViewController: nil)
            newViewController.willMove(toParentViewController: self)
            oldController.removeFromParentViewController()
            self.addChildViewController(newViewController)
            oldController.view.removeFromSuperview()
            newViewController.view.frame = self.view.frame
            self.view.addSubview(newViewController.view)
            self.addPanGestureToView(newViewController.view)
            oldController.didMove(toParentViewController: nil)
            newViewController.didMove(toParentViewController: self)
            
            _viewControllers.removeAll()
            
            for newController in newValue {
                _viewControllers.append(newController)
            }
        }
    }
    //current display viewcontroller
    open var visibleViewController : UIViewController? {
        get{
            return _viewControllers.last
        }
    }
    //viewcontroller before display viewcontroller
    open var previousViewController : UIViewController? {
        get{
            if _viewControllers.count > 1 {
                return self._viewControllers[self._viewControllers.count-2]
            }
            return nil
        }
    }
    //the rootViewController of the filpNavigationController
    open var rootViewController : UIViewController?{
        get{
            return _viewControllers.first
        }
    }

    // the max horizontal for previous move when push a new viewcontroller, the default value is 30
    open var moveOffset : CGFloat = 100
    // the animation duration when push a new viewcontroller, the default value is 0.5
    open var animationDuration : TimeInterval = 0.4
    // the aimation delay when push a new viewcontroller, the default value is 0.0
    open var animationDelay : TimeInterval = 0.0
    
    //MARK: private variable
    fileprivate var _maskView : UIView = UIView(frame: CGRect.zero)
    fileprivate var _animationInProgress : Bool = false
    fileprivate var _panGestures : Array<UIPanGestureRecognizer> = []
    //MARK:
    //MARK: init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(rootViewCotroller : UIViewController){
        self.init()
        _viewControllers.append(rootViewCotroller)
    }

    //MARK:
    //MARK: loadview
    override open func loadView() {
        super.loadView()
        
        let rect = self.viewBounds(self.preferredInterfaceOrientationForPresentation)
        
        let rootViewController = _viewControllers[0]
        rootViewController.willMove(toParentViewController: self)
        self.addChildViewController(rootViewController)
        
        let rootView = rootViewController.view
        rootView!.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        rootView!.frame = rect
        self.view.addSubview(rootView!)
        
        rootViewController.didMove(toParentViewController: self)
        
        _maskView.frame = rect
        _maskView.backgroundColor = UIColor.clear
        _maskView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.view.insertSubview(_maskView, at: 0)
        
        self.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
    

    //roll back to previous state. like pangesture pop a ViewController cancle 
    //then a pop should return  to previous state
    fileprivate func rollBackViewController() {
        
        guard let current = self.visibleViewController  else {
            return
        }
        
        guard let previous = self.previousViewController else{
            return
        }
        
        let rect = CGRect(x: 0,y: 0,width: current.view.frame.width,height: current.view.frame.height)
        let finishFrame = self.view.bounds.offsetBy(dx: -moveOffset, dy: 0)

        _animationInProgress = true

        UIView .animate(withDuration: animationDuration/2, delay: animationDelay/2, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            current.view.frame = rect
            previous.view.frame = finishFrame
            
            }, completion: { (finish) -> Void in
                
                if finish {

                    self._animationInProgress = false
                    previous.view.removeFromSuperview()

                }
            
        })
        
    }

    // Go forward when the gesture is end
    fileprivate func rollForwardViewController() {
        
        guard let current = self.visibleViewController  else {
            return
        }
        
        guard let previous = self.previousViewController else{
            return
        }
        
        let finishFrame = CGRect(x: 0,y: 0,width: current.view.frame.width,height: current.view.frame.height)
        let rect = self.view.bounds.offsetBy(dx: self.view.frame.width, dy: 0)
        
        _animationInProgress = true
    
        previous.willMove(toParentViewController: self)
        self.addChildViewController(previous)
        
        current.willMove(toParentViewController: nil)
        current.removeFromParentViewController()
        
        UIView .animate(withDuration: animationDuration/2, delay: animationDelay/2, options: UIViewAnimationOptions(), animations: { () -> Void in
            
            current.view.frame = rect
            previous.view.frame = finishFrame
            
            }, completion: { (finish) -> Void in
                
                if finish {
                    
                    self._animationInProgress = false

                    previous.didMove(toParentViewController: self)
                    current.didMove(toParentViewController: nil)
                    current.view.removeFromSuperview()
                    _ = self._viewControllers.flipRemoveObject(current)
    
                }
                
                
        })
        
    }

    // remove viewcontroller after some viecontroller when you want pop more then one
    fileprivate func removeViewControllersAfterViewController(_ viewController : UIViewController){
        
        let idx = _viewControllers.index(of: viewController)

        guard let index = idx else{
            print("self.viewController not contains object \(viewController)")
            return
        }

        while _viewControllers.count > index + 2 {
            
            let removedVC = self._viewControllers[index+1]
            removedVC.view.removeFromSuperview()
            removedVC.willMove(toParentViewController: nil)
            removedVC.removeFromParentViewController()
            removedVC.didMove(toParentViewController: nil)
            _viewControllers.remove(at: index+1)
        }

    }

    //add pan gesutre when push a viewccontroller
    fileprivate func addPanGestureToView(_ view : UIView?) {
        
        guard let view = view else{
            return
        }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(KYFlipNavigationController.gestureRecognizerDidPan(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        _panGestures.append(panGesture)
    }
    
    func gestureRecognizerDidPan(_ panGesture : UIPanGestureRecognizer) {
        
        if _animationInProgress {
            return
        }

        let currentPoint = panGesture.translation(in: self.view)
        let x = currentPoint.x + _panOrigin.x
        
        var panDirection : KYFlipPanDirection = .none
        
        let vel = panGesture.velocity(in: self.view)
        if vel.x > 0{
            panDirection = .right
        }else{
            panDirection = .left
        }
        
        var offset : CGFloat = 0

        
        guard let current = self.visibleViewController else {
            return
        }
        
        guard let previous = self.previousViewController else {
            return
        }
        
        if panGesture.state == .began {
            self.view.addSubview(previous.view)
            self.view.bringSubview(toFront: current.view)
        }

        offset = self.view.frame.width - x
        
        _percentageOffsetFromLeft = offset/self.viewBounds(self.preferredInterfaceOrientationForPresentation).width
        
        current.view.frame = self.getSlidingRectWithPercentageOffset(_percentageOffsetFromLeft, orientation: self.preferredInterfaceOrientationForPresentation)
        previous.view.frame = self.getPreviousRectPrecentageOffset(_percentageOffsetFromLeft, orientation: self.preferredInterfaceOrientationForPresentation)
        
        if panGesture.state == .ended || panGesture.state == .cancelled {

            if abs(vel.x) > 100 {
                self.completeSlidingAnimationWithDirection(panDirection)
            }else{
                self.completeSlidingAnimationWithOffset(offset)
            }
            
        }
    }
    
    fileprivate func getSlidingRectWithPercentageOffset(_ percentage : CGFloat, orientation : UIInterfaceOrientation) -> CGRect {
    
        let viewRect = self.viewBounds(orientation)
        var rectToReturn = CGRect.zero
        rectToReturn.size = viewRect.size
        rectToReturn.origin = CGPoint(x: max(0, (1-percentage)*viewRect.size.width), y: 0)
        return rectToReturn
        
    }
    
    fileprivate func getPreviousRectPrecentageOffset(_ percentage : CGFloat, orientation : UIInterfaceOrientation) -> CGRect{
        
        let viewRect = self.viewBounds(orientation)
        var rectToReturn = CGRect.zero
        rectToReturn.size = viewRect.size
        let precentOffst = moveOffset * percentage
        rectToReturn.origin = CGPoint(x: max(-moveOffset, -precentOffst), y: 0)
        return rectToReturn
    }
    
    fileprivate func completeSlidingAnimationWithDirection(_ driection : KYFlipPanDirection){
        
        if driection == .right  {
            self.rollForwardViewController()
        }else {
            self.rollBackViewController()
        }
        
        
    }
    
    fileprivate func completeSlidingAnimationWithOffset(_ offset : CGFloat){
        
        if offset < self.viewBounds(self.preferredInterfaceOrientationForPresentation).size.width/2 {
            self.rollForwardViewController()
        }else{
            self.rollBackViewController()
        }
    }

    fileprivate var topMostViewController : UIViewController?{

        guard let current = self.visibleViewController else{
            return nil
        }

        //current is kind of UINavigationController Class , find the top ViewController
        if current .isKind(of: UINavigationController.self) {

            let currentNavi = current as! UINavigationController
            let topVC = currentNavi.topViewController

            guard let top = topVC else {
                return nil
            }
            return top
            //current is kind of UITabBarController class , find the selected ViewController
        }else if current.isKind(of: UITabBarController.self) {

            let currentTab = current as! UITabBarController
            let selectVC = currentTab.selectedViewController

            guard let select = selectVC else{
                return nil
            }

            if select.isKind(of: UINavigationController.self) {

                let selectTapNavi = select as! UINavigationController
                let selectTopVC = selectTapNavi.topViewController

                guard let selectTop = selectTopVC else {
                    return nil
                }

                return selectTop

            }

            return select

        }else{
            return current
        }

    }




    open override var shouldAutorotate : Bool {

        guard let current = self.topMostViewController else{
            return false
        }
        return current.shouldAutorotate
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        guard let current = self.topMostViewController else{
            return .portrait
        }
        return current.supportedInterfaceOrientations

    }

    // Returns interface orientation masks.
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        guard let current = self.topMostViewController else{
            return .portrait
        }
        return current.preferredInterfaceOrientationForPresentation
    }
}

//MARK:
//MARK: Public Method
extension KYFlipNavigationController {
    
    public func pushViewController(_ viewController : UIViewController, animated : Bool, completed : KYFlipNavigationCompletionBlock? = nil){
        
        
        viewController.view.frame = self.view.bounds.offsetBy(dx: self.view.bounds.width, dy: 0)
        viewController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        viewController.willMove(toParentViewController: self)
        self.addChildViewController(viewController)
        self.view.bringSubview(toFront: _maskView)
        self.view.addSubview(viewController.view)
        
        let finishFrame = self.view.bounds.offsetBy(dx: -moveOffset, dy: 0)
        self.visibleViewController?.willMove(toParentViewController: nil)
        if animated {
            
            _animationInProgress = true
            UIView .animate(withDuration: animationDuration, delay: animationDelay, options: UIViewAnimationOptions(), animations: { () -> Void in

                self.visibleViewController?.view.frame = finishFrame
                viewController.view.frame = self.view.bounds
                
                }, completion: { (finish) -> Void in
                    
                    if finish {
                        self.visibleViewController?.removeFromParentViewController()
                        self.visibleViewController?.didMove(toParentViewController: nil)
                        self.visibleViewController?.view.removeFromSuperview()
                        self._viewControllers.append(viewController)
                        viewController.didMove(toParentViewController: self)
                        self._animationInProgress = false
                        self.addPanGestureToView(self.visibleViewController?.view)
                        if let _ = completed {
                            completed!()
                        }
                        
                    }
                    
                    
            })
            
        }else{
            self.visibleViewController?.removeFromParentViewController()
            self.visibleViewController?.view.frame = finishFrame
            self.visibleViewController?.view.removeFromSuperview()
            self.visibleViewController?.didMove(toParentViewController: nil)

            viewController.view.frame = self.view.bounds
            self._viewControllers.append(viewController)
            viewController.didMove(toParentViewController: self)
            self.addPanGestureToView(self.visibleViewController?.view)
            if let _ = completed {
                completed!()
            }

        }
        
    }

    
    public func popToRootViewControllerAnimated(_ animated : Bool ,completed : KYFlipNavigationCompletionBlock?){
        
        guard let rootVC = self.rootViewController else {
            return
        }
        self.popToViewController(rootVC, animated: animated, completed: completed)
        
    }

    public func popToViewController(_ viewController : UIViewController, animated : Bool, completed : KYFlipNavigationCompletionBlock? = nil){
        
        if self._viewControllers.count < 2 {
            print("self.viewControllers.count : \(self._viewControllers.count) < 2")
            return
        }

        guard let current = self.visibleViewController else {
            return
        }
        self.removeViewControllersAfterViewController(current)
        let previousVC = self.previousViewController
        
        guard let previous = previousVC else {
            return
        }
        
        previous.willMove(toParentViewController: self)
        self.addChildViewController(previous)
        self.view.addSubview(previous.view)
        
        self.view.bringSubview(toFront: current.view)
        current.willMove(toParentViewController: nil)
        current.removeFromParentViewController()
        if animated {
            _animationInProgress = true
            UIView.animate(withDuration: animationDuration, delay: animationDelay, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                current.view.frame = self.view.bounds.offsetBy(dx: self.view.bounds.width, dy: 0)
                previous.view.frame = self.view.bounds
                
                }, completion: { (finished) -> Void in
                    
                    if finished {
                        
                        self._animationInProgress = false
                        current.view.removeFromSuperview()
                        self.view.bringSubview(toFront: previousVC!.view)
                        
                        current.didMove(toParentViewController: nil)
                        _ = self._viewControllers.flipRemoveObject(current)
                        previous.didMove(toParentViewController: self)
                        
                        if let _ = completed {
                            completed!()
                        }
                    }
            })
            
        }else{
            
            previous.view.frame = self.view.bounds
            current.view.removeFromSuperview()
            self.view.bringSubview(toFront: previousVC!.view)
            current.didMove(toParentViewController: nil)
             _ = self._viewControllers.flipRemoveObject(current)
            previous.didMove(toParentViewController: self)
            
            if let _ = completed {
                completed!()
            }
        }

        
       
    }
    
    public func popViewController(_ animated : Bool, completed : KYFlipNavigationCompletionBlock? = nil){
        
        if self._viewControllers.count < 2 {
            print("self.viewControllers.count : \(self._viewControllers.count) < 2")
            return
        }
        guard let previous = self.previousViewController else {
            return
        }
        self.popToViewController(previous, animated: animated,completed:completed )
    }

    
}

//MARK:
//MARK: UIGestureRecognizerDelegate
extension KYFlipNavigationController : UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            
            let panGestureRecoginizer = gestureRecognizer as! UIPanGestureRecognizer
            let translation =  panGestureRecoginizer.translation(in: self.view)
            
            if translation.x > translation.y {
                return true
            }
        }
        return false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        guard let current = self.visibleViewController else {
            return false
        }
        
        if current .isKind(of: UINavigationController.self) {
            
            let currentNavi = current as! UINavigationController
            
            let currentNaviControllers = currentNavi.viewControllers
            if currentNaviControllers.count != 1{ // the navigation viewcontroller statck has more than one viewcontroller , should not pan the naviationcontroller
                return false
            }
            
            if currentNavi.navigationBar.isHidden == false {
                
                if currentNavi.navigationBar.frame.contains(touch.location(in: currentNavi.view)) {
                    
                    return false
                }
                
            }
            
        }else if current.isKind(of: UITabBarController.self) {
            
            let currentTab = current as! UITabBarController
            let selectVC = currentTab.selectedViewController
            
            if let select = selectVC {
                
                if select.isKind(of: UINavigationController.self) {
                    
                    let selectTapNavi = select as! UINavigationController
                    let currentNaviControllers = selectTapNavi.viewControllers
                    if currentNaviControllers.count != 1{ // the navigation viewcontroller statck has more than one viewcontroller , should not pan the naviationcontroller
                        return false
                    }
                    
                    if selectTapNavi.navigationBar.isHidden == false {
                        
                        if selectTapNavi.navigationBar.frame.contains(touch.location(in: selectTapNavi.view)) {
                            
                            return false
                        }
                        
                    }
                    
                }
                
            }
            
            if !currentTab.tabBar.isHidden {
                
                if currentTab.tabBar.frame.contains(touch.location(in: currentTab.view)) {
                    
                    return false
                }
                
                
            }
            
        }

        _panOrigin = current.view.frame.origin
        gestureRecognizer.isEnabled = true
        return  !_animationInProgress
    }
    
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    
}


//MARK:
//MARK: private calculate
extension KYFlipNavigationController {
    
    //Not Support Version < 7.0
    fileprivate func viewBounds(_ orientation : UIInterfaceOrientation) -> CGRect {
        
        var bounds = UIScreen.main.bounds
        if UIInterfaceOrientationIsLandscape(orientation){
            let width = bounds.width
            bounds.size.width = bounds.height
            bounds.size.height = width
        }
        return bounds
    }
    
    
}


//MARK:
//MARK: UIViewController -> KYFlipNavigationController
extension UIViewController{
    
    open var flipNavigationController : KYFlipNavigationController? {
        get{
            if let parentController = self.parent {

                if parentController.isKind(of: KYFlipNavigationController.self) {
                    return parentController as? KYFlipNavigationController
                }
                if parentController.isKind(of: UINavigationController.self){
                    if let grandfatherController = parentController.parent {
                        if grandfatherController.isKind(of: KYFlipNavigationController.self) {
                            return grandfatherController as? KYFlipNavigationController
                        }
                    }
                }
            }
            return nil
        }
    }

}

//MARK:
//MARK: Array Flip Extension
extension Array {
    
    mutating func flipRemoveObject<U: Equatable>(_ object: U) -> Bool {
        for index in 0..<self.count {
            let objectToCompare = self[index]
            if let to = objectToCompare as? U {
                if object == to {
                    self.remove(at: index)
                    return true
                }
            }
        }
        return false
    }
    
}


