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



//protocol DetailViewControllerDelegate: class {
//    func didFinishTask(sender: DetailViewController)
//}


class LoginController: UIViewController, UITextFieldDelegate {
  
  private let ADMIN = "admin"
  private let ROOT = "root"

  

  
  func displayAlert(title:String, message: String){
    let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alertcontroller, animated: true, completion: nil)
  }
  
  
  
  @IBOutlet var userName: UITextField!
  @IBOutlet var password: UITextField!
  @IBOutlet var uncheckbox: UIButton!
  
  
  
  var checkBox = UIImage(named: "checkbox1")
  var uncheckBox = UIImage(named: "checkbox2")
  var isboxclicked: Bool!
  
  
  
  
  @IBAction func loginButton(_ sender: Any) {
    if userName.text == "" || password.text == "" {
      displayAlert(title: "Error", message: "Username and password are required")
    } else {
      let name : String = userName.text!
      let replacedUsername = name.replacingOccurrences(of: ADMIN, with: ROOT)
   //   print("saunu", replacedUsername)
      
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
    
    isboxclicked = false
    
    
    
    super.viewDidLoad()
    
    
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    self.view.endEditing(true)
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    textField.resignFirstResponder()
    
    return true
  }
  
  
  @IBAction func Checkbox(_ sender: Any) {
    let ddd = LoginModel()
    ddd.jsonDevice(param1: (UserDefaults.standard.value(forKey: "saved_token")! as! String))
    ddd.jsonDeviceSerial()
    
    if isboxclicked == true {
      isboxclicked = false
      
    }else {
      isboxclicked = true
    }
    if isboxclicked == true{
      uncheckbox.setImage(checkBox, for: UIControlState.normal)
    }else {
      uncheckbox.setImage(uncheckBox, for: UIControlState.normal)
      
    }
  }
  
  
  public func performLogin(userName: String, password: String, complete: @escaping (Bool)->()){
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicator.center = self.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
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
  
  
}

