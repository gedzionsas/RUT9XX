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
    private static let WIFI_SSID = "wifi_ssid"
    private static let WIRELESS_DEVICE = "wireless_device"
    private static let DEVICE_RESULT = "device_result"
    private static let WIRELESSDOWNLOADUPLOAD_RESULT = "wirelessdownloadupload_result"
    private static let WIRELESSCLIENTS_COUNT = "wirelessclients_count"
    private static let WIRELESS_MODE = "wireless_mode"
    private static let MODULEVID_VALUE = "modulevid_value"
    private static let MODULEPID_VALUE = "modulepid_value"
    private static let WIRELESSQUALITY_RESULT = "wirelessquality_result"
    private static let RX_DATA = "rx_data"
    private static let TX_DATA = "tx_data"
    private static let RXMONTH_DATA = "rxmonth_data"
    private static let TXMONTH_DATA = "txmonth_data"
    private static let ARR_DATA = "arr_data"
    private static let DISPLAY_DATA = "display_data"
    private static let DEVICEFIRMWARE_NUMBER = "devicefirmware_number"
    private static let FW_INFORMATION = "fwinformation"
    private static let FW_VALUE = "fwValue"
    private static let FWUPDATE_ARRAY = "fwupdate_array"
    private static let DEVICESERIAL_NUMBER = "deviceserial_number"
    private static let DEVICEIMEI_NUMBER = "deviceimei_number"
    private static let DEVICELANMAC_NUMBER = "devicelanmac_number"
    private static let ROUTERDETAILS_ARRAY = "routerdetails_array"
    private static let TEMP = "temp"
    private static let ROUTERSERVICES_ARRAY = "routerservices_array"
    private static let ROUTERSERVICES_STATUS = "routerservices_status"
    private static let SETNEWROUTER_PASSWORD = "routernew_password"
    private static let MOBILEDETAILS_ARRAY = "mobiledetails_array"
    private static let WIRELESSDETAILS_ARRAY = "wirelessdetails_array"
    
    static var setWirelessDetailsArray: String {
        get {
            return UserDefaults.standard.string(forKey: WIRELESSDETAILS_ARRAY)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: WIRELESSDETAILS_ARRAY)
        }
    }
    static var setMobileDetailsArray: String {
        get {
            return UserDefaults.standard.string(forKey: MOBILEDETAILS_ARRAY)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: MOBILEDETAILS_ARRAY)
        }
    }
    static var setRouterNewPassword: String {
        get {
            return UserDefaults.standard.string(forKey: SETNEWROUTER_PASSWORD)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SETNEWROUTER_PASSWORD)
        }
    }
    static var setRouterServicesStatus: String {
        get {
            return UserDefaults.standard.string(forKey: ROUTERSERVICES_STATUS)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ROUTERSERVICES_STATUS)
        }
    }
    static var setRouterServicesArray: String {
        get {
            return UserDefaults.standard.string(forKey: ROUTERSERVICES_ARRAY)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ROUTERSERVICES_ARRAY)
        }
    }
    static var setTemp: String {
        get {
            return UserDefaults.standard.string(forKey: TEMP)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: TEMP)
        }
    }
    static var setRouterDetailsArray: String {
        get {
            return UserDefaults.standard.string(forKey: ROUTERDETAILS_ARRAY)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ROUTERDETAILS_ARRAY)
        }
    }
    static var setDeviceLanMacNumber: String {
        get {
            return UserDefaults.standard.string(forKey: DEVICELANMAC_NUMBER)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: DEVICELANMAC_NUMBER)
        }
    }
    static var setDeviceImeiNumber: String {
        get {
            return UserDefaults.standard.string(forKey: DEVICEIMEI_NUMBER)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: DEVICEIMEI_NUMBER)
        }
    }
  static var setDeviceSerialNumber: String {
        get {
            return UserDefaults.standard.string(forKey: DEVICESERIAL_NUMBER)!
        }
        set {
            UserDefaults.standard.set(newValue, forKey: DEVICESERIAL_NUMBER)
        }
    }
  static var setFwUpdateArray: String {
    get {
      return UserDefaults.standard.string(forKey: FWUPDATE_ARRAY)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: FWUPDATE_ARRAY)
    }
  }
  static var setFwValue: String {
    get {
      return UserDefaults.standard.string(forKey: FW_VALUE)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: FW_VALUE)
    }
  }
  static var setDeviceFirmwareInformation: String {
    get {
      return UserDefaults.standard.string(forKey: FW_INFORMATION)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: FW_INFORMATION)
    }
  }
  static var setDeviceFirmwareNumber: String {
    get {
      return UserDefaults.standard.string(forKey: DEVICEFIRMWARE_NUMBER)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: DEVICEFIRMWARE_NUMBER)
    }
  }
  static var setDisplayData: String {
    get {
      return UserDefaults.standard.string(forKey: DISPLAY_DATA)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: DISPLAY_DATA)
    }
  }
  static var setArrData: String {
    get {
      return UserDefaults.standard.string(forKey: ARR_DATA)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: ARR_DATA)
    }
  }
  static var setRxMonthData: String {
    get {
      return UserDefaults.standard.string(forKey: RXMONTH_DATA)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: RXMONTH_DATA)
    }
  }
  static var setTxMonthData: String {
    get {
      return UserDefaults.standard.string(forKey: TXMONTH_DATA)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: TXMONTH_DATA)
    }
  }
  static var setTxData: String {
    get {
      return UserDefaults.standard.string(forKey: TX_DATA)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: TX_DATA)
    }
    
  }
  static var setWirelessQualityResult: String {
    get {
      return UserDefaults.standard.string(forKey: WIRELESSQUALITY_RESULT)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: WIRELESSQUALITY_RESULT)
    }
    
  }
  static var setModulePidValue: String {
    get {
      return UserDefaults.standard.string(forKey: MODULEPID_VALUE)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: MODULEPID_VALUE)
    }
    
  }
  static var setModuleVidValue: String {
    get {
      return UserDefaults.standard.string(forKey: MODULEVID_VALUE)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: MODULEVID_VALUE)
    }
    
  }
  static var setWirelessMode: String {
    get {
      return UserDefaults.standard.string(forKey: WIRELESS_MODE)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: WIRELESS_MODE)
    }
    
  }
  static var setWirelessClientsCount: String {
    get {
      return UserDefaults.standard.string(forKey: WIRELESSDOWNLOADUPLOAD_RESULT)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: WIRELESSDOWNLOADUPLOAD_RESULT)
    }
    
  }
  static var setWirelessDownloadUploadResult: String {
    get {
      return UserDefaults.standard.string(forKey: WIRELESSDOWNLOADUPLOAD_RESULT)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: WIRELESSDOWNLOADUPLOAD_RESULT)
    }
    
  }
  static var setDeviceResult: String {
    get {
      return UserDefaults.standard.string(forKey: DEVICE_RESULT)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: DEVICE_RESULT)
    }
    
  }
  static var setWirelessDevice: String {
    get {
      return UserDefaults.standard.string(forKey: WIRELESS_DEVICE)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: WIRELESS_DEVICE)
    }
  }
  static var setWifiSSID: String {
    get {
      return UserDefaults.standard.string(forKey: WIFI_SSID)!
    }
    set {
      UserDefaults.standard.set(newValue, forKey: WIFI_SSID)
    }
  }
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
