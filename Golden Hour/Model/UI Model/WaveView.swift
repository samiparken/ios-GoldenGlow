//
//  WaveView.swift
//  Golden Hour
//
//  Created by Sam on 10/4/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation
import UIKit

class WaveView: UIView {
    
    var waveLength: CGFloat?
    var waveAmp: CGFloat?       // ~50

    // init the view with a rectangular frame
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    // init the view by deserialisation
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, wLength: CGFloat, wAmp: CGFloat)
    {
        super.init(frame: frame)
        self.waveLength = wLength
        self.waveAmp = wAmp
    }
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        let origin = CGPoint(x: 0, y: 50)
        path.move(to: origin)
        for i in 1 ... ( Int( rect.width / (waveLength!) ) + 1 ) {
            let x = waveLength! * CGFloat(i)
            path.addCurve(to: CGPoint(x: x, y: 50),
                          controlPoint1: CGPoint(x: x-(waveLength!/2), y: 50-waveAmp!),
                          controlPoint2: CGPoint(x: x-(waveLength!/2), y: 50+waveAmp!))
        }
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.close()
        
        // Gradient
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.3).cgColor,
            UIColor.black.withAlphaComponent(0.1).cgColor
        ]
        // Gradient direction
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.frame = CGRect(x:0, y: 0, width: rect.width, height: rect.height)

        // Mask Gradient
        let shapeMask = CAShapeLayer()
        shapeMask.path = path.cgPath
        gradient.mask = shapeMask

        self.layer.addSublayer(gradient)
    }
    
    
}
