//
//  UIButton+Ext.swift
//  Golden Hour
//
//  Created by Sam on 10/7/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

extension UIButton{
    func addCharacterSpacing(_ spacing: CGFloat = 1.30) {
        if let labelText = self.titleLabel?.text!, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length - 1 ))
            setAttributedTitle(attributedString, for: .normal)
        }
    }
}
