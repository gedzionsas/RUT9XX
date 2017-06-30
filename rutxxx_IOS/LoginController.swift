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
  
  
  private let ADMIN = "admin"
  private let ROOT = "root"
  
  func displayAlert(title:String, message: String){
    let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alertcontroller, animated: true, completion: nil)
  }
  
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet var userName: UITextField!
  @IBOutlet var password: UITextField!
  
  @IBAction func loginButton(_ sender: Any) {   
    if userName.text == "" || password.text == "" {
      displayAlert(title: "Error", message: "Username and password are required")
    } else {
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
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
    self.view.addGestureRecognizer(tapGesture)
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
//  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    
//    textField.resignFirstResponder()
//    
//    return true
//  }

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
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicator.center = self.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    view.addSubview(activityIndicator)
    
    activityIndicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
    
    let loginJsonResult = LoginModel()
    loginJsonResult.jsonResult(param1: userName, param2: password, param3: self){ success in
      if success {
        print("successful")
        complete(true)
      } else {
        print("not successful")
        complete(false)
      }
      
      
    }
    activityIndicator.stopAnimating()
    UIApplication.shared.endIgnoringInteractionEvents()
    
  }
  
  func finishLoggingIn() {
    print("Finish logging in")
    
    
    let appDelegate = UIApplication.shared.delegate! as! AppDelegate
    
    let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainVC")
    appDelegate.window?.rootViewController = initialViewController
    appDelegate.window?.makeKeyAndVisible()
    
    UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
    UserDefaults.standard.synchronize()
    dismiss(animated: true, completion: nil)
  }
  
  // scroll view

}

