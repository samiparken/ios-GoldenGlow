import Foundation
protocol TimerManagerDelegate {
    func didUpdateTimer(_ h: Int, _ m: Int, _ s: Int)
    func didEndTimer()
    func didUpdateLocaltime()
}

class TimerManager {
    var delegate: TimerManagerDelegate?
    var countdownTimer: Timer!
    var toTime: Date!
    var isLocalTimeOn: Bool = false
    let calendar = Calendar.current
    var localTimeMinute: Int = -1 {
        didSet {
            if ( localTimeMinute != oldValue ) {
                self.delegate?.didUpdateLocaltime()
            }
        }
    }
    

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
        
        if (isLocalTimeOn) {
            let now = Date()
            localTimeMinute = Int(calendar.component(.minute, from: now))
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        self.delegate?.didEndTimer()        
    }
    
    
    func startLocalTime() {
        isLocalTimeOn = true
        localTimeMinute = -1
    }
    
    func endLocalTime() {
        isLocalTimeOn = false
    }
    
}
