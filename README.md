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

###Init
```swift

		let firstVC = StoryboardHelper.loadViewControllerVCIdentifier("FirstViewController")
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


## Requirements

## Installation

KYFlipNavigationController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "KYFlipNavigationController"
```

## Author

kyleYang, yangzychina@gmail.com

## License

KYFlipNavigationController is available under the MIT license. See the LICENSE file for more info.
