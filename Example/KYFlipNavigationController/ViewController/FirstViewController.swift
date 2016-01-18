//
//  FirstViewController.swift
//  KYFlipNavigationController
//
//  Created by Kyle on 15/12/21.
//  Copyright © 2015年 xiaoluuu. All rights reserved.
//

import UIKit
import KYFlipNavigationController

class FirstViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func flipPush(sender: AnyObject) {
        
        let  viewController = StoryboardHelper.loadViewControllerVCIdentifier("NavigationController")
        viewController.title = "第三个"
        self.rdv_tabBarController.flipNavigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("\(self) viewWillAppear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("\(self) viewDidAppear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(self) viewWillDisappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("\(self) viewDidDisappear")
    }
    

 
}
