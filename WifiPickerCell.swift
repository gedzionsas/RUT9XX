//
//  wifiPickerCell.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 25/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class WifiPickerCell: UITableViewCell {

    @IBOutlet weak var wifiPickerName: UILabel!
    @IBOutlet weak var wifiPickerValue: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
