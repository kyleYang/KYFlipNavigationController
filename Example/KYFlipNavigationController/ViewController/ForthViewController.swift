//
//  ForthViewController.swift
//  KYFlipNavigationController
//
//  Created by Kyle on 15/12/24.
//  Copyright © 2015年 xiaoluuu. All rights reserved.
//

import UIKit
import KYFlipNavigationController

class ForthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setViewController(sender: AnyObject) {
        
        let  viewController = StoryboardHelper.loadViewControllerVCIdentifier("FifthViewController")
        viewController.title = "第五个"
        
        self.flipNavigationController?.pushViewController(viewController, animated: true)

        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
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
