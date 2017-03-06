//
//  MainWindowModel.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 23/02/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import SwiftyJSON


public class MainWindowModel: UIViewController {
  
  private let WIRELESS_DOWNLOAD = "wirelessDownload"
  private let WIRELESS_UPLOAD = "wirelessUpload"
  private let MOBILE_DOWNLOAD = "mobileDownload"
  private let MOBILE_UPLOAD = "mobileUpload"

  
  internal func mainTasks (param1: String){
    let token = UserDefaults.standard.value(forKey: "saved_token")
    let GSM_3G_CONNECTION_STATE = "-j"
    
    var deviceName = UserDefaults.standard.value(forKey: "device_name") as! String
    print(deviceName)
    
        let wifiName = network().getSSID()
    
        guard wifiName != nil else {
    
          //// TODO: Alert -----
          print("no wifi name")
    
          return
        }
        UserDefaults.standard.setValue(wifiName, forKey: "wifi_ssid")

    
    // Mobile data, Mobile web services calss
    Json().deviceinform(token: token as! String, config: "network", section: "ppp", option: "ifname") { (json) in
      MethodsClass().getJsonValue(response_data: json){ (devicesInterface) in
        UserDefaults.standard.setValue(devicesInterface, forKey: "device_interface")
        UserDefaults.standard.synchronize()
        Json().aboutDevice2(token: token as! String, deviceInterface: (UserDefaults.standard.value(forKey: "device_interface") as! String).trimmingCharacters(in: .whitespacesAndNewlines), parameter: "" ) { (json) in
          MethodsClass().processJsonStdoutOutput(response_data: json){ (processedGsmData) in
            MethodsClass().processedDataArrayString(response_data: processedGsmData){ (finalGsmDataResult) in
              UserDefaults.standard.set(finalGsmDataResult, forKey: "processedgsm_data")
            }
          }
        }

        
        let deviceInterface = (UserDefaults.standard.value(forKey: "device_interface") as! String).trimmingCharacters(in: .whitespacesAndNewlines)
        Json().aboutDevice1(token: token as! String, command: deviceInterface, parameter: deviceInterface ) { (json) in
          MethodsClass().processJsonStdoutOutput(response_data: json){ (gsmDataRequestResult) in
            MethodsClass().processedDataArrayString(response_data: gsmDataRequestResult){ (finalGsmDataRequestResult) in
              UserDefaults.standard.set(finalGsmDataRequestResult, forKey: "mobile_data")
              
            }
          }
          
        }}}
    
    // if device is RUT9XX, found simcard inserted or not
    if ((deviceName.range(of:"RUT9")) != nil) {
      Json().fileExec2Comm(token: token as! String, command: "sim_switch sim") { (json) in
        MethodsClass().processJsonStdoutOutput(response_data: json){ (simCardValue) in
          UserDefaults.standard.setValue(simCardValue, forKey: "simcard_value")
          
          Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: "-z") { (json) in
            MethodsClass().processJsonStdoutOutput(response_data: json){ (simCardStateResult) in
              UserDefaults.standard.setValue(simCardStateResult, forKey: "simcard_state")
            }}
        }
      }
    }
    
    
    Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: "-g") { (json) in
      MethodsClass().processJsonStdoutOutput(response_data: json){ (mobileRoamingStatus) in
        UserDefaults.standard.setValue(mobileRoamingStatus, forKey: "mobileroaming_datastatus")
      }
    }
    Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: GSM_3G_CONNECTION_STATE) { (json) in
      MethodsClass().processJsonStdoutOutput(response_data: json){ (connectionStatus) in
        UserDefaults.standard.setValue(connectionStatus, forKey: "connection_status")
      }
    }
    Json().mobileConnectionUptime(token: token as! String, param1: "network.interface.wan", param2: "status") { (mobileConnectionUptime) in
      if let jsonDic = mobileConnectionUptime as? JSON, let object = jsonDic.dictionaryObject {
        UserDefaults.standard.setValue(object, forKey: "mobileconnection_uptime")

      }
    }
    
    
    // Wireless data
    
    var getConnectedWirelessIfNameParam = "get_ifname.lua "
    getConnectedWirelessIfNameParam.append((UserDefaults.standard.value(forKey: "wifi_ssid") as! String).trimmingCharacters(in: .whitespacesAndNewlines))
    Json().fileExec2Comm(token: token as! String, command: getConnectedWirelessIfNameParam) { (json) in
      MethodsClass().processJsonStdoutOutput(response_data: json){ (wirelessDevice) in
        UserDefaults.standard.setValue(wirelessDevice, forKey: "wireless_device")
        }
      
        let wirelesssDeviceTrimmed = (UserDefaults.standard.value(forKey: "wireless_device") as! String).trimmingCharacters(in: .whitespacesAndNewlines)
        Json().aboutDevice1(token: token as! String, command: wirelesssDeviceTrimmed, parameter: wirelesssDeviceTrimmed ) { (wirelessDownloadUploadRequestResult) in
          MethodsClass().processJsonStdoutOutput(response_data: wirelessDownloadUploadRequestResult){ (wirelessDataResult) in
         MethodsClass().processedDataArrayString(response_data: wirelessDataResult){ (wifiDataResult) in            UserDefaults.standard.setValue(wifiDataResult, forKey: "wirelessdownloadupload_result")
             }
            }
          }
          
        Json().deviceWirelessDetails(token: token as! String, param1: "info", param2: wirelesssDeviceTrimmed) { (deviceResult) in
          if let jsonDic = deviceResult as? JSON, let result = jsonDic.dictionaryObject {
            UserDefaults.standard.setValue(result, forKey: "device_result")
                    }
          }
      
        Json().deviceWirelessDetails(token: token as! String, param1: "assoclist", param2: wirelesssDeviceTrimmed) { (wirelessClients) in
               MainWindowModel().getCountOfWirelessClients(response_data: wirelessClients) { (wirelessClientsCount) in
                UserDefaults.standard.setValue(wirelessClientsCount, forKey: "wirelessclients_count")
        }
      }
      Json().deviceinform(token: token as! String, config: "wireless", section: "@wifi-iface[0]", option: "mode") { (json) in
         MethodsClass().getJsonValue(response_data: json){ (wirelessMode) in
          UserDefaults.standard.setValue(wirelessMode, forKey: "wireless_mode")
        }
      }
      Json().deviceWirelessDetails(token: token as! String, param1: "info", param2: wirelesssDeviceTrimmed) { (wirelessQuality) in
        MainWindowModel().getDeviceQuality(response_data: wirelessQuality){ (wirelessQualityResult) in
          UserDefaults.standard.setValue(wirelessQualityResult, forKey: "wirelessquality_result")
        }
      }

    }
    
