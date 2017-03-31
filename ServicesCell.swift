//
//  ServicesCell.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 31/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class ServicesCell: UITableViewCell {

    
    
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var servicesName: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    @IBAction func switchButtonAction(_ sender: Any) {
//        if switchButton.isOn {
//            print("Switch is on")
//            switchButton.setOn(false, animated:true)
//        } else {
//            print("Switch is off")
//            switchButton.setOn(true, animated:true)
//        }
  //  }
    
//    func switchIsChanged(mySwitch: UISwitch) {
//        if switchButton.isOn {
//            print("UISwitch is ON")
//        } else {
//            print("UISwitch is OFF")
//        }
//    }

}
