//
//  Rut9xxRulesCell.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 12/07/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Rut9xxRulesCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var triggerLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
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
