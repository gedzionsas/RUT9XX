//
//  pickerCell.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 24/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class pickerCell: UITableViewCell {

    @IBOutlet weak var nameOfPicker: UILabel!
    @IBOutlet weak var pickerValue: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
