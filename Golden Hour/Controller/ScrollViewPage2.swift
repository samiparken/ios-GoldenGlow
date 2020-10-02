//
//  ScrollViewPage2.swift
//  Golden Hour
//
//  Created by Sam on 9/15/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

class ScrollViewPage2: UIView {

    // Date Buttons
    @IBOutlet weak var dateLeftButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var dateRightButton: UIButton!
    
    // Weather & Sun SetRise
    @IBOutlet weak var setRiseIcon: UIButton!
    @IBOutlet weak var setRiseTimeLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIButton!
    @IBOutlet weak var weatherLabel: UILabel!
    
    //EventTime Labels
    @IBOutlet weak var eventTimeLabel1: UILabel!
    @IBOutlet weak var eventTimeLabel2: UILabel!
    @IBOutlet weak var eventTimeLabel3: UILabel!
    @IBOutlet weak var eventTimeLabel4: UILabel!
        
    //Event Labels
    @IBOutlet weak var event1Label: UILabel!
    @IBOutlet weak var event2Label: UILabel!
    @IBOutlet weak var event3Label: UILabel!
    
    //Event Duration Labels
    @IBOutlet weak var event1DurationLabel: UILabel!
    @IBOutlet weak var event2DurationLabel: UILabel!
    @IBOutlet weak var event3DurationLabel: UILabel!
    
    //Event BG
    @IBOutlet weak var event1BG: UIImageView!
    @IBOutlet weak var event2BG: UIImageView!
    @IBOutlet weak var event3BG: UIImageView!
    
    //Bottom Bar Selector
    @IBOutlet weak var morningButton: UIButton!
    @IBOutlet weak var eveningButton: UIButton!
    @IBOutlet weak var selectorBar: UIImageView!
    
    @IBOutlet weak var contentCenterBar: UIStackView!
    
    // for Sharing Data
    let myTabBar = TabBarController.singletonTabBar

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupEventLabelSpacing()
        setupEventBGsRadius()
        
    }


    func setupEventLabelSpacing()
    {
        event1Label.addCharacterSpacing()
        event2Label.addCharacterSpacing()
        event3Label.addCharacterSpacing()
    }
    
    func setupEventBGsRadius() {
        event1BG.layer.cornerRadius = 15
        event2BG.layer.cornerRadius = 15
        event3BG.layer.cornerRadius = 15
    }
    

    //MARK: - Set Time Label
    func setEvent1Time(_ time: String) {
        eventTimeLabel1.text = time
        eventTimeLabel1.addCharacterSpacing()
    }
    func setEvent2Time(_ time: String) {
        eventTimeLabel2.text = time
        eventTimeLabel2.addCharacterSpacing()
    }
    func setEvent3Time(_ time: String) {
        eventTimeLabel3.text = time
        eventTimeLabel3.addCharacterSpacing()
    }
    func setEventEndTime(_ time: String) {
        eventTimeLabel4.text = time
        eventTimeLabel4.addCharacterSpacing()
    }
    
    //MARK: - Set Duration Label
    func setEvent1Duration(_ duration: String) {
        event1DurationLabel.text = duration
        event1DurationLabel.addCharacterSpacing()
    }
    func setEvent2Duration(_ duration: String) {
        event2DurationLabel.text = duration
        event2DurationLabel.addCharacterSpacing()
    }
    func setEvent3Duration(_ duration: String) {
        event3DurationLabel.text = duration
        event3DurationLabel.addCharacterSpacing()
    }

    
    func setSunsetMode(){
        setRiseIcon.setImage(UIImage(systemName: "sunset"), for: .normal)
    }

    func setSunriseMode(){
        setRiseIcon.setImage(UIImage(systemName: "sunrise"), for: .normal)
    }

    
    
    @IBAction func morningButtonPressed(_ sender: Any) {
        
        // Button Color Change
        morningButton.setTitleColor(UIColor.white, for: .normal)
        eveningButton.setTitleColor(UIColor.darkGray, for: .normal)

        // Bar Animation
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.selectorBar.transform = CGAffineTransform(translationX: 0, y: 0)
        } completion: { (_) in
            // For second animation
        }

        // Event BG Update
