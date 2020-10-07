//
//  UILabel+Ext.swift
//  Golden Hour
//
//  Created by Sam on 10/7/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation
import UIKit

//MARK:- UILabel Character Spacing
extension UILabel {
    func addCharacterSpacing(_ spacing: Double = 1.30) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}
