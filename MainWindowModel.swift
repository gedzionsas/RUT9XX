//
//  MainWindowModel.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 23/02/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit


public class MainWindowModel: UIViewController {
  
  internal func mainTasks (param1: String){
    let token = UserDefaults.standard.value(forKey: "saved_token")
    let GSM_3G_CONNECTION_STATE = "-j"
    
    
// Mobile data, Mobile web services calss
    Json().deviceinform(token: token as! String, config: "network", section: "ppp", option: "ifname") { (json) in
      
      MethodsClass().getJsonValue(response_data: json){ (devicesInterface) in
        
        UserDefaults.standard.setValue(devicesInterface, forKey: "device_interface")
        print("tai", UserDefaults.standard.value(forKey: "device_interface"))
      }}
    var deviceName = UserDefaults.standard.value(forKey: "device_name") as! String
    print(deviceName)
    // if device is RUT9XX, found simcard inserted or not
//    if ((deviceName.range(of:"RUT9")) != nil) {
      Json().fileExec2Comm(token: token as! String, command: "sim_switch sim") { (json) in
        MethodsClass().processJsonStdoutOutput(response_data: json){ (simCardValue) in
          UserDefaults.standard.setValue(simCardValue, forKey: "simcard_value")
          print(UserDefaults.standard.value(forKey: "simcard_value"))
          Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: "-z") { (json) in
            MethodsClass().processJsonStdoutOutput(response_data: json){ (simCardStateResult) in
              UserDefaults.standard.setValue(simCardStateResult, forKey: "simcard_state")
              print("taip", UserDefaults.standard.value(forKey: "simcard_state"))
            }}
        }
      }
//    }
    var pForGsmData = "-p"
    pForGsmData.append((UserDefaults.standard.value(forKey: "device_interface") as! String))
    var param = ["-q", "-o", "-t", pForGsmData]
    let parametersForGsmData = param.joined(separator: " ")
    Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: parametersForGsmData ) { (json) in
      MethodsClass().processJsonStdoutOutput(response_data: json){ (processedGsmData) in
        UserDefaults.standard.setValue(processedGsmData, forKey: "processedgsm_data")
        print(UserDefaults.standard.value(forKey: "processedgsm_data"))
        
      }
    }
    var rForGsmData = "-r"
    var eForGsmData = "-e"
    rForGsmData.append((UserDefaults.standard.value(forKey: "device_interface") as! String))
    eForGsmData.append((UserDefaults.standard.value(forKey: "device_interface") as! String))
    var paramForDownloadUpload = [rForGsmData, eForGsmData]
    let paramDownloadUpload = paramForDownloadUpload.joined(separator: " ")
    Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: paramDownloadUpload ) { (json) in
      MethodsClass().processJsonStdoutOutput(response_data: json){ (mobileData) in
        print(mobileData)
        UserDefaults.standard.setValue(mobileData, forKey: "mobile_data")
        print(UserDefaults.standard.value(forKey: "mobile_data"))
        
      }
    }
    Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: "-g") { (json) in
      MethodsClass().processJsonStdoutOutput(response_data: json){ (mobileRoamingStatus) in
        print(mobileRoamingStatus)
        UserDefaults.standard.setValue(mobileRoamingStatus, forKey: "mobileroaming_datastatus")
        print(UserDefaults.standard.value(forKey: "mobileroaming_datastatus"))
        
      }
    }
    Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: GSM_3G_CONNECTION_STATE) { (json) in
      MethodsClass().processJsonStdoutOutput(response_data: json){ (connectionStatus) in
        print(connectionStatus)
        UserDefaults.standard.setValue(connectionStatus, forKey: "connection_status")
        print(UserDefaults.standard.value(forKey: "connection_status"))
      }
    }
    Json().mobileConnectionUptime(token: token as! String, param1: "network.interface.wan", param2: "status") { (json) in
      print("va", json)
     // UserDefaults.standard.setValue(json, forKey: "mobileconnection_uptime")
    //  print(UserDefaults.standard.value(forKey: "mobileconnection_uptime"))
    }
    
//    MethodsClass().processedDataArrayString(response_data: UserDefaults.standard.value(forKey: "processedgsm_data") as! String){ (result) in
//      var gsmDataResult = result
//      
//      print("ha", gsmDataResult)
//    }
// Wireless data
    
  }
}
