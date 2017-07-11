//
//  Rut9xxSimCardChoose.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 07/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

protocol PassdataDelegate {
    
    func passData(value: String)
}

class Rut9xxSimCardPopUp: UIViewController {

    
    @IBOutlet weak var sim1Button: UIButton!
    @IBOutlet weak var sim2Button: UIButton!
    

    var delegate: PassdataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        sim1Button.backgroundColor = .clear
        sim1Button.layer.cornerRadius = 20
        sim1Button.layer.borderWidth = 5
        sim1Button.layer.borderColor = UIColor(red:12.0/255.0, green:87.0/255.0, blue:168.0/255.0, alpha: 1.0).cgColor
        
        sim2Button.backgroundColor = .clear
        sim2Button.layer.cornerRadius = 20
        sim2Button.layer.borderWidth = 5
        sim2Button.layer.borderColor = UIColor(red:12.0/255.0, green:87.0/255.0, blue:168.0/255.0, alpha: 1.0).cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sim1Action(_ sender: Any) {
        
        if delegate != nil {
            self.delegate?.passData(value: "SIM 1")
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sim2Action(_ sender: Any) {
        if delegate != nil {
            self.delegate?.passData(value: "SIM 2")
        }
        dismiss(animated: true, completion: nil)
    }
}
