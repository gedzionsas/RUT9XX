//
//  WirelessWizardController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 23/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


protocol PassNextdataDelegate3 {
    
    func passNextPageData3()
}

class WirelessWizardController: UIViewController, UITextFieldDelegate {
    
    
    var delegate: PassNextdataDelegate3?
    
    let token = UserDefaults.standard.value(forKey: "saved_token")
    
    var wirelessencryptionValue = ""
    var wirelessencryption = ""
    let noEnc = "No Encryption"
    let none = "none"
    var wifiName = ""
    @IBAction func skipTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainVC")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if self.delegate != nil {
            self.delegate?.passNextPageData3()
        }
    }
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var wirelessPassword: UITextField!
    @IBOutlet weak var repeatWirelesslabel: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var wirelessLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var wirelessName: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wirelessPassword.delegate = self
        repeatPassword.delegate = self
        wirelessName.delegate = self
        
        
        
        Json().deviceinform(token: token as! String, config: "wireless", section: "@wifi-iface[0]", option: "encryption") { (responseEnc) in
            MethodsClass().getJsonValue(response_data: responseEnc) { (encValue) in
                UserDefaults.standard.set(encValue, forKey: "wirelessencryption_value")
                
            }}
        
        
        if UserDefaults.standard.value(forKey: "wirelessencryption_value") != nil {
            wirelessencryptionValue = UserDefaults.standard.value(forKey: "wirelessencryption_value") as! String
        }
        if !wirelessencryptionValue.isEmpty {
            wirelessencryption = checkWirelessEncryption(value: wirelessencryptionValue)
        }
        
        if !(wirelessencryption == noEnc) && !(wirelessencryption == none) {
            var password = UserDefaults.standard.value(forKey: "wirelesspassword_value")
            switchButton.isOn = true
            suggestionLabel.isHidden = true
            message.isHidden = true
            wirelessPassword.text = password as! String
            repeatPassword.text = password as! String
        } else {
            switchButton.isOn = false
            suggestionLabel.isHidden = false
            message.isHidden = false
            wirelessPassword.isHidden = true
            repeatPassword.isHidden = true
            view1.isHidden = true
            view2.isHidden = true
            repeatWirelesslabel.isHidden = true
            wirelessLabel.isHidden = true
            UserDefaults.standard.set("", forKey: "wirelesspassword_value")
        }
        
        wifiName = network().getSSID()!
        
        guard wifiName != nil else {
            
            //// TODO: Alert -----
            print("no wifi name")
            
            return
        }
        wirelessName.text = wifiName
        
    }
    
    @IBAction func wirelessNameEdditinEnd(_ sender: Any) {
        if !(wirelessName.text == wifiName) {
            UserDefaults.standard.set(wirelessName.text, forKey: "wifi_ssid")
        }
    }
    @IBAction func wirelessPswEditingEnded(_ sender: Any) {
        
    }
    @IBAction func wirelessRepeatEditingEnd(_ sender: Any) {
        if wirelessPassword.text == repeatPassword.text {
            wirelessPassword.textColor = UIColor.black
            repeatPassword.textColor = UIColor.black
            UserDefaults.standard.set(repeatPassword.text, forKey: "wirelesspassword_value")
        } else {
            wirelessPassword.textColor = UIColor.red
            repeatPassword.textColor = UIColor.red
        }
    }
    
    
    
    @IBAction func switchTapped(_ sender: Any) {
        if switchButton.isOn {
            suggestionLabel.isHidden = true
            message.isHidden = true
            wirelessPassword.isHidden = false
            repeatPassword.isHidden = false
            view1.isHidden = false
            view2.isHidden = false
            repeatWirelesslabel.isHidden = false
            wirelessLabel.isHidden = false
        } else {
            suggestionLabel.isHidden = false
            message.isHidden = false
            wirelessPassword.isHidden = true
            repeatPassword.isHidden = true
            view1.isHidden = true
            view2.isHidden = true
            repeatWirelesslabel.isHidden = true
            wirelessLabel.isHidden = true
            UserDefaults.standard.set("", forKey: "wirelesspassword_value")
            
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        wirelessName.resignFirstResponder()
        wirelessPassword.resignFirstResponder()
        repeatPassword.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        wirelessName.resignFirstResponder()
        wirelessPassword.resignFirstResponder()
        repeatPassword.resignFirstResponder()
        return true
    }
    
    func checkWirelessEncryption(value: String)-> (String) {
        
        let none = "none", wepOpen = "wep-open", wepShared = "wep-shared", psk = "psk", psk2 = "psk2",
        pskMixed = "psk-mixed", noEncryption = "No Encryption", wepOpenSystem = "WEP open system",
        wepSharedKey = "WEP shared key", wpaPsk = "WPA-PSK", wpa2Psk = "WPA2-PSK",
        wpaPskWpa1pskMixedMode = "WPA-PSK/WPA2-PSK mixed mode"
        
        var result = ""
        if (value.range(of: none) != nil) {
            result = noEncryption
        } else if ((value.range(of: wepOpen)) != nil) {
            result = wepOpenSystem
        } else if ((value.range(of: wepShared)) != nil) {
            result = wepSharedKey
        } else if ((value.range(of: psk)) != nil) {
            if ((value.range(of: pskMixed)) != nil) {
                result = wpaPskWpa1pskMixedMode
            } else if ((value.range(of: psk2)) != nil) {
                result = wpa2Psk
            } else if ((value.range(of: psk)) != nil) {
                result = wpaPsk
            }
        }
        return result
    }
}


