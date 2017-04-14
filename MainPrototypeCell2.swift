//
//  MainPrototypeCell2.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 12/04/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit

class MainPrototypeCell2: UITableViewCell {

    @IBOutlet weak var mobileStrenghtRing: UICircularProgressRingView!
    @IBOutlet weak var wirelessQualityRing: UICircularProgressRingView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let progressRing = UICircularProgressRingView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
//        // Change any of the properties you'd like
//        progressRing.maxValue = 100
//     //   progressRing.innerRingColor = UIColor.blue
//        
//    progressRing.setProgress(value: 49, animationDuration: 2.0) {
//    print("Done animating!")
//    // Do anything your heart desires...
//    }
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    
}
