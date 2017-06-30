//
//  SimPinController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 15/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

protocol PassNextdataDelegate {
    
    func passNextPageData()
}

class SimPinController: UIViewController {
    let token = UserDefaults.standard.value(forKey: "saved_token")
    let simPinText = "SIM PIN Required"
    var delegate: PassNextdataDelegate?


    @IBAction func skipButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainVC")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    @IBAction func nextButton(_ sender: Any) {
        pinField.resignFirstResponder()
        SimPinModel().simPinMethod(simPin: pinField.text!){ (result) in
            if result.range(of: "ERROR") != nil {
                self.statement.text = "Wrong SIM PIN Number"
                if self.delegate != nil {
                    self.delegate?.passNextPageData()
                }
            } else if result.range(of: "OK") != nil {
                if self.delegate != nil {
                    self.delegate?.passNextPageData()
                }
            } else if result.range(of: "not inserted") != nil {
                self.statement.text = self.simPinText

            }
        
        }}
    @IBAction func pinFieldEddited(_ sender: Any) {
        
        if (pinField.text?.characters.count)! == 4 || (pinField.text?.characters.count)! > 4 {
            
        print(pinField.text)
        } else {
            
        }
        
    }
    @IBOutlet weak var statement: UILabel!
    @IBOutlet weak var pinField: UITextField!
    @IBOutlet weak var suggestion: UILabel!
    @IBOutlet weak var suggestionField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myColor : UIColor = UIColor.white
        pinField.layer.borderColor = myColor.cgColor
        pinField.layer.borderWidth = 1.0

        
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.isTranslucent = true
        // Do any additional setup after loading the view.
        performSimCardCheckTask()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        self.view.endEditing(true)

    }
    
    @IBAction func simpinStaetedEditing(_ sender: Any) {
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  
    
    func performSimCardCheckTask () {
        Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: "-u") { (json) in
            MethodsClass().processJsonStdoutOutput(response_data: json){ (checkIfSimPinIsEntered) in
                print(checkIfSimPinIsEntered)
                Json().aboutDevice(token: self.token as! String, command: "gsmctl", parameter: "-z") { (json1) in
                    MethodsClass().processJsonStdoutOutput(response_data: json1){ (simCardStateResult) in
                        print(simCardStateResult)
                    }}}}
    }
    
}
