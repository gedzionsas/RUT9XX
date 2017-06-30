//
//  RouterPasswordController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 26/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

class RouterPasswordController: UIViewController, UITextFieldDelegate {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    
    
    @IBAction func finishAction(_ sender: Any) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        WizardFinishModel().finishMethod() { (result) in
            self.dismiss(animated: true, completion: nil)
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainVC")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
        }
        
    }
    @IBAction func skipAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainVC")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var routerPassword: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var repeatPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routerPassword.delegate = self
        repeatPassword.delegate = self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func routerPasswordEdittingEnd(_ sender: Any) {
    }
    @IBAction func repeatPswEditingEnd(_ sender: Any) {
        
        if !(routerPassword.text?.isEmpty)! && !(repeatPassword.text?.isEmpty)! {
            if routerPassword.text == repeatPassword.text {
                UserDefaults.standard.setValue(repeatPassword.text, forKey: "routernew_password")
            }
        } else {
            UserDefaults.standard.setValue("", forKey: "routernew_password")

            }
        }
        
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        routerPassword.resignFirstResponder()
        repeatPassword.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        routerPassword.resignFirstResponder()
        repeatPassword.resignFirstResponder()
        return true
    }
}