// Module data
    Json().deviceinform(token: token as! String, config: "system", section: "module", option: "vid") { (moduleVid) in
        MethodsClass().getJsonValue(response_data: moduleVid){ (moduleVidValue) in
          UserDefaults.standard.setValue(moduleVidValue, forKey: "modulevid_value")
    }
    }
    Json().deviceinform(token: token as! String, config: "system", section: "module", option: "pid") { (modulePid) in
      MethodsClass().getJsonValue(response_data: modulePid){ (modulePidValue) in
        UserDefaults.standard.setValue(modulePidValue, forKey: "modulepid_value")

        let va = self.asddas()
        
        
        if let deviceResultUnwrapped = (UserDefaults.standard.value(forKey: "device_result")), let mobileConnectionUptimeUnwrapped = (UserDefaults.standard.value(forKey: "mobileconnection_uptime") as? NSDictionary), let processedGsmDataUnwrapped = (UserDefaults.standard.array(forKey: "processedgsm_data") as? [String]), let wirelessDownloadUploadResultUnwrapped = (UserDefaults.standard.array(forKey: "wirelessdownloadupload_result") as? [String]), let mobileDataUnwrapped = (UserDefaults.standard.array(forKey: "mobile_data") as? [String]), let DeviceInterfaceUnwrapped = (UserDefaults.standard.value(forKey: "device_interface") as? String), let mobileRoamingUnwrapped = (UserDefaults.standard.value(forKey: "mobileroaming_datastatus") as? String), let wirelessClientsCountUnwrapped = (UserDefaults.standard.value(forKey: "wirelessclients_count") as? Int), let wirelessQualityResultUnwrapped = (UserDefaults.standard.value(forKey: "wirelessquality_result") as? String), let wirelessModeUnwrapped = (UserDefaults.standard.value(forKey: "wireless_mode") as? String), let connectionStatusUnwrapped = (UserDefaults.standard.value(forKey: "connection_status") as? String), let simcardStateUnwrapped = (UserDefaults.standard.value(forKey: "simcard_state") as? String) {
          
          
          MainWindowModel().parseDeviceDataObject(deviceResult:deviceResultUnwrapped, mobileConnectionUptime:mobileConnectionUptimeUnwrapped, processedGsmData: processedGsmDataUnwrapped, wirelessDownloadUploadResult: wirelessDownloadUploadResultUnwrapped, mobileData: mobileDataUnwrapped, DeviceInterface: DeviceInterfaceUnwrapped, mobileRoaming: mobileRoamingUnwrapped, wirelessClientsCount: wirelessClientsCountUnwrapped,wirelessQualityResult: wirelessQualityResultUnwrapped, wirelessMode: wirelessModeUnwrapped, connectionStatus: connectionStatusUnwrapped, simcardState: simcardStateUnwrapped)
        }
      }
    }
    if (UserDefaults.standard.array(forKey: "wirelessdownloadupload_result") as? [String] )?[0].isNumeric == true {
 
    print("gerai", (UserDefaults.standard.array(forKey: "wirelessdownloadupload_result") as? [String] )?[0])
      
   } else {
    print("nulisss")
         print("hhhasdasd", UserDefaults.standard.array(forKey: "wirelessdownloadupload_result"))
    }
    print("reikiama1", UserDefaults.standard.value(forKey: "device_result"))
    print("reikiama2", UserDefaults.standard.value(forKey: "wireless_mode"))


  }
  
  func asddas () {
    print("viskas", (UserDefaults.standard.value(forKey: "device_result")), (UserDefaults.standard.value(forKey: "mobileconnection_uptime") as? NSDictionary), "2", (UserDefaults.standard.array(forKey: "processedgsm_data") as? [String]), "ka?", (UserDefaults.standard.array(forKey: "wirelessdownloadupload_result") as? [String]), "ka?", (UserDefaults.standard.array(forKey: "mobile_data") as? [String]), (UserDefaults.standard.value(forKey: "device_interface") as? String), (UserDefaults.standard.value(forKey: "mobileroaming_datastatus") as? String), (UserDefaults.standard.value(forKey: "wirelessclients_count") as? Int), (UserDefaults.standard.value(forKey: "wirelessquality_result") as? String), (UserDefaults.standard.value(forKey: "wireless_mode") as? String), (UserDefaults.standard.value(forKey: "connection_status") as? String), (UserDefaults.standard.value(forKey: "simcard_state") as? String))
  }
  

