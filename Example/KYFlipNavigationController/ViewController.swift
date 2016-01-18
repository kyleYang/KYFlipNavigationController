//
//  ViewController.swift
//  KYFlipNavigationController
//
//  Created by kyleYang on 01/17/2016.
//  Copyright (c) 2016 kyleYang. All rights reserved.
//

import UIKit
import RDVTabBarController
import KYFlipNavigationController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        self.present(UIButton())
    }
    
    func present(sender: AnyObject) {
        
        let firstVC = StoryboardHelper.loadViewControllerVCIdentifier("FirstViewController")
        firstVC.title = "第一个"
        let firstNavi = UINavigationController(rootViewController: firstVC)
        
        let sencondVC = StoryboardHelper.loadViewControllerVCIdentifier("SecondViewController")
        sencondVC.title = "第二个"
        
        
        let tabbar = RDVTabBarController()
        tabbar.viewControllers = [firstNavi,sencondVC]
        
        
        let flipViewController = KYFlipNavigationController(rootViewCotroller: tabbar)
        
        self.presentViewController(flipViewController, animated: false) { () -> Void in
            
        }
        
    }

}

