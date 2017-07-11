//
//  StatusController.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 05/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit

class StatusController: UIViewController {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var digitalInput: UILabel!
    @IBOutlet weak var digitalGalvanicallyInput: UILabel!
    @IBOutlet weak var analogInput: UILabel!
    @IBOutlet weak var openCollectorOutput: UILabel!
    @IBOutlet weak var relayOutput: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   scrollview.contentSize = CGSize(self.view.frame.width, self.view.frame.height+100)

        self.navigationController?.navigationBar.topItem?.title = " "
        Rut9xxInputOutputStateModel().Rut9xxInputOutputState(){ (result) in
            self.setData(resultArray: result)
        
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}


    
    func setData (resultArray: String) {
        

        var antype = "", gDin1 = "", gDin2 = ""
        var gAnalog = 0.0, gResistor = 0.0
        var gDout1 = 0, gDout2 = 0, open_collector_output_cfg = 0, relay_output_cfg = 0
        var analog = ""
        var text = ""
        
        
        if(!resultArray.isEmpty) {
            
            let Arr : [String] = resultArray.components(separatedBy: ",")
            if Arr.count > 6 {
                gDin1 = Arr[0]
                gDin2 = Arr[1]
                gAnalog = Double(Arr[2])!
                gDout1 = Int(Arr[3])!
                gDout2 = Int(Arr[4])!
                gResistor = Double(Arr[5])!
                open_collector_output_cfg = Int(Arr[6])!
                relay_output_cfg = Int(Arr[7])!
                if (Arr.count - 8) != 0 {
                    antype = Arr[8]
                }

            }
        }
        
        
        if (gDin1 == "1") {
            digitalInput.text = "Open"
        } else {
            digitalInput.text = "Shorted"
        }
        
        if (gDin2 == "1") {
            digitalGalvanicallyInput.text = "Low level"
        } else {
            digitalGalvanicallyInput.text = "High level"
        }
        
        if (gAnalog >= 0) {
            if (antype == "currenttype") {
                var analogValue = (gAnalog * (131000 + gResistor) / (131000 * gResistor))
                let formatedAnalogValue = String(format: "%.02f", analogValue)
                analog = "\(formatedAnalogValue) mA"
            } else {
                var analogValue = (gAnalog / 1000);
                let formatedAnalogValue = String(format: "%.02f", analogValue)
                analog = "\(formatedAnalogValue) V"
            }
        } else {
            analog = "N/A";
        }
        analogInput.text = analog
        
        if (open_collector_output_cfg == 1) {
            if (gDout1 == 1) {
                text = "Active (Low level)"
                openCollectorOutput.text = text
            } else {
                text = "Inactive (High level)"
                openCollectorOutput.text = text
            }
        } else {
            if (gDout1 == 1) {
                text = "Inactive (Low level)"
                openCollectorOutput.text = text
            } else {
                text = "Active (High level)"
                openCollectorOutput.text = text
            }
        }
        
        if (relay_output_cfg == 1) {
            if (gDout2 == 1) {
                text = "Active (Contacts closed)"
                relayOutput.text = text
            } else {
                text = "Inactive (Contacts open)"
                relayOutput.text = text
            }
        } else {
            if (gDout2 == 1) {
                text = "Inactive (Contacts open)"
                relayOutput.text = text
            } else {
                text = "Active (Contacts closed)"
                relayOutput.text = text
            }
        }
        
    }
}
