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



}
