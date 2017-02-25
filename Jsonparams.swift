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
  static func fileExec2Command(token: String, command: String) -> [String:Any] {
    
    let fileExec2: [String : Any] = ["jsonrpc": "2.0",
                                     "id": 1,
                                     "method": "call",
                                     "params": [ token, "file", "exec2", [ "command": command]
      ]]
    return fileExec2
  }
  static func gsmDeviceDataRequest(token: String, command: String, parameter : String) -> [String:Any] {
    
    let deviceParam: [String : Any] = ["jsonrpc": "2.0",
                                       "id": 1,
                                       "method": "call",
                                       "params": [ token, "file", "exec", [ "command": command, "params": [parameter]]
      ]]
    
    return deviceParam
  }
  static func mobileConnectionUptime(token: String, param1: String, param2 : String) -> [String:Any] {
    
    let connectionUptime: [String : Any] = ["jsonrpc": "2.0",
                                       "id": 1,
                                       "method": "call",
                                       "params": [ token, "network.interface.wan", "status", [:]]
  ]
    return connectionUptime
  }
  
}


