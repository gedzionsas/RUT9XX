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
    
    makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: loginrequest, completion: { (json, error) in
      loginCompletion(json, error)
      
    })
    
  }
  
  public func deviceinform(token: String, config: String, section: String, option: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
    
    let deviceinformation = JsonRequests.getInformationFromConfig(token: token, config: config, section: section, option: option)
    makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceinformation, completion: { (json, error) in
      loginCompletion(json)
    })
  }
  
  public func infoAboutFirmware(token: String, param1: String, param2 : String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
    
    let deviceParam = JsonRequests.firmawareInformation(token: token, param1: param1, param2 : param2)
    makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceParam, completion: { (json, error) in
      loginCompletion(json)
    })
  }
  
  public func aboutDevice(token: String, command: String, parameter : String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
    
    let deviceParam = JsonRequests.aboutDeviceParam(token: token, command: command, parameter : parameter)
    makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceParam, completion: { (json, error) in
      loginCompletion(json)
    })
  }
  public func downloadNewFirmware(token: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
    
    let deviceParam = JsonRequests.downloadFirmware(token: token)
    makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceParam, completion: { (json, error) in
      loginCompletion(json)
    })
  }
  
  public func aboutDevice1(token: String, command: String, parameter : String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
    
    let deviceParam = JsonRequests.aboutDeviceParam1(token: token, command: command, parameter : parameter)
    makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceParam, completion: { (json, error) in
      loginCompletion(json)
    })
  }
  
  public func aboutDevice2(token: String, deviceInterface: String, parameter : String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
    
    let deviceParam = JsonRequests.aboutDeviceParam2(token: token, deviceInterface: deviceInterface, parameter: parameter)
    makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceParam, completion: { (json, error) in
      loginCompletion(json)
    })
  }
  
  public func mobileConnectionUptime(token: String, param1: String, param2 : String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
    let uptimeParam = JsonRequests.mobileConnectionUptime(token: token, param1: param1, param2 : param2)
    makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: uptimeParam, completion: { (json, error) in
      loginCompletion(json)
    })
  }
  
  public func fileExec2Comm(token: String, command: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
    
    let deviceParam = JsonRequests.fileExec2Command(token: token, command: command)
    makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceParam, completion: { (json, error) in
      loginCompletion(json)
    })
  }
  public func deviceWirelessDetails(token: String, param1: String, param2: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
    
    let deviceWirelessParam = JsonRequests.requestForWirelessDetails(token: token, param1: param1, param2: param2)
    makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceWirelessParam, completion: { (json, error) in
      loginCompletion(json)
    })
  }
  
  
  private func makeWebServiceCall (urlAddress: String, requestMethod: String, params:[String:Any], completion: @escaping (_ JSONResponse : Any?, _ error: Error?) -> ()) {
//    let manager = Alamofire.SessionManager.default

    
//    manager.session.configuration.timeoutIntervalForRequest = 2
    
    
    var request = URLRequest(url: NSURL.init(string: urlAddress) as! URL)
    request.httpMethod = requestMethod
    request.timeoutInterval = 4
    let postString = params
    request.httpBody = try! JSONSerialization.data(withJSONObject: postString, options: [])
    Alamofire.request(request).responseJSON {
      response in
      
//    }
//    
//    manager.request(urlAddress, method: requestMethod, parameters: params, encoding: JSONEncoding.default).responseJSON{ response in
    
//      print(response.timeline)
 //     print(response.error)
      
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
