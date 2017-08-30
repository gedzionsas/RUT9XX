//
//  Rut8xxRestartModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 09/08/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

class Rut8xxRestartModel: UIViewController {
    
    func routerRestartModel (params: String, complete: @escaping ()->()){
        
        let ntpConfig = "ntpclient", pingRebootConfig = "ping_reboot",
        hostblockConfig = "hostblock", ddnsConfig = "ddns",
        smsUtilsRulesConfig = "sms_utils", hotspotConfig = "coovachilli"
        
        let zero = "0", one = "1"
        
        if params == zero {
            restartService(serviceData: ntpConfig)
        } else if params == one {
            restartService(serviceData: pingRebootConfig)
        } else if params == "2" {
            restartService(serviceData: ddnsConfig)
        } else if params == "3" {
            restartService(serviceData: hostblockConfig)
        } else if params == "4" {
            restartService(serviceData: smsUtilsRulesConfig)
        } else if params == "5" {
            restartService(serviceData: hostblockConfig)
}

        
        complete()


}
    
    func restartService(serviceData: String) {
        if (!serviceData.isEmpty) {
            let token = UserDefaults.standard.value(forKey: "saved_token")
            let command = "/etc/init.d/\(serviceData) restart"
            print(command)
            Json().fileExec2Comm(token: token as! String, command: command) { (json) in
            }
        }
        
        
    }


}
