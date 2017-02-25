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
    //       let appDomain = Bundle.main.bundleIdentifier!
    //       UserDefaults.standard.removePersistentDomain(forName: appDomain)
    
    if isLoggedIn() {
      let loginController = LoginController()
      loginController.performLogin(userName: UserDefaults.standard.value(forKey: "saved_username")! as! String, password: UserDefaults.standard.value(forKey: "saved_password")! as! String){ success in
        if success {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let mainVCC = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          appDelegate.window?.rootViewController = mainVCC
        } else {
        }
        
      }
      
      
      
      
      
    } else {
      perform(#selector(showLoginVC), with: nil, afterDelay: 0.01)
    }
  }
  
  fileprivate func isLoggedIn() -> Bool {
    return UserDefaults.standard.bool(forKey: "isLoggedIn")
    
  }
  
  func showLoginVC() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier :"LoginVC")
    self.present(viewController, animated: true)
  }
  
}


