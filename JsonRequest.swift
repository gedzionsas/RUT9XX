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
    print(loginrequest)
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
    
    public func setConfigInformation(token: String, config: String, section: String, configOption: String, value: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        let deviceinformation = JsonRequests.setInformationToConfig(token: token, config: config, section: section, configsOption: configOption, value: value)
        makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceinformation, completion: { (json, error) in
            loginCompletion(json)
        })
    }
    public func setNotRequiredWirelessPassword(token: String, currentWirelessSSID: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        let deviceinformation = JsonRequests.setNotRequiredWirelessPassword(token: token, currentWirelessSSID: currentWirelessSSID)
        makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceinformation, completion: { (json, error) in
            loginCompletion(json)
        })
    }
    public func setWirelessWpaEncryptionPassword2(token: String, value: String,currentWirelessSSID: String, passwordKey: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        let deviceinformation = JsonRequests.setWirelessWpaEncryptionPassword2(token: token, value: value, currentWirelessSSID: currentWirelessSSID, passwordKey: passwordKey)
        makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceinformation, completion: { (json, error) in
            loginCompletion(json)
        })
    }
    public func setWirelessWpaEncryptionPassword(token: String, value: String, passwordKey: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        let deviceinformation = JsonRequests.setWirelessWpaEncryptionPassword(token: token, value: value, passwordKey: passwordKey)
        makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceinformation, completion: { (json, error) in
            loginCompletion(json)
        })
    }
    public func setSimCardApn(token: String, simCardNumber: String, apnValue: String, value: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        let deviceinformation = JsonRequests.setSimCardApn(token: token, simCardNumber: simCardNumber, apnValue: apnValue, value: value)
        makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceinformation, completion: { (json, error) in
            loginCompletion(json)
        })
    }
    public func setWirelessSSID(token: String, value: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        let deviceinformation = JsonRequests.setWirelessSSID(token: token, value: value)
        makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceinformation, completion: { (json, error) in
            loginCompletion(json)
        })
    }
    public func deleteConfigInformation(token: String, config: String, section: String, configOption: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        let deviceinformation = JsonRequests.deleteConfigsOption(token: token, config: config, section: section, configsOption: configOption)
        makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceinformation, completion: { (json, error) in
            loginCompletion(json)
        })
    }
    
    public func commitConfigsChanges(token: String, config: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        
        let deviceinformation = JsonRequests.commitConfigChanges(token: token, config: config)
        makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceinformation, completion: { (json, error) in
            loginCompletion(json)
        })
    }
    public func luciReload(token: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        
        let deviceinformation = JsonRequests.luciReloadAfterChanges(token: token)
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
    print("uzklausom", deviceParam)
    makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceParam, completion: { (json, error) in
      loginCompletion(json)
    })
  }
    public func getOperatorsInformation(token: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        let deviceParam = JsonRequests.getOperatorsInformation(token: token)
        makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceParam, completion: { (json, error) in
            loginCompletion(json)
        })
    }
    public func simPinCheck(token: String, simPin: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        
        let deviceParam = JsonRequests.simPinCheckRequest(token: token, simPin: simPin)
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
  public func updateNewFirmware(token: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
    
    let deviceParam = JsonRequests.updateNewFirmware(token: token)
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
 public func startSpeedTest(token: String, fileValue: Int, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        
        let deviceParam = JsonRequests.startSpeedTest(token: token, fileValue: fileValue)
        makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceParam, completion: { (json, error) in
            loginCompletion(json)
        })
    }
    public func readSpeedTestFile(token: String, fileValue: Int, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        
        let deviceParam = JsonRequests.readSpeedTestFile(token: token, fileValue: fileValue)
        makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceParam, completion: { (json, error) in
            loginCompletion(json)
        })
    }
  public func fileExec2Comm(token: String, command: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
    
    let deviceParam = JsonRequests.fileExec2Command(token: token, command: command)
    makeWebServiceCall(urlAddress: URLREQUEST, requestMethod: "POST", params: deviceParam, completion: { (json, error) in
      loginCompletion(json)
    })
  }
    
    public func setPassword(token: String, password: String, loginCompletion: @escaping (_ JSONResponse : Any?) -> ()) {
        
        let deviceParam = JsonRequests.setRouterPassword(token: token, password: password)
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
 
    
    var request = URLRequest(url: NSURL.init(string: urlAddress) as! URL)
    request.httpMethod = requestMethod
    request.timeoutInterval = 15
    let postString = params
    request.httpBody = try! JSONSerialization.data(withJSONObject: postString, options: [])
    Alamofire.request(request).responseJSON {
      response in

      switch response.result {
      case .success(let value):
        
        let json = JSON(value)
        if let message = json["error"]["message"].string, message == "Access denied" {
          let loginController = LoginController()
          loginController.performLogin(userName: UserDefaults.standard.value(forKey: "saved_username")! as! String, password: UserDefaults.standard.value(forKey: "saved_password")! as! String){ success in
            print("nepasibaige, pasikartojo loginas")
   //         UserDefaults.standard.setValue(, forKey: "saved_token")

          
          }
          print("Access denied+")
        }
        if let jsonData = response.result.value {
          completion(json, nil)
        }
        
        
      case .failure(let error):
        
//        DispatchQueue.main.async {
//        
//        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
//        //...
//        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
//        if let navigationController = rootViewController as? UINavigationController {
//            rootViewController = navigationController.viewControllers.first
//        }
//        if let tabBarController = rootViewController as? UITabBarController {
//            rootViewController = tabBarController.selectedViewController
//        }
//        rootViewController?.present(alertController, animated: true, completion: nil)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let view = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = view
//        }))
//
//        
//        print(error)
//
//        }
        completion(nil, error)
        
      }
      
    }
  }

}
