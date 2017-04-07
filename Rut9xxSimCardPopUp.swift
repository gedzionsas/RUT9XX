//
//  Rut9xxSimCardChoose.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 07/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Rut9xxSimCardPopUp: UIViewController {

    
    
    @IBOutlet weak var sim1Button: UIButton!
    @IBOutlet weak var sim2Button: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        sim1Button.backgroundColor = .clear
        sim1Button.layer.cornerRadius = 6
        sim1Button.layer.borderWidth = 5
        sim1Button.layer.borderColor = UIColor(red:1.0/255.0, green:182.0/255.0, blue:190.0/255.0, alpha: 1.0).cgColor        
        
        sim2Button.backgroundColor = .clear
        sim2Button.layer.cornerRadius = 6
        sim2Button.layer.borderWidth = 5
        sim2Button.layer.borderColor = UIColor(red:1.0/255.0, green:182.0/255.0, blue:190.0/255.0, alpha: 1.0).cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sim1Action(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sim2Action(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
