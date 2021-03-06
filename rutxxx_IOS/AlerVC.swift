//
//  AlerVC.swift
//  bandymasAlam
//
//  Created by Gedas Urbonas on 09/02/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation


func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    
    if let nav = base as? UINavigationController {
        return topViewController(base: nav.visibleViewController)
    }
    
    if let tab = base as? UITabBarController {
        let moreNavigationController = tab.moreNavigationController
        
        if let top = moreNavigationController.topViewController , top.view.window != nil {
            return topViewController(base: top)
        } else if let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
    }
    
    if let presented = base?.presentedViewController {
        return topViewController(base: presented)
    }
    
    return base
}
