//
//  WizardWirelessSettingsModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 26/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class WizardWirelessSettingsModel: UIViewController {
    
    internal func WizardWirelessSettingsMethod(wirelessSsid: String, wirelessPassword: String, complete: @escaping ()->()){
        
        let token = UserDefaults.standard.value(forKey: "saved_token")
        let encryption = "psk2"
        var wifiName = ""
        
        
        wifiName = network().getSSID()!
        
        guard wifiName != nil else {
            
            //// TODO: Alert -----
            print("no wifi name")
            
            return
        }

        if wirelessSsid != nil && !wirelessSsid.isEmpty {
            Json().setWirelessSSID(token: token as! String, value: wirelessSsid) { (response) in
                Json().commitConfigsChanges(token: token as! String, config: wireless) { (json) in
                }
            }
        }
        
        if wirelessPassword != nil && !wirelessPassword.isEmpty {
            Json().setWirelessWpaEncryptionPassword2(token: token as! String, value: encryption, currentWirelessSSID: wifiName, passwordKey: wirelessPassword) { (response1) in
                print("asdasd", response1)
            }
        } else {
            Json().setNotRequiredWirelessPassword(token: token as! String, currentWirelessSSID: wifiName) { (response2) in
            }
        }
        Json().commitConfigsChanges(token: token as! String, config: wireless) { (json) in
            
            complete()
        }
}
}
