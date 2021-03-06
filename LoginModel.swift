//
//  LoginModel.swift
//  bandymasAlam
//
//  Created by Gedas Urbonas on 03/02/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SystemConfiguration.CaptiveNetwork

public class LoginModel: UIViewController {
  
  
  var loginToken = ""
  let inOutString = "in_out"
  let hwinfoConfig = "hwinfo"
  let rut2_String = "RUT2"
  let rut8_String = "RUT8"
  let rut9_String = "RUT9"

    
  
  internal func jsonResult (param1: String, param2: String, param3: UIViewController, complete:@escaping (Bool)->()){
    
   var loginTokenForE = ""
    Json().login(userName: param1, password: param2) { (json, error) in
      if error != nil {
        //Show alert
        print(error!.localizedDescription)
        DispatchQueue.main.async {
          AlertController.showErrorWith(title: "Error", message: error!.localizedDescription, controller: param3) {
            complete(false)
          }
        }
        
        //  self.loginToken = "Failed"
      }
      
      //Access JSON here
      
      if let jsonDic = json as? JSON {
        
        if (jsonDic["result"].exists()){
          if (jsonDic["result"].arrayValue.contains(6)) {
            self.loginToken = "[6]"
          } else {
            for item in jsonDic["result"].arrayValue {
              self.loginToken = item["ubus_rpc_session"].stringValue
            }
          }
        }
        if (jsonDic["error"].exists()){
          
          self.loginToken = jsonDic["error"]["message"].stringValue
          complete(false)
        }
      }
      
      if (!self.loginToken.isEmpty) {
        var deviceName = ""
        
        if ((!self.loginToken.contains("[6]")) && (!self.loginToken.contains("Failed"))) {
          
          UserDefaults.standard.setValue(self.loginToken, forKey: "saved_token")
          loginTokenForE = UserDefaults.standard.value(forKey: "saved_token") as! String
          // Device get name call
          Json().aboutDevice(token: self.loginToken, command: "mnf_info", parameter: "name") { (json) in
            MethodsClass().processJsonStdoutOutput(response_data: json){ (newDeviceName) in
                
              if (newDeviceName.characters.count >= 6) {
                let subString = newDeviceName.substring(to: newDeviceName.index(newDeviceName.startIndex, offsetBy: 6))
                deviceName = subString
              } else {
                deviceName = newDeviceName
              }
              UserDefaults.standard.setValue(deviceName, forKey: "device_name")
              UserDefaults.standard.synchronize()
            
            Json().fileExec2Comm(token: loginTokenForE, command: "sim_switch sim") { (json) in
                MethodsClass().processJsonStdoutOutput(response_data: json){ (simCardValue) in
                    UserDefaults.standard.setValue(simCardValue, forKey: "simcard_value")

                
                Json().infoAboutFirmware(token: loginTokenForE, param1: "read", param2: "/etc/version"){ (json) in
            MethodsClass().parseFirmwareInformation(response_data: json){ (firmwareNumber) in
              UserDefaults.standard.setValue(firmwareNumber.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "devicefirmware_number")
            Json().deviceinform(token: loginTokenForE, config: self.hwinfoConfig, section: self.hwinfoConfig, option: self.inOutString) { (response1) in
                MethodsClass().getJsonValue(response_data: response1) { (inputOutputValue) in
                    UserDefaults.standard.setValue(inputOutputValue, forKey: "inputoutput_value")
            self.getWIFIInformation()
                    let wifiName = network().getSSID()
                    
                    guard wifiName != nil else {
                        
                        //// TODO: Alert -----
                        print("no wifi name")
                        
                        return
                    }
                    UserDefaults.standard.setValue(wifiName, forKey: "wifi_ssid")
          Json().aboutDevice(token: loginTokenForE, command: "mnf_info", parameter: "sn") { (json) in
            MethodsClass().processJsonStdoutOutput(response_data: json){ (deviceSerialNumber) in
              UserDefaults.standard.setValue(deviceSerialNumber.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "deviceserial_number")
          Json().aboutDevice(token: loginTokenForE, command: "gsmctl", parameter: "-i") { (json) in
            MethodsClass().processJsonStdoutOutput(response_data: json){ (deviceImeiNumber) in
                UserDefaults.standard.setValue(deviceImeiNumber.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "deviceimei_number")
            Json().aboutDevice(token: loginTokenForE, command: "mnf_info", parameter: "mac") { (json) in
                MethodsClass().processJsonStdoutOutput(response_data: json){ (deviceLanMacNumber) in
                    UserDefaults.standard.setValue(deviceLanMacNumber.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "devicelanmac_number")
            Json().deviceinform(token: loginTokenForE, config: SIM_CARD_CONFIG, section: SIM_CARD_1, option: AUTHENTICATION) { (response3) in
                MethodsClass().getJsonValue(response_data: response3) { (mobileAuthentication) in
                UserDefaults.standard.setValue(self.parseAuthenticationValue(value: mobileAuthentication).trimmingCharacters(in: .whitespacesAndNewlines), forKey: "mobileauthentication_value")
            Json().deviceinform(token: loginTokenForE, config: SIM_CARD_CONFIG, section: SIM_CARD_1, option: APN) { (response) in
                MethodsClass().getJsonValue(response_data: response) { (mobileApn) in
                    UserDefaults.standard.setValue(mobileApn, forKey: "registrationapn_value")
            Json().getOperatorsInformation(token: loginTokenForE) { (response1) in
                MethodsClass().processJsonStdoutOutput(response_data: response1){ (operators) in
                    UserDefaults.standard.setValue(operators, forKey: "operators_value")
            
            Json().deviceinform(token: loginTokenForE, config: "wireless", section: "@wifi-iface[0]", option: "key") { (responseKey) in
                MethodsClass().getJsonValue(response_data: responseKey) { (wirelessPsk) in
                    UserDefaults.standard.setValue(wirelessPsk, forKey: "wirelesspassword_value")
                    complete(true)
                }}}}}}}}}}}
                }}}}}}}}}
                }}

        }else {
          if (self.loginToken.contains("Access denied")) {
            self.loginToken = "Access denied"
            complete(false)
            print(self.loginToken)
          } else if (self.loginToken.contains("Failed")) {
            self.loginToken = "Connection timeout"
            complete(false)
          } else if (self.loginToken.contains("[6]")) {
            DispatchQueue.main.async {
              AlertController.showErrorWith(title: "Error", message: "Wrong username or password", controller: param3) {
                
              }
              complete(false)
            }
            self.loginToken = "Login Error"
            print(self.loginToken)
          }
        }
      }
      self.loginToken = ""
    }
    
    
  }
  
    func parseAuthenticationValue (value: String) -> (String) {
        let noneValue = "none"
        let chapValue = "chap"
        let papValue = "pap"
        var result = ""
        var authenticationValue = ""
        
        if !value.isEmpty {
            if (value.range(of: noneValue) != nil) {
                authenticationValue = "None"
            } else if ((value.range(of: chapValue)) != nil){
                authenticationValue = value.uppercased()
            } else if (value.range(of: papValue) != nil) {
                authenticationValue = value.uppercased()
            }
            result = authenticationValue
        }
        if result.isEmpty {
            result = "No data"
        }
        return result
    }
    
    func getWIFIInformation() -> [String:String]{
        var informationDictionary = [String:String]()
        let informationArray:NSArray? = CNCopySupportedInterfaces()
        if let information = informationArray {
            let dict:NSDictionary? = CNCopyCurrentNetworkInfo(information[0] as! CFString)
            if let temp = dict {
                informationDictionary["SSID"] = String(describing: temp["SSID"]!)
                informationDictionary["BSSID"] = String(describing: temp["BSSID"]!)
                MAC_ADDRESS = String(describing: temp["BSSID"]!)
                return informationDictionary
            }
        }
        
        return informationDictionary
    }
    
}
