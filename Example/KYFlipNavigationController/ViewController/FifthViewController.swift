//
//  FifthViewController.swift
//  KYFlipNavigationController
//
//  Created by Kyle on 16/1/13.
//  Copyright © 2016年 xiaoluuu. All rights reserved.
//

import UIKit
import KYFlipNavigationController

class FifthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setViewCotrollers(sender: AnyObject) {
        
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
