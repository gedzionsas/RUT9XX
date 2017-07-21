//
//  Rut9xxRouterSettings.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 06/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit



class Rut9xxRouterSettings: UIViewController, UITextFieldDelegate, PassdataDelegate {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    func passData(value: String) {
        primarySimCardField?.titleLabel?.text = value
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "popUpIdent") {
            let destVC: Rut9xxSimCardPopUp = segue.destination as! Rut9xxSimCardPopUp
            destVC.delegate = self
        }
    }
    
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var reapeatPasswordField: UITextField!
    @IBOutlet weak var primarySimCardField: UIButton!
    
    var roundButton = UIButton()
    
    var notChangedRouterPasswordFieldText = ""
    var notChangedRepeatRouterPasswordFieldText = ""
    var simCardValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        primarySimCardField.setTitle(checkSimCard(value: UserDefaults.standard.value(forKey: "simcard_value") as! String), for: .normal)
        simCardValue = (primarySimCardField.titleLabel?.text)!
        
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
        var checkedSimCard = primarySimCardField.titleLabel?.text
        
        if routerPassword == repeatRouterPasswordValue {
            UserDefaults.standard.setValue(routerPassword, forKey: "routernew_password")
            if !(self.simCardValue == checkedSimCard){
                self.performRouterSimSwitchTask(_: checkedSimCard!){ (result) in
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                }
            } else {
            }
                   Ru9xxRouterChangePasswordModel().performRouterPasswordTask(params: [routerPassword!]){ () in

                    self.navigationItem.rightBarButtonItem?.isEnabled = false

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
        primarySimCardField.setTitle(checkSimCard(value: UserDefaults.standard.value(forKey: "simcard_value") as! String), for: .normal)
    }
    
    @IBAction func newPasswordEditChanged(_ sender: UITextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
    }
    
    @IBAction func newPasswordEditingEnd(_ sender: UITextField) {
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
    
        func performRouterSimSwitchTask(_: String, complete: @escaping ()->()){
        
        var simCardValue = self.primarySimCardField.titleLabel?.text
        UserDefaults.standard.setValue(self.checkedSimCardValue(value: simCardValue!), forKey: "simcard_value")
        Rut9xxSimCardSwitchTask().simCardSwitchTask(){ (result) in
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            complete()
                    }
    }
    
    func checkSimCard(value: String)->(String){
        var result = ""
        if value.range(of: "sim") != nil {
            if value.range(of: "1") != nil {
                result = "SIM 1"
            } else {
                result = "SIM 2"
            }
        } else {
            result = "N/A"
        }
        return result
    }
    
    func checkedSimCardValue(value: String)->(String){
        var result = ""
        if value.lowercased().range(of: "sim") != nil {
            if value.range(of: "1") != nil {
                result = "sim1"
            } else {
                result = "sim2"
            }
        }
        return result
    }
}
