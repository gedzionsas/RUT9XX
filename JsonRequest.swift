//
//  JsonRequest.swift
//  bandymasAlam
//
//  Created by Gedas Urbonas on 16/01/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON



class Json {
var loginToken = ""

    
    public func login(userName: String, password: String, loginCompletion: @escaping (_ JSONResponse : Any?, _ error: Error?) -> ()) {

        
        let loginrequest = JsonRequests.loginRequest(userName: userName, password: password)
        
        makeWebServiceCall(urlAddress: URL, requestMethod: .post, params: loginrequest, completion: { (json, error) in
            loginCompletion(json, error)
            
        })
        
    }
        
    public func device(token: String, loginCompletion: @escaping (_ JSONResponse : Any?, _ error: Error?) -> ()) {
        
        let deviceinfo = JsonRequests.getInformationFromConfig(token: token, config: "wireless", section: "@wifi-iface[0]", option: "mode")
        makeWebServiceCall(urlAddress: URL, requestMethod: .post, params: deviceinfo, completion: { (json, error) in
            loginCompletion(json, error)
        })
    }
    
    public func deviceSerial(token: String, command: String, parameter : String, loginCompletion: @escaping (_ JSONResponse : Any?, _ error: Error?) -> ()) {
        
        let deviceSerialNumber = JsonRequests.deviceSerialNumber(token: token, command: command, parameter : parameter)
        makeWebServiceCall(urlAddress: URL, requestMethod: .post, params: deviceSerialNumber, completion: { (json, error) in
            loginCompletion(json, error)
        })
    }
    
    let manager = Alamofire.SessionManager.default
    
    private func makeWebServiceCall (urlAddress: String, requestMethod: HTTPMethod, params:[String:Any], completion: @escaping (_ JSONResponse : Any?, _ error: Error?) -> ()) {
        
        
        manager.session.configuration.timeoutIntervalForRequest = 5
        
        
        manager.request(urlAddress, method: requestMethod, parameters: params, encoding: JSONEncoding.default).responseJSON{ response in
            
            print(response.timeline)
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                if let message = json["error"]["message"].string, message == "Access denied" {
                    let loginController = LoginController()
                    loginController.performLogin(userName: UserDefaults.standard.value(forKey: "saved_username")! as! String, password: UserDefaults.standard.value(forKey: "saved_password")! as! String){ success in
                        
                        
                    }
                    print("Access denied+")
                }
                if let jsonData = response.result.value {
                    completion(json, nil)
                }
                
                
            case .failure(let error):

                    completion(nil, error)
                    
          
        
    }
    
}
}
}