public func getCountOfWirelessClients (response_data: Any?, complete: (Int)->()){
  
    
    var count = 0
    if let jsonDic = response_data as? JSON {
      print(jsonDic)
      if (jsonDic["result"].exists()){
        for item in jsonDic["result"].arrayValue {
          if item["results"].exists() {
           count = item["results"].count
          }
        }
        complete(count)
      } else {
        complete(count)
      }
    }else {
      print("klaida?")
    }
    
    
  }

func getDeviceQuality(response_data: Any?, complete: (String)->()){
 
  var result = ""
  var resultValue = ""
  if let jsonDic = response_data as? JSON {
    print(jsonDic)
    if (jsonDic["result"].exists()){
      for item in jsonDic["result"].arrayValue {
        if item["signal"].exists() {
          result = item["signal"].stringValue
          let index = result.index(result.startIndex, offsetBy: 1)
          resultValue = result.substring(from: index) + "%"
        }
      }
      complete(resultValue)
    } else {
      complete("Error")
    }
  }else {
    print("klaida+")
  }
  
  
  }



 func parseDeviceDataObject (deviceResult: Any?, mobileConnectionUptime: Any?, processedGsmData: Array<String>, wirelessDownloadUploadResult: Array<Any>, mobileData: Array<String>, DeviceInterface: String, mobileRoaming: String, wirelessClientsCount: Int, wirelessQualityResult: String, wirelessMode: String, connectionStatus: String, simcardState: String) {
 
  var object1: [String: String] = ["signal": processedGsmData[0], "operator": processedGsmData[1], "connection": MainWindowModel().gsmConnectionChecker(processedGsmData: processedGsmData[2] as! String)]
  
  var objectWifi: [String: String] = [:]
  var objectGsm: [String: String] = [:]
  var objectDevices: [String: Any] = [:]
  
  print("veikia!!", wirelessDownloadUploadResult[0] as! String)
  do {
    
  if ((wirelessDownloadUploadResult[0] as! String).isNumeric) == true {
    objectWifi[WIRELESS_DOWNLOAD] = (wirelessDownloadUploadResult[0] as! String)
  } else {
    objectWifi[WIRELESS_DOWNLOAD] = "0"
  }
  
  if ((wirelessDownloadUploadResult[1] as! String).isNumeric) == true {
    objectWifi[WIRELESS_UPLOAD] = wirelessDownloadUploadResult[1] as! String
  } else {
    objectWifi[WIRELESS_UPLOAD] = "0"
  }

  if ((mobileData[0] as! String).isNumeric) == true {
    objectGsm[MOBILE_DOWNLOAD] = mobileData[0] as! String
  } else {
    objectGsm[MOBILE_DOWNLOAD] = "0"
  }
  if ((mobileData[1] as! String).isNumeric) == true {
    objectGsm[MOBILE_UPLOAD] = mobileData[1] as! String
  } else {
    objectGsm[MOBILE_UPLOAD] = "0"
  }
  } catch {
    DispatchQueue.main.async {
      AlertController.showErrorWith(title: "Parse DeviceData Object", message: "Has Failed", controller: self) {
      }
    }
    
  }
  objectGsm["ConnectionStatus"] = connectionStatus
  objectDevices["MobileDevice"] = DeviceInterface
  objectDevices["WirelessClientsCount"] = wirelessClientsCount
  objectDevices["WirelessQuality"] = wirelessQualityResult
  objectDevices["SimCardState"] = simcardState
  print(objectDevices, "pppppp")
//  MainWindowModel().processedWirelessInformation()
  
  
  }
  
  
