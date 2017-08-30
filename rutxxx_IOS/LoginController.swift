//
//  ViewController.swift
//  bandymasAlam
//
//  Created by Gedas Urbonas on 06/01/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class LoginController: UIViewController, UITextFieldDelegate {
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

  
  private let ADMIN = "admin"
  private let ROOT = "root"
  
  func displayAlert(title:String, message: String){
    self.activityIndicator.stopAnimating()
    UIApplication.shared.endIgnoringInteractionEvents()
    let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alertcontroller, animated: true, completion: nil)
  }
  
  @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet var userName: UITextField!
  @IBOutlet var password: UITextField!
  
  @IBAction func loginButton(_ sender: Any) {
    login()
  }
    
    func login() {
        checkReachability() { success in
            if success {
                if userName.text == "" || password.text == "" {
                    displayAlert(title: "Error", message: "Username and password are required")
                } else {
                    if let gateway = getGatewayIP() {
                        UserDefaults.standard.setValue(gateway, forKey: "gateway_value")
                        URLREQUEST = "http://\(gateway)/ubus"
                        IP = URL(string: "http://\(gateway)")
                        
                    } else {
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            AlertController.showErrorWith(title: "Error", message: "Getting gateway IP failed", controller: self) {
                            }
                        }
                    }
                    let name : String = userName.text!
                    let replacedUsername = name.replacingOccurrences(of: ADMIN, with: ROOT)
                    
                    UserDefaults.standard.setValue(replacedUsername, forKey: "saved_username")
                    UserDefaults.standard.setValue(password.text, forKey: "saved_password")
                    UserDefaults.standard.synchronize()
                    
                    performLogin(userName: UserDefaults.standard.value(forKey: "saved_username")! as! String, password: UserDefaults.standard.value(forKey: "saved_password")! as! String){ success in
                        if success {
                            self.finishLoggingIn()
                        } else {
                        }
                    }
                }
            } else {
                // Then wifi not connected
                wifiSettings(false)
            }
        }

    }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
    self.view.addGestureRecognizer(tapGesture)
  }
  
    @IBAction func didEndPasswordEditting(_ sender: Any) {
        self.password.delegate = self;

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        login()
        return false
    }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tap(gesture: UITapGestureRecognizer) {
    userName.resignFirstResponder()
    password.resignFirstResponder()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    self.view.endEditing(true)
  }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= (UIScreen.main.bounds.size.height) {
                self.keyboardHeightLayoutConstraint?.constant = 289
            } else {
                self.keyboardHeightLayoutConstraint?.constant = 289.0 - ((endFrame?.size.height)! - (UIScreen.main.bounds.size.height - 455))
                
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
  public func performLogin(userName: String, password: String, complete: @escaping (Bool)->()){
    
    
    activityIndicator.center = self.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    view.addSubview(activityIndicator)
    
    activityIndicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
    
    let loginJsonResult = LoginModel()
    loginJsonResult.jsonResult(param1: userName, param2: password, param3: self){ success in
      if success {
        
        if self.isLoggedIn() {
            
            
        } else {
        let deviceName = UserDefaults.standard.value(forKey: "device_name") as! String
        if (deviceName.isEmpty || !deviceName.contains("RUT")) {
        } else {
            self.perform(#selector(self.showWizardVC), with: nil, afterDelay: 0.01)
            }
        }
        complete(true)
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
      } else {
        complete(false)
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
      }
      
      
    }

    
  }
  
    
    func isLoggedIn() -> Bool {
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
    
    func getGatewayIP() -> String? {
        var gatewayaddr = in_addr()
        let r = getdefaultgateway(&gatewayaddr.s_addr)
        if r >= 0 {
            return String(cString: inet_ntoa(gatewayaddr))
        } else {
            return nil
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
    
    func showLoginVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"LoginVC")
        self.present(viewController, animated: true)
    }
    
    func showWizardVC() {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "pageWizard")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
  func finishLoggingIn() {
    print(self.isLoggedIn())
    if self.isLoggedIn() {

    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainVC")
    appDelegate.window?.rootViewController = initialViewController
    appDelegate.window?.makeKeyAndVisible()
    }
        
    UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
    UserDefaults.standard.synchronize()
    dismiss(animated: true, completion: nil)
  }
  

}

