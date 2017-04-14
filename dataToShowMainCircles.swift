//
//  dataToShowMainCircles.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 12/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
class dataToShowMainCircles {
    var mobileStrenghtRing: Double
    var wirelessQualityRing: Int
    
    //MARK: Initialization
    
    init?(mobileStrenghtRing: Double, wirelessQualityRing: Int) {
        
        // The name must not be empty
//        guard mobileStrenghtRing == nil else {
//            return nil
//        }
//        
//        guard wirelessQualityRing == nil else {
//            return nil
//        }
        
        // Initialize stored properties.
        self.mobileStrenghtRing = mobileStrenghtRing
        self.wirelessQualityRing = wirelessQualityRing
        
    }
}
