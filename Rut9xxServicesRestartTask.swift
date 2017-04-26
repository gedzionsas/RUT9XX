//
//  Rut9xxServicesRestartTask.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 31/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Rut9xxServicesRestartTask: UIViewController {

    func routerRestartModel (params: String, complete: @escaping ()->()){
        
        let vrrpdConfig = "vrrpd", snmpdConfig = "snmpd", ntpConfig = "ntpclient",
        pingRebootConfig = "ping_reboot", inputOutpuConfig = "ioman",
        hostblockConfig = "hostblock", privoxyConfig = "privoxy",
        openVpnConfig = "openvpn", strongswanConfig = "strongswan", ddnsConfig = "ddns",
        smsUtilsRulesConfig = "sms_utils", hotspotConfig = "coovachilli",
        greTunnelConfig = "gre_tunnel", qosConfig = "qos", gpsConfig = "gps"
        
        let zero = "0", one = "1"
        
        if params == zero {
            restartService(serviceData: vrrpdConfig)
        } else if params == one {
            restartService(serviceData: openVpnConfig)
        } else if params == "2" {
            restartService(serviceData: openVpnConfig)
        } else if params == "3" {
            restartService(serviceData: snmpdConfig)
        } else if params == "4" {
            restartService(serviceData: snmpdConfig)
        } else if params == "5" {
            restartService(serviceData: ntpConfig)
        } else if params == "6" {
            restartService(serviceData: strongswanConfig)
        } else if params == "7" {
            restartService(serviceData: pingRebootConfig)
        } else if params == "8" {
            restartService(serviceData: inputOutpuConfig)
        } else if params == "9" {
            restartService(serviceData: ddnsConfig)
        } else if params == "10" {
            restartService(serviceData: hostblockConfig)
        } else if params == "11" {
            restartService(serviceData: privoxyConfig)
        } else if params == "12" {
            restartService(serviceData: smsUtilsRulesConfig)
        } else if params == "13" {
            restartService(serviceData: hotspotConfig)
        } else if params == "14" {
            restartService(serviceData: hotspotConfig)
        } else if params == "15" {
            restartService(serviceData: greTunnelConfig)
        } else if params == "16" {
            restartService(serviceData: qosConfig)
        } else if params == "17" {
            restartService(serviceData: gpsConfig)
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
