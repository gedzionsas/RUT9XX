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

    internal func routerServicesModel (complete: @escaping (String)->()){
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
        Json().fileExec2Comm(token: token as! String, command: openVpnServersCommand) { (json) in
           var openVPNServersValue = self.checkForStdout(receivedData: json)
        Json().fileExec2Comm(token: token as! String, command: openVpnClientCommand) { (json) in
            var openVpnClientValue = self.checkForStdout(receivedData: json)
            
        Json().deviceinform(token: token as! String, config: snmpdConfig, section: snmpdAgentSection, option: enabledOption) { (snmpdJson) in
                MethodsClass().getJsonValue(response_data: snmpdJson){ (snmpdResult) in
        Json().deviceinform(token: token as! String, config: snmpdConfig, section: snmpdTrapSection, option: trapEnabledOption) { (snmpdTrapJson) in
                MethodsClass().getJsonValue(response_data: snmpdTrapJson){ (snmpdTrapResult) in
        Json().deviceinform(token: token as! String, config: ntpConfig, section: ntpClientSection, option: enabledOption) { (ntpClientJson) in
                MethodsClass().getJsonValue(response_data: ntpClientJson){ (ntpClientResult) in
        Json().fileExec2Comm(token: token as! String, command: ipSecCommand) { (ipSecJson) in
            var ipSecValue = self.checkForStdout(receivedData: ipSecJson)
        
        Json().deviceinform(token: token as! String, config: pingRebootConfig, section: pingRebootSection, option: enabledOption) { (pingRebootJson) in
                MethodsClass().getJsonValue(response_data: pingRebootJson){ (pingRebootValue) in
        Json().fileExec2Comm(token: token as! String, command: inputOutputRulesCommand) { (rulesEnabledJson) in
            var rulesEnabledValue = self.checkForStdout(receivedData: rulesEnabledJson)
            
        Json().fileExec2Comm(token: token as! String, command: ddnsEnabledCommand) { (ddnsEnabledJson) in
            var ddnsEnabledValue = self.checkForStdout(receivedData: ddnsEnabledJson)
            print("edc", ddnsEnabledValue)
                        complete(result)

            }}}}}}}}}
            }}}}}

        }
        
    }
    
    func checkForStdout(receivedData: Any?)-> (String) {
        var result = " "
        print("dd", receivedData)
        if let jsonDic = receivedData as? JSON {
            if (jsonDic["stdout"].exists()){
                MethodsClass().processJsonStdoutOutput(response_data: receivedData){ (result) in
                print(result)
                    let aa = result
                }
                print(result)
            } else {
                result = "0"
            }
        } else {
            print("Klaida")
        }
        print("ooo", result)
        return result
    }

}
