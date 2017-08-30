//
//  Rut8xxServicesGetDataModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 09/08/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Rut8xxServicesGetDataModel: UIViewController {

    
    private static let NTP_CLIENT = "NtpClient"
    private static let  PING_REBOOT = "PingReboot"
    private static let  DDNS = "Ddns"
    private static let SITE_BLOCKING = "SiteBlocking"
    private static let SMS_UTILS_RULES = "SmsUtilsRules"
    private static let HOTSPOT = "Hotspot"
    
    let enabledCapital = "Enabled", disabledCapital = "Disabled", noDataCapital = "No data"

    let ntpConfig = "ntpclient", pingRebootConfig = "ping_reboot",
    hostblockConfig = "hostblock"
    
    let  ntpClientSection = "@ntpclient[0]", pingRebootSection = "@ping_reboot[0]",
    hostblockConfigSection = "config"
    
    let enabledOption = "enabled", enableOption = "enable";
    
    let ddnsEnabledCommand = "uci show ddns | grep 'enabled='",
    hotspotsCommand = "uci show coovachilli | grep 'hotspot' | grep 'enabled='",
    smsUtilsRulesCommand = "uci show sms_utils | grep 'rule' | grep 'enabled='"
    
    internal func routerServicesModel (complete: @escaping ([String])->()){
        let token = UserDefaults.standard.value(forKey: "saved_token")

        Json().deviceinform(token: token as! String, config: ntpConfig, section: ntpClientSection, option: enabledOption) { (json) in
            MethodsClass().getJsonValue(response_data: json){ (ntpClientEnableValue) in
                let finalNtpClientEnableValue = self.checkResultValue(receicedData: ntpClientEnableValue)
                Json().deviceinform(token: token as! String, config: self.pingRebootConfig, section: self.pingRebootSection, option: self.enableOption) { (json) in
                    MethodsClass().getJsonValue(response_data: json){ (pingRebootValue) in
                        let finalPingRebootValue = self.checkResultValue(receicedData: pingRebootValue)
                        Json().fileExec2Comm(token: token as! String, command: self.ddnsEnabledCommand) { (ddnsEnabledValueM) in
                            let ddnsEnabledValue = self.checkResultValue(receicedData: self.checkForStdout(receivedData: ddnsEnabledValueM))
                
                            Json().deviceinform(token: token as! String, config: self.hostblockConfig, section: self.hostblockConfigSection, option: self.enabledOption) { (json) in
                                MethodsClass().getJsonValue(response_data: json){ (siteBlockingValue) in
                                    let finalSiteBlockingValue = self.checkResultValue(receicedData: siteBlockingValue)
                                    
                                    Json().fileExec2Comm(token: token as! String, command: self.smsUtilsRulesCommand) { (smsUtilsRulesValueM) in
                                        let smsUtilsRulesValue = self.checkResultValue(receicedData: self.checkForStdout(receivedData: smsUtilsRulesValueM))
                                        
                                        Json().fileExec2Comm(token: token as! String, command: self.hotspotsCommand) { (hotspotsEnabledValueM) in
                                            let hotspotsEnabledValue = self.checkResultValue(receicedData: self.checkForStdout(receivedData: hotspotsEnabledValueM))
                                            
                                        var serversStatus = [finalNtpClientEnableValue, finalPingRebootValue, ddnsEnabledValue, finalSiteBlockingValue, smsUtilsRulesValue, hotspotsEnabledValue]
                                            
                                            complete(serversStatus)
                                            
                                        }
                                    }
                                }}
                    }}
            }}

    }
    }
    
    
    func checkForStdout(receivedData: Any?)-> (String) {
        var result = ""
        if let jsonDic = receivedData as? JSON {
            if jsonDic["result"][1]["stdout"].exists() {
                MethodsClass().processJsonStdoutOutput(response_data: receivedData){ (result) in
                    UserDefaults.standard.set(result, forKey: "temp")
                }
                result = (UserDefaults.standard.value(forKey: "temp") as! String).trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                result = "0"
            }
        } else {
            print("Error checking Stdout")
        }
        return result
    }
    
    func checkResultValue (receicedData: String)-> (String) {
        var result = ""
        if !receicedData.isEmpty {
            if receicedData.range(of: "=0") != nil || receicedData == "0" {
                result = disabledCapital
            } else if receicedData.range(of: "=1") != nil || receicedData == "1" {
                result = enabledCapital
            }
        } else {
            result = noDataCapital
        }
        return result
    }
    
}
