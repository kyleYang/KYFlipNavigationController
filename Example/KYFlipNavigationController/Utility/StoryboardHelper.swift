//
//  StoryboardHelper.swift
//  KYFlipNavigationController
//
//  Created by Kyle on 15/12/23.
//  Copyright © 2015年 xiaoluuu. All rights reserved.
//

import UIKit

class StoryboardHelper: NSObject {

    //Load UIVieController From Main Storyboard with UIViewContrller Identifier
    class func loadViewControllerVCIdentifier(_ vcIdentifier:String) -> UIViewController {
        
       return StoryboardHelper.loadViewControllerFrom("Main", vcIdentifier: vcIdentifier)
        
    }
    
    //Load UIVieController From storyboardName Storyboard with UIViewContrller Identifier
    class func loadViewControllerFrom(_ storyboardName : String, vcIdentifier:String) -> UIViewController {
        
        let storybard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storybard.instantiateViewController(withIdentifier: vcIdentifier)
        return vc
        
    }
    
    
}
