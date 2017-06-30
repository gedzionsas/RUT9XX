//
//  MonitoringGetDataModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 12/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class MonitoringGetDataModel: UIViewController {
    private let ENABLE = "enable"
    private let HOSTNAME = "hostname"
    private let PORT = "port"
    private let CONNECTION_STATE = "connectionState"
    private let LAN_MAC_ADDRESS = "lanMacAddress"
    let token = UserDefaults.standard.value(forKey: "saved_token")

    internal func monitoringModel (complete: @escaping ([String: Any])->()){

    
    let remoteMonitoringEnableCommand = "uci show openvpn | grep 'enable'",
    remoteMonitoringCommand = "uci show openvpn | grep 'remote'",
    monitoringPortCommand = "uci show openvpn | grep 'port'",
    defaultRemote = "uci -c /rom/etc/config -q get openvpn.teltonika_auth_service.remote",
    defaultPort = "uci -c /rom/etc/config -q get openvpn.teltonika_auth_service.port",
    removeLog2File = "rm /tmp/mon_openvpn_log2",
    devB = "uci -q get openvpn.teltonika_auth_service.dev",
    executionCommand = "cat /tmp/monitoring_log",
    closingTunTapInterface = "Closing TUN/TAP interface",
    lanMacAddressCommand = "cat /sys/class/net/br-lan/address";
    var connectionState = "", stringAddedValueForNoReason = "[0-9]\\{1,\\}"
    var object: [String: Any] = [:]
        
        
        
    Json().fileExec2Comm(token: token as! String, command: remoteMonitoringEnableCommand) { (monitoringEnable) in
        MethodsClass().processJsonStdoutOutput(response_data: monitoringEnable){ (value) in
    var monitoringEnableValue : [String] = value.components(separatedBy: "=")
            Json().fileExec2Comm(token: self.token as! String, command: remoteMonitoringCommand) { (monitoringValue) in
                MethodsClass().processJsonStdoutOutput(response_data: monitoringValue){ (value) in
                    let monitoringRemote : [String] = value.components(separatedBy: "=")
                     MethodsClass().checkForBraces(value: monitoringRemote[1]){ (monitoringRemoteValue) in
                        Json().fileExec2Comm(token: self.token as! String, command: monitoringPortCommand) { (monitoringPort) in
                            MethodsClass().processJsonStdoutOutput(response_data: monitoringPort){ (value) in
                                let monitoringPortValue : [String] = value.components(separatedBy: "=")
                                MethodsClass().checkForBraces(value: monitoringPortValue[1]){ (monitoringPortFinalValue) in
                                    Json().fileExec2Comm(token: self.token as! String, command: defaultRemote) { (defaultRemote) in
                                        MethodsClass().processJsonStdoutOutput(response_data: defaultRemote){ (defaultRemoteValue) in
                                            
                                            Json().fileExec2Comm(token: self.token as! String, command: defaultPort) { (defaultPort) in
                                                MethodsClass().processJsonStdoutOutput(response_data: defaultPort){ (defaultPortValue) in
                                                    Json().fileExec2Comm(token: self.token as! String, command: devB) { (devB) in
                                                        MethodsClass().processJsonStdoutOutput(response_data: devB){ (devBValue) in
                                                            
                                                            Json().fileExec2Comm(token: self.token as! String, command: lanMacAddressCommand) { (lanMac) in
                                                                MethodsClass().processJsonStdoutOutput(response_data: lanMac){ (lanMacAddress) in
                                                             
                if (self.getError(errorTag: "Network is unreachable", logFile: "1")) {
                        connectionState = "Server is unreachable"
                                    } else {
                    var dev = devBValue.trimmingCharacters(in: .whitespacesAndNewlines) + stringAddedValueForNoReason;
                    if (monitoringRemoteValue.trimmingCharacters(in: .whitespacesAndNewlines) == defaultRemoteValue.trimmingCharacters(in: .whitespacesAndNewlines) && monitoringPortFinalValue.trimmingCharacters(in: .whitespacesAndNewlines) == defaultPortValue.trimmingCharacters(in: .whitespacesAndNewlines)) {
                        
                        Json().fileExec2Comm(token: self.token as! String, command: removeLog2File) { (removeLogFile) in
                        }
                        connectionState = "Connecting to server"
                        var tik: Bool = true
                        if (self.getError(errorTag: "AUTH_FAILED", logFile: "1")) {
                            connectionState = "Device is not registered in monitoring system"
                            tik = false
                            }
                        if (self.getError(errorTag: "device \(dev) opened", logFile: "1")) {
                            connectionState = "Primary connection to server made"
                            tik = false
                        }
                        if (tik) {
                            let parseTest = "cat /tmp/mon_openvpn_log | grep -o '\(dev)[0-9]\\{1,\\} [0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\} pointopoint [0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}' | awk '{print $4}'"
                            Json().fileExec2Comm(token: self.token as! String, command: parseTest) { (result) in
                                MethodsClass().processJsonStdoutOutput(response_data: result){ (ptpIp) in
                            
                                
                            var ptpErrExecCommand = "/usr/bin/eventslog -p -t events | grep '\(ptpIp)' | tail -1"
                            Json().fileExec2Comm(token: self.token as! String, command: ptpErrExecCommand) { (result1) in
                                MethodsClass().processJsonStdoutOutput(response_data: result1){ (ptpErr) in
                                    
                                if (!ptpErr.isEmpty && ptpErr.range(of: "Bad password") != nil) {
                                connectionState = "Wrong device password in monitoring system"
                            } 
                                }}}}
                        }
                    } else {
                            if (monitoringRemoteValue.trimmingCharacters(in: .whitespacesAndNewlines) == defaultRemoteValue.trimmingCharacters(in: .whitespacesAndNewlines)) {
                                connectionState = "Connecting to profile tunnel"
                                
                                Json().fileExec2Comm(token: self.token as! String, command: executionCommand) { (result1) in
                                    MethodsClass().processJsonStdoutOutput(response_data: result1){ (mConnectionState) in
                                        
                                if (!mConnectionState.isEmpty) {
                                    if ((mConnectionState.range(of: "\n")) != nil) {
                                        var valueSplited : [String] = mConnectionState.components(separatedBy: "\n")
                                        if valueSplited.count > 1 {
                                            var connectionStateSecond = valueSplited[1]
                                            if (!connectionStateSecond.isEmpty) {
                                                connectionState = connectionStateSecond
                                            }
                                        }else{
                                            var connectionStateSecond = valueSplited[1]
                                            if (!connectionStateSecond.isEmpty) {
                                                connectionState = connectionStateSecond
                                            }
                                        }
                                    }
                                }
                                let errorDeviceOpened = "device \(dev) opened"
                                        if (self.getError(errorTag: errorDeviceOpened, logFile: "1")) {
                                    connectionState = "Connected to profile tunnel"
                                            Json().fileExec2Comm(token: self.token as! String, command: executionCommand) { (result1) in
                                                MethodsClass().processJsonStdoutOutput(response_data: result1){ (mConnectionState1) in
                                    if (!mConnectionState1.isEmpty) {
                                        var valueSplited : [String] = mConnectionState1.components(separatedBy: "\n")
                                        if valueSplited.count > 1 {
                                            var connectionStateSecond = valueSplited[1]
                                            if (!connectionStateSecond.isEmpty) {
                                                connectionState = connectionStateSecond
                                            }

                                    }
                                                    }}}}
                                if (self.getError(errorTag: closingTunTapInterface, logFile: "2")) {
                                    connectionState = "Connection closed"
                                    Json().fileExec2Comm(token: self.token as! String, command: removeLog2File) { (result1) in

                                    }
                                        }
                            }
                        }
                        
                        
                        
                    }
                    }
                    
                    object[self.ENABLE] = monitoringEnableValue[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    object[self.HOSTNAME] = monitoringRemoteValue.trimmingCharacters(in: .whitespacesAndNewlines) 
                    object[self.PORT] = monitoringPortValue[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    object[self.CONNECTION_STATE] = connectionState.trimmingCharacters(in: .whitespacesAndNewlines) 
                    object[self.LAN_MAC_ADDRESS] = lanMacAddress.trimmingCharacters(in: .whitespacesAndNewlines)
                    complete(object)

                                                                    }
                                                                
                                                                }} }} }} }}}}}}}}}
    }

    }
    
    func getError(errorTag: String, logFile: String)-> Bool {
    var errorFound = false
    var connectionState = ""
    let firstFileCommand = "cat /tmp/mon_openvpn_log | grep -v grep | grep '\(errorTag)'",
    secondFileCommand = "cat /tmp/mon_openvpn_log2 | grep -v grep | grep '\(errorTag)'"
    if (logFile == "1") {
        Json().fileExec2Comm(token: token as! String, command: firstFileCommand) { (connectionState1) in
            MethodsClass().processJsonStdoutOutput(response_data: connectionState1){ (connectionState) in
            }}
    } else {
        Json().fileExec2Comm(token: token as! String, command: secondFileCommand) { (connectionState1) in
            MethodsClass().processJsonStdoutOutput(response_data: connectionState1){ (connectionState) in
            }}
    }
    if (!connectionState.isEmpty) {
   let values : [String] = connectionState.components(separatedBy: .newlines)
    if(values.count > 1) {
    if (!values[1].isEmpty) {
    errorFound = true
    }
    }
    }
    return errorFound
    }
}
