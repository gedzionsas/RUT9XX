//
//  Rut9xxInputOutputStateModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 10/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class Rut9xxInputOutputStateModel: UIViewController {
    
    internal func Rut9xxInputOutputState(complete: @escaping (String)->()){
        let token = UserDefaults.standard.value(forKey: "saved_token")
        let gpioDin1Command = "gpio.sh get DIN1"
        let gpioDin2Command = "gpio.sh get DIN2"
        let voltageCommand = "cat /sys/class/hwmon/hwmon0/device/in0_input"
        let gpioDout1Command = "gpio.sh get DOUT1"
        let gpioDout2Command = "gpio.sh get DOUT2"
        let gresistor = "uci get ioman.ioman.resistor"
        let iomanConfig = "ioman"
        let dOut1Command = "active_DOUT1_status"
        let dOut2Command = "active_DOUT2_status"
        var typeValue = ""
        var result = ""
        
        
        Json().fileExec2Comm(token: token as! String, command: gpioDin1Command) { (response1) in
            MethodsClass().processJsonStdoutOutput(response_data: response1){ (gpioDin1Value) in
                Json().fileExec2Comm(token: token as! String, command: gpioDin2Command) { (response2) in
                    MethodsClass().processJsonStdoutOutput(response_data: response2){ (gpioDin2Value) in
                        Json().fileExec2Comm(token: token as! String, command: voltageCommand) { (response3) in
                            MethodsClass().processJsonStdoutOutput(response_data: response3){ (gAnalog) in
                                Json().fileExec2Comm(token: token as! String, command: gpioDout1Command) { (response4) in
                                    MethodsClass().processJsonStdoutOutput(response_data: response4){ (gpioDout1Value) in
                                        Json().fileExec2Comm(token: token as! String, command: gpioDout2Command) { (response5) in
                                            MethodsClass().processJsonStdoutOutput(response_data: response5){ (gpioDout2Value) in
                                                Json().fileExec2Comm(token: token as! String, command: gresistor) { (response6) in
                                                    MethodsClass().processJsonStdoutOutput(response_data: response6){ (gresistorValue) in
                                                        Json().deviceinform(token: token as! String, config: iomanConfig, section: iomanConfig, option: dOut1Command) { (response7) in
                                                            MethodsClass().getJsonValue(response_data: response7) { (dOut1Value) in
                                                                Json().deviceinform(token: token as! String, config: iomanConfig, section: iomanConfig, option: dOut2Command) { (response8) in
                                                                    MethodsClass().getJsonValue(response_data: response8) { (dOut2Value) in
                                                                        
                                                                        
                                                                        
                                                                        Json().fileExec2Comm(token: token as! String, command: "cat /etc/config/ioman") { (response9) in
                                                                            MethodsClass().processJsonStdoutOutput(response_data: response9){ (value) in
                                                                                
                                                                                var i = 0
                                                                                
                                                                                let Arr : [String] = value.components(separatedBy: "rule")
                                                                                for item in Arr {
                                                                                    i += 1
                                                                                }
                                                                                
                                                                                
                                                                                
                                                                                var rulesNumber = 0
                                                                                let configOption = "type"
                                                                                let analogTypeString = "analogtype"
                                                                                
                                                                                while rulesNumber < i {
                                                                                    var configSection = "@rule[\(rulesNumber)]"
                                                                                    Json().deviceinform(token: token as! String, config: iomanConfig, section: configSection, option: configOption) { (response10) in
                                                                                        MethodsClass().getJsonValue(response_data: response10) { (configTypeValue) in
                                                                                            if(configTypeValue == "analog"){
                                                                                                Json().deviceinform(token: token as! String, config: iomanConfig, section: configSection, option: analogTypeString) { (response11) in
                                                                                                    MethodsClass().getJsonValue(response_data: response11) { (typeValue0) in
                                                                                                        UserDefaults.standard.set(typeValue0, forKey: "type_value")
                                                                                                        
                                                                                                    }} }
                                                                                        }}
                                                                                    rulesNumber += 1
                                                                                }
                                                                                
                                                                                if let typeValue = (UserDefaults.standard.value(forKey: "type_value") as? String) {
                                                                                    result = gpioDin1Value.trimmingCharacters(in: .whitespacesAndNewlines) + "," + gpioDin2Value.trimmingCharacters(in: .whitespacesAndNewlines) + "," + gAnalog.trimmingCharacters(in: .whitespacesAndNewlines) + "," +
                                                                                        gpioDout1Value.trimmingCharacters(in: .whitespacesAndNewlines) + "," + gpioDout2Value.trimmingCharacters(in: .whitespacesAndNewlines) + "," + gresistorValue.trimmingCharacters(in: .whitespacesAndNewlines) + "," + dOut1Value.trimmingCharacters(in: .whitespacesAndNewlines) + "," + dOut2Value.trimmingCharacters(in: .whitespacesAndNewlines) + "," + typeValue.trimmingCharacters(in: .whitespacesAndNewlines)
                                                                                    
                                                                                }else{
                                                                                    result = gpioDin1Value.trimmingCharacters(in: .whitespacesAndNewlines) + "," + gpioDin2Value.trimmingCharacters(in: .whitespacesAndNewlines) + "," + gAnalog.trimmingCharacters(in: .whitespacesAndNewlines) + "," +
                                                                                        gpioDout1Value.trimmingCharacters(in: .whitespacesAndNewlines) + "," + gpioDout2Value.trimmingCharacters(in: .whitespacesAndNewlines) + "," + gresistorValue.trimmingCharacters(in: .whitespacesAndNewlines) + "," + dOut1Value.trimmingCharacters(in: .whitespacesAndNewlines) + "," + dOut2Value.trimmingCharacters(in: .whitespacesAndNewlines)
                                                                                }
                                                                                
                                                                                complete(result)
                                                                                
                                                                            }}
                                                                    }}  }}
                                                    }}}}}} }}}}
            }}
        
        
        
        
    }
}
