//
//  UserDefaults.swift
//  bandymasAlam
//
//  Created by Gedas Urbonas on 24/01/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation



class UserDefaultsManager {
    
    private static let SAVED_TOKEN = "saved_token"
    private static let SAVED_USERNAME = "saved_username"
    private static let SAVED_PASSWORD = "saved_password"
    private static let SAVE_PASSWORD = "save_password"
    private static let DEVICE_NAME = "device_name"
    private static let DEVICE_INTERFACE = "device_interface"
    private static let SIMCARD_VALUE = "simcard_value"
    private static let SIMCARD_STATE = "simcard_state"
    private static let PROCESSEDGSM_DATA = "processedgsm_data"
    private static let MOBILE_DATA = "mobile_data"
    private static let MOBILEROAMING_DATASTATUS = "mobileroaming_datastatus"
    private static let CONNECTION_STATUS = "connection_status"
    private static let MOBILECONNECTION_UPTIME = "mobileconnection_uptime"

  static var setMobileConnectionUptime: String {
    get {
      return UserDefaults.standard.string(forKey: MOBILECONNECTION_UPTIME)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: MOBILECONNECTION_UPTIME)
    }
  }
  static var setConnectionStatus: String {
    get {
      return UserDefaults.standard.string(forKey: CONNECTION_STATUS)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: CONNECTION_STATUS)
    }
  }
  static var setMobileRoamingDataStatus: String {
    get {
      return UserDefaults.standard.string(forKey: MOBILEROAMING_DATASTATUS)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: MOBILEROAMING_DATASTATUS)
    }
  }
  static var setMobileData: String {
    get {
      return UserDefaults.standard.string(forKey: MOBILE_DATA)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: MOBILE_DATA)
    }
  }
  static var setProcessedGsmData: String {
    get {
      return UserDefaults.standard.string(forKey: PROCESSEDGSM_DATA)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: PROCESSEDGSM_DATA)
    }
  }
  static var setSimCardState: String {
    get {
      return UserDefaults.standard.string(forKey: SIMCARD_STATE)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: SIMCARD_STATE)
    }
  }
  static var setSimCardValue: String {
    get {
      return UserDefaults.standard.string(forKey: SIMCARD_VALUE)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: SIMCARD_VALUE)
    }
  }
    static var setDeviceInterface: String {
        get {
            return UserDefaults.standard.string(forKey: DEVICE_INTERFACE)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: DEVICE_INTERFACE)
        }
    }
    
    static var setDeviceName: String {
        get {
            return UserDefaults.standard.string(forKey: DEVICE_NAME)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: DEVICE_NAME)
        }
    }
    
    static var setSavePasswordValue: String {
        get {
            return UserDefaults.standard.string(forKey: SAVE_PASSWORD)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SAVE_PASSWORD)
        }
    }
    
    static var setSaved_Token: String {
        get {
            return UserDefaults.standard.string(forKey: SAVED_TOKEN)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SAVED_TOKEN)
        }
    }
    
    
    static var setSaved_Username: String {
        get {
            return UserDefaults.standard.string(forKey: SAVED_USERNAME)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SAVED_USERNAME)
        }
    }
    static var setSaved_password: String {
        get {
            return UserDefaults.standard.string(forKey: SAVED_PASSWORD)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SAVED_PASSWORD)
        }
    }
    
}
