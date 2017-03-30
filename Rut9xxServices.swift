//
//  Rut9xxServices.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 29/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Rut9xxServices: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Rut9xxServicesModel().routerServicesModel(){ (result) in

        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
