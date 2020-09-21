//
//  ScrollViewPage2.swift
//  Golden Hour
//
//  Created by Sam on 9/15/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

class ScrollViewPage2: UIView {

    
    //Time Labels
    @IBOutlet weak var lowSunTimeLabel: UILabel!
    @IBOutlet weak var goldenHourTimeLabel: UILabel!
    @IBOutlet weak var blueHourTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    //Nametag Labels
    @IBOutlet weak var lowSunLabel: UILabel!
    @IBOutlet weak var goldenHourLabel: UILabel!
    @IBOutlet weak var blueHourLabel: UILabel!
    
    //Duration Labels
    @IBOutlet weak var lowSunDurationLabel: UILabel!
    @IBOutlet weak var goldenHourDurationLabel: UILabel!
    @IBOutlet weak var blueHourDurationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLabelSpacing()
                
    }


    func setupLabelSpacing()
    {
        lowSunLabel.addCharacterSpacing()
        goldenHourLabel.addCharacterSpacing()
        blueHourLabel.addCharacterSpacing()
        
    }
    

    //MARK: - Set Time Label
    func setLowSunTimeLabel(_ time: String) {
        lowSunTimeLabel.text = time
        lowSunTimeLabel.addCharacterSpacing()
    }
    func setGoldenHourTimeLabel(_ time: String) {
        goldenHourTimeLabel.text = time
        goldenHourTimeLabel.addCharacterSpacing()
    }
    func setBlueHourTimeLabel(_ time: String) {
        blueHourTimeLabel.text = time
        blueHourTimeLabel.addCharacterSpacing()
    }
    func setEndTimeLabel(_ time: String) {
        endTimeLabel.text = time
        endTimeLabel.addCharacterSpacing()
    }
    
    //MARK: - Set Duration Label
    func setLowSunDurationLabel(_ duration: String) {
        lowSunDurationLabel.text = duration
        lowSunDurationLabel.addCharacterSpacing()
    }
    func setGoldenHourDurationLabel(_ duration: String) {
        goldenHourDurationLabel.text = duration
        goldenHourDurationLabel.addCharacterSpacing()
    }
    func setBlueHourDurationLabel(_ duration: String) {
        blueHourDurationLabel.text = duration
        blueHourDurationLabel.addCharacterSpacing()
    }

    
//    func setSunsetMode(){
//        setriseImageView.image = UIImage(systemName: "sunset.fill")
//    }
//
//    func setSunriseMode(){
//        setriseImageView.image = UIImage(systemName: "sunrise.fill")
//    }
    
}


// UILabel Character Spacing
extension UILabel {
  func addCharacterSpacing(kernValue: Double = 1.30) {
    if let labelText = text, labelText.count > 0 {
      let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}

// Custom Side Border
extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}
