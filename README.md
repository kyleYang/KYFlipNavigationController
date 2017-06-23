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

#### Init
Set up flipNavigationController as root of a window,self.flipNavigationController will find the KYFlipNavigationController if it's exist!
```swift

   let firstVC = FirstViewController(nibName: nil, bundle: nil);
   firstVC.title = "First"
   let firstNavi = UINavigationController(rootViewController: firstVC)

   let sencondVC = SecondViewController(nibName: nil, bundle: nil);
   sencondVC.title = "Second"

   let tabbar = RDVTabBarController()
   tabbar.viewControllers = [firstNavi,sencondVC]
   
   let flipViewController = KYFlipNavigationController(rootViewCotroller: tabbar)
   self.window = UIWindow();
   self.window?.backgroundColor = UIColor.white;
   self.window?.rootViewController = flipViewController;
   self.window?.makeKeyAndVisible()

```
#### Push or Pop
Push and pop almost like the UINavigationController . The key way is to find the flipNavigationController. It's easy that we use a UIViewController's extension
```swift
   //Push
   let  viewController = ThirdViewController(nibName: nil, bundle: nil)
   viewController.title = "cell_\(indexPath.row)"
   // push a navigationcontroller
   let navi = UINavigationController(rootViewController: viewController)
   self.rdv_tabBarController.flipNavigationController?.pushViewController(navi, animated: true)//self is add to a tabbarcontroller
   
   //we also an push a UIViewController,and if self is not add to a tabbarcontroller
   self.flipNavigationController?.pushViewController(viewController, animated: true)
   

     //Pop
    self.flipNavigationController?.popViewController(true)
    //also we can pop to a viewcontroller or to the rootviewcontroller

```
#### The public func 

```swift
   //Push
   pushViewController(_ viewController : UIViewController, animated : Bool, completed : KYFlipNavigationCompletionBlock? = nil)

   //Pop
   public func popViewController(_ animated : Bool, completed : KYFlipNavigationCompletionBlock? = nil)
   public func popToViewController(_ viewController : UIViewController, animated : Bool, completed : KYFlipNavigationCompletionBlock? = nil)
   public func popToRootViewControllerAnimated(_ animated : Bool ,completed : KYFlipNavigationCompletionBlock?)
```
#### Change the stack
You can also change the UIViewController stack when you want，so you can remove some viewcontroller or add some viewcontroller from the stack and change the pop way

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
