//
//  WizardFinishModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 26/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class WizardFinishModel: UIViewController {
    
    let rut8 = "RUT8"
    let rut9 = "RUT9"
    
    internal func finishMethod(complete: @escaping ()->()){
        
        
        var deviceName = UserDefaults.standard.value(forKey: "device_name") as? String
        var apn = UserDefaults.standard.value(forKey: "apn_value")
        var authentication = UserDefaults.standard.value(forKey: "mobileauthentication_value")
        var authenticationUsername = UserDefaults.standard.value(forKey: "authentication_username")
        var authenticationPass = UserDefaults.standard.value(forKey: "authentication_password")
        var roamingValue = UserDefaults.standard.value(forKey: "roaming_value")
        var wirelessSsid = UserDefaults.standard.value(forKey: "wifi_ssid")
        var wirelessPassw = UserDefaults.standard.value(forKey: "wirelesspassword_value")
        var routerPassword = UserDefaults.standard.value(forKey: "routernew_password") as? String
        
        if deviceName?.range(of: rut8) != nil {
            performWizardMobileSettingsTask()
        } else if deviceName?.range(of: rut9) != nil {
            performWizardRut9xxMobileSettingsTask()
        }
        WizardWirelessSettingsModel().WizardWirelessSettingsMethod(wirelessSsid: wirelessSsid as! String, wirelessPassword: wirelessPassw as! String) { (result) in
            
        }
        if routerPassword != nil && !(routerPassword?.isEmpty)! {
            
            ChangeRouterPasswordMethod().ChangeRouterPassword(routerPassword: routerPassword as! String) { (result) in
                let token = UserDefaults.standard.value(forKey: "saved_token")
                Json().luciReload(token: token as! String) { (json) in
                    
                    complete()
                }
            }
        } else {
            complete()
        }
        
        
    }
    
    func performWizardMobileSettingsTask() {
        WizardMobileSettingsModel().WizardRutMobileSettingsMethod() { (result) in
            
        }
    }
    
    func performWizardRut9xxMobileSettingsTask() {
        WizardRut9xxMobileSettingsModel().WizardRut9xxMobileSettingsMethod() { (result) in
            
        }
    }
}
