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
  
  var activeTextField: UITextField!

  
  private let ADMIN = "admin"
  private let ROOT = "root"
  
  func displayAlert(title:String, message: String){
    let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alertcontroller, animated: true, completion: nil)
  }
  
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
    
    
    
  //  userName.delegate = self
 //   password.delegate = self
    
    NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
    self.view.addGestureRecognizer(tapGesture)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    registerKeyboardNotifications()
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    deRegisterKeyboardNotifications()
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

  fileprivate func registerKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(LoginController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  fileprivate func deRegisterKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: self.view.window)
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: self.view.window)
  }
  func keyboardWillShow(notification: NSNotification) {
    
    let info: NSDictionary = notification.userInfo! as NSDictionary
    let value: NSValue = info.value(forKey: UIKeyboardFrameBeginUserInfoKey) as! NSValue
    let keyboardSize: CGSize = value.cgRectValue.size
    let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    var aRect: CGRect = self.view.frame
    aRect.size.height -= keyboardSize.height
    let activeTextFieldRect: CGRect? = activeTextField?.frame
    let activeTextFieldOrigin: CGPoint? = activeTextFieldRect?.origin
    if (!aRect.contains(activeTextFieldOrigin!)) {
      scrollView.scrollRectToVisible(activeTextFieldRect!, animated:true)
    }    }
  
  func keyboardWillHide(notification: NSNotification) {
    let contentInsets: UIEdgeInsets = .zero
    scrollView.contentInset = contentInsets
    scrollView.scrollIndicatorInsets = contentInsets
  }
  
  //MARK: - UITextField Delegate Methods
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == userName {
      password.becomeFirstResponder()
    }
    else if textField == password {
      userName.becomeFirstResponder()
    }
    else {
      self.view.endEditing(true)
    }
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeTextField = textField
    scrollView.isScrollEnabled = true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    activeTextField = nil
    scrollView.isScrollEnabled = false
  }
  
}

