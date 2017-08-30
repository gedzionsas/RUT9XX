//
//  Rut8xxGetIgnitionDetailsModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 10/08/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

class Rut8xxGetIgnitionDetailsModel: UIViewController {
    
    
    internal func routerSettingsModel (complete: @escaping ([String])->()){

        let token = UserDefaults.standard.value(forKey: "saved_token")

        let lowValue = "low"
        let voltageValueADC = "value"
        let config = "system"
        let section = "sleep_mode"
        let enableOption = "enable"
        let sleepOption = "sleep"
        let triggerOption = "trigger"
        let lowOption = "low"
        
        Json().deviceinform(token: token as! String, config: config, section: section, option: enableOption) { (json) in
            MethodsClass().getJsonValue(response_data: json){ (enableValue) in
                Json().deviceinform(token: token as! String, config: config, section: section, option: lowOption) { (json) in
                    MethodsClass().getJsonValue(response_data: json){ (lowestVoltageValue) in
                        Json().deviceinform(token: token as! String, config: config, section: section, option: sleepOption) { (json) in
                            MethodsClass().getJsonValue(response_data: json){ (voltageSleepCounter) in
                                var sleepCounterValue = self.processTime(value: voltageSleepCounter)
                                Json().deviceinform(token: token as! String, config: config, section: section, option: triggerOption) { (json) in
                                    MethodsClass().getJsonValue(response_data: json){ (sleepTriggerValue) in
                                        var finalSleepTriggerValue = self.processTrigger(value: sleepTriggerValue)
                                        Json().deviceinform(token: token as! String, config: config, section: section, option: lowValue) { (json) in
                                            MethodsClass().getJsonValue(response_data: json){ (lowestVoltagePowerMonValue) in
                                                Json().readPowermonctl(token: token as! String, parameter: voltageValueADC) { (currentVoltageADC) in
                                                            MethodsClass().processJsonStdoutOutput(response_data: currentVoltageADC){ (currentVoltageADCValue) in
                                                                
                                                                var ignitionArray = [enableValue, lowestVoltageValue, sleepCounterValue, finalSleepTriggerValue, currentVoltageADCValue, lowestVoltagePowerMonValue]
     
                                                                
                complete(ignitionArray)
            }}
                                    }}}}}}}}
            }}
        
        


    }
    
    
    
    func processTrigger(value: String)-> (String) {
    var result = ""
    if (value != nil && !value.isEmpty) {
    switch (value) {
    case "1":
    result = "Ignition"
    case "2":
    result = "Voltage"
    case "3":
    result = "Ignition & Voltage"
    case "0":
    result = "None"
    default:
        result = ""
    }
    }
    return result
    }
    
    func processTime(value: String)-> (String) {
    var timeInMin = 0
    if (value != nil && !value.isEmpty) {
    timeInMin = Int(value)! / 60
    } else {
    timeInMin = 0
    }
    return "\(timeInMin) min."
    }

}
