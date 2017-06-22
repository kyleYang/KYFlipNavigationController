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

    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.present(UIButton())
    }
    
    func present(_ sender: AnyObject) {
        
        let firstVC = StoryboardHelper.loadViewControllerVCIdentifier("FirstViewController")
        firstVC.title = "First"
        let firstNavi = UINavigationController(rootViewController: firstVC)
        
        let sencondVC = StoryboardHelper.loadViewControllerVCIdentifier("SecondViewController")
        sencondVC.title = "Second"

        let tabbar = RDVTabBarController()
        tabbar.viewControllers = [firstNavi,sencondVC]
        
        
        let flipViewController = KYFlipNavigationController(rootViewCotroller: tabbar)
        
        self.present(flipViewController, animated: false) { () -> Void in
            
        }
        
    }

}

