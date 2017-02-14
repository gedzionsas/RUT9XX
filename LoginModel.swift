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
    
    internal func JsonResult (param1: String, param2: String, param3: UIViewController){
    
    Json().login(userName: param1, password: param2) { (json, error) in
        print(json)
        print(error)
        
        if error != nil {
            //Show alert
            print(error!.localizedDescription)
            DispatchQueue.main.async {
                AlertController.showErrorWith(title: "Error", message: error!.localizedDescription, controller: param3) {
                    
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
            
         if ((!self.loginToken.contains("[6]")) && (!self.loginToken.contains("Failed"))) {
            
            UserDefaults.standard.setValue(self.loginToken, forKey: "saved_token")
                   print(self.loginToken)
            
        }else {
            if (self.loginToken.contains("Access denied")) {
                self.loginToken = "Access denied"
                print(self.loginToken)
            } else if (self.loginToken.contains("Failed")) {
                self.loginToken = "Connection timeout"
            } else if (self.loginToken.contains("[6]")) {
                self.loginToken = "Login Error"
                print(self.loginToken)
            }
        
        
        }
        }
        self.loginToken = ""
    }
        
    self.JsonDevice(param1: (UserDefaults.standard.value(forKey: "saved_token")! as! String))
 
    }
 
    
    
    
 internal func JsonDevice (param1: String){

    Json().device(token: param1) { (json) in
        print(UserDefaults.standard.value(forKey: "saved_token"))
        print(json)
    }
    }
    
    
    
}
