//
//  TimerManager.swift
//  Golden Hour
//
//  Created by Sam on 9/9/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import Foundation
protocol TimerManagerDelegate {
    func didUpdateTimer(_ h: Int, _ m: Int, _ s: Int)
    func didEndTimer()
}

class TimerManager {
    var delegate: TimerManagerDelegate?
    var countdownTimer: Timer!
    var toTime: Date!
    
    func startTimer(_ to: Date) {
        self.toTime = to
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        let remainingTime = toTime.timeIntervalSince1970 - Date().timeIntervalSince1970

        if ( remainingTime > 0 ) {
            let hour: Int = Int((remainingTime / 3600))
            let min: Int = Int(remainingTime / 60) % 60
            let sec: Int = Int(remainingTime) % 60
            self.delegate?.didUpdateTimer(hour, min, sec)
        }
        else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        self.delegate?.didEndTimer()        
    }
    
}
