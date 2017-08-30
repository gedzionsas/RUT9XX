//
//  Ru9xxRouterSettingsModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 06/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Ru9xxRouterChangePasswordModel: UIViewController {

    internal func performRouterPasswordTask (params: [String], complete: @escaping ()->()){
        
        let token = UserDefaults.standard.value(forKey: "saved_token")
        let config = "system",
        section = "sleep_mode",
        enableOption = "enable",
        sleepOption = "sleep",
        triggerOption = "trigger",
        lowOption = "low"

        
        if !params[0].isEmpty {
            Json().setPassword(token: token as! String, password: params[0]){ (response) in
                print(response)
                complete()
            }
        } else {
            let alert = UIAlertController(title: "", message: "Password fields are empty!", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)})
            complete()

        }
        
        
        if params.count > 1 {
            
            if params[1] != nil {
                let enableValue = params[1]
                Json().setConfigInformation(token: token as! String, config: config, section: section, configOption: enableOption, value: enableValue) { (json) in
                }
            }
            if params[2] != nil {
                let sleepDelayTime = params[2]
                Json().setConfigInformation(token: token as! String, config: config, section: section, configOption: sleepOption, value: sleepDelayTime) { (json) in
                }
            }
            if params[3] != nil {
                let sleepTriggerValue = params[3]
                Json().setConfigInformation(token: token as! String, config: config, section: section, configOption: triggerOption, value: sleepTriggerValue) { (json) in
                }
            }
            if params[4] != nil {
                let minimumVoltageValue = params[4]
                Json().setConfigInformation(token: token as! String, config: config, section: section, configOption: lowOption, value: minimumVoltageValue) { (json) in
                
                
                }
            }
            
            Json().commitConfigsChanges(token: token as! String, config: "system") { (json) in
            }
            Json().restartSystemConfigs(token: token as! String) { (json) in
            complete()
            }
            
        }
       
        
    }


}
