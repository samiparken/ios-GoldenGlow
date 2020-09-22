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

