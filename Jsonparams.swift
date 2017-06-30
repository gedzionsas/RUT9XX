//
//  Jsonparams.swift
//  bandymasAlam
//
//  Created by Gedas Urbonas on 25/01/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class JsonRequests {
  static let loginToken = "00000000000000000000000000000000"
  
  static func loginRequest(userName: String, password: String) -> [String:Any] {
    
    let loginparam: [String : Any] = ["jsonrpc": "2.0",
                                      "id": 1,
                                      "method": "call",
                                      "params": [ self.loginToken, "session", "login", [ "username": userName, "password": password]]
    ]
    
    return loginparam
  }
  
  static func getInformationFromConfig(token: String, config: String, section : String, option: String) -> [String:Any] {
    
    let getInformationFromConfigparam: [String : Any] = ["jsonrpc": "2.0",
                                                         "id": 1,
                                                         "method": "call",
                                                         "params": [ token, "uci", "get", [ "config": config, "section": section, "option": option]]
    ]
    
    return getInformationFromConfigparam
  }
  
  static func aboutDeviceParam(token: String, command: String, parameter : String) -> [String:Any] {
    
    let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                       "id": 1,
                                       "method": "call",
                                       "params": [ token, "file", "exec", [ "command": command, "params": [parameter]]
      ]]
    
    return deviceParam
  }
    static func getOperatorsInformation(token: String) -> [String:Any] {
        
        let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                           "id": 1,
                                           "method": "call",
                                           "params": [ token, "file", "exec", [ "command": "/sbin/get_operators"]
            ]]
        
        return deviceParam
    }
    static func simPinCheckRequest(token: String, simPin: String) -> [String:Any] {
        
        let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                           "id": 1,
                                           "method": "call",
                                           "params": [ token, "file", "exec", [ "command": "gsmctl", "params": ["-A", "AT+CPIN=\(simPin)"]]
            ]]
        
        return deviceParam
    }
  static func downloadFirmware(token: String) -> [String:Any] {
    
    let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                       "id": 1,
                                       "method": "call",
                                       "params": [ token, "file", "exec", [ "command": "/usr/sbin/auto_update.sh", "params": ["get", "0"]]
      ]]
    
    return deviceParam
  }
    
    static func setInformationToConfig(token: String, config: String, section: String, configsOption: String, value: String) -> [String:Any] {
        
        let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                           "id": 1,
                                           "method": "call",
                                           "params": [ token, "uci", "set", [ "config": config, "section": section, "values": [configsOption: value]]
            ]]
        
        return deviceParam
    }
    static func setWirelessWpaEncryptionPassword2(token: String, value: String, currentWirelessSSID: String, passwordKey: String) -> [String:Any] {
        
        let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                           "id": 1,
                                           "method": "call",
                                           "params": [ token, "uci", "set", [ "config": "wireless", "type": "wifi-iface", "match": ["ssid": currentWirelessSSID], "values": ["encryption": value, "key": passwordKey]]
            ]]
        
        return deviceParam
    }
    static func setNotRequiredWirelessPassword(token: String, currentWirelessSSID: String) -> [String:Any] {
        
        let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                           "id": 1,
                                           "method": "call",
                                           "params": [ token, "uci", "set", [ "config": "wireless", "type": "wifi-iface", "match": ["ssid": currentWirelessSSID], "values": ["encryption": "none"
                                            ]]
            ]]
        
        return deviceParam
    }

    static func setWirelessWpaEncryptionPassword(token: String, value: String, passwordKey: String) -> [String:Any] {
        
        let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                           "id": 1,
                                           "method": "call",
                                           "params": [ token, "uci", "set", [ "config": "wireless", "type": "wifi-iface", "values": ["encryption": value, "key": passwordKey]]
            ]]
        
        return deviceParam
    }
    static func setSimCardApn(token: String, simCardNumber: String, apnValue: String, value: String) -> [String:Any] {
        
        let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                           "id": 1,
                                           "method": "call",
                                           "params": [ token, "uci", "set", [ "config": "simcard", "type": simCardNumber, "values": [value: apnValue]]
            ]]
        
        return deviceParam
    }
    
    static func setWirelessSSID(token: String, value: String) -> [String:Any] {
        
        let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                           "id": 1,
                                           "method": "call",
                                           "params": [ token, "uci", "set", [ "config": "wireless", "type": "wifi-iface", "values": ["ssid": value]]
            ]]
        
        return deviceParam
    }
    
    static func deleteConfigsOption(token: String, config: String, section: String, configsOption: String) -> [String:Any] {
        
        let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                           "id": 1,
                                           "method": "call",
                                           "params": [ token, "uci", "delete", [ "config": config, "section": section, "options": [configsOption]]
            ]]
        
        return deviceParam
    }
    
    static func commitConfigChanges(token: String, config: String) -> [String:Any] {
        
        let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                           "id": 1,
                                           "method": "call",
                                           "params": [ token, "uci", "commit", [ "config": config]
            ]]
        
        return deviceParam
    }
    
    static func luciReloadAfterChanges(token: String) -> [String:Any] {
        
        let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                           "id": 1,
                                           "method": "call",
                                           "params": [ token, "file", "exec", [ "command": "luci-reload"]
            ]]
        
        return deviceParam
    }
    
    
  static func aboutDeviceParam1(token: String, command: String, parameter : String) -> [String:Any] {
    
    let deviceParam1: [String : Any] = ["jsonrpc": "2.0",
                                       "id": 1,
                                       "method": "call",
                                       "params": [ token, "file", "exec", [ "command": "gsmctl", "params": ["-r" + command + ", ", "-e" + parameter ]]
]]
    
    return deviceParam1
  }
  static func updateNewFirmware(token: String) -> [String:Any] {
    
    let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                        "id": 1,
                                        "method": "call",
                                        "params": [ token, "file", "exec", [ "command": "sysupgrade", "params": ["-d", "3", "-n", "/tmp/firmware.img" ]]
      ]]
    
    return deviceParam
  }

  static func aboutDeviceParam2(token: String, deviceInterface: String, parameter : String) -> [String:Any] {
    
    let deviceParam2: [String : Any] = ["jsonrpc": "2.0",
                                        "id": 1,
                                        "method": "call",
                                        "params": [ token, "file", "exec", [ "command": "gsmctl", "params": ["-q", "-o", "-t", "-p" + deviceInterface ]]
      ]]
    
    return deviceParam2
  }
  static func fileExec2Command(token: String, command: String) -> [String:Any] {
    
    let fileExec2: [String : Any] = ["jsonrpc": "2.0",
                                     "id": 1,
                                     "method": "call",
                                     "params": [ token, "file", "exec2", [ "command": command]
      ]]
    return fileExec2
  }
    static func setRouterPassword(token: String, password: String) -> [String:Any] {
        
        let info: [String : Any] = ["jsonrpc": "2.0",
                                         "id": 1,
                                         "method": "call",
                                         "params": [ token, "file", "exec2", [ "command": "(echo '\(password)'; sleep 1; echo '\(password)') | passwd 'root'"]
            ]]
        return info
    }
    static func startSpeedTest(token: String, fileValue: Int) -> [String:Any] {
        
        let fileExec2: [String : Any] = ["jsonrpc": "2.0",
                                         "id": 1,
                                         "method": "call",
                                         "params": [ token, "file", "exec2", [ "command": "speedtest \(fileValue) &"]
            ]]
        return fileExec2
    }
    static func readSpeedTestFile(token: String, fileValue: Int) -> [String:Any] {
        
        let fileExec2: [String : Any] = ["jsonrpc": "2.0",
                                         "id": 1,
                                         "method": "call",
                                         "params": [ token, "file", "read", [ "path": "/tmp/speedtest\(fileValue)"]
            ]]
        return fileExec2
    }
  static func firmawareInformation(token: String, param1: String, param2: String) -> [String:Any] {
    
    let firmwareInfo: [String : Any] = ["jsonrpc": "2.0",
                                     "id": 1,
                                     "method": "call",
                                     "params": [ token, "file", param1, [ "path": param2]
      ]]
    return firmwareInfo
  }
  static func mobileConnectionUptime(token: String, param1: String, param2 : String) -> [String:Any] {
    
    let connectionUptime: [String : Any] = ["jsonrpc": "2.0",
                                       "id": 1,
                                       "method": "call",
                                       "params": [ token, "network.interface.wan", "status", [:]]
  ]
    return connectionUptime
  }
  static func requestForWirelessDetails(token: String, param1: String, param2: String) -> [String:Any] {
    
    let wirelessParms: [String : Any] = ["jsonrpc": "2.0",
                                     "id": 1,
                                     "method": "call",
                                     "params": [ token, "iwinfo", param1, [ "device": param2]
      ]]
    return wirelessParms
  }
  
}


