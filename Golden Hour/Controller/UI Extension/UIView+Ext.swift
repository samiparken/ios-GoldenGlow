//
//  UIView+Ext.swift
//  Golden Hour
//
//  Created by Sam on 10/7/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation
import UIKit
//MARK: - Custom Rounded Border
extension UIView {
    func topRoundedCorners(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .topRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
