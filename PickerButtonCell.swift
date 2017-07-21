//
//  pickerButtonCell.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 26/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class PickerButtonCell: UITableViewCell {
    
    
    @IBOutlet weak var valueOfButton: UIButton!
    @IBOutlet weak var nameOfValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
