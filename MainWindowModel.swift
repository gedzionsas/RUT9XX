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
  
  private let MOBILE_COLLECTED_RX = "CollectedRx"
  private let MOBILE_COLLECTED_TX = "CollectedTx"
  private let MOBILE_COLLECTED_MONTH_RX = "CollectedMonthRx"
  private let MOBILE_COLLECTED_MONTH_TX = "CollectedMonthTx"
  
  internal func mainTasks (param1: String){
    
    let token = UserDefaults.standard.value(forKey: "saved_token")
    let GSM_3G_CONNECTION_STATE = "-j"
    
    var deviceName = UserDefaults.standard.value(forKey: "device_name") as! String
    
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
          let deviceInterface = (UserDefaults.standard.value(forKey: "device_interface") as! String).trimmingCharacters(in: .whitespacesAndNewlines)
          Json().aboutDevice1(token: token as! String, command: deviceInterface, parameter: deviceInterface ) { (json) in
            MethodsClass().processJsonStdoutOutput(response_data: json){ (gsmDataRequestResult) in
              MethodsClass().processedDataArrayString(response_data: gsmDataRequestResult){ (finalGsmDataRequestResult) in
                UserDefaults.standard.set(finalGsmDataRequestResult, forKey: "mobile_data")
                
              }
            }
            // if device is RUT9XX, found simcard inserted or not
            if ((deviceName.range(of:"RUT9")) != nil) {
              Json().fileExec2Comm(token: token as! String, command: "sim_switch sim") { (json) in
                MethodsClass().processJsonStdoutOutput(response_data: json){ (simCardValue) in
                  UserDefaults.standard.setValue(simCardValue, forKey: "simcard_value")
                }
                Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: "-z") { (json) in
                  MethodsClass().processJsonStdoutOutput(response_data: json){ (simCardStateResult) in
                    UserDefaults.standard.setValue(simCardStateResult, forKey: "simcard_state")
                  }
                  
                  
                  let testCommand = "mdcollectdctl -rx"
                  let test2Command = "mdcollectdctl -tx"
                  let test3Command = "mdcollectdctl -cmonthrx"
                  let test4Command = "mdcollectdctl -cmonthtx"
                  
                  Json().fileExec2Comm(token: token as! String, command: testCommand) { (json) in
                    MethodsClass().processJsonStdoutOutput(response_data: json){ (rxData) in
                      UserDefaults.standard.setValue(rxData, forKey: "rx_data")
                    }
                    
                    Json().fileExec2Comm(token: token as! String, command: test2Command) { (json) in
                      MethodsClass().processJsonStdoutOutput(response_data: json){ (txData) in
                        UserDefaults.standard.setValue(txData, forKey: "tx_data")
                      }
                      
                      Json().fileExec2Comm(token: token as! String, command: test3Command) { (json) in
                        MethodsClass().processJsonStdoutOutput(response_data: json){ (rxMonthData) in
                          UserDefaults.standard.setValue(rxMonthData, forKey: "rxmonth_data")
                        }
                        
                        Json().fileExec2Comm(token: token as! String, command: test4Command) { (json) in
                          MethodsClass().processJsonStdoutOutput(response_data: json){ (txMonthData) in
                            UserDefaults.standard.setValue(txMonthData, forKey: "txmonth_data")
                          }
                          //print(rxData, txData, rxMonthData, txMonthData)
                          var arr: [String] = [(UserDefaults.standard.value(forKey: "rx_data") as! String).trimmingCharacters(in: .whitespacesAndNewlines), (UserDefaults.standard.value(forKey: "tx_data") as! String).trimmingCharacters(in: .whitespacesAndNewlines), (UserDefaults.standard.value(forKey: "rxmonth_data") as! String).trimmingCharacters(in: .whitespacesAndNewlines), (UserDefaults.standard.value(forKey: "txmonth_data") as! String).trimmingCharacters(in: .whitespacesAndNewlines)]
                          UserDefaults.standard.setValue(arr, forKey: "arr_data")
                          Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: "-g") { (json) in
                            MethodsClass().processJsonStdoutOutput(response_data: json){ (mobileRoamingStatus) in
                              UserDefaults.standard.setValue(mobileRoamingStatus, forKey: "mobileroaming_datastatus")
                            }
                            
                            Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: GSM_3G_CONNECTION_STATE) { (json) in
                              MethodsClass().processJsonStdoutOutput(response_data: json){ (connectionStatus) in
                                let connectionStatusTrimmed = connectionStatus.trimmingCharacters(in: .whitespacesAndNewlines)
                                UserDefaults.standard.setValue(connectionStatusTrimmed, forKey: "connection_status")
                              }
                              Json().mobileConnectionUptime(token: token as! String, param1: "network.interface.wan", param2: "status") { (mobileConnectionUptime) in
                                if let jsonDic = mobileConnectionUptime as? JSON, let object = jsonDic.dictionaryObject {
                                  UserDefaults.standard.setValue(object, forKey: "mobileconnection_uptime")
                                }
                                // Wireless data
                                
                                var getConnectedWirelessIfNameParam = "get_ifname.lua "
                                getConnectedWirelessIfNameParam.append((UserDefaults.standard.value(forKey: "wifi_ssid") as! String).trimmingCharacters(in: .whitespacesAndNewlines))
                                Json().fileExec2Comm(token: token as! String, command: getConnectedWirelessIfNameParam) { (json) in
                                  MethodsClass().processJsonStdoutOutput(response_data: json){ (wirelessDevice) in
                                    print("kanors", wirelessDevice)
                                    if wirelessDevice.isEmpty{
                                      UserDefaults.standard.setValue("0", forKey: "wireless_device")
                                      
                                    } else {
                                      UserDefaults.standard.setValue(wirelessDevice, forKey: "wireless_device")
                                    }}
                                  let wirelesssDeviceTrimmed = (UserDefaults.standard.value(forKey: "wireless_device") as! String).trimmingCharacters(in: .whitespacesAndNewlines)
                                  Json().aboutDevice1(token: token as! String, command: wirelesssDeviceTrimmed, parameter: wirelesssDeviceTrimmed ) { (wirelessDownloadUploadRequestResult) in
                                    MethodsClass().processJsonStdoutOutput(response_data: wirelessDownloadUploadRequestResult){ (wirelessDataResult) in
                                      MethodsClass().processedDataArrayString(response_data: wirelessDataResult){ (wifiDataResult) in
                                        UserDefaults.standard.setValue(wifiDataResult, forKey: "wirelessdownloadupload_result")
                                      }
                                    }
                                    Json().deviceWirelessDetails(token: token as! String, param1: "info", param2: wirelesssDeviceTrimmed) { (deviceResult) in
                                      if let jsonDic = deviceResult as? JSON, let result = jsonDic.dictionaryObject {
                                        UserDefaults.standard.setValue(result, forKey: "device_result")
                                      }
                                      Json().deviceWirelessDetails(token: token as! String, param1: "assoclist", param2: wirelesssDeviceTrimmed) { (wirelessClients) in
                                        MainWindowModel().getCountOfWirelessClients(response_data: wirelessClients) { (wirelessClientsCount) in
                                          UserDefaults.standard.setValue(wirelessClientsCount, forKey: "wirelessclients_count")
                                        }
                                        
                                        Json().deviceinform(token: token as! String, config: "wireless", section: "@wifi-iface[0]", option: "mode") { (json) in
                                          MethodsClass().getJsonValue(response_data: json){ (wirelessMode) in
                                            UserDefaults.standard.setValue(wirelessMode, forKey: "wireless_mode")
                                          }
                                          
                                          Json().deviceWirelessDetails(token: token as! String, param1: "info", param2: wirelesssDeviceTrimmed) { (wirelessQuality) in
                                            MainWindowModel().getDeviceQuality(response_data: wirelessQuality){ (wirelessQualityResult) in
                                              UserDefaults.standard.setValue(wirelessQualityResult, forKey: "wirelessquality_result")
                                            }
                                            
                                            
                                            //      print("rasiu",UserDefaults.standard.value(forKey: "device_result"), UserDefaults.standard.value(forKey: "mobileconnection_uptime") as? NSDictionary, (UserDefaults.standard.array(forKey: "processedgsm_data") as? [String]), (UserDefaults.standard.array(forKey: "wirelessdownloadupload_result") as? [String]), (UserDefaults.standard.array(forKey: "mobile_data") as? [String]), (UserDefaults.standard.array(forKey: "arr_data") as? [String]), (UserDefaults.standard.value(forKey: "device_interface") as? String), (UserDefaults.standard.value(forKey: "mobileroaming_datastatus") as? String), (UserDefaults.standard.value(forKey: "wirelessclients_count") as? Int), (UserDefaults.standard.value(forKey: "wirelessquality_result") as? String), (UserDefaults.standard.value(forKey: "wireless_mode") as? String), (UserDefaults.standard.value(forKey: "connection_status") as? String), (UserDefaults.standard.value(forKey: "simcard_state") as? String))
                                            
                                            
                                            if let deviceResultUnwrapped = (UserDefaults.standard.value(forKey: "device_result")), let mobileConnectionUptimeUnwrapped = (UserDefaults.standard.value(forKey: "mobileconnection_uptime") as? NSDictionary), let processedGsmDataUnwrapped = (UserDefaults.standard.array(forKey: "processedgsm_data") as? [String]), let wirelessDownloadUploadResultUnwrapped = (UserDefaults.standard.array(forKey: "wirelessdownloadupload_result") as? [String]), let mobileDataUnwrapped = (UserDefaults.standard.array(forKey: "mobile_data") as? [String]), let mobileDataArray = (UserDefaults.standard.array(forKey: "arr_data") as? [String]), let DeviceInterfaceUnwrapped = (UserDefaults.standard.value(forKey: "device_interface") as? String), let mobileRoamingUnwrapped = (UserDefaults.standard.value(forKey: "mobileroaming_datastatus") as? String), let wirelessClientsCountUnwrapped = (UserDefaults.standard.value(forKey: "wirelessclients_count") as? Int), let wirelessQualityResultUnwrapped = (UserDefaults.standard.value(forKey: "wirelessquality_result") as? String), let wirelessModeUnwrapped = (UserDefaults.standard.value(forKey: "wireless_mode") as? String), let connectionStatusUnwrapped = (UserDefaults.standard.value(forKey: "connection_status") as? String), let simcardStateUnwrapped = (UserDefaults.standard.value(forKey: "simcard_state") as? String) {
                                              
                                              let data = MainWindowModel().parseDeviceDataObject(deviceResult:deviceResultUnwrapped, mobileConnectionUptime:mobileConnectionUptimeUnwrapped, processedGsmData: processedGsmDataUnwrapped, wirelessDownloadUploadResult: wirelessDownloadUploadResultUnwrapped, mobileData: mobileDataUnwrapped, mobileDataArray: mobileDataArray, DeviceInterface: DeviceInterfaceUnwrapped, mobileRoaming: mobileRoamingUnwrapped, wirelessClientsCount: wirelessClientsCountUnwrapped,wirelessQualityResult: wirelessQualityResultUnwrapped, wirelessMode: wirelessModeUnwrapped, connectionStatus: connectionStatusUnwrapped, simcardState: simcardStateUnwrapped)
                                              UserDefaults.standard.setValue(data, forKey: "display_data")
                                            } else {
                                              print("Error unwrapping values")
                                            }
                                            print(UserDefaults.standard.array(forKey: "display_data"))
                                            
                                          }}}
                                      // Module data
                                      Json().deviceinform(token: token as! String, config: "system", section: "module", option: "vid") { (moduleVid) in
                                        MethodsClass().getJsonValue(response_data: moduleVid){ (moduleVidValue) in
                                          UserDefaults.standard.setValue(moduleVidValue, forKey: "modulevid_value")
                                        }
                                      }
                                      Json().deviceinform(token: token as! String, config: "system", section: "module", option: "pid") { (modulePid) in
                                        MethodsClass().getJsonValue(response_data: modulePid){ (modulePidValue) in
                                          UserDefaults.standard.setValue(modulePidValue, forKey: "modulepid_value")
                                        }
                                      }
                                      
                                    }}}}
                            }}}
                      }}}}}}}}}}}
  
  public func getCountOfWirelessClients (response_data: Any?, complete: (Int)->()){
    
    var count = 0
    if let jsonDic = response_data as? JSON {
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
      print("klaida")
    }
  }
  
  func getDeviceQuality(response_data: Any?, complete: (String)->()){
    
    var result = ""
    var resultValue = ""
    if let jsonDic = response_data as? JSON {
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
      print("klaida")
    }
  }
  func parseDeviceDataObject (deviceResult: Any?, mobileConnectionUptime: Any?, processedGsmData: Array<String>, wirelessDownloadUploadResult: Array<Any>, mobileData: Array<String>, mobileDataArray: Array<String>, DeviceInterface: String, mobileRoaming: String, wirelessClientsCount: Int, wirelessQualityResult: String, wirelessMode: String, connectionStatus: String, simcardState: String)-> [Any] {
    
    var object1: [String: String] = ["signal": processedGsmData[0], "operator": processedGsmData[1], "connection": MainWindowModel().gsmConnectionChecker(processedGsmData: processedGsmData[2] as! String)]
    
    var objectWifi: [String: String] = [:]
    var objectGsm: [String: String] = [:]
    var objectDevices: [String: Any] = [:]
    var array = [Any]()
    
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
      if ((mobileDataArray[2] as! String).isNumeric) == true {
        objectGsm[MOBILE_COLLECTED_MONTH_RX] = mobileDataArray[2] as! String
      } else {
        objectGsm[MOBILE_COLLECTED_RX] = mobileDataArray[0] as! String
      }
      if ((mobileDataArray[3] as! String).isNumeric) == true {
        objectGsm[MOBILE_COLLECTED_MONTH_TX] = mobileDataArray[3] as! String
      } else {
        objectGsm[MOBILE_COLLECTED_TX] = mobileDataArray[1] as! String
      }
      
    } catch {
      DispatchQueue.main.async {
        AlertController.showErrorWith(title: "Parse DeviceData Object", message: "Has Failed", controller: self) {
        }
      }
      
    }
    objectGsm["ConnectionStatus"] = connectionStatus
    //  let labas = MainWindowModel().convertedDataCountToMb(object: objectGsm, downloadObjectName: MOBILE_COLLECTED_RX, uploadObjectName: MOBILE_COLLECTED_TX)
    //   print("labai idomu man", MainWindowModel().calculatedMobileData(object: labas))
    objectDevices["MobileDevice"] = DeviceInterface
    objectDevices["WirelessClientsCount"] = wirelessClientsCount
    objectDevices["WirelessQuality"] = wirelessQualityResult
    objectDevices["SimCardState"] = (simcardState ).trimmingCharacters(in: .whitespacesAndNewlines)
    var arrayResultWifi = MethodsClass().jsonResultObject(response_data: deviceResult)
    print("das", arrayResultWifi)
    if (UserDefaults.standard.value(forKey: "wireless_device") as? String) == "0" {
      var objectWDevices: [String: String] = [:]
      objectWDevices["mode"] = "N/A"
      objectWDevices["chanel"] = "N/A"
      objectWDevices["SSID"] = "N/A"
      objectWDevices["BSSID"] = "N/A"
      objectWDevices["encryption"] = "N/A"
      array.insert(objectWDevices, at:0)
    } else {
      array.insert(MainWindowModel().processedWirelessInformation(deviceResult: arrayResultWifi, wirelessMode: wirelessMode), at: 0)
    }
    array.insert(object1, at: 0)
    array.insert(objectWifi, at: 0)
    array.insert(objectGsm, at: 0)
    let arrayResultMobile = MethodsClass().jsonResultObject(response_data: mobileConnectionUptime)
    array.insert(MainWindowModel().processedMobileInformation(mobileUptime: arrayResultMobile, mobileRoaming: mobileRoaming), at: 0)
    array.insert(objectDevices, at: 0)
    print(array)
    return array
  }
  
  func processedMobileInformation (mobileUptime: [Any?], mobileRoaming: String) -> Dictionary<String,Any> {
    var objectDevices: [String: Any] = [:]
    var uptime : String! = ""
    var device : String! = ""
    if let information = mobileUptime[1] as? Dictionary<String, Any> {
      if let uptimew = information["uptime"] {
        uptime = "\(uptimew)"
      } else {
        uptime = "0.0"
      }
      if (information["device"] != nil) {
        device = information["device"] as! String
      } else {
        device = ""
      }
    }
    objectDevices["uptime"] = uptime
    objectDevices["device"] = device
    objectDevices["roaming"] = (mobileRoaming).trimmingCharacters(in: .whitespacesAndNewlines)
    
    return objectDevices
  }
  
  func processedWirelessInformation (deviceResult: [Any?], wirelessMode: String) -> Dictionary<String,Any> {
    var result = ""
    var objectDevices: [String: Any] = [:]
    if let information = deviceResult[1] as? Dictionary<String, Any> {
      let chanel = information["channel"]
      let ssid = information["ssid"]
      let bssid = information["bssid"]
      let encryption = MainWindowModel().checkWirelessEncryption(encryption: information["encryption"])
      objectDevices["mode"] = wirelessMode
      objectDevices["chanel"] = chanel
      objectDevices["SSID"] = ssid
      objectDevices["BSSID"] = bssid
      objectDevices["encryption"] = encryption
    }
    return objectDevices
  }
  
  func checkWirelessEncryption(encryption: Any?) -> String {
    var result = ""
    if var information = encryption as? Dictionary<String, Any?> {
      let enabled = information["enabled"] as? Bool
      if enabled == false {
        result = "No encryption"
      }else if enabled == true {
        if (information["wpa"] != nil) {
          let encryptionLevel = information["wpa"] as! String
          let index = encryptionLevel.index(encryptionLevel.startIndex, offsetBy: 1)
          let endIndex = encryptionLevel.index(encryptionLevel.startIndex, offsetBy: 1)
          let encryptionLevelWrapped = encryptionLevel[index...endIndex]
          result = "WPA\(encryptionLevelWrapped)"
        } else if (information["wep"] != nil) {
          let encryptionLevel = information["wep"] as! String
          let index = encryptionLevel.index(encryptionLevel.startIndex, offsetBy: 1)
          let endIndex = encryptionLevel.index(encryptionLevel.startIndex, offsetBy: 1)
          let encryptionLevelWrapped = encryptionLevel[index...endIndex]
          result = "WEP\(encryptionLevelWrapped)"
        }
      }
    }
    return result
  }
  
  
  
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
  
  
  public func convertedDataCountToMb (object: [String: String], downloadObjectName: String, uploadObjectName: String) -> [String: Double] {
    var convertedToMb: [String: Double] = [:]
    let mega = 1048576.0
    
    do {
      if (downloadObjectName != nil && uploadObjectName != nil){
        var download = 0.0
        var upload = 0.0
        let download_data = object[downloadObjectName]
        let upload_data = object[uploadObjectName]
        if let mobileDownloadData = NumberFormatter().number(from: download_data!)?.doubleValue {
          download = mobileDownloadData
        }
        if let mobileUploadData = NumberFormatter().number(from: upload_data!)?.doubleValue {
          upload = mobileUploadData
        }
        let download_mb = download / mega
        let upload_mb = upload / mega
        convertedToMb[downloadObjectName] = download_mb
        convertedToMb[uploadObjectName] = upload_mb
      } else {
        convertedToMb[downloadObjectName] = 0
        convertedToMb[uploadObjectName] = 0
      }
    } catch {
      DispatchQueue.main.async {
        AlertController.showErrorWith(title: "Parse DeviceData Object", message: "Has Failed", controller: self) {
        }
      }
    }
    return convertedToMb
  }
  
  public func calculatedMobileData (object: [String: Double]) -> String {
    let giga = 1024.0
    var download = 0.0
    var upload = 0.0
    var mobileDataAmount = 0.0
    var finalAmount = ""
    
    
    do{
      var downloadData = 0.0
      var uploadData = 0.0
      if (object[MOBILE_COLLECTED_RX] != nil && object[MOBILE_COLLECTED_TX] != nil){
        downloadData = object[MOBILE_COLLECTED_RX]!
        uploadData = object[MOBILE_COLLECTED_TX]!
      } else {
        downloadData = object[MOBILE_COLLECTED_MONTH_RX]!
        uploadData = object[MOBILE_COLLECTED_MONTH_TX]!
      }
      mobileDataAmount = downloadData + uploadData
      if ((mobileDataAmount / giga) > 1) {
        let dataAmountInGygabytes = mobileDataAmount / giga
        var value: String = String(format:"%.0f", dataAmountInGygabytes)
        finalAmount = value + " GB"
      } else if ((mobileDataAmount / giga) < 1) {
        let finalValue = Double(round(1000*mobileDataAmount)/10)
        
        finalAmount = "\(finalValue) MB"
      }
    } catch {
      DispatchQueue.main.async {
        AlertController.showErrorWith(title: "Parse DeviceData Object", message: "Has Failed", controller: self) {
        }
      }
    }
    return finalAmount
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
