//
//  Ru9xxRouterSettingsModel.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 06/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Ru9xxRouterSettingsModel: UIViewController {

    internal func routerSettingsModel (complete: @escaping ()->()){
        
        
        func checkSimCard(value: String)->(String){
            var result = ""
            if value.range(of: "sim") != nil {
                if value.range(of: "1") != nil {
                    result = "SIM 1"
                } else {
                    result = "SIM 2"
                }
            } else {
                result = "N/A"
            }
            return result
        }        
        
    }


}
