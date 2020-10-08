//
//  ScrollViewPage1.swift
//  Golden Hour
//
//  Created by Sam on 9/15/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

class ScrollViewPage1: UIView {
        
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var upperStateStack: UIStackView!
    @IBOutlet weak var middleStateStack: UIStackView!
    
    // Upper State Stack
    @IBOutlet weak var upperCurrentState: UIButton!
    @IBOutlet weak var upperRemainingTime: UILabel!
    @IBOutlet weak var upperNextState: UILabel!
    
    // Middle State Stack
    @IBOutlet weak var middleCurrentState: UIButton!
    @IBOutlet weak var middleRemainingTime: UILabel!
    @IBOutlet weak var middleNextStateLabel: UILabel!
    
    
    @IBOutlet weak var sunAngleLabel: UILabel!
    
    
    // for Sharing Data
    let myTabBar = TabBarController.singletonTabBar

    // Deallocate Notification Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerObservers()

        upperStateStack.isHidden = true
        
    }
    
    
    
    
    
    
    //MARK: - For Notification Observers
    
    // for Notification Observers
    let keyForTimerUpdate = Notification.Name(rawValue: TimerUpdateNotificationKey)
    let keyForSunAngleUpdate = Notification.Name(rawValue: SunAngleUpdateNotificationKey)
    let keyForCurrentState = Notification.Name(rawValue: CurrentStateUpdateNotificationKey)
    
    // Register Observers for updates
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollViewPage1.updateTimer(notification:)), name: keyForTimerUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollViewPage1.updateSunAngle(notification:)), name: keyForSunAngleUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollViewPage1.updateCurrentState(notification:)), name: keyForCurrentState, object: nil)
    }
    
    @objc func updateCurrentState(notification: NSNotification) {
        middleCurrentState.setTitle(myTabBar.currentState, for: .normal)
        middleCurrentState.addCharacterSpacing(3)
        middleNextStateLabel.text = "NEXT: " + myTabBar.nextState
        middleNextStateLabel.addCharacterSpacing()
    }
    
    @objc func updateTimer(notification: NSNotification) {
        middleRemainingTime.text = "\(myTabBar.timerHour):\(myTabBar.timerMin):\(myTabBar.timerSec)"
    }
    
    @objc func updateSunAngle(notification: NSNotification) {
        let mySunAngle = myTabBar.sunAngle
        let mySunAngleText = mySunAngle < 10
            ? String(format: "%.1f", mySunAngle) + "°"
            : String(format: "%.0f", mySunAngle) + "°"
        sunAngleLabel.text = mySunAngleText
    }
}
