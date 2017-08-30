//
//  MainWindowWirelessSettingsDataSetController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 25/05/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class MainWindowWirelessSettingsDataSetController: UIViewController {
    
    internal func routerWirelessSetDataModel (params: [dataToShowWirelessSettings], complete: @escaping ()->()){
        
        let token = UserDefaults.standard.value(forKey: "saved_token")
        var encryption = ""
        let wifiName = network().getSSID()
        
        guard wifiName != nil else {
            
            //// TODO: Alert -----
            print("no wifi name")
            
            return
        }
        
        if !(params[0].value == "") {
            if !(wifiName == params[0].value) {
                Json().setWirelessSSID(token: token as! String, value: params[0].value) { (response) in
                    
                    Json().commitConfigsChanges(token: token as! String, config: wireless) { (json) in
                        
                        Json().luciReload(token: token as! String) { (json) in
                            
                        }}
                }}}
        
        if !(params[1].value == "") {
            Json().setConfigInformation(token: token as! String, config:wireless, section: "radio0", configOption: "hwmode", value: self.checkWirelessMode(value: params[1].value)) { (response) in
                
                Json().commitConfigsChanges(token: token as! String, config: wireless) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                    
                }
            }
        }
        if !(params[2].value == "") {
            print(params[2].value)
            Json().setConfigInformation(token: token as! String, config:wireless, section: "radio0", configOption: "channel", value: self.checkWirelessChannel(value: params[2].value)) { (response) in
                
                Json().commitConfigsChanges(token: token as! String, config: wireless) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                    
                }
            }
        }
        if !(params[3].value == "") {
            print(params[3].value)
            
            var encryptionValue = checkWirelessEncryption(stringValue: params[3].value)
            encryption = encryptionValue
            if (params[3].value.range(of: "WPA") != nil) {
                if !(params[4].value == "") {
                    if !(params[4].value == "Auto") {
                        var cipherValue = checkWirelessAuthenticationCipher(value: params[4].value);
                        encryption = encryptionValue + "+" + cipherValue
                    }
                    UserDefaults.standard.set(params[5].value, forKey: "wirelesspassword_value")
                    Json().setWirelessWpaEncryptionPassword(token: token as! String, value: encryption, passwordKey: params[5].value) { (response) in
                    }}} else if (params[3].value.range(of: "WEP") != nil) {
                UserDefaults.standard.set(params[5].value, forKey: "wirelesspassword_value")
                Json().setWirelessWpaEncryptionPassword(token: token as! String, value: encryption, passwordKey: params[5].value) { (response) in
                }} else if (params[3].value.range(of: "encryption") != nil) {
                UserDefaults.standard.set(params[5].value, forKey: "wirelesspassword_value")
                Json().setWirelessWpaEncryptionPassword(token: token as! String, value: encryption, passwordKey: params[5].value) { (response) in
                }}
            
            
            Json().commitConfigsChanges(token: token as! String, config: wireless) { (json) in
            }
            Json().luciReload(token: token as! String) { (json) in
                
                complete()
            }}}
    
    
    
    
    func checkWirelessAuthenticationCipher(value: String)-> (String) {
        var result = ""
        let autoValue = "", ccmpValue = "ccmp", tkipValue = "tkip", tkipCcmpValue = "tkip+ccmp",
        autoResult = "Auto", cmpResult = "Force CCMP (AES)", tkipResult = "Force TKIP",
        tkipCcmpResult = "Force TKIP and CCMP (AES)"
        
        if (value.range(of: autoResult) != nil ) {
            result = autoValue
        } else if ((value.range(of: cmpResult)) != nil) {
            result = ccmpValue
        } else if (value == tkipResult) {
            result = tkipValue
        } else if (value == tkipCcmpResult) {
            result = tkipCcmpValue
        }
        return result
    }
    
    func checkWirelessMode(value: String)-> (String) {
        let none = "", b = "11b", g = "11g", ng = "11ng", auto = "Auto", returnB = "802.11b",
        returnG = "802.11g", returnNG = "802.11g+n";
        var result = ""
        
        if (value == auto) {
            result = none
        } else if (value == returnB) {
            result = b
        } else if (value == returnG) {
            result = g
        } else if (value == returnNG) {
            result = ng
        }
        return result
    }
    
    
    
    func checkWirelessChannel(value: String)-> (String) {
        let auto = "auto", firstValue = "1", secondValue = "2", thirdValue = "3", forthValue = "4",
        fifthValue = "5", sixthValue = "6", seventhValue = "7", eighthValue = "8", ninthValue = "9",
        tenthValue = "10", eleventhValue = "11", autoChannel = "Auto", firstChannel = "1 (2.412 GHz)",
        secondChannel = "2 (2.417 GHz)", thirdChannel = "3 (2.422 GHz)",
        forthChannel = "4 (2.427 GHz)", fifthChannel = "5 (2.432 GHz)",
        sixthChannel = "6 (2.437 GHz)", seventhChannel = "7 (2.442 GHz)",
        eighthChannel = "8 (2.447 GHz)", ninthChannel = "9 (2.452 GHz)",
        tenthChannel = "10 (2.457 GHz)", eleventhChannel = "11 (2.462 GHz)"
        var result = ""
        
        if (value == autoChannel) {
            result = auto
        } else if (value == firstChannel) {
            result = firstValue
        } else if (value == secondChannel) {
            result = secondValue
        } else if (value == thirdChannel) {
            result = thirdValue
        } else if (value == forthChannel) {
            result = forthValue
        } else if (value == fifthChannel) {
            result = fifthValue
        } else if (value == sixthChannel) {
            result = sixthValue
        } else if (value == seventhChannel) {
            result = seventhValue
        } else if (value == eighthChannel) {
            result = eighthValue
        } else if (value == ninthChannel) {
            result = ninthValue
        } else if (value == tenthChannel) {
            result = tenthValue
        } else if (value == eleventhChannel) {
            result = eleventhValue
        }
        return result
    }
    
    func checkWirelessEncryption(stringValue: String)-> (String) {
        let none = "none", wepOpen = "wep-open", wepShared = "wep-shared", psk = "psk", psk2 = "psk2",
        pskMixed = "psk-mixed", noEncryption = "No Encryption", wepOpenSystem = "WEP open system",
        wepSharedKey = "WEP shared key", wpaPsk = "WPA-PSK", wpa2Psk = "WPA2-PSK",
        wpaPskWpa1pskMixedMode = "WPA-PSK/WPA2-PSK mixed mode"
        
        var result = ""
        var value = stringValue.lowercased()
        
        if (value == noEncryption.lowercased()) {
            result = none
        } else if (value == wepOpenSystem.lowercased()) {
            result = wepOpen
        } else if (value == wepSharedKey.lowercased()) {
            result = wepShared
        } else if (value == wpaPsk.lowercased()) {
            result = psk
        } else if (value == wpa2Psk.lowercased()) {
            result = psk2
        } else if (value == wpaPskWpa1pskMixedMode.lowercased()) {
            result = pskMixed
        }
        return result
    }
    
}
