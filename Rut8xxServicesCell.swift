//
//  Rut8xxServicesCell.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 09/08/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class Rut8xxServicesCell: UITableViewCell {

    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var restartButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
