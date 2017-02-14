//
//  AlertController.swift
//  bandymasAlam
//
//  Created by Gedas Urbonas on 10/02/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

class AlertController: NSObject {
    
    class func showErrorWith(title:String? = nil, message:String? = nil, controller: UIViewController , complition:(() -> ())?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.present(alert, animated: true)
    } 
}
