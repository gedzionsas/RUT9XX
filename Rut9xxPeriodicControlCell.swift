//
//  Rut9xxPeriodicControlCell.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 13/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Rut9xxPeriodicControlCell: UITableViewCell {

    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
