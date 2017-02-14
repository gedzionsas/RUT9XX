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


protocol LoginControllerDelegate: class {
    func finishLoggingIn()
}

class LoginController: UIViewController, UITextFieldDelegate, LoginControllerDelegate {
    
   
    
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
            performLogin(userName: userName.text!, password: password.text!)
            UserDefaults.standard.setValue(userName.text, forKey: "saved_username")
            UserDefaults.standard.setValue(password.text, forKey: "saved_password")
        }
        handleLogin()
        
    }
    
    
    weak var delegate: LoginControllerDelegate?
    func handleLogin() {
       // finishLoggingIn()
        delegate?.finishLoggingIn()
    }
    
    override func viewDidLoad() {
        LoginController.Log
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
        ddd.JsonDevice(param1: (UserDefaults.standard.value(forKey: "saved_token")! as! String))
        
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
    
    
    public func performLogin(userName: String, password: String){
        
        var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        view.addSubview(activityIndicator)
        
        let duom = LoginModel()
        duom.JsonResult(param1: userName, param2: password, param3: self)
        

        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        
        
        
        
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func finishLoggingIn() {
        print("Finish logging in")
        dismiss(animated: true, completion: nil)
    }
    

}

