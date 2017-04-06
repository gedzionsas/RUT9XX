//
//  Rut9xxServicesSetData.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 03/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit
import SwiftyJSON

class Rut9xxServicesSetData: UIViewController {
    
    internal func routerServicesSetDataModel (params: [String], complete: @escaping (String)->()){
        
        
        let vrrpdConfig = "vrrpd",
        snmpdConfig = "snmpd",
        ntpConfig = "ntpclient",
        pingRebootConfig = "ping_reboot",
        inputOutputConfig = "ioman",
        hostblockConfig = "hostblock",
        privoxyConfig = "privoxy",
        openVpnConfig = "openvpn",
        strongswanConfig = "strongswan",
        ddnsConfig = "ddns",
        smsUtilsRulesConfig = "sms_utils",
        hotspotConfig = "coovachilli",
        greTunnelConfig = "gre_tunnel",
        qosConfig = "qos",
        gpsConfig = "gps",
        
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
        ddnsServiceCommand = "uci show ddns | grep '=service'",
        gpsEnabledCommand = "uci show gps | grep 'enabled='",
        hotspotsCommand = "uci show coovachilli | grep 'hotspot' | grep 'enabled='",
        inputOutputRulesCommand = "uci show ioman | grep 'rule' | grep 'enabled='",
        smsUtilsRulesCommand = "uci show sms_utils | grep 'rule' | grep 'enabled='",
        greTunnelCommand = "uci show gre_tunnel | grep 'enabled='",
        qosCommand = "uci show qos | grep 'enabled='",
        pingRebootCommand = "uci show ping_reboot | grep 'enable='",
        
        zero = "0", one = "1", stdoutString = "stdout"
        
        var error = ""
        
        let token = UserDefaults.standard.value(forKey: "saved_token")
        
        if params[0] == zero {
            if params[1] == one {
                Json().setConfigInformation(token: token as! String, config: vrrpdConfig, section: vid1Section, configOption: enabledOption, value: one) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: vrrpdConfig) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }
            } else {
                Json().setConfigInformation(token: token as! String, config: vrrpdConfig, section: vid1Section, configOption: enabledOption, value: zero) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: vrrpdConfig) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }
            }
        } else if params[0] == one {
            Json().fileExec2Comm(token: token as! String, command: openVpnServersCommand) { (openVpnServersValue) in
                if let jsonDic = openVpnServersValue as? JSON {
                    if jsonDic["result"][1]["stdout"].exists() {
                                MethodsClass().processJsonStdoutOutput(response_data: openVpnServersValue){ (result) in
                                    let temp = result as? String
                                    let serverSectionArray = temp?.components(separatedBy: ".")
                                    if params[1] == one {
                                        Json().setConfigInformation(token: token as! String, config: openVpnConfig, section: (serverSectionArray?[1])!, configOption: enableOption, value: one) { (json) in
                                            Json().commitConfigsChanges(token: token as! String, config: openVpnConfig) { (json) in
                                                Json().luciReload(token: token as! String) { (json) in
                                                    complete(error)
                                                }
                                            }
                                        }
                                    } else {
                                        Json().setConfigInformation(token: token as! String, config: openVpnConfig, section: (serverSectionArray?[1])!, configOption: enableOption, value: zero) { (json) in
                                            Json().commitConfigsChanges(token: token as! String, config: openVpnConfig) { (json) in
                                                Json().luciReload(token: token as! String) { (json) in
                                                    complete(error)
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                
                            } else {
                                error = "Please create server"
                                complete(error)
                            }
                        }}
        
        }else if params[0] == "2" {
            Json().fileExec2Comm(token: token as! String, command: openVpnClientCommand) { (openVpnClientsValue) in
                if let jsonDic = openVpnClientsValue as? JSON {
                    if jsonDic["result"][1]["stdout"].exists() {
                                self.processListEnableValue(token: token as! String, jsonValue: openVpnClientsValue, backgroundValue: params[1], config:openVpnConfig, option: enableOption){ () in
                                    complete(error)
                                }
                            } else {
                                error = "Please create clients"
                                complete(error)
                            }
                        }}
        } else if params[0] == "3" {
            if params[1] == one {
                Json().setConfigInformation(token: token as! String, config: snmpdConfig, section: snmpdAgentSection, configOption: enabledOption, value: one) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: snmpdConfig) { (json) in
                        Json().luciReload(token: token as! String) { (json) in
                            complete(error)
                        }
                    }
                }
            } else {
                Json().setConfigInformation(token: token as! String, config: snmpdConfig, section: snmpdAgentSection, configOption: enabledOption, value: zero) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: snmpdConfig) { (json) in
                        Json().luciReload(token: token as! String) { (json) in
                            complete(error)
                        }
                    }
                }
            }
        } else if params[0] == "4" {
            if params[1] == one {
                Json().setConfigInformation(token: token as! String, config: snmpdConfig, section: snmpdTrapSection, configOption: trapEnabledOption, value: one) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: snmpdConfig) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }
            } else {
                Json().setConfigInformation(token: token as! String, config: snmpdConfig, section: snmpdTrapSection, configOption: trapEnabledOption, value: zero) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: snmpdConfig) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }
            }

        } else if params[0] == "5" {
            if params[1] == one {
                Json().setConfigInformation(token: token as! String, config: ntpConfig, section: ntpClientSection, configOption: enabledOption, value: one) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: ntpConfig) { (json) in
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }   }
            } else {
                Json().setConfigInformation(token: token as! String, config: ntpConfig, section: ntpClientSection, configOption: enabledOption, value: zero) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: ntpConfig) { (json) in
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                } }
            }
        } else if params[0] == "6" {
                    Json().fileExec2Comm(token: token as! String, command: ipSecCommand) { (ipSecValue) in
                        if let jsonDic = ipSecValue as? JSON {
                            if jsonDic["result"][1]["stdout"].exists() {
                                        self.processListEnableValue(token: token as! String, jsonValue: ipSecValue, backgroundValue: params[1], config:strongswanConfig, option: enabledOption){ () in
                                            complete(error)
                                        }
                                    } else {
                                        error = "Please create Ipsec"
                                        complete(error)
                                    }
                                }}
        } else if params[0] == "7" {
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
        } else if params[0] == "8" {
            Json().fileExec2Comm(token: token as! String, command: inputOutputRulesCommand) { (inputOutputRulesValue) in
                if let jsonDic = inputOutputRulesValue as? JSON {
                    if jsonDic["result"][1]["stdout"].exists() {
                        self.processListEnableValue(token: token as! String, jsonValue: inputOutputRulesValue, backgroundValue: params[1], config:inputOutputConfig, option: enabledOption){ () in
                            complete(error)
                        }
                    } else {
                        error = "Please create rule"
                        complete(error)
                    }
                }}
        } else if params[0] == "9" {
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
        } else if params[0] == "10" {
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
        } else if params[0] == "11" {
            if params[1] == one {
                Json().setConfigInformation(token: token as! String, config: privoxyConfig, section: privoxySection, configOption: enabledOption, value: one) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: privoxyConfig) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }
            } else {
                Json().setConfigInformation(token: token as! String, config: privoxyConfig, section: privoxySection, configOption: enabledOption, value: zero) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: privoxyConfig) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }
            }
        } else if params[0] == "12" {
            Json().fileExec2Comm(token: token as! String, command: smsUtilsRulesCommand) { (smsUtilsRulesValue) in
                if let jsonDic = smsUtilsRulesValue as? JSON {
                    if jsonDic["result"][1]["stdout"].exists() {
                        self.processListEnableValue(token: token as! String, jsonValue: smsUtilsRulesValue, backgroundValue: params[1], config:smsUtilsRulesConfig, option: enabledOption){ () in
                            complete(error)
                        }
                    }
                }}
        } else if params[0] == "13" {
            Json().fileExec2Comm(token: token as! String, command: hotspotsCommand) { (hotspotValue) in
                if let jsonDic = hotspotValue as? JSON {
                    if jsonDic["result"][1]["stdout"].exists() {
                        self.processListEnableValue(token: token as! String, jsonValue: hotspotValue, backgroundValue: params[1], config:hotspotConfig, option: enabledOption){ () in
                            complete(error)
                        }
                    }
                }}
        } else if params[0] == "14" {
            if params[1] == one {
                Json().setConfigInformation(token: token as! String, config: hotspotConfig, section: ftpCoovachilliSection, configOption: enabledOption, value: one) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: hotspotConfig) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }
            } else {
                Json().setConfigInformation(token: token as! String, config: hotspotConfig, section: ftpCoovachilliSection, configOption: enabledOption, value: zero) { (json) in
                    Json().commitConfigsChanges(token: token as! String, config: hotspotConfig) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                        complete(error)
                    }
                }
            }
        } else if params[0] == "15" {
            Json().fileExec2Comm(token: token as! String, command: greTunnelCommand) { (greTunnelValue) in
                if let jsonDic = greTunnelValue as? JSON {
                    if jsonDic["result"][1]["stdout"].exists() {
                        self.processListEnableValue(token: token as! String, jsonValue: greTunnelValue, backgroundValue: params[1], config:greTunnelConfig, option: enabledOption){ () in
                            complete(error)
                        }
                    } else {
                        error = "Please create Gre tunnel"
                        complete(error)
                    }
                }}
        } else if params[0] == "16" {
            Json().fileExec2Comm(token: token as! String, command: qosCommand) { (qosValue) in
                if let jsonDic = qosValue as? JSON {
                    if jsonDic["result"][1]["stdout"].exists() {
                        self.processListEnableValue(token: token as! String, jsonValue: qosValue, backgroundValue: params[1], config:qosConfig, option: enabledOption){ () in
                            complete(error)
                        }
                    }
                }}
        } else if params[0] == "17" {
            Json().fileExec2Comm(token: token as! String, command: gpsEnabledCommand) { (gpsValue) in
                if let jsonDic = gpsValue as? JSON {
                    if jsonDic["result"][1]["stdout"].exists() {
                        self.processListEnableValue(token: token as! String, jsonValue: gpsValue, backgroundValue: params[1], config:gpsConfig, option: enabledOption){ () in
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
