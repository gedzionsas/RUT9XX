//
//  Rut9xxPeriodicControlRulesModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 14/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class Rut9xxPeriodicControlRulesModel: UIViewController {
    
    
    
    internal func Rut9xxPeriodicControlRulesMethod(rowNumber: String, valueSwitch: String, complete: @escaping ()->()){
        let token = UserDefaults.standard.value(forKey: "saved_token")
        
        
        let configOption = "enabled"
        let configSection = "@rule[\(rowNumber)]"
        let configValue = valueSwitch
        let config = "output_control"
        
        Json().setConfigInformation(token: token as! String, config: config, section: configSection, configOption: configOption, value: configValue) { (response) in
            print("valio", response)
            Json().commitConfigsChanges(token: token as! String, config: config) { (json) in
                Json().luciReload(token: token as! String) { (json) in
                    
                    complete()
                    
                }}}
        
    }}
