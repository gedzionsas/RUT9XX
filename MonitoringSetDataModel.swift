//
//  MonitoringSetDataModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 13/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class MonitoringSetDataModel: UIViewController {

    
    
    
    let token = UserDefaults.standard.value(forKey: "saved_token")
    
    internal func monitoringModel (switchValue: String, hostnameValue: String, portValue: String, complete: @escaping ()->()){
        let openVpnConfig = "openvpn", enableOption = "enable", remoteOption = "remote", portOption = "port"
        var openVpnSection = ""
        let remoteMonitoringEnableCommand = "uci show openvpn | grep 'enable'"

        
        
            Json().fileExec2Comm(token: token as! String, command: remoteMonitoringEnableCommand) { (result) in
                MethodsClass().processJsonStdoutOutput(response_data: result){ (getOpenVpnSection) in
                        if !getOpenVpnSection.isEmpty {
                        var valueSplited : [String] = getOpenVpnSection.components(separatedBy: ".")
                        if !valueSplited[1].isEmpty {
                            if !switchValue.isEmpty {
                                Json().setConfigInformation(token: self.token as! String, config:openVpnConfig, section: valueSplited[1], configOption: enableOption, value: switchValue) { (response) in
                                    Json().commitConfigsChanges(token: self.token as! String, config: openVpnConfig) { (json) in
                                    
                                    Json().luciReload(token: self.token as! String) { (json) in
                                    }
                                    }
                                }
                                
                            }
                            if !hostnameValue.isEmpty {
                                Json().setConfigInformation(token: self.token as! String, config:openVpnConfig, section: valueSplited[1], configOption: remoteOption, value: hostnameValue) { (response) in
                                    Json().commitConfigsChanges(token: self.token as! String, config: openVpnConfig) { (json) in
                                    
                                    Json().luciReload(token: self.token as! String) { (json) in
                                        complete()

                                        }}
                                }
                                
                            }
                            if !portValue.isEmpty {
                                Json().setConfigInformation(token: self.token as! String, config:openVpnConfig, section: valueSplited[1], configOption: portOption, value: portValue) { (response) in
                                    Json().commitConfigsChanges(token: self.token as! String, config: openVpnConfig) { (json) in
                                    }
                                    Json().luciReload(token: self.token as! String) { (json) in
                                    }
                                }
                                
                            }
                            
                        }
                    }
                    
                    
    }}


    }}
