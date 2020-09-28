//
//  SearchViewController.swift
//  Golden Hour
//
//  Created by Sam on 8/29/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit
import Foundation

class PlanViewController: UIViewController {

    // Top Bar
    @IBOutlet weak var currentLocationOutlet: UIButton!

    // BG & Layout
    @IBOutlet weak var BGImageView: UIImageView!
    @IBOutlet weak var mainContentView: UIView!
    
    // Date Buttons
    @IBOutlet weak var dateButtonOutlet: UIButton!
    
    
    // Center Weather & Sunset
    @IBOutlet weak var weatherIcon: UIButton!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var setriseIcon: UIButton!
    @IBOutlet weak var setriseTime: UILabel!
    
    // Time Labels
    @IBOutlet weak var timeLabel1: UILabel!
    @IBOutlet weak var timeLabel2: UILabel!
    @IBOutlet weak var timeLabel3: UILabel!
    @IBOutlet weak var timeLabel4: UILabel!
    
    // Event BG
    @IBOutlet weak var event1BG: UIImageView!
    @IBOutlet weak var event2BG: UIImageView!
    @IBOutlet weak var event3BG: UIImageView!
    
    // Event Labels
    @IBOutlet weak var event1Label: UILabel!
    @IBOutlet weak var event2Label: UILabel!
    @IBOutlet weak var event3Label: UILabel!
  
    // Event Durations
    @IBOutlet weak var event1Duration: UILabel!
    @IBOutlet weak var event2Duration: UILabel!
    @IBOutlet weak var event3Duration: UILabel!
    
    // Bottom Selector Bar & Buttons
    @IBOutlet weak var morningButton: UIButton!
    @IBOutlet weak var eveningButton: UIButton!
    @IBOutlet weak var selectorBar: UIImageView!

    // for Sharing Data
    let myTabBar = TabBarController.singletonTabBar
    
    // Deallocate Notification Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerObservers()
        setupMainContentViewBG()
        setupEventBGsRadius()
        setupFixedLabelSpacing()



    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("PlanView: viewDidAppear")
        
        if let location = myTabBar.currentLocation {
            currentLocationOutlet.setTitle(location, for: .normal)
            currentLocationOutlet.addCharacterSpacing()
        }
        
        if let imageName = myTabBar.BGImageViewName {
            BGImageView.image = UIImage(named: imageName)
        }
        
        if( myTabBar.isEvening ) { eveningButtonPressed((Any).self) }
        else{ morningButtonPressed((Any).self) }
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("PlanView: viewWillDisappear")
    }
    
    func setupFixedLabelSpacing() {
        event1Label.addCharacterSpacing()
        event2Label.addCharacterSpacing()
        event3Label.addCharacterSpacing()
        dateButtonOutlet.addCharacterSpacing()
    }
    
    func setupEventBGsRadius() {
        event1BG.layer.cornerRadius = 15
        event2BG.layer.cornerRadius = 15
        event3BG.layer.cornerRadius = 15
    }
    
    func setupMainContentViewBG() {
        let contentBGView : UIView = UIView()
        contentBGView.frame = CGRect(x:0, y: view.frame.height / 9, width:view.frame.width, height: view.frame.height / 9 * 8)
        contentBGView.layer.backgroundColor = UIColor.black.cgColor
        contentBGView.layer.opacity = 0.8
        contentBGView.layer.cornerRadius = 25
        contentBGView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(contentBGView)
        
        view.bringSubviewToFront(mainContentView)

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
        timeLabel1.text = myTabBar.morningTime[3]
        timeLabel2.text = myTabBar.morningTime[2]
        timeLabel3.text = myTabBar.morningTime[1]
        timeLabel4.text = myTabBar.morningTime[0]
        timeLabel1.addCharacterSpacing()
        timeLabel2.addCharacterSpacing()
        timeLabel3.addCharacterSpacing()
        timeLabel4.addCharacterSpacing()
        
        // Event Duration Update
        event1Duration.text = String(myTabBar.morningDuration[2]) + " min"
        event2Duration.text = String(myTabBar.morningDuration[1]) + " min"
        event3Duration.text = String(myTabBar.morningDuration[0]) + " min"
        event1Duration.addCharacterSpacing()
        event2Duration.addCharacterSpacing()
        event3Duration.addCharacterSpacing()
        
        
        // Event Label Update
//        event1Label.text = "BLUE HOUR"
//        event2Label.text = "GOLDEN HOUR"
//        event3Label.text = "LOW SUN"
        
        // Weather Update
        weatherIcon.setImage(UIImage(systemName: "cloud.sun"), for: .normal)
        weatherLabel.text = "Fair"
        weatherLabel.addCharacterSpacing()
        
        // Sunrise Update
        setriseIcon.setImage(UIImage(systemName: "sunrise"), for: .normal)
        setriseTime.text = myTabBar.sunriseTime
        setriseTime.addCharacterSpacing()

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
        timeLabel1.text = myTabBar.eveningTime[0]
        timeLabel2.text = myTabBar.eveningTime[1]
        timeLabel3.text = myTabBar.eveningTime[2]
        timeLabel4.text = myTabBar.eveningTime[3]
        timeLabel1.addCharacterSpacing()
        timeLabel2.addCharacterSpacing()
        timeLabel3.addCharacterSpacing()
        timeLabel4.addCharacterSpacing()
        
        // Event Duration Update
        event1Duration.text = String(myTabBar.eveningDuration[0]) + " min"
        event2Duration.text = String(myTabBar.eveningDuration[1]) + " min"
        event3Duration.text = String(myTabBar.eveningDuration[2]) + " min"
        event1Duration.addCharacterSpacing()
        event2Duration.addCharacterSpacing()
        event3Duration.addCharacterSpacing()
        
        // Event Label Update
//        event1Label.text = "LOW SUN"
//        event2Label.text = "GOLDEN HOUR"
//        event3Label.text = "BLUE HOUR"
        
        // Weather Update
        weatherIcon.setImage(UIImage(systemName: "sun.max"), for: .normal)
        weatherLabel.text = "Good"
        weatherLabel.addCharacterSpacing()
        
        // Sunset Update
        setriseIcon.setImage(UIImage(systemName: "sunset"), for: .normal)
        setriseTime.text = myTabBar.sunsetTime
        setriseTime.addCharacterSpacing()
        
    }
    

    
    //MARK: - For Notification Observers
    
    // for Notification Observers
    let keyForCityName = Notification.Name(rawValue: CityNameUpdateNotificationKey)
    let keyForBGImage = Notification.Name(rawValue: BGImageUpdateNotificationKey)
    
    // Register Observers for updates
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SkyViewController.updateCityName(notification:)), name: keyForCityName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SkyViewController.updateBGImage(notification:)), name: keyForBGImage, object: nil)
    }
    
    @objc func updateCityName(notification: NSNotification) {
        currentLocationOutlet.setTitle(myTabBar.currentLocation, for: .normal)
        currentLocationOutlet.addCharacterSpacing()
    }
    
    @objc func updateBGImage(notification: NSNotification) {
        BGImageView.image = UIImage(named: myTabBar.BGImageViewName!)
    }
}


