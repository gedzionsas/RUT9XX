//
//  ChangeRouterPasswordMethod.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 27/06/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class ChangeRouterPasswordMethod: UIViewController {
    
    internal func ChangeRouterPassword(routerPassword: String, complete: @escaping ()->()){
        let token = UserDefaults.standard.value(forKey: "saved_token")
        let config = "system"
        let section = "sleep_mode"
        let enableOption = "enable"
        let sleepOption = "sleep"
        let triggerOption = "trigger"
        let lowOption = "low"

        
        if routerPassword != nil && !routerPassword.isEmpty {
            Json().setPassword(token: token as! String, password: routerPassword){ (response) in
                
                complete()
            }
        }
}
}
