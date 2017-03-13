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
  
//  func checkWiFi() -> Bool {
//    
//    let networkStatus = Reachability().connectionStatus()
//    switch networkStatus {
//    case .Unknown, .Offline:
//      
//      DispatchQueue.main.async {
//        AlertController.showErrorWith(title: "Error", message: "Not connected to router", controller: self) {
//          
//        }
//      }
//      return false
//    case .Online(.WWAN):
//      DispatchQueue.main.async {
//        AlertController.showErrorWith(title: "Error", message: "Not connected to router", controller: self) {
//          
//        }
//      }
//      return true
//    case .Online(.WiFi):
//      print("Connected via WiFi")
//      return true
//    }
//  }
  override public func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

//           let appDomain = Bundle.main.bundleIdentifier!
// UserDefaults.standard.removePersistentDomain(forName: appDomain)
    


    if isLoggedIn() {
    //  checkReachability()
      let loginController = LoginController()
      loginController.performLogin(userName: UserDefaults.standard.value(forKey: "saved_username")! as! String, password: UserDefaults.standard.value(forKey: "saved_password")! as! String){ success in
        if success {
          let deviceName = UserDefaults.standard.value(forKey: "device_name") as! String
          if (deviceName.isEmpty || !deviceName.contains("RUT")) {
            self.perform(#selector(self.showLoginVC), with: nil, afterDelay: 0.01)
          }
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let mainVCC = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          appDelegate.window?.rootViewController = mainVCC
        } else {
        }
        
      }
      
    } else {
//      checkReachability(){ success in
//        if success {
//          print("successful")
//          self.perform(#selector(self.showLoginVC), with: nil, afterDelay: 0.01)
//        } else {
//          print("not successful")
 self.perform(#selector(self.showLoginVC), with: nil, afterDelay: 0.01)
//        }
//      }
    }
  }
  
  func checkReachability(complete: (Bool)->()){
    if currentReachabilityStatus == .reachableViaWiFi {
      print("User is connected to the internet via wifi.")
      complete(true)
    } else {
      print("There is no internet connection")
    complete(false)

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


