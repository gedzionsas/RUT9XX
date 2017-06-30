//
//  WizardRut9xxMobileSettingsModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 26/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class WizardRut9xxMobileSettingsModel: UIViewController {

    internal func WizardRut9xxMobileSettingsMethod(complete: @escaping ()->()){
        
        
        let deviceName = UserDefaults.standard.value(forKey: "device_name") as? String
        let apnValue = UserDefaults.standard.value(forKey: "apn_value")
        let authenticationValue = UserDefaults.standard.value(forKey: "mobileauthentication_value")
        let authenticationUsernameValue = UserDefaults.standard.value(forKey: "authentication_username")
        let authenticationPasswordValue = UserDefaults.standard.value(forKey: "authentication_password")
        let roamingValue = UserDefaults.standard.value(forKey: "roaming_value")

    let token = UserDefaults.standard.value(forKey: "saved_token")
    let apnOption = "apn"
    let none = "none"
    let simCardNumber = (UserDefaults.standard.value(forKey: "simcard_value") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if (apnValue != nil) {
    Json().setSimCardApn(token: token as! String, simCardNumber: simCardNumber!, apnValue: apnValue as! String, value: "apn") { (response1) in
        }
    } else {
    Json().deleteConfigInformation(token: token as! String, config: SIM_CARD_CONFIG, section: simCardNumber!, configOption: apnOption) { (response2) in
        }
    }
    
    if (authenticationValue != nil) {
        Json().setSimCardApn(token: token as! String, simCardNumber: simCardNumber!, apnValue: (authenticationValue as! String).lowercased(), value: "auth_mode") { (response3) in
        }
        if !(authenticationValue as! String == none) {
    if (authenticationUsernameValue != nil) {
        Json().setSimCardApn(token: token as! String, simCardNumber: simCardNumber!, apnValue: (authenticationUsernameValue as! String).lowercased(), value: "username") { (response4) in
        }
            }
    if (authenticationPasswordValue != nil) {
        Json().setSimCardApn(token: token as! String, simCardNumber: simCardNumber!, apnValue: (authenticationPasswordValue as! String).lowercased(), value: "password") { (response5) in
        }
    }
    }
    }
    if (roamingValue != nil) {
        Json().setSimCardApn(token: token as! String, simCardNumber: simCardNumber!, apnValue: (roamingValue as! String).lowercased(), value: "roaming") { (response6) in
        }
    }
        Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
        
        Json().luciReload(token: token as! String) { (json) in
            
            complete()
            }}

}
}