//        event1BG.image = UIImage(named: "Event_Blue")
//        event2BG.image = UIImage(named: "Event_Golden")
//        event3BG.image = UIImage(named: "Event_LowSun")
        
        // Event Time Update
        eventTimeLabel1.text = myTabBar.morningTime[3]
        eventTimeLabel2.text = myTabBar.morningTime[2]
        eventTimeLabel3.text = myTabBar.morningTime[1]
        eventTimeLabel4.text = myTabBar.morningTime[0]
        eventTimeLabel1.addCharacterSpacing()
        eventTimeLabel2.addCharacterSpacing()
        eventTimeLabel3.addCharacterSpacing()
        eventTimeLabel4.addCharacterSpacing()
        
        // Event Duration Update
        event1DurationLabel.text = String(myTabBar.morningDuration[2]) + " min"
        event2DurationLabel.text = String(myTabBar.morningDuration[1]) + " min"
        event3DurationLabel.text = String(myTabBar.morningDuration[0]) + " min"
        event1DurationLabel.addCharacterSpacing()
        event2DurationLabel.addCharacterSpacing()
        event3DurationLabel.addCharacterSpacing()
        
        
        // Event Label Update
//        event1Label.text = "BLUE HOUR"
//        event2Label.text = "GOLDEN HOUR"
//        event3Label.text = "LOW SUN"
        
        // Weather Update
        weatherIcon.setImage(UIImage(systemName: "cloud.sun"), for: .normal)
        weatherLabel.text = "Fair"
        weatherLabel.addCharacterSpacing()
        
        // Sunrise Update
        setRiseIcon.setImage(UIImage(systemName: "sunrise"), for: .normal)
        setRiseTimeLabel.text = myTabBar.sunriseTime
        setRiseTimeLabel.addCharacterSpacing()
    }
    
    @IBAction func eveningButtonPressed(_ sender: Any) {

        // Button Color Change
        morningButton.setTitleColor(UIColor.darkGray, for: .normal)
        eveningButton.setTitleColor(UIColor.white, for: .normal)

        // Bar Animation
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.selectorBar.transform = CGAffineTransform(translationX: self.selectorBar.frame.width, y: 0)
        } completion: { (_) in
            // For second animation
        }
        
        // Event BG Update
//        event1BG.image = UIImage(named: "Event_LowSun")
//        event2BG.image = UIImage(named: "Event_Golden")
//        event3BG.image = UIImage(named: "Event_Blue")

        // Event Time Update
        eventTimeLabel1.text = myTabBar.eveningTime[0]
        eventTimeLabel2.text = myTabBar.eveningTime[1]
        eventTimeLabel3.text = myTabBar.eveningTime[2]
        eventTimeLabel4.text = myTabBar.eveningTime[3]
        eventTimeLabel1.addCharacterSpacing()
        eventTimeLabel2.addCharacterSpacing()
        eventTimeLabel3.addCharacterSpacing()
        eventTimeLabel4.addCharacterSpacing()
        
        // Event Duration Update
        event1DurationLabel.text = String(myTabBar.eveningDuration[0]) + " min"
        event2DurationLabel.text = String(myTabBar.eveningDuration[1]) + " min"
        event3DurationLabel.text = String(myTabBar.eveningDuration[2]) + " min"
        event1DurationLabel.addCharacterSpacing()
        event2DurationLabel.addCharacterSpacing()
        event3DurationLabel.addCharacterSpacing()
        
        // Event Label Update
//        event1Label.text = "LOW SUN"
//        event2Label.text = "GOLDEN HOUR"
//        event3Label.text = "BLUE HOUR"
        
        // Weather Update
        weatherIcon.setImage(UIImage(systemName: "sun.max"), for: .normal)
        weatherLabel.text = "Good"
        weatherLabel.addCharacterSpacing()
        
        // Sunset Update
        setRiseIcon.setImage(UIImage(systemName: "sunset"), for: .normal)
        setRiseTimeLabel.text = myTabBar.sunsetTime
        setRiseTimeLabel.addCharacterSpacing()
    }
    
    
    
}

