//
//  Rut8xxRouterSettings.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 10/08/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit



class Rut8xxRouterSettings: UIViewController, UITextFieldDelegate, PassSleepDelaydataDelegate, PassSleepTriggerdataDelegate {
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
   
    
    func passSleepDelayData(value: String) {
        sleepDelay.setTitle(value, for: .normal)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "sleepDelayId") {
            let destVC: SleepDelayPickerView = segue.destination as! SleepDelayPickerView
            destVC.delegate = self
        } else if (segue.identifier == "sleepTriggerId") {
            let destVC: SleepTriggerPickerView = segue.destination as! SleepTriggerPickerView
            destVC.delegate = self
        }
    }
    
    func passTriggerData(value: String) {
        sleepTrigger.setTitle(value, for: .normal)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if (value.range(of: "Voltage") != nil) {
            self.minimumVoltageLabel.isHidden = false
            self.minimumVoltage.isHidden = false
        } else {
            self.minimumVoltageLabel.isHidden = true
            self.minimumVoltage.isHidden = true
        }    }
    

    @IBAction func newPasswordEdditingEnd(_ sender: Any) {
    }
    @IBAction func edditingEndRepeatPassword(_ sender: Any) {
        if newPasswordTextField.text == "" || reapeatPasswordField.text == "" || !(newPasswordTextField.text == reapeatPasswordField.text) {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    @IBAction func minVoltageEdditingEnd(_ sender: Any) {
        validateMinimumVoltage()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    @IBAction func editingChangedMinVol(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @IBOutlet weak var sleepDelayLabel: UILabel!
    @IBOutlet weak var sleepTriggerLabel: UILabel!
    @IBOutlet weak var minimumVoltageLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var reapeatPasswordField: UITextField!
    @IBOutlet weak var sleepDelay: UIButton!
    @IBOutlet weak var sleepTrigger: UIButton!
    @IBOutlet weak var minimumVoltage: UITextField!
    @IBOutlet weak var switchButton: UISwitch!
    @IBAction func switchTapped(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if (switchButton.isOn == true) {
            switchButton.isOn = false
            sleepDelay.isHidden = true
            sleepTrigger.isHidden = true
            minimumVoltage.isHidden = true
            sleepDelayLabel.isHidden = true
            sleepTriggerLabel.isHidden = true
            minimumVoltageLabel.isHidden = true
        } else {
            switchButton.isOn = true
            sleepDelay.isHidden = false
            sleepDelay.setTitle("5min.", for: .normal)
            sleepTrigger.isHidden = false
            sleepTrigger.setTitle("Ignition & Voltage", for: .normal)
            minimumVoltage.isHidden = false
            minimumVoltage.text = "11.75"
            sleepDelayLabel.isHidden = false
            sleepTriggerLabel.isHidden = false
            minimumVoltageLabel.isHidden = false
        }

    }
    
    
    var switchValue = ""
    override func viewDidLoad() {
        super.viewDidLoad()
     //   edgesForExtendedLayout = []
          displayData()
        
        
        // Do any additional setup after loading the view.
        self.newPasswordTextField.delegate = self
        self.reapeatPasswordField.delegate = self
        self.minimumVoltage.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(onSave))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        
    }

    func displayData() {
        Rut8xxGetIgnitionDetailsModel().routerSettingsModel(){ (result) in
            self.getSwitchValue(value: result[0])
            self.sleepDelay.setTitle(result[2], for: .normal)
            self.sleepTrigger.setTitle(result[3], for: .normal)
            
            if (result[3].range(of: "Voltage") != nil && !(result[0] == "0")) {
                self.minimumVoltageLabel.isHidden = false
                self.minimumVoltage.isHidden = false
                
            } else {
                self.minimumVoltageLabel.isHidden = true
                self.minimumVoltage.isHidden = true
            }
            self.minimumVoltage.text = result[1]
            
        }
        
    }
    
    func onSave() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        var timeValue = sleepDelay.titleLabel?.text
        var value = 0
        
        if (timeValue?.characters.count)! > 6 {
            let index = timeValue?.index((timeValue?.startIndex)!, offsetBy: 2)
            value = Int((timeValue?.substring(to: index!))!)!
        } else {
            let index = timeValue?.index((timeValue?.startIndex)!, offsetBy: 1)
            value = Int((timeValue?.substring(to: index!))!)!
        }
        
        var committingTime = value * 60
        var routerPassword = newPasswordTextField.text
        var repeatRouterPasswordValue = reapeatPasswordField.text
        
        if switchButton.isOn == true {
            switchValue = "1"
        } else {
            switchValue = "0"
        }
        
        var sleepDelayValue = String(committingTime)
        var triggerValue = processTrigger()
        var sleepTriggerValue = String(triggerValue)
        var minVoltageValue = minimumVoltage.text
        
        
        if routerPassword == repeatRouterPasswordValue {
            UserDefaults.standard.setValue(routerPassword, forKey: "routernew_password")
           } else {
            newPasswordTextField.text = ""
            reapeatPasswordField.text = ""
        }
        
            Ru9xxRouterChangePasswordModel().performRouterPasswordTask(params: [routerPassword!, switchValue, sleepDelayValue, sleepTriggerValue, minVoltageValue!]){ () in
                
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.displayData()
            }
        }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func getSwitchValue (value: String){
        if (value != nil && !value.isEmpty) {
            if (value == "0") {
                switchButton.isOn = false
                sleepDelay.isHidden = true
                sleepTrigger.isHidden = true
                minimumVoltage.isHidden = true
                sleepDelayLabel.isHidden = true
                sleepTriggerLabel.isHidden = true
                minimumVoltageLabel.isHidden = true
            } else {
                switchButton.isOn = true
                sleepDelay.isHidden = false
                sleepTrigger.isHidden = false
                minimumVoltage.isHidden = false
                sleepDelayLabel.isHidden = false
                sleepTriggerLabel.isHidden = false
                minimumVoltageLabel.isHidden = false
            }
        } else {
            switchButton.isOn = false
            sleepDelay.isHidden = true
            sleepTrigger.isHidden = true
            minimumVoltage.isHidden = true
            sleepDelayLabel.isHidden = true
            sleepTriggerLabel.isHidden = true
            minimumVoltageLabel.isHidden = true
        }
    }

    func validateMinimumVoltage()->(Bool) {
    var minVoltageValue = minimumVoltage.text
    if (!minVoltageValue!.isEmpty) {
        if let minVoltageDoubleValue = Double(minVoltageValue!) {
    if ((minVoltageDoubleValue < 0.0) || (minVoltageDoubleValue > 51.5)) {
    minimumVoltage.textColor = UIColor.red
   // minimumVoltageErrorMessage.setText("Voltage value must be between 0 and 51");
        
        let alert = UIAlertController(title: "", message: "Voltage value must be between 0 and 51", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    return false
    } else {
    minimumVoltage.textColor = UIColor.init(red: CGFloat(12/255.0), green: CGFloat(87/255.0), blue: CGFloat(168/255.0), alpha: CGFloat(1.0))
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    return true
    }
        }}
    return true
    }
    
    func processTrigger()-> (Int) {
        var result = 0
        if let  triggerValue = sleepTrigger.titleLabel?.text {
        if !(switchButton.isOn == true) {
         result = 0
        } else {
            switch (triggerValue) {
            case "Ignition":
                result = 1
            case "Voltage":
                result = 2
            case "Ignition & Voltage":
                result = 3
            default:
                result = 1
            }
            }}
        return result
        }}
