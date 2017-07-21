//
//  Rut9xxOutputOnOffSetModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 14/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class Rut9xxOutputOnOffSetModel: UIViewController {
    
    internal func outputOnOffSetDataModel (doutParam: String, value: String, complete: @escaping ()->()){
        let token = UserDefaults.standard.value(forKey: "saved_token")
        var command = ""
        
        if(doutParam == "DOUT1") {
            if (value == "1") {
                command = "gpio.sh set DOUT1"
            } else {
                command = "gpio.sh clear DOUT1"
            }
        }else{
            if (value == "1") {
                command = "gpio.sh set DOUT2"
            } else {
                command = "gpio.sh clear DOUT2"
            }
        }
        Json().fileExec2Comm(token: token as! String, command: command) { (response) in
            
        }
        
    }
}
