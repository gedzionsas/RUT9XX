//
//  DesignableButton.swift
//  rutxxx_IOS
//
//  Created by Gedas Urbonas on 21/03/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import UIKit


@IBDesignable
class DesignableButton: UIButton {
  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
    }
  }

}
