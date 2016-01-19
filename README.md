# KYFlipNavigationController

[![CI Status](http://img.shields.io/travis/kyleYang/KYFlipNavigationController.svg?style=flat)](https://travis-ci.org/kyleYang/KYFlipNavigationController)
[![Version](https://img.shields.io/cocoapods/v/KYFlipNavigationController.svg?style=flat)](http://cocoapods.org/pods/KYFlipNavigationController)
[![License](https://img.shields.io/cocoapods/l/KYFlipNavigationController.svg?style=flat)](http://cocoapods.org/pods/KYFlipNavigationController)
[![Platform](https://img.shields.io/cocoapods/p/KYFlipNavigationController.svg?style=flat)](http://cocoapods.org/pods/KYFlipNavigationController)

The KYFlipNavigationController is an custom NavigationController the use UIViewController to manager the UIViewController(include UINavigationController,UITabbarController,UIViewController) like the UINavigationController .
Many app like EasyNet News and Toutiao use TabbarController UINavigationController when push

##Overview
![alt tag](https://github.com/kyleYang/KYFlipNavigationController/blob/master/Example/KYFlipNavigationController/KYFlipNavigationController.gif)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

####Init
```swift

	let firstVC = StoryboardHelper.loadViewControllerVCIdentifier("FirstViewController") //load viewcontroller from storyboard
    firstVC.title = "One"
    let firstNavi = UINavigationController(rootViewController: firstVC)
    
    let sencondVC = StoryboardHelper.loadViewControllerVCIdentifier("SecondViewController")
    sencondVC.title = "Two"
    
    
    let tabbar = RDVTabBarController()
    tabbar.viewControllers = [firstNavi,sencondVC]
    
    
    let flipViewController = KYFlipNavigationController(rootViewCotroller: tabbar)
    self.windows.rootViewController = flipViewController
    self.window.makeKeyAndVisible()

```
####Push or Pop
Push and pop almost like the UINavigationController . The key way is to find the flipNavigationController. It's easy and we use a UITabbarController's extension
```swift
	//Push
	let  viewController = StoryboardHelper.loadViewControllerVCIdentifier("NavigationController")
    viewController.title = "Three"
    self.rdv_tabBarController.flipNavigationController?.pushViewController(viewController, animated: true) //find the navigationCotroller use self.pushViewController

    //Pop
    self.navigationController?.flipNavigationController?.popViewController(true)

```
####The public func 

```swift
	//Push
    public func pushViewController(viewController : UIViewController, animated : Bool, completed : KYFlipNavigationCompletionBlock?)
    public func pushViewController(viewController : UIViewController , animated: Bool) 

    //Pop
    public func popToRootViewControllerAnimated(animated : Bool ,completed : KYFlipNavigationCompletionBlock?)
    public func popToRootViewControllerAnimated(animated : Bool ,completed : KYFlipNavigationCompletionBlock?)
	public func popToViewController(viewController : UIViewController, animated : Bool, completed : KYFlipNavigationCompletionBlock?)
	public func popViewController(animated : Bool, completed : KYFlipNavigationCompletionBlock?)
	public func popViewController(animated : Bool)
```
####Change the stack
You can also change the UIViewController stack when you want

```swift

	guard let viewControllers = self.flipNavigationController?.viewControllers else {
    	return
    }
    var newControllers : Array<UIViewController> = []
    for viewController in viewControllers {
        
        if !viewController.isKindOfClass(ForthViewController.self) {
            newControllers.append(viewController)
        }
    }
    
    self.flipNavigationController?.viewControllers = newControllers

```


## Requirements

## Installation

KYFlipNavigationController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KYFlipNavigationController"
```

## Author

kyleYang, yangzychina@gmail.com

If you find any porblem , please tell me

## License

KYFlipNavigationController is available under the MIT license. See the LICENSE file for more info.
