//
//  Rut2xxRouterSettings.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 07/08/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class Rut2xxRouterSettings: UIViewController, UITextFieldDelegate {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var reapeatPasswordField: UITextField!
    
    var notChangedRouterPasswordFieldText = ""
    var notChangedRepeatRouterPasswordFieldText = ""
    var simCardValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        self.newPasswordTextField.delegate = self
        self.reapeatPasswordField.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(onSave))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        
    }
    
    func onSave() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        var routerPassword = newPasswordTextField.text
        var repeatRouterPasswordValue = reapeatPasswordField.text
        if routerPassword == repeatRouterPasswordValue {
            UserDefaults.standard.setValue(routerPassword, forKey: "routernew_password")
            Ru9xxRouterChangePasswordModel().performRouterPasswordTask(params: [routerPassword!]){ () in
                
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
            }
        } else {
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            let alert = UIAlertController(title: "", message: "Password do not match!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)})
            newPasswordTextField.text = ""
            reapeatPasswordField.text = ""
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @IBAction func newPasswordEditChanged(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @IBAction func newPasswordEditingEnd(_ sender: Any) {
        if newPasswordTextField.text == "" || reapeatPasswordField.text == "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            notChangedRouterPasswordFieldText = newPasswordTextField.text!
        }
    }
    @IBAction func repeatPasswordEditChanged(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @IBAction func repeatPasswordEdittingEnd(_ sender: Any) {
        if newPasswordTextField.text == "" || reapeatPasswordField.text == "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            notChangedRepeatRouterPasswordFieldText = reapeatPasswordField.text!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

