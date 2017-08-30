//
//  WizardMobileSettingsModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 16/08/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class WizardMobileSettingsModel: UIViewController {
    
    internal func WizardRutMobileSettingsMethod(complete: @escaping ()->()){
        
        
        let deviceName = UserDefaults.standard.value(forKey: "device_name") as? String
        let apnValue = (UserDefaults.standard.value(forKey: "apn_value") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        let authenticationValue = UserDefaults.standard.value(forKey: "mobileauthentication_value")
        let authenticationUsernameValue = (UserDefaults.standard.value(forKey: "authentication_username") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        let authenticationPasswordValue = (UserDefaults.standard.value(forKey: "authentication_password") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        let roamingValue = UserDefaults.standard.value(forKey: "roaming_value")
        
        let token = UserDefaults.standard.value(forKey: "saved_token")
        let apnOption = "apn"
        let none = "none"
     
        if (apnValue != nil) {

            Json().setConfigInformation(token: token as! String, config:NETWORK, section: PPP, configOption: APN, value: apnValue as! String) { (response) in
                print("apn koks", response, apnValue)
            }
        } else {
            Json().deleteConfigInformation(token: token as! String, config: NETWORK, section: PPP, configOption: apnOption) { (response2) in
            }
        }

        if (authenticationValue != nil) {
            Json().setConfigInformation(token: token as! String, config:NETWORK, section: PPP, configOption: AUTHENTICATION, value: authenticationValue as! String) { (response) in
            }
            if !(authenticationValue as! String == none) {
                if (authenticationUsernameValue != nil) {
                    Json().setConfigInformation(token: token as! String, config:NETWORK, section: PPP, configOption: USERNAME, value: authenticationUsernameValue as! String) { (response) in
                    }
                }
                if (authenticationPasswordValue != nil) {
                    Json().setConfigInformation(token: token as! String, config:NETWORK, section: PPP, configOption: PASSWORD, value: authenticationPasswordValue as! String) { (response) in
                    }
                }
            }
        }
        
        if (roamingValue != nil) {
            Json().setConfigInformation(token: token as! String, config:NETWORK, section: PPP, configOption: ROAMING, value: roamingValue as! String) { (response) in
            }
        }
        Json().commitConfigsChanges(token: token as! String, config: NETWORK) { (json) in
            
            Json().luciReload(token: token as! String) { (json) in
                
                complete()
            }}

    }}
