//
//  UIColor+Ext.swift
//  Golden Hour
//
//  Created by Sam on 10/7/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

//MARK: - For HEX Color Code
// *Usage*
// view.backgroundColor = UIColor.init(rgb: 0xF58634)     // + .cgColor
extension UIColor {
    convenience init(rgb: UInt) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}

