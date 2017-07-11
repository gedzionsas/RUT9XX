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
  
    
  private let MOBILE_CONNECTION_CONNECTED = "connected"
  private let MOBILE_CONNECTION_DISCONNECTED = "Disconnected"
  private let WIRELESS_DOWNLOAD = "wirelessDownload"
  private let WIRELESS_UPLOAD = "wirelessUpload"
  private let MOBILE_DOWNLOAD = "mobileDownload"
  private let MOBILE_UPLOAD = "mobileUpload"
  
  private let MOBILE_COLLECTED_RX = "CollectedRx"
  private let MOBILE_COLLECTED_TX = "CollectedTx"
  private let MOBILE_COLLECTED_MONTH_RX = "CollectedMonthRx"
  private let MOBILE_COLLECTED_MONTH_TX = "CollectedMonthTx"
  
  internal func mainTasks (complete: @escaping ([[String]])->()){
    
    let token = UserDefaults.standard.value(forKey: "saved_token")
    let GSM_3G_CONNECTION_STATE = "-j"
    
    let deviceName = UserDefaults.standard.value(forKey: "device_name") as! String
    
    let wifiName = network().getSSID()
    
    guard wifiName != nil else {
      
      //// TODO: Alert -----
      print("no wifi name")
      
      return
    }
    UserDefaults.standard.setValue(wifiName, forKey: "wifi_ssid")
    print("wifi vardas", UserDefaults.standard.value(forKey: "wifi_ssid"))
    
    // Mobile data, Mobile web services calss
    Json().deviceinform(token: token as! String, config: "network", section: "ppp", option: "ifname") { (json) in
      MethodsClass().getJsonValue(response_data: json){ (devicesInterface) in
        UserDefaults.standard.setValue(devicesInterface, forKey: "device_interface")
        UserDefaults.standard.synchronize()
        Json().aboutDevice2(token: token as! String, deviceInterface: (UserDefaults.standard.value(forKey: "device_interface") as! String).trimmingCharacters(in: .whitespacesAndNewlines), parameter: "" ) { (json) in
            print(json, "asdasd")
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
                                            
                                            print("trimed", wirelesssDeviceTrimmed)
                                            MainWindowModel().getDeviceQuality(response_data: wirelessQuality){ (wirelessQualityResult) in
                                              UserDefaults.standard.setValue(wirelessQualityResult, forKey: "wirelessquality_result")
                                            }
                                            
                                            
                                               //   print("rasiu",UserDefaults.standard.value(forKey: "device_result"), UserDefaults.standard.value(forKey: "mobileconnection_uptime") as? NSDictionary, (UserDefaults.standard.array(forKey: "processedgsm_data") as? [String]), (UserDefaults.standard.array(forKey: "wirelessdownloadupload_result") as? [String]), (UserDefaults.standard.array(forKey: "mobile_data") as? [String]), (UserDefaults.standard.array(forKey: "arr_data") as? [String]), (UserDefaults.standard.value(forKey: "device_interface") as? String), (UserDefaults.standard.value(forKey: "mobileroaming_datastatus") as? String), (UserDefaults.standard.value(forKey: "wirelessclients_count") as? Int), (UserDefaults.standard.value(forKey: "wirelessquality_result") as? String), (UserDefaults.standard.value(forKey: "wireless_mode") as? String), (UserDefaults.standard.value(forKey: "connection_status") as? String), (UserDefaults.standard.value(forKey: "simcard_state") as? String))
                                            
                                            
                                            if let deviceResultUnwrapped = (UserDefaults.standard.value(forKey: "device_result")), let mobileConnectionUptimeUnwrapped = (UserDefaults.standard.value(forKey: "mobileconnection_uptime") as? NSDictionary), let processedGsmDataUnwrapped = (UserDefaults.standard.array(forKey: "processedgsm_data") as? [String]), let wirelessDownloadUploadResultUnwrapped = (UserDefaults.standard.array(forKey: "wirelessdownloadupload_result") as? [String]), let mobileDataUnwrapped = (UserDefaults.standard.array(forKey: "mobile_data") as? [String]), let mobileDataArray = (UserDefaults.standard.array(forKey: "arr_data") as? [String]), let DeviceInterfaceUnwrapped = (UserDefaults.standard.value(forKey: "device_interface") as? String), let mobileRoamingUnwrapped = (UserDefaults.standard.value(forKey: "mobileroaming_datastatus") as? String), let wirelessClientsCountUnwrapped = (UserDefaults.standard.value(forKey: "wirelessclients_count") as? Int), let wirelessQualityResultUnwrapped = (UserDefaults.standard.value(forKey: "wirelessquality_result") as? String), let wirelessModeUnwrapped = (UserDefaults.standard.value(forKey: "wireless_mode") as? String), let connectionStatusUnwrapped = (UserDefaults.standard.value(forKey: "connection_status") as? String), let simcardStateUnwrapped = (UserDefaults.standard.value(forKey: "simcard_state") as? String) {
                                              
                                              let data = MainWindowModel().parseDeviceDataObject(deviceResult:deviceResultUnwrapped, mobileConnectionUptime:mobileConnectionUptimeUnwrapped, processedGsmData: processedGsmDataUnwrapped, wirelessDownloadUploadResult: wirelessDownloadUploadResultUnwrapped, mobileData: mobileDataUnwrapped, mobileDataArray: mobileDataArray, DeviceInterface: DeviceInterfaceUnwrapped, mobileRoaming: mobileRoamingUnwrapped, wirelessClientsCount: wirelessClientsCountUnwrapped,wirelessQualityResult: wirelessQualityResultUnwrapped, wirelessMode: wirelessModeUnwrapped, connectionStatus: connectionStatusUnwrapped, simcardState: simcardStateUnwrapped)
                                              UserDefaults.standard.setValue(data, forKey: "display_data")
                                            } else {
                                              print("Error unwrapping values")
                                            }
                                            
                                           let array = self.setDataMainWindow(params: UserDefaults.standard.array(forKey: "display_data")!)
                                          complete (array)
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
                      }}}}}}}}}}
    
    }
    
    func setDataMainWindow (params: [Any])->([[String]]) {
        
        let deviceName = UserDefaults.standard.value(forKey: "device_name") as! String

        
        var objectGsmData = [String:String]()
        var convertedData = [String:Double]()
        var paramsObject = [String:String]()
        var devicesObject = [String:String]()
        var object1 = [String:String]()

        var wifiClientsCount = ""
        var wifiQuality = ""
        var connectionUpTime = ""
        var mobileOperatorValue = ""
        var mobileConnectionValue = ""
        var completedUpTime = ""
        var completedSimCardState = ""
        var dataUsage = ""
        var mobileSignalStrength = 0.0

        print(params)
        object1 = params[1] as! [String : String]
          objectGsmData = params[3] as! [String : String]
          paramsObject = params[0] as! [String : String]
        devicesObject = params[5] as! [String : String]

        if objectGsmData[MOBILE_COLLECTED_RX] != nil && objectGsmData[MOBILE_COLLECTED_TX] != nil {
            convertedData = convertedDataCountToMb(object: params[3] as! [String : String], downloadObjectName: MOBILE_COLLECTED_RX, uploadObjectName: MOBILE_COLLECTED_TX)
            dataUsage = "DATA USAGE (CURRENT SESSION)"
            
        } else if objectGsmData[MOBILE_COLLECTED_MONTH_RX] != nil && objectGsmData[MOBILE_COLLECTED_MONTH_TX] != nil {
            convertedData = convertedDataCountToMb(object: params[3] as! [String : String], downloadObjectName: MOBILE_COLLECTED_MONTH_RX, uploadObjectName: MOBILE_COLLECTED_MONTH_TX)
            dataUsage = "DATA USAGE (MONTH SESSION)"
        }else {
            convertedData[MOBILE_COLLECTED_MONTH_RX] = 0
            convertedData[MOBILE_COLLECTED_MONTH_TX] = 0
            dataUsage = "DATA USAGE"
        }
        var finalDataUsage = calculatedMobileData(object: convertedData)
        let mode = checkWirelessMode(param: paramsObject["mode"]!)
        let chanel = paramsObject["chanel"]
        let ssid = paramsObject["SSID"]
        let encryption = paramsObject["encryption"]
        
        if devicesObject["WirelessClientsCount"] != nil {
            wifiClientsCount = devicesObject["WirelessClientsCount"]!
        } else {
            wifiClientsCount = "N/A"
        }
        if devicesObject["WirelessQuality"] != nil && !(devicesObject["WirelessQuality"] == "") {
            print("kascia", devicesObject["WirelessQuality"])
            wifiQuality = devicesObject["WirelessQuality"]!
        } else {
            wifiQuality = "0"
        }
        if objectGsmData["ConnectionStatus"] != nil {
            connectionUpTime = objectGsmData["ConnectionStatus"]!.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            connectionUpTime = "N/A"
        }
        
        if !(object1["signal"]?.isEmpty)! {
            let index = object1["signal"]?.index((object1["signal"]?.startIndex)!, offsetBy: 1)
        var signalValue = object1["signal"]?.substring(from: index!) as? String
            if signalValue?.isNumeric == true {
                mobileSignalStrength = Double(object1["signal"]!) ?? 0.0
            } else {
                mobileSignalStrength = -112.0
            }
        } else {
            mobileSignalStrength = -112.0
        }
        
        
        let finalMobileConnectionValue = String((112 + mobileSignalStrength))

        
        if object1["operator"] != nil {
            mobileOperatorValue = object1["operator"]!.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            mobileOperatorValue = "N/A"
        }
        if object1["connection"] != nil {
            mobileConnectionValue = object1["connection"]!.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            mobileConnectionValue = "N/A"
        }


        if deviceName.range(of: "RUT9") != nil {
           var simCardState = ""
            
           let selectedSimCard = (UserDefaults.standard.value(forKey: "simcard_value") as? String)?.uppercased()
            
            if devicesObject["SimCardState"] != nil {
                simCardState = devicesObject["SimCardState"]!
            } else {
                simCardState = "N/A"
            }
            completedSimCardState = selectedSimCard! + "(\(simCardState))"
        }
        
        if !mobileConnectionValue.isEmpty {
        } else {
            mobileConnectionValue = "Undefined"
        }
        if connectionUpTime == MOBILE_CONNECTION_CONNECTED {
          completedUpTime = uptimeData(params: params)
        } else {
            completedUpTime = MOBILE_CONNECTION_DISCONNECTED
        }
        
        let mobileRoaming = roamingStatus(params: params)
        let chanelValue = chanel != nil ? "\(chanel!)" : ""
        let modeChannel = "\(mode) / \(chanelValue)"
        var mobileArray = [completedSimCardState, mobileOperatorValue, mobileConnectionValue, mobileRoaming]
        var wirelessArray = ["\(ssid ?? "")", "\(modeChannel)", "\(encryption ?? "")", "\(wifiClientsCount)"]
        var importantStats = [completedUpTime, finalDataUsage, "\(wifiClientsCount)"]
        var importantStatsName = ["CONNECTION UPTIME", dataUsage, "CLIENTS CONNECTED"]
        let signalWords = mobileSignalCheck(strength: mobileSignalStrength)
    //    var signalsArray = [finalMobileConnectionValue, signalWords , wifiQuality]
        let finalValue = [mobileArray, wirelessArray, importantStats, importantStatsName, [finalMobileConnectionValue], [signalWords] , [wifiQuality]]
        return finalValue as! ([[String]])

    }
    
  
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
            resultValue = result.substring(from: index)
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
   
    var object1: [String: String] = [:]
    if !(processedGsmData[0] == "") {
        print("There are objects!")
         object1 = ["signal": processedGsmData[0], "operator": processedGsmData[1], "connection": MainWindowModel().gsmConnectionChecker(processedGsmData: processedGsmData[2] as! String)]
    } else {
         object1 = ["signal": "N/A", "operator": "N/A", "connection": "N/A"]
    }
    
    var objectWifi: [String: String] = [:]
    var objectGsm: [String: String] = [:]
    var objectDevices: [String: String] = [:]
    var array = [Any]()
    
    do {

      if ((wirelessDownloadUploadResult[0] as! String).isNumeric) == true {
        objectWifi[WIRELESS_DOWNLOAD] = (wirelessDownloadUploadResult[0] as! String)
      } else {
        objectWifi[WIRELESS_DOWNLOAD] = "0"
      }
      
      if ((wirelessDownloadUploadResult[1] as! String).isNumeric) == true {
        objectWifi[WIRELESS_UPLOAD] = wirelessDownloadUploadResult[1] as? String
      } else {
        objectWifi[WIRELESS_UPLOAD] = "0"
      }
      
      if ((mobileData[0] ).isNumeric) == true {
        objectGsm[MOBILE_DOWNLOAD] = mobileData[0] 
        
      } else {
        objectGsm[MOBILE_DOWNLOAD] = "0"
      }
        if (mobileData.count > 1) {
      if ((mobileData[1] ).isNumeric) == true {
        objectGsm[MOBILE_UPLOAD] = mobileData[1] 
      } else {
        objectGsm[MOBILE_UPLOAD] = "0"
            }} else {
            objectGsm[MOBILE_UPLOAD] = "0"

        }
      if ((mobileDataArray[2] ).isNumeric) == true {
        objectGsm[MOBILE_COLLECTED_MONTH_RX] = mobileDataArray[2] 
      } else {
        objectGsm[MOBILE_COLLECTED_RX] = mobileDataArray[0] 
      }
      if ((mobileDataArray[3] ).isNumeric) == true {
        objectGsm[MOBILE_COLLECTED_MONTH_TX] = mobileDataArray[3] 
      } else {
        objectGsm[MOBILE_COLLECTED_TX] = mobileDataArray[1] 
      }
      
    } catch {
      DispatchQueue.main.async {
        AlertController.showErrorWith(title: "Parse DeviceData Object", message: "Has Failed", controller: self) {
        }
      }
      
    }
    objectGsm["ConnectionStatus"] = connectionStatus
    objectDevices["MobileDevice"] = DeviceInterface
    objectDevices["WirelessClientsCount"] = String(wirelessClientsCount)
    objectDevices["WirelessQuality"] = wirelessQualityResult
    objectDevices["SimCardState"] = (simcardState).trimmingCharacters(in: .whitespacesAndNewlines)
    var arrayResultWifi = MethodsClass().jsonResultObject(response_data: deviceResult)
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
    array.insert(object1, at: 1)
    array.insert(objectWifi, at: 2)
    array.insert(objectGsm, at: 3)
    let arrayResultMobile = MethodsClass().jsonResultObject(response_data: mobileConnectionUptime)
    array.insert(MainWindowModel().processedMobileInformation(mobileUptime: arrayResultMobile, mobileRoaming: mobileRoaming), at: 4)
    array.insert(objectDevices, at: 5)
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
  
  func processedWirelessInformation (deviceResult: [Any?], wirelessMode: String) -> Dictionary<String,String> {
    var result = ""
    var objectDevices: [String: String] = [:]
    if let information = deviceResult[1] as? Dictionary<String, Any> {
      let chanel = information["channel"]
      let ssid = information["ssid"]
      let bssid = information["bssid"]
      let encryption = MainWindowModel().checkWirelessEncryption(encryption: information["encryption"])
      objectDevices["mode"] = wirelessMode
        if let temp = chanel {
            objectDevices["chanel"] = "\(temp)"
        }
      objectDevices["SSID"] = ssid as? String
      objectDevices["BSSID"] = bssid as? String
      objectDevices["encryption"] = encryption
    }
    return objectDevices
  }
  
  func checkWirelessEncryption(encryption: Any?) -> String {
    var result = ""
    var encryptionLevelUnwrappedResult = ""
    if var information = encryption as? Dictionary<String, Any?> {
      let enabled = information["enabled"] as? Bool
      if enabled == false {
        result = "No encryption"
      }else if enabled == true {
        if (information["wpa"] != nil) {
            var array = (information["wpa"]! as! NSArray).mutableCopy() as! NSMutableArray
          let encryptionLevel = array[0] as? NSNumber
            if let encryptionLevelUnwrapped = encryptionLevel{
                 encryptionLevelUnwrappedResult = "\(encryptionLevelUnwrapped)"
            } else {
                encryptionLevelUnwrappedResult = "Error identifying encryption"
            }
          result = "WPA\(encryptionLevelUnwrappedResult)"
        } else if (information["wep"] != nil) {
          var array = (information["wep"]! as! NSArray).mutableCopy() as! NSMutableArray
            let encryptionLevel = array[0] as? NSNumber
            if let encryptionLevelUnwrapped = encryptionLevel{
                encryptionLevelUnwrappedResult = "\(encryptionLevelUnwrapped)"
            } else {
                encryptionLevelUnwrappedResult = "Error identifying encryption"
            }
            result = "WEP\(encryptionLevelUnwrappedResult)"
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
    }  else if processedGsmData == "N/A" {
        connectionType = "N/A"
    }
    return connectionType
  }
  
  
  public func convertedDataCountToMb (object: [String: String], downloadObjectName: String, uploadObjectName: String) -> [String: Double] {
    var convertedToMb: [String: Double] = [:]
    let mega = 1048576.0
    print(object)
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
    print(convertedToMb)
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
    func uptimeData(params:[Any])-> (String){
        
        var result = 0
        var time = ""
        var years: Int = 0
        var months: Int = 0
        var days: Int = 0
        var hours: Int = 0
        var minutes: Int = 0

        
        var objectUptime = [String:String]()
        var objectDevices = [String:String]()
        
        objectUptime = params[4] as! [String : String]
        objectDevices = params[5] as! [String : String]
        
        var uptime = objectUptime["uptime"] as? Int
        var uptimeDevices = objectUptime["device"]
        
        var mobileDevice = objectDevices["MobileDevice"]
        
        
        if mobileDevice == uptimeDevices {

            if uptime! > 60 {
                if (uptime! / 60) >= 60 {
                    if uptime! / 3600 >= 24 {
                        if uptime! / 86400 >= 30 {
                            if uptime! / 2592000 >= 12 {
                                result = uptime! / 31104000
                                years = roundOffTimeValue(result: Double(result))
                                if years > 1 {
                                    time = "\(years) years"
                                }else {
                                    time = "\(years) year"
                                }
                            } else {
                                result = uptime! / 2592000
                                months = roundOffTimeValue(result: Double(result))
                                if months > 1 {
                                    time = "\(months) months"
                                } else {
                                    time = "\(months) month"
                                }
                            }
                        } else {
                            result = uptime! / 86400
                            days = roundOffTimeValue(result: Double(result))
                            if days > 1 {
                                time = "\(days) days"
                            } else {
                                time = "\(days) day"
                            }
                        }
                    } else {
                        result = uptime! / 3600
                        hours = roundOffTimeValue(result: Double(result))
                        if hours > 1 {
                            time = "\(hours) hours"
                        } else {
                            time = "\(hours) hour"
                        }
                        
                    }
                    
                } else {
                    result = uptime! / 60
                    minutes = roundOffTimeValue(result: Double(result))
                    if minutes > 1 {
                        time = "\(minutes) minutes"
                    } else {
                        time = "\(minutes) minute"
                    }
                }
            } else {
                time = "\(uptime) s"
            }
        } else {
            time = "Device is OFF";
        }
        return time
    }
    
    func roamingStatus(params:[Any])-> (String){
    var result = ""
        var objectDevices = [String:String]()
        objectDevices = params[4] as! [String : String]
        var roamingValue = objectDevices["roaming"]
        if roamingValue == "roaming"{
        result = "Active"
        } else {
            result = "Inactive"
        }
    return result
    }

    func mobileSignalCheck(strength: Double)-> (String) {
        
        var result = ""
        
        if (strength > -52) {
            result = "EXCELLENT"
        } else if (strength > -67) {
            result = "GOOD"
        } else if (strength > -82) {
            result = "OK"
        } else if (strength > -97) {
            result = "POOR"
        } else if (strength > -112) {
            result = "WEAK"
        } else if (strength <= -112) {
            result = "NO SIGNAL"
        }
        
        return result
    }
    
    func roundOffTimeValue(result : Double)-> (Int) {

        let fractionalPart: Double = result.truncatingRemainder(dividingBy: 1)
        let timeCount: Double = result - fractionalPart
        let timeValue = String(timeCount)
        var token = timeValue.components(separatedBy: ".")
        let intToken: Int = Int(token[0])!
        return intToken
    }
    
    
    func checkWirelessMode(param: String)-> (String) {
        var result = ""
        if param == "ap" {
            result = "Access Point (\(param.uppercased()))"
        }else {
            result = "STA"
        }
        return result
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
