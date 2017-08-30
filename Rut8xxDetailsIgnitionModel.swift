//
//  Rut8xxDetailsIgnitionModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 08/08/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Rut8xxDetailsIgnitionModel: UIViewController {
    
    internal func routerDetailsModel (complete: @escaping ([String])->()){

        let token = UserDefaults.standard.value(forKey: "saved_token")
     
        let lowValue = "low", voltageSleep = "voltage_sleep", sleepValue = "sleep", voltageValueADC = "value", ignitionState = "ignition", sleepTrigger = "source", enableString = "enable", systemConfig = "system", section = "sleep_mode"
        
        let nAString = "N/A"
        var arrayObjects = [String]()
        let undefined = "Undefined"
        var ignitionStateValue = "", sleepTriggerValue = "", lowestVoltageValue = "",
        voltageSleepCounter = "", leftTimeToSleep = "", voltageADCValue = ""
        UserDefaults.standard.set("", forKey: "voltageadc_value")
        UserDefaults.standard.set("", forKey: "lowestvoltage_value")
        UserDefaults.standard.set("", forKey: "voltagesleepcounter_value")
        UserDefaults.standard.set("", forKey: "lefttimetosleep_value")

        Json().deviceinform(token: token as! String, config: systemConfig, section: section, option: enableString) { (json) in
            MethodsClass().getJsonValue(response_data: json){ (enableValue) in
        
        Json().readPowermonctl(token: token as! String, parameter: lowValue) { (lowestVoltage) in
                 Json().readPowermonctl(token: token as! String, parameter: voltageSleep) { (voltageSleepCounterValue) in
                                 Json().readPowermonctl(token: token as! String, parameter: sleepValue) { (leftTimeToSleepValue) in
                                    Json().readPowermonctl(token: token as! String, parameter: voltageValueADC) { (voltageADC) in
                                                                            Json().readPowermonctl(token: token as! String, parameter: ignitionState) { (ignitionStateValue2) in
                                                                                Json().readPowermonctl(token: token as! String, parameter: sleepTrigger) { (sleepTriggerValue2) in
                                                                                  
                                                                                    if let jsonDic = ignitionStateValue2 as? JSON {
                                                                                        if jsonDic["result"][1]["stdout"].exists() {
                                                                                            MethodsClass().processJsonStdoutOutput(response_data: ignitionStateValue2){ (ignitionStateValueMet) in
               UserDefaults.standard.set(ignitionStateValueMet, forKey: "ignitionstate_value")
                                                                                            }} else {
              UserDefaults.standard.set(nAString, forKey: "ignitionstate_value")
                                                                                        }
                                                                                    
                                                                                    }
                                                                                    if let jsonDic = sleepTriggerValue2 as? JSON {
                                                                                        if jsonDic["result"][1]["stdout"].exists() {
                                                                                            MethodsClass().processJsonStdoutOutput(response_data: sleepTriggerValue2){ (sleepTriggerValueMet) in
                                                                                                UserDefaults.standard.set(sleepTriggerValueMet, forKey: "sleeptrigger_value")
                                                                                                if !((UserDefaults.standard.value(forKey: "ignitionstate_value") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) == "0") {
                                                                                                    if let jsonDic = lowestVoltage as? JSON {
                                                                                                        if jsonDic["result"][1]["stdout"].exists() {
                                                                                                            MethodsClass().processJsonStdoutOutput(response_data: lowestVoltage){ (lowestVoltageValueMet) in
                                                                                                            UserDefaults.standard.set(lowestVoltageValueMet, forKey: "lowestvoltage_value")
                                                                                                            }} else {
                                                                                                            UserDefaults.standard.set(nAString, forKey: "lowestvoltage_value")
                                                                                                        }
                                                                                                        
                                                                                                    }

                                                                                                    if let jsonDic = voltageSleepCounterValue as? JSON {
                                                                                                        if jsonDic["result"][1]["stdout"].exists() {
                                                                                                            MethodsClass().processJsonStdoutOutput(response_data: voltageSleepCounterValue){ (voltageSleepCounterValueMet) in
                                                                                                            UserDefaults.standard.set(voltageSleepCounterValueMet, forKey: "voltagesleepcounter_value")
                                                                                                            }} else {
                                                                                                            UserDefaults.standard.set(nAString, forKey: "voltagesleepcounter_value")
                                                                                                        }
                                                                                                        
                                                                                                    }
                                                                                                    
                                                                                                    if let jsonDic = leftTimeToSleepValue as? JSON {
                                                                                                        if jsonDic["result"][1]["stdout"].exists() {
                                                                                                            MethodsClass().processJsonStdoutOutput(response_data: leftTimeToSleepValue){ (leftTimeToSleepValueMet) in
                                                                                                            UserDefaults.standard.set(leftTimeToSleepValueMet, forKey: "lefttimetosleep_value")
                                                                                                            }} else {
                                                                                                            UserDefaults.standard.set(nAString, forKey: "lefttimetosleep_value")
                                                                                                        }
                                                                                                        
                                                                                                    }

                                                                                                    if let jsonDic = voltageADC as? JSON {
                                                                                                        if jsonDic["result"][1]["stdout"].exists() {
                                                                                                            MethodsClass().processJsonStdoutOutput(response_data: voltageADC){ (voltageADCValueMet) in
                                                                                                                UserDefaults.standard.set(voltageADCValueMet, forKey: "voltageadc_value")
                                                                                                            }} else {
                                                                                                            UserDefaults.standard.set(nAString, forKey: "voltageadc_value")
                                                                                                        }
                                                                                                        
                                                                                                    }
                 
                                                                                                } else {
                                                                                                    UserDefaults.standard.set(nAString, forKey: "lowestvoltage_value")
                                                                                                    UserDefaults.standard.set(nAString, forKey: "voltagesleepcounter_value")
                                                                                                    UserDefaults.standard.set(nAString, forKey: "lefttimetosleep_value")
                                                                                                    UserDefaults.standard.set(nAString, forKey: "voltageadc_value")

                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                }
                                                                                            
                                                                                            }
                                                                                            
                                                                                            
                                                                                    
                                                                                        } else {
                                                                                            sleepTriggerValue = ""
                                                                                        }
                                                                                    
                                                                                    
                                                                                    
                                                                                    }
                                                                                    
                                                                                    if (!((UserDefaults.standard.value(forKey: "ignitionstate_value") as? String)?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!) {
                                                                                        arrayObjects.insert(self.parseIgnitionState(value: enableValue.trimmingCharacters(in: .whitespacesAndNewlines)), at: 0)
                                                                                    } else {
                                                                                        arrayObjects.insert(undefined, at: 0)
                                                                                    }
                                                                                    voltageADCValue = (UserDefaults.standard.value(forKey: "voltageadc_value") as? String)!
                                                                                    if !(voltageADCValue.isEmpty) {
                                                                                        
                                                                                        if (voltageADCValue.isNumeric == true) {
                                                                                            arrayObjects.insert(self.addVoltageSymbolToString(value: self.convertAdcToV(value: voltageADCValue)), at: 0)

                                                                                        } else {
                                                                                            arrayObjects.insert(voltageADCValue, at: 0)
                                                                                        }
                                                                                    } else {
                                                                                        arrayObjects.insert(undefined, at: 0)
                                                                                    }
                                                                                    lowestVoltageValue = (UserDefaults.standard.value(forKey: "lowestvoltage_value") as? String)!

                                                                                    if (!lowestVoltageValue.isEmpty) {
                                                                                        if (lowestVoltageValue.isNumeric == true) {
                                                                                            arrayObjects.insert(self.addVoltageSymbolToString(value: self.convertAdcToV(value: lowestVoltageValue)), at: 0)
                                                                                        } else {
                                                                                            arrayObjects.insert(lowestVoltageValue, at: 0)
                                                                                        }
                                                                                    } else {
                                                                                        arrayObjects.insert(undefined, at: 0)
                                                                                    }

                                                                                    leftTimeToSleep = (UserDefaults.standard.value(forKey: "lefttimetosleep_value") as? String)!

                                                                                    if (!leftTimeToSleep.isEmpty) {
                                                                                        if (leftTimeToSleep.isNumeric == true){
                                                                                            arrayObjects.insert(self.parseSleepTime(value: leftTimeToSleep), at: 0)
                                                                                        } else {
                                                                                            arrayObjects.insert(leftTimeToSleep, at: 0)
                                                                                        }
                                                                                    } else {
                                                                                        arrayObjects.insert(undefined, at: 0)
                                                                                    }
                                                                                    complete(arrayObjects)
                                                                                }}}
                    }}
                }
            }}
            



        
    }
    
    func parseSleepTime(value: String)-> (String) {
    let time = Int(value)
    let minutesValue = time! / 60
    let minutesString = String(minutesValue)
    return "\(minutesString)min"
    }
    
    func parseIgnitionState(value: String)-> (String) {
    var result = ""
    if (value == "1") {
    result = "Turned On"
    } else {
    result = "Turned Off"
    }
    return result
    }
    
    func addVoltageSymbolToString(value: String)-> (String) {
    
    return value + " V"
    }

    func convertAdcToV(value: String)-> (String) {
    var result = ""
    if (value != nil && !value.isEmpty) {
    let voltageValueFromRouter = Double(value)
    let firstAction = 3.3 / 1023
    let secondAction = 235.0 / 15.0
    var multiplyFirstAndSecondActions = firstAction * secondAction
    var divideMultipleResultWithFirstAction = voltageValueFromRouter! * multiplyFirstAndSecondActions
    var addToMultipliedValue = divideMultipleResultWithFirstAction + 0.35
    var newValue = String(addToMultipliedValue)
    var firstPart = newValue.components(separatedBy: "\\.")
        let index = firstPart[1].index(firstPart[1].startIndex, offsetBy: 1)
        result = "\(firstPart[0]).\(firstPart[1].substring(to: index))"
    } else {
    result = ""
    }
    return result
    }
}