//  func processedWirelessInformation (deviceResult: Any?, wirelessMode: String) -> ([]) {
//  }
//  
  
  
 func gsmConnectionChecker(processedGsmData: String) -> String {
    var connectionType = ""
    let cdma = "CDMA"
    var valueResult = ""
    if processedGsmData == cdma || processedGsmData.range(of: "EDGE") != nil || processedGsmData.range(of: "GPRS") != nil || processedGsmData.range(of: "GSM") != nil {
      connectionType = "2G (" + processedGsmData + ")"
    } else if processedGsmData.range(of: "WCDMA") != nil || processedGsmData.range(of: "HSDPA") != nil || processedGsmData.range(of: "HSUPA") != nil || processedGsmData.range(of: "HSPA") != nil || processedGsmData.range(of: "HSPA+") != nil || processedGsmData.range(of: "UMTS") != nil {
      
      if processedGsmData.range(of: "DC-") != nil {
        let index = processedGsmData.index(processedGsmData.startIndex, offsetBy: 3)
        valueResult = processedGsmData.substring(from: index)
        connectionType = "3G (" + valueResult + ")"
      } else {
        connectionType = "3G (" + processedGsmData + ")"
      }
      
    } else if (processedGsmData.range(of: "LTE") != nil) {
      connectionType = "4G (" + processedGsmData + ")"
    }
    return connectionType
  }
}


extension String {
  var isNumeric: Bool {
    let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    return Set(self.characters).isSubset(of: nums)
  }
}

  class network : NSObject {
    
    func getSSID() -> String? {
      
      let interfaces = CNCopySupportedInterfaces()
      if interfaces == nil {
        return nil
      }
      
      let interfacesArray = interfaces as! [String]
      if interfacesArray.count <= 0 {
        return nil
      }
      
      let interfaceName = interfacesArray[0] as String
      let unsafeInterfaceData =     CNCopyCurrentNetworkInfo(interfaceName as CFString)
      if unsafeInterfaceData == nil {
        return nil
      }
      
      let interfaceData = unsafeInterfaceData as! Dictionary <String,AnyObject>
      
      return interfaceData["SSID"] as? String
    }
    
  }
