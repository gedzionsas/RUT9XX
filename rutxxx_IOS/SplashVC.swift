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

           let appDomain = Bundle.main.bundleIdentifier!
 UserDefaults.standard.removePersistentDomain(forName: appDomain)
    
    // check is wi-fi connected
    checkReachability() { success in
      if success {

        print(isLoggedIn())
    if isLoggedIn() {
      // Auto login when not first time
      
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
          // what happens when connected wrong Wi-fi device
          
          
        }
        
      }
      
    } else {

          self.perform(#selector(self.showLoginVC), with: nil, afterDelay: 0.01)
    }
    } else {
        
        // Then wifi not connected
        
        wifiSettings(false)

    }
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
  
 
  
  func wifiSettings(_ animated: Bool) {
    let alertController = UIAlertController (title: "Not connected to router", message: "Go to Wi-fi Settings?", preferredStyle: .alert)
    
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
      guard let settingsUrl = URL(string: "App-Prefs:root=WIFI") else {
        return
      }
      if UIApplication.shared.canOpenURL(settingsUrl) {
        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
          print("Settings opened: \(success)") // Prints true
          self.perform(#selector(self.showLoginVC), with: nil, afterDelay: 0.01)
        })
      }
    }
    alertController.addAction(settingsAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    alertController.addAction(cancelAction)
    
  let alertWindow = UIWindow(frame: UIScreen.main.bounds)
  alertWindow.rootViewController = UIViewController()
  alertWindow.windowLevel = UIWindowLevelAlert + 1;
  alertWindow.makeKeyAndVisible()
  alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
  }
 
  func showLoginVC() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier :"LoginVC")
    self.present(viewController, animated: true)
  }
  
}


