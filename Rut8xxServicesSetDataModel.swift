//
//  Rut8xxServicesSetDataModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 10/08/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Rut8xxServicesSetDataModel: UIViewController {
    
    internal func routerServicesSetDataModel (params: [String], complete: @escaping (String)->()){

        let token = UserDefaults.standard.value(forKey: "saved_token")

        let ntpConfig = "ntpclient", pingRebootConfig = "ping_reboot",
        hostblockConfig = "hostblock", ddnsConfig = "ddns",
        smsUtilsRulesConfig = "sms_utils", hotspotConfig = "coovachilli"
        
        let ntpClientSection = "@ntpclient[0]", hostblockConfigSection = "config"
        
        let enabledOption = "enabled", enableOption = "enable"
        
        let  ddnsServiceCommand = "uci show ddns | grep '=service'",
        hotspotsCommand = "uci show coovachilli | grep 'hotspot' | grep 'enabled='", smsUtilsRulesCommand = "uci show sms_utils | grep 'rule' | grep 'enabled='", pingRebootCommand = "uci show ping_reboot | grep 'enable='"
        
        var zero = "0", one = "1", error = "", stdoutString = "stdout";
        
        if params[0] == zero {
            if params[1] == one {
                Json().setConfigInformation(token: token as! String, config: ntpConfig, section: ntpClientSection, configOption: enabledOption, value: one) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: ntpConfig) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }
            } else {
                Json().setConfigInformation(token: token as! String, config: ntpConfig, section: ntpClientSection, configOption: enabledOption, value: zero) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: ntpConfig) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }
            }
        } else if params[0] == one {
            Json().fileExec2Comm(token: token as! String, command: pingRebootCommand) { (pingRebootValue) in
                if let jsonDic = pingRebootValue as? JSON {
                    if jsonDic["result"][1]["stdout"].exists() {
                        self.processListEnableValue(token: token as! String, jsonValue: pingRebootValue, backgroundValue: params[1], config:pingRebootConfig, option: enableOption){ () in
                            complete(error)
                        }
                        
                    } else {
                        error = "Please create rule"
                        complete(error)
                        
                    }
                }
            }

        }else if params[0] == "2" {
            Json().fileExec2Comm(token: token as! String, command: ddnsServiceCommand) { (inputOutputRulesValue) in
                if let jsonDic = inputOutputRulesValue as? JSON {
                    if jsonDic["result"][1]["stdout"].exists() {
                        MethodsClass().processJsonStdoutOutput(response_data: inputOutputRulesValue){ (result) in
                            var stringsArray = result.components(separatedBy: "\n")
                            var itemsOnArray = stringsArray.count
                            var i = 1
                            var j = 0
                            var configSectionArray = [String]()
                            while i <= (itemsOnArray - 1) {
                                var stringsArray1 = stringsArray[j].components(separatedBy: ".")
                                var stringsArray2 = stringsArray1[1].components(separatedBy: "=")
                                configSectionArray.append(stringsArray2[0])
                                i += 1
                                j += 1
                            }
                            
                            if configSectionArray.count > 0 {
                                if params[1] == one {
                                    for var aConfigSection in configSectionArray {
                                        Json().setConfigInformation(token: token as! String, config: ddnsConfig, section: aConfigSection, configOption: enabledOption, value: one) { (v) in
                                            
                                            Json().commitConfigsChanges(token: token as! String, config: ddnsConfig) { (va) in
                                                
                                                Json().luciReload(token: token as! String) { (json) in
                                                }
                                            }}
                                    }
                                    complete(error)
                                } else {
                                    for var aConfigSection in configSectionArray {
                                        Json().setConfigInformation(token: token as! String, config: ddnsConfig, section: aConfigSection, configOption: enabledOption, value: zero) { (json) in                                                    Json().commitConfigsChanges(token: token as! String, config: ddnsConfig) { (json) in
                                            Json().luciReload(token: token as! String) { (json) in
                                            }}}
                                        
                                    }
                                    complete(error)
                                }}
                        }
                        
                    }}}

        } else if params[0] == "3" {
            if params[1] == one {
                Json().setConfigInformation(token: token as! String, config: hostblockConfig, section: hostblockConfigSection, configOption: enabledOption, value: one) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: hostblockConfig) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }
            } else {
                Json().setConfigInformation(token: token as! String, config: hostblockConfig, section: hostblockConfigSection, configOption: enabledOption, value: zero) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: hostblockConfig) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }
            }

        } else if params[0] == "4" {
            Json().fileExec2Comm(token: token as! String, command: smsUtilsRulesCommand) { (smsUtilsRulesValue) in
                if let jsonDic = smsUtilsRulesValue as? JSON {
                    if jsonDic["result"][1]["stdout"].exists() {
                        self.processListEnableValue(token: token as! String, jsonValue: smsUtilsRulesValue, backgroundValue: params[1], config:smsUtilsRulesConfig, option: enabledOption){ () in
                            complete(error)
                        }
                    }
                }}

        } else if params[0] == "5" {
            Json().fileExec2Comm(token: token as! String, command: hotspotsCommand) { (hotspotValue) in
                if let jsonDic = hotspotValue as? JSON {
                    if jsonDic["result"][1]["stdout"].exists() {
                        self.processListEnableValue(token: token as! String, jsonValue: hotspotValue, backgroundValue: params[1], config:hotspotConfig, option: enabledOption){ () in
                            complete(error)
                        }
                    }
                }}
        }

    }
    func processListEnableValue (token: String, jsonValue: Any?, backgroundValue: String, config: String, option: String, complete: @escaping ()->()){
        let one = "1", zero = "0"
        
        MethodsClass().processJsonStdoutOutput(response_data: jsonValue){ (result) in
            var stringsArray = result.components(separatedBy: "\n")
            var itemsOnArray = stringsArray.count
            var i = 1
            var j = 0
            var configSectionArray = [String]()
            while i <= (itemsOnArray - 1) {
                var stringsArray1 = stringsArray[j].components(separatedBy: ".")
                configSectionArray.append(stringsArray1[1])
                i += 1
                j += 1
            }
            
            if configSectionArray.count > 0 {
                if backgroundValue == one {
                    for var aConfigSection in configSectionArray {
                        Json().setConfigInformation(token: token as! String, config: config, section: aConfigSection, configOption: option, value: one) { (v) in
                            
                            Json().commitConfigsChanges(token: token as! String, config: config) { (va) in
                                Json().luciReload(token: token as! String) { (json) in
                                    
                                }
                            }}
                    }
                    complete()
                } else {
                    for var aConfigSection in configSectionArray {
                        Json().setConfigInformation(token: token as! String, config: config, section: aConfigSection, configOption: option, value: zero) { (json) in
                            Json().commitConfigsChanges(token: token as! String, config: config) { (json) in
                                
                                Json().luciReload(token: token as! String) { (json) in
                                    
                                }}}
                        
                    }
                    complete()
                    
                    
                }}
        }
    }
}
