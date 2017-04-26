//
//  apnPrototypeCell.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 24/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class apnPrototypeCell: UITableViewCell {

    @IBOutlet weak var apnTextField: UITextField!
    
    @IBOutlet weak var apnNameTextField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
