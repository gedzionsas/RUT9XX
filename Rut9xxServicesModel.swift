//
//  Rut9xxServicesModelViewController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 29/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit
import SwiftyJSON

class Rut9xxServicesModel: UIViewController {
    let checkInOut = "uci get hwinfo.hwinfo.in_out",
    checkGps = "uci get hwinfo.hwinfo.gps"
    
    
    let enabledCapital = "Enabled", disabledCapital = "Disabled", noDataCapital = "No data"
    
    internal func routerServicesModel (complete: @escaping ([String])->()){
        let token = UserDefaults.standard.value(forKey: "saved_token")
        
        let vrrpdConfig = "vrrpd",
        snmpdConfig = "snmpd",
        ntpConfig = "ntpclient",
        pingRebootConfig = "ping_reboot",
        inputOutputConfig = "ioman",
        hostblockConfig = "hostblock",
        privoxyConfig = "privoxy",
        coovachilliConfig = "coovachilli",
        vid1Section = "vid1",
        snmpdAgentSection = "@agent[0]",
        snmpdTrapSection = "@trap[0]",
        ntpClientSection = "@ntpclient[0]",
        pingRebootSection = "@ping_reboot[0]",
        hostblockConfigSection = "config",
        privoxySection = "privoxy",
        ftpCoovachilliSection = "ftp",
        enabledOption = "enabled",
        trapEnabledOption = "trap_enabled",
        enableOption = "enable",
        openVpnServersCommand = "uci show openvpn | grep  'server_' | grep 'enable='",
        openVpnClientCommand = "uci show openvpn | grep  'client_' | grep 'enable='",
        ipSecCommand = "uci show strongswan | grep 'enabled='",
        ddnsEnabledCommand = "uci show ddns | grep 'enabled='",
        gpsEnabledCommand = "uci show gps | grep 'enabled='",
        hotspotsCommand = "uci show coovachilli | grep 'hotspot' | grep 'enabled='",
        inputOutputRulesCommand = "uci show ioman | grep 'rule' | grep 'enabled='",
        smsUtilsRulesCommand = "uci show sms_utils | grep 'rule' | grep 'enabled='",
        greTunnelCommand = "uci show gre_tunnel | grep 'enabled='",
        qosCommand = "uci show qos | grep 'enabled='"
        
        
        
        
        
        Json().deviceinform(token: token as! String, config: vrrpdConfig, section: vid1Section, option: enabledOption) { (json) in
            MethodsClass().getJsonValue(response_data: json){ (result) in
                let vrrpLanValue =  self.checkResultValue(receicedData: (result))
                Json().fileExec2Comm(token: token as! String, command: openVpnServersCommand) { (json) in
                    let openVPNServersValue = self.checkResultValue(receicedData: (self.checkForStdout(receivedData: json)))
                    Json().fileExec2Comm(token: token as! String, command: openVpnClientCommand) { (json) in
                        let openVpnClientValue = self.checkResultValue(receicedData: (self.checkForStdout(receivedData: json)))
                        Json().deviceinform(token: token as! String, config: snmpdConfig, section: snmpdAgentSection, option: enabledOption) { (snmpdJson) in
                            MethodsClass().getJsonValue(response_data: snmpdJson){ (snmpdResult) in
                                let snmpAgentsValue =  self.checkResultValue(receicedData: (snmpdResult))
                                Json().deviceinform(token: token as! String, config: snmpdConfig, section: snmpdTrapSection, option: trapEnabledOption) { (snmpdTrapJson) in
                                    MethodsClass().getJsonValue(response_data: snmpdTrapJson){ (snmpdTrapResult) in
                                        let snmpTrapValue =  self.checkResultValue(receicedData: (snmpdTrapResult))
                                        Json().deviceinform(token: token as! String, config: ntpConfig, section: ntpClientSection, option: enabledOption) { (ntpClientJson) in
                                            MethodsClass().getJsonValue(response_data: ntpClientJson){ (ntpClientResult) in
                                                let ntpClientValue =  self.checkResultValue(receicedData: (ntpClientResult))
                                                
                                                Json().fileExec2Comm(token: token as! String, command: ipSecCommand) { (ipSecJson) in
                                                    let ipSecValue = self.checkResultValue(receicedData: (self.checkForStdout(receivedData: ipSecJson)))
                                                    Json().deviceinform(token: token as! String, config: pingRebootConfig, section: pingRebootSection, option: enableOption) { (pingRebootJson) in
                                                        MethodsClass().getJsonValue(response_data: pingRebootJson){ (pingRebootValue) in
                                                            let pingReboot =  self.checkResultValue(receicedData: (pingRebootValue))
                                                            Json().fileExec2Comm(token: token as! String, command: inputOutputRulesCommand) { (rulesEnabledJson) in
                                                                let rulesEnabledValue = self.checkResultValue(receicedData: (self.checkForStdout(receivedData: rulesEnabledJson)))
                                                                Json().fileExec2Comm(token: token as! String, command: ddnsEnabledCommand) { (ddnsEnabledJson) in
                                                                    let ddnsEnabledValue = self.checkResultValue(receicedData: (self.checkForStdout(receivedData: ddnsEnabledJson)))
                                                                    
                                                                    Json().deviceinform(token: token as! String, config: hostblockConfig, section: hostblockConfigSection, option: enabledOption) { (siteBlockingJson) in
                                                                        MethodsClass().getJsonValue(response_data: siteBlockingJson) { (siteBlockingValue) in
                                                                            let siteBlocking = self.checkResultValue(receicedData: (siteBlockingValue))
                                                                            Json().deviceinform(token: token as! String, config: privoxyConfig, section: privoxySection, option: enabledOption) { (contentBlockerJson) in
                                                                                MethodsClass().getJsonValue(response_data: contentBlockerJson) { (contentBlockerValue) in
                                                                                    let contentBlocker = self.checkResultValue(receicedData: (contentBlockerValue))
                                                                                    
                                                                                    Json().fileExec2Comm(token: token as! String, command: smsUtilsRulesCommand) { (smsUtilsRulesJson) in
                                                                                        let smsUtilsRulesValue = self.checkResultValue(receicedData: (self.checkForStdout(receivedData: smsUtilsRulesJson)))
                                                                                        
                                                                                        Json().fileExec2Comm(token: token as! String, command: hotspotsCommand) { (hotspotsEnabledJson) in
                                                                                            let hotspotsEnabledValue = self.checkResultValue(receicedData: (self.checkForStdout(receivedData: hotspotsEnabledJson)))
                                                                                            Json().deviceinform(token: token as! String, config: coovachilliConfig, section: ftpCoovachilliSection, option: enabledOption) { (hotspotLoggingJson) in
                                                                                                MethodsClass().getJsonValue(response_data: hotspotLoggingJson) { (hotspotLogging) in
                                                                                                    let hotspotLogg = self.checkResultValue(receicedData: (hotspotLogging))
                                                                                                    Json().fileExec2Comm(token: token as! String, command: greTunnelCommand) { (greTunnelJson) in
                                                                                                        let greTunnelValue = self.checkResultValue(receicedData: (self.checkForStdout(receivedData: greTunnelJson)))
                                                                                                        
                                                                                                        Json().fileExec2Comm(token: token as! String, command: qosCommand) { (qosJson) in
                                                                                                            let qosValue = self.checkResultValue(receicedData: (self.checkForStdout(receivedData: qosJson)))
                                                                                                            
                                                                                                            Json().fileExec2Comm(token: token as! String, command: gpsEnabledCommand) { (gpsEnabledJson) in
                                                                                                                let gpsEnabledValue = self.checkResultValue(receicedData: (self.checkForStdout(receivedData: gpsEnabledJson)))
                                                                                                                
                                                                                                                var serversStatus = [vrrpLanValue, openVPNServersValue, openVpnClientValue, snmpAgentsValue, snmpTrapValue, ntpClientValue, ipSecValue, pingReboot, rulesEnabledValue, ddnsEnabledValue, siteBlocking, contentBlocker, smsUtilsRulesValue, hotspotsEnabledValue, hotspotLogg, greTunnelValue, qosValue, gpsEnabledValue]
                                                                                                                //      UserDefaults.standard.setValue(serversStatus, forKey: "routerservices_array")
                                                                                                                
                                                                                                                //  var originalState: [String] = UserDefaults.standard.value(forKey: "routerservices_array") as! [String]
                                                                                                                
                                                                                                                
                                                                                                                print("dsa", result, openVPNServersValue, openVpnClientValue, snmpdResult, snmpdTrapResult, ntpClientResult, ipSecValue, pingRebootValue, rulesEnabledValue, ddnsEnabledValue, siteBlockingValue, contentBlockerValue, smsUtilsRulesValue, hotspotsEnabledValue, hotspotLogging, greTunnelValue, qosValue, gpsEnabledValue)
                                                                                                                
                                                                                                                
                                                                                                                
                                                                                                                
                                                                                                                self.checkServices(){ (gpsEnabledJson) in
                                                                                                                    UserDefaults.standard.setValue(gpsEnabledJson, forKey: "routerservices_status")
                                                                                                                }
                                                                                                                
                                                                                                                
                                                                                                                complete(serversStatus)
                                                                                                            }}}}}}}}}}}}}}}}}}
                                    }}}}}}}
            
        }
        
    }
    // check If roeter got services
    
    func checkServices(complete: @escaping (Bool)->()){
        var result: Bool = true
        Json().fileExec2Comm(token: UserDefaults.standard.value(forKey: "saved_token") as! String, command: checkInOut) { (checkServicesInOut) in
            MethodsClass().processJsonStdoutOutput(response_data: checkServicesInOut){ (resultInOut) in
                
                Json().fileExec2Comm(token: UserDefaults.standard.value(forKey: "saved_token") as! String, command: self.checkGps) { (checkServicesGPS) in
                    MethodsClass().processJsonStdoutOutput(response_data: checkServicesGPS){ (resultGps) in
                        if resultInOut.trimmingCharacters(in: .whitespacesAndNewlines) == "0" && resultGps.trimmingCharacters(in: .whitespacesAndNewlines) == "0" {
                            result = false
                            complete(result)
                        } else {
                            result = true
                            complete(result)
                        }
                    }
                }
            }
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
    
    func performRut9xxServicesRestartTask() {
        Rut9xxServicesRestartTask().routerRestartModel(params: "1") { () in
        }
        
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
