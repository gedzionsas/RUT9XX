//
//  Rut9xxInputRulesModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 11/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class Rut9xxInputRulesModel: UIViewController {
    
    
    
    internal func Rut9xxInputRulesMethod(complete: @escaping ([[String: String]])->()){
        let token = UserDefaults.standard.value(forKey: "saved_token")
        
        let iomanConfig = "ioman", configEnabledOption = "enabled", configTypeOption = "type", configTriggerOption = "triger", configActionOption = "action", configAnalogType = "analogtype", configMinOption = "min", configMaxOption = "max", configMinCOption = "minc", configMaxCOption = "maxc", configOutPut = "outputnb"
        
        var enabledValue = ""
        
        Json().fileExec2Comm(token: token as! String, command: "cat /etc/config/ioman") { (response9) in
            MethodsClass().processJsonStdoutOutput(response_data: response9){ (value) in
                var i = 0
                
                let Arr : [String] = value.components(separatedBy: "rule")
                for item in Arr {
                    i += 1
                }
                
                var object: [String: String] = [:]
                var arrayObjects = [[String: String]]()
                
                var rulesNumber = 0
                var rulesCount = (i - 1)
                
                
                let dispatchGroup = DispatchGroup()
                
                repeat {
                    
                    dispatchGroup.enter()
                    
                    var configSection = "@rule[\(rulesNumber)]"
                    print(rulesNumber, rulesCount)
                    
                    
                    Json().deviceinform(token: token as! String, config: iomanConfig, section: configSection, option: configEnabledOption) { (response1) in
                        MethodsClass().getJsonValue(response_data: response1) { (enabledValue) in
                            Json().deviceinform(token: token as! String, config: iomanConfig, section: configSection, option: configAnalogType) { (response2) in
                                MethodsClass().getJsonValue(response_data: response2) { (analogTypeValue) in
                                    Json().deviceinform(token: token as! String, config: iomanConfig, section: configSection, option: configTypeOption) { (response3) in
                                        MethodsClass().getJsonValue(response_data: response3) { (typeValue) in
                                            Json().deviceinform(token: token as! String, config: iomanConfig, section: configSection, option: configTriggerOption) { (response4) in
                                                MethodsClass().getJsonValue(response_data: response4) { (triggerValue) in
                                                    Json().deviceinform(token: token as! String, config: iomanConfig, section: configSection, option: configActionOption) { (response5) in
                                                        MethodsClass().getJsonValue(response_data: response5) { (actionValue) in
                                                            Json().deviceinform(token: token as! String, config: iomanConfig, section: configSection, option: configMinOption) { (response6) in
                                                                MethodsClass().getJsonValue(response_data: response6) { (minValue) in
                                                                    Json().deviceinform(token: token as! String, config: iomanConfig, section: configSection, option: configMaxOption) { (response7) in
                                                                        MethodsClass().getJsonValue(response_data: response7) { (maxValue) in
                                                                            Json().deviceinform(token: token as! String, config: iomanConfig, section: configSection, option: configMinCOption) { (response8) in
                                                                                MethodsClass().getJsonValue(response_data: response8) { (minCValue) in
                                                                                    Json().deviceinform(token: token as! String, config: iomanConfig, section: configSection, option: configMaxCOption) { (response9) in
                                                                                        MethodsClass().getJsonValue(response_data: response9) { (maxCValue) in
                                                                                            Json().deviceinform(token: token as! String, config: iomanConfig, section: configSection, option: configOutPut) { (response10) in
                                                                                                MethodsClass().getJsonValue(response_data: response10) { (outPutNb) in
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    if (!enabledValue.isEmpty && !typeValue.isEmpty && !triggerValue.isEmpty && !actionValue.isEmpty) {
                                                                                                        object["Enabled"] = enabledValue
                                                                                                        object["Type"] = typeValue
                                                                                                        object["Trigger"] = triggerValue
                                                                                                        object["Action"] = actionValue
                                                                                                        
                                                                                                        object["AnalogType"] = analogTypeValue
                                                                                                        object["MinValue"] = minValue
                                                                                                        object["MaxValue"] = maxValue
                                                                                                        object["MinCValue"] = minCValue
                                                                                                        object["MaxCValue"] = maxCValue
                                                                                                        object["OutputNb"] = outPutNb
                                                                                                        arrayObjects.insert(object, at: 0)
                                                                                                        
                                                                                                    }
                                                                                                    
                                                                                                    if rulesNumber == rulesCount {
                                                                                                        
                                                                                                        dispatchGroup.leave()
                                                                                                        
                                                                                                    }
                                                                                                    
                                                                                                }}
                                                                                        }} }}}}  }}}}}}}}}}
                        }}
                    rulesNumber += 1
                } while (rulesNumber < rulesCount)
                
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    complete(arrayObjects)
                    
                }
                
                
            }}
        
        
        
    }
    
    
    
}
