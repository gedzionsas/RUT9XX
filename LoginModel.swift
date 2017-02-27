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

public class LoginModel: UIViewController {
  
  
  var loginToken = ""
  
  internal func jsonResult (param1: String, param2: String, param3: UIViewController, complete:@escaping (Bool)->()){
    
    Json().login(userName: param1, password: param2) { (json, error) in
      print(json)
      print(error)
      
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
          print(jsonDic["result"]["ubus_rpc_session"].stringValue)
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
          
        }
      }
      print(self.loginToken)
      
      if (!self.loginToken.isEmpty) {
        var deviceName = ""
        
        if ((!self.loginToken.contains("[6]")) && (!self.loginToken.contains("Failed"))) {
          
          // Device get name
          Json().aboutDevice(token: self.loginToken, command: "mnf_info", parameter: "name") { (json) in
            MethodsClass().processJsonStdoutOutput(response_data: json){ (newDeviceName) in
              print(newDeviceName)
              if (newDeviceName.characters.count >= 6) {
                let subString = newDeviceName.substring(to: newDeviceName.index(newDeviceName.startIndex, offsetBy: 6))
                deviceName = subString
              } else {
                deviceName = newDeviceName
              }
              UserDefaults.standard.setValue(deviceName, forKey: "device_name")
            }
          }
          
          UserDefaults.standard.setValue(self.loginToken, forKey: "saved_token")
          print(self.loginToken)
          complete(true)
          
          
          
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
  
  
  
  
  internal func jsonDevice (param1: String){
    
    Json().deviceinform(token: (UserDefaults.standard.value(forKey: "saved_token")! as! String), config: "network", section: "ppp", option: "ifname") { (json) in
      
      
      print(UserDefaults.standard.value(forKey: "saved_token"))
      print(json)
    }
  }
  
  internal func jsonDeviceSerial (){
    Json().aboutDevice(token: (UserDefaults.standard.value(forKey: "saved_token")! as! String), command: "mnf_info", parameter: "sn") { (json) in
      MethodsClass().processJsonStdoutOutput(response_data: json){ (deviceserialkey) in
        print(deviceserialkey)
      }
    }}
  
}
