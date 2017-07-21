//
//  Rut9xxSimCardSwitchTask.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 07/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Rut9xxSimCardSwitchTask: UIViewController {
    let token = UserDefaults.standard.value(forKey: "saved_token")
    var simCardStateResult = ""

    internal func simCardSwitchTask (complete: @escaping ()->()){
        let commandToSetFirstSim = "sim_switch change sim1",
        commandToSetSecondSim = "sim_switch change sim2",
        simCardSection = "simcard",
        simCardOption = "default"
        
        guard let simValue = UserDefaults.standard.value(forKey: "simcard_value") as? String else {
            print("No sim card value")
            return
        }
        
        
        if !(simValue.isEmpty) {
            
           
            var simCardValueToSet = checkSimCardValueToGpio(value: simValue)
            if simCardValueToSet == "1" {
                Json().setConfigInformation(token: token as! String, config:SIM_CARD_CONFIG, section: simCardSection, configOption: simCardOption, value: simValue) { (response) in
                }
                Json().commitConfigsChanges(token: token as! String, config: SIM_CARD_CONFIG) { (valueOfCommit) in
                }
                Json().fileExec2Comm(token: token as! String, command: commandToSetFirstSim) { (valueToSet) in
                }
                Json().luciReload(token: token as! String) { (luciValue) in
                }
            } else {
                Json().setConfigInformation(token: token as! String, config:SIM_CARD_CONFIG, section: simCardSection, configOption: simCardOption, value: simValue) { (response) in
                }
                Json().commitConfigsChanges(token: token as! String, config: SIM_CARD_CONFIG) { (valueOfCommit) in
                }
                Json().fileExec2Comm(token: token as! String, command: commandToSetSecondSim) { (valueToSet) in
                }
                Json().luciReload(token: token as! String) { (luciValue) in
                    
                }
                
            }
            simCardStateMethod(){ (result) in
                complete()

            }

        }
        
    }
    
    func simCardStateMethod(complete: @escaping ()->()){
         sleep(1)
        Json().aboutDevice(token: token as! String, command: "gsmctl", parameter: "-z") { (json) in
            MethodsClass().processJsonStdoutOutput(response_data: json){ (simCardState) in
                if !(self.simCardStateResult.range(of: "inserted") != nil) {
                    UserDefaults.standard.setValue(simCardState, forKey: "temp")
                    self.simCardStateResult = UserDefaults.standard.value(forKey: "temp") as! String
                    self.simCardStateMethod(){ (result) in
                        complete()
                    }
                } else {
                    complete()

                }
                
            }
        }
    }
    
    func checkSimCardValueToGpio(value: String)->(String){
        var result = ""
        if value.lowercased().range(of: "sim") != nil {
            if value.range(of: "1") != nil {
                result = "1"
            } else {
                result = "0"
            }
        }
        print(result)
        return result
    }
    
    
}
