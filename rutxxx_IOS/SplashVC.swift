//
//  SplashViewController.swift
//  bandymasAlam
//
//  Created by Gedas Urbonas on 16/01/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

public class SplashVC: UINavigationController {
    
        
        private static let VALID_PASSWORD = UserDefaults.standard.value(forKey: "saved_password")
    
    
    override public func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
   
    
    if isLoggedIn() {
    
    let homeController = HomeController()
        viewControllers = [homeController]
    } else {
        perform(#selector(showLoginVC), with: nil, afterDelay: 0.01)
        }
    }
 
    fileprivate func isLoggedIn() -> Bool {
    return false
    }
    
    func showLoginVC() {
     //   let loginVC = LoginController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"LoginVC") 
        self.present(viewController, animated: true)
     //   present(loginVC, animated: true, completion: {
            
        
        
    }
}

class HomeController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }


}
    
    
