//
//  MainPrototypeCell1.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 11/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class MainPrototypeCell1: UITableViewCell {

    @IBOutlet weak var uptimeLabel: UILabel!
    @IBOutlet weak var uptimeValue: UILabel!
    @IBOutlet weak var dataUsageLabel: UILabel!
    @IBOutlet weak var dataUsageValue: UILabel!
    @IBOutlet weak var clientsLabel: UILabel!
    @IBOutlet weak var clientsValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
