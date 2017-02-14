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
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        controller.present(alert, animated: true, completion: nil)
    } 
}


