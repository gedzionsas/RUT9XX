//
//  Rut9xxRouterSettings.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 06/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Rut9xxRouterSettings: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var reapeatPasswordField: UITextField!
    @IBOutlet weak var primarySimCardField: UIButton!
    
    var roundButton = UIButton()
    
    var notChangedRouterPasswordFieldText = ""
    var notChangedRepeatRouterPasswordFieldText = ""
    var simCardValue = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        primarySimCardField.setTitle(checkSimCard(value: UserDefaults.standard.value(forKey: "simcard_value") as! String), for: .normal)
        simCardValue = (primarySimCardField.titleLabel?.text)!
        
        // Do any additional setup after loading the view.
        self.roundButton = UIButton(type: .custom)
        self.roundButton.setTitleColor(UIColor.orange, for: .normal)
        self.roundButton.addTarget(self, action: #selector(saveButtonAction(_:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(roundButton)
        roundButton.isHidden = true
        
        self.newPasswordTextField.delegate = self
        self.reapeatPasswordField.delegate = self
    }
    @IBAction func newPasswordEditChanged(_ sender: UITextField) {
       roundButton.isHidden = false
    }
    
    @IBAction func newPasswordEditingEnd(_ sender: UITextField) {
        if newPasswordTextField.text == "" || reapeatPasswordField.text == "" {
            roundButton.isHidden = true
        } else {
         notChangedRouterPasswordFieldText = newPasswordTextField.text!
        }
    }
    @IBAction func repeatPasswordEditChanged(_ sender: Any) {
        roundButton.isHidden = false
    }

    @IBAction func repeatPasswordEdittingEnd(_ sender: Any) {
        if newPasswordTextField.text == "" || reapeatPasswordField.text == "" {
            roundButton.isHidden = true
        } else {
            notChangedRepeatRouterPasswordFieldText = reapeatPasswordField.text!
        }
    }
    override func viewWillLayoutSubviews() {
        
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.backgroundColor = UIColor.init(red: 44.0/255.0, green: 93.0/255.0, blue: 154.0/255.0, alpha: 1.0)
        roundButton.clipsToBounds = true
        roundButton.setImage(UIImage(named:"user"), for: .normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roundButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -3),
            roundButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -53),
            roundButton.widthAnchor.constraint(equalToConstant: 60),
            roundButton.heightAnchor.constraint(equalToConstant: 60)])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
    
        var routerPassword = newPasswordTextField.text
        var repeatRouterPasswordValue = reapeatPasswordField.text
        var checkedSimCard = primarySimCardField.titleLabel?.text
        print(routerPassword, repeatRouterPasswordValue, checkedSimCard)
        
        if routerPassword == repeatRouterPasswordValue {
            UserDefaults.standard.setValue(routerPassword, forKey: "routernew_password")
            Ru9xxRouterChangePasswordModel().performRouterPasswordTask(params: [routerPassword!]){ () in
                
            }
        } else {
            let alert = UIAlertController(title: "", message: "Password do not match!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)})
            newPasswordTextField.text = ""
            reapeatPasswordField.text = ""
        }
        
        if !(simCardValue == checkedSimCard){
           print(simCardValue, checkedSimCard)
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
//    func performRouterSimSwitchTask(primarySimCardValue){
//        
//        
//        
//        
//    }

    
    
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
}
