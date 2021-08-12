import UIKit

class ScrollViewPage1: UIView {
    let myTabBar = TabBarController.singletonTabBar

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
    
    var currentState: String = "" {
        didSet {
            if currentState != oldValue {
                middleCurrentState.titleLabel?.text = myTabBar.currentState
                middleCurrentState.addCharacterSpacing(3)
            }
        }
    }
    
    var nextState: String = "" {
        didSet {
            if nextState != oldValue {
                middleNextStateLabel.text = "NEXT: " + myTabBar.nextState
                middleNextStateLabel.addCharacterSpacing()
            }
        }
    }
    
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
        //update labels
        currentState = myTabBar.currentState
        nextState = myTabBar.nextState
    }
        
    @objc func updateSunAngle(notification: NSNotification) {
        let mySunAngle = myTabBar.sunAngle
        let mySunAngleText = mySunAngle < 10
            ? String(format: "%.1f", mySunAngle) + "°"
            : String(format: "%.0f", mySunAngle) + "°"
        sunAngleLabel.text = mySunAngleText
    }
    
    @objc func updateTimer(notification: NSNotification) {
        middleRemainingTime.text =
            myTabBar.timerHour == "00"
            ? "\(myTabBar.timerMin):\(myTabBar.timerSec)"
            :"\(myTabBar.timerHour):\(myTabBar.timerMin):\(myTabBar.timerSec)"
        
        //update labels
        currentState = myTabBar.currentState
        nextState = myTabBar.nextState
    }
}
