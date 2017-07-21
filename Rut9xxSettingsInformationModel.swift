//
//  Rut9xxSettingsInformationModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 21/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit
import SwiftyJSON

class Rut9xxSettingsInformationModel: UIViewController {
    
    internal func routerInformationSettingsModel (complete: @escaping ([String])->()){
        let token = UserDefaults.standard.value(forKey: "saved_token")
        let wirelessConfig = "wireless", wirelessSection = "radio0", wirelessMode = "hwmode", channelOption = "channel", encryptionSection = "@wifi-iface[0]", encryptionOption = "encryption", encryptionWepUsingKey = "key"
        
        // Mobile Settings Values
        Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_1, option: APN) { (response) in
            MethodsClass().getJsonValue(response_data: response) { (mobileApn) in
                Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_1, option: PIN_CODE) { (response1) in
                    MethodsClass().getJsonValue(response_data: response1) { (mobileSimPin) in
                        Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_1, option: DIALING_NUMBER) { (response2) in
                            MethodsClass().getJsonValue(response_data: response2) { (simDialingNumber) in
                                Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_1, option: AUTHENTICATION) { (response3) in
                                    MethodsClass().getJsonValue(response_data: response3) { (mobileAuthentication) in
                                        Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_1, option: USERNAME) { (response4) in
                                            MethodsClass().getJsonValue(response_data: response4) { (mobileAuthenticationUsername) in
                                                Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_1, option: PASSWORD) { (response5) in
                                                    MethodsClass().getJsonValue(response_data: response5) { (mobileAuthenticationPassword) in
                                                        Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_1, option: SERVICE) { (response6) in
                                                            MethodsClass().getJsonValue(response_data: response6) { (mobileService) in
                                                                var checkedMobileService = self.checkServiceValue(info: mobileService)
                                                                
                                                                
                                                                Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_2, option: APN) { (response) in
                                                                    MethodsClass().getJsonValue(response_data: response) { (mobileSim2Apn) in
                                                                        Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_2, option: PIN_CODE) { (response1) in
                                                                            MethodsClass().getJsonValue(response_data: response1) { (mobileSim2SimPin) in
                                                                                Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_2, option: DIALING_NUMBER) { (response2) in
                                                                                    MethodsClass().getJsonValue(response_data: response2) { (simDialingSim2Number) in
                                                                                        Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_2, option: AUTHENTICATION) { (response3) in
                                                                                            MethodsClass().getJsonValue(response_data: response3) { (mobileSim2Authentication) in
                                                                                                Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_2, option: USERNAME) { (response4) in
                                                                                                    MethodsClass().getJsonValue(response_data: response4) { (mobileSim2AuthenticationUsername) in
                                                                                                        Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_2, option: PASSWORD) { (response5) in
                                                                                                            MethodsClass().getJsonValue(response_data: response5) { (mobileSim2AuthenticationPassword) in
                                                                                                                Json().deviceinform(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_2, option: SERVICE) { (response6) in
                                                                                                                    MethodsClass().getJsonValue(response_data: response6) { (mobileSim2Service) in
                                                                                                                        var checkedSim2MobileService = self.checkServiceValue(info: mobileSim2Service)
                                                                                                                        
                                                                                                                        // Wireless Settings Values
                                                                                                                        Json().deviceinform(token: token as! String, config: wirelessConfig, section: wirelessSection, option: wirelessMode) { (wifiResponse) in
                                                                                                                            MethodsClass().getJsonValue(response_data: wifiResponse) { (wirelessMode) in
                                                                                                                                let finalWirelessMode = self.checkWirelessMode(value: wirelessMode)
                                                                                                                                Json().deviceinform(token: token as! String, config: wirelessConfig, section: wirelessSection, option: channelOption) { (wifiResponse2) in
                                                                                                                                    MethodsClass().getJsonValue(response_data: wifiResponse2) { (wirelessChannel) in
                                                                                                                                        let finalWirelessChannel = self.checkWirelessChannel(value: wirelessChannel)
                                                                                                                                        Json().deviceinform(token: token as! String, config: wirelessConfig, section: encryptionSection, option: encryptionOption) { (wifiResponse3) in
                                                                                                                                            MethodsClass().getJsonValue(response_data: wifiResponse3) { (wirelessEncryption) in
                                                                                                                                                print("jiba", wifiResponse3)
                                                                                                                                                let finalWirelessEncryption = self.checkWirelessEncryption(value: wirelessEncryption)
                                                                                                                                                let cipherValue = self.getCipherPartFromEncryption(value: wirelessEncryption)
                                                                                                                                                Json().deviceinform(token: token as! String, config: wirelessConfig, section: encryptionSection, option: encryptionWepUsingKey) { (wifiResponse4) in
                                                                                                                                                    MethodsClass().getJsonValue(response_data: wifiResponse4) { (pskAuthenticationKey) in
                                                                                                                                                        let pskAuthenticationCipher = self.checkWirelessAuthenticationCipher(value: cipherValue)
                                                                                                                                                        
                                                                                                                                                        
                                                                                                                                                        var array = [mobileApn, mobileSimPin, simDialingNumber, mobileAuthentication, mobileAuthenticationUsername, mobileAuthenticationPassword, checkedMobileService, wirelessMode, finalWirelessMode, finalWirelessChannel, finalWirelessEncryption, pskAuthenticationCipher, pskAuthenticationKey, mobileSim2Apn, mobileSim2SimPin, simDialingSim2Number, mobileSim2Authentication, mobileSim2AuthenticationUsername, mobileSim2AuthenticationPassword, checkedSim2MobileService]
                                                                                                                                                        
                                                                                                                                                        
                                                                                                                                                        
                                                                                                                                                        
                                                                                                                                                        complete(array)
                                                                                                                                                        
                                                                                                                                                    }}}}}}}}}}}}}}
                                                                                            }}}}}}}}
                                                            }}}}}}}}
                            }}}}}}
        
        
    }
    
    func checkServiceValue (info: String)-> (String){
        var result = ""
        let gprsOnly = "gprs-only", gprs = "gprs", umtsOnly = "umts-only", umts = "umts", lteOnly = "lte-only", lte = "lte", auto = "auto", twoGOnly = "2G only", twoGPreferred = "2G preferred", threeGOnly = "3G only", threeGPreferred = "3G preferred", fourGOnly = "4G (LTE) only", fourGPreferred = "4G (LTE) preferred", automatic = "Automatic"
        
        if info == gprs {
            result = twoGOnly
        } else if (info == gprs){
            result = twoGPreferred
        } else if (info == umtsOnly){
            result = threeGOnly
        } else if (info == umts) {
            result = threeGPreferred
        } else if (info == lteOnly) {
            result = fourGOnly
        } else if (info == lte) {
            result = fourGPreferred
        } else if (info == auto) {
            result = automatic
        }
        return result
    }
    func checkWirelessMode(value: String)-> (String) {
        let none = "", b = "11b", g = "11g", ng = "11ng", auto = "Auto", returnB = "802.11b",
        returnG = "802.11g", returnNG = "802.11g+n"
        var result = ""
        
        if value == none {
            result = auto
        } else if value == b {
            result = returnB
        } else if value == g {
            result = returnG
        } else if value == ng {
            result = returnNG
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
        
        if value == auto {
            result = autoChannel
        } else if value == firstValue {
            result = firstChannel
        } else if value == secondValue {
            result = secondChannel
        } else if value == thirdValue {
            result = thirdChannel
        } else if value == forthValue {
            result = forthChannel
        } else if value == fifthValue {
            result = fifthChannel
        } else if value == sixthValue {
            result = sixthChannel
        } else if value == seventhValue {
            result = seventhChannel
        } else if value == eighthValue {
            result = eighthChannel
        } else if value == ninthValue {
            result = ninthChannel
        } else if value == tenthValue {
            result = tenthChannel
        } else if value == eleventhValue {
            result = eleventhChannel
        }
        return result
    }
    
    func checkWirelessEncryption(value: String)-> (String) {
        let none = "none", wepOpen = "wep-open", wepShared = "wep-shared", psk = "psk", psk2 = "psk2",
        pskMixed = "psk-mixed", paskccmp = "psk+ccmp", noEncryption = "No Encryption", wepOpenSystem = "WEP open system",
        wepSharedKey = "WEP shared key", wpaPsk = "WPA-PSK", wpa2Psk = "WPA2-PSK",
        wpaPskWpa1pskMixedMode = "WPA-PSK/WPA2-PSK mixed mode"
        var result = ""
        if value.range(of: none) != nil {
            result = noEncryption
        } else if value.range(of: wepOpen) != nil {
            result = wepOpenSystem
        } else if value.range(of: wepShared) != nil {
            result = wepSharedKey
        } else if value.range(of: psk) != nil {
            if value == pskMixed {
                result = wpaPskWpa1pskMixedMode
            } else if value == psk2 {
                result = wpa2Psk
            } else if value == psk {
                result = wpaPsk
            } else if value == paskccmp {
                result = wpaPsk
            }
        }
        print("encr", result)
        return result
    }
    private func getCipherPartFromEncryption(value: String)-> (String){
        var result = ""
        
        var array = value.components(separatedBy: "+")
        if array.count > 1 {
            result = array[1].trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            result = ""
        }
        return result
    }
    private func checkWirelessAuthenticationCipher(value: String)-> (String){
        var result = ""
        let ccmpValue = "ccmp", tkipValue = "tkip", tkipCcmpValue = "tkip+ccmp",
        autoResult = "Auto", cmpResult = "Force CCMP (AES)", tkipResult = "Force TKIP",
        tkipCcmpResult = "Force TKIP and CCMP (AES)"
        
        if value.isEmpty {
            result = autoResult
        } else if value.range(of: ccmpValue) != nil {
            result = cmpResult
        } else if (value.range(of: tkipValue) != nil) {
            result = tkipResult
            if (value.range(of: tkipCcmpValue) != nil) {
                result = tkipCcmpResult
            }
        }
        return result
    }
    
    
}
