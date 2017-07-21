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
//        let config = "system",
//        section = "sleep_mode",
//        enableOption = "enable",
//        sleepOption = "sleep",
//        triggerOption = "trigger",
//        lowOption = "low"

        
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
       
        
    }


}
