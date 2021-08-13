import UIKit

class NotifyViewController: UIViewController {
    let defaults = UserDefaults.standard
    let myTabBar = TabBarController.singletonTabBar
    
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var notificationTitleButton: UIButton!
    
    @IBOutlet weak var sunStackViewBG: UIView!
    @IBOutlet weak var reminderTimingTableView: UITableView!
    @IBOutlet weak var reminderTimingTableViewBG: UIView!
    
    // Switches
    @IBOutlet weak var sunriseSwitch: UISwitch!
    @IBOutlet weak var sunsetSwitch: UISwitch!
    @IBOutlet weak var lowsunMorningSwitch: UISwitch!
    @IBOutlet weak var lowsunEveningSwitch: UISwitch!
    @IBOutlet weak var goldenhourMorningSwitch: UISwitch!
    @IBOutlet weak var goldenhourEveningSwitch: UISwitch!
    @IBOutlet weak var bluehourMorningSwitch: UISwitch!
    @IBOutlet weak var bluehourEveningSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerObservers()
        
        //delegate
        reminderTimingTableView.delegate = self
        reminderTimingTableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        initLayout()
        initTableView()
        initSwitches()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        print("NotifyView: viewDidAppear")
        if let color = myTabBar.BGImageColor {
            BGView.backgroundColor = UIColor(hexString: color)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("NotifyView: viewWillDisappear")
    }
    
//MARK: - For Notification Observers

    // for Notification Observers
    let keyForBGImage = Notification.Name(rawValue: BGImageUpdateNotificationKey)

    // Register Observers for updates
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SkyViewController.updateBGImage(notification:)), name: keyForBGImage, object: nil)
    }
    
    @objc func updateBGImage(notification: NSNotification) {
        if let color = myTabBar.BGImageColor {
            BGView.backgroundColor = UIColor(hexString: color)
        }
    }
    
    
//MARK: - Init
    func initLayout() {
        notificationTitleButton.addCharacterSpacing()
        sunStackViewBG.layer.cornerRadius = 10
        reminderTimingTableViewBG.layer.cornerRadius = 10
    }
    
    func initTableView() {
        // set background to clear
        reminderTimingTableView.backgroundColor = .clear

        // add clear view as tableFooterView
        // to prevent empty cells
        let v = UIView()
        v.backgroundColor = .clear
        reminderTimingTableView.tableFooterView = v
    }
    
    func initSwitches() {
                
        sunriseSwitch.isOn = defaults.bool(forKey: K.UserDefaults.Notification.sunrise)
        sunsetSwitch.isOn = defaults.bool(forKey: K.UserDefaults.Notification.sunset)
        
        lowsunMorningSwitch.isOn = defaults.bool(forKey: K.UserDefaults.Notification.lowSunMorning)
        lowsunEveningSwitch.isOn = defaults.bool(forKey: K.UserDefaults.Notification.lowSunEvening)
        
        goldenhourMorningSwitch.isOn = defaults.bool(forKey: K.UserDefaults.Notification.goldenHourMorning)
        goldenhourEveningSwitch.isOn = defaults.bool(forKey: K.UserDefaults.Notification.goldenHourEvening)
        
        bluehourMorningSwitch.isOn = defaults.bool(forKey: K.UserDefaults.Notification.blueHourMorning)
        bluehourEveningSwitch.isOn = defaults.bool(forKey: K.UserDefaults.Notification.blueHourEvening)

    }
    
//MARK: - UI Action
    @IBAction func sunriseSwitched(_ sender: UISwitch) {
        self.defaults.set(sender.isOn, forKey: K.UserDefaults.Notification.sunrise)
    }
    @IBAction func sunsetSwitched(_ sender: UISwitch) {
        self.defaults.set(sender.isOn, forKey: K.UserDefaults.Notification.sunset)
    }
    @IBAction func lowsunMorningSwitched(_ sender: UISwitch) {
        self.defaults.set(sender.isOn, forKey: K.UserDefaults.Notification.lowSunMorning)
    }
    @IBAction func lowsunEveningSwitched(_ sender: UISwitch) {
        self.defaults.set(sender.isOn, forKey: K.UserDefaults.Notification.lowSunEvening)
    }
    @IBAction func goldenhourMorningSwitched(_ sender: UISwitch) {
        self.defaults.set(sender.isOn, forKey: K.UserDefaults.Notification.goldenHourMorning)
    }
    @IBAction func goldenhourEveningSwitched(_ sender: UISwitch) {
        self.defaults.set(sender.isOn, forKey: K.UserDefaults.Notification.goldenHourEvening)
    }
    @IBAction func bluehourMorningSwitched(_ sender: UISwitch) {
        self.defaults.set(sender.isOn, forKey: K.UserDefaults.Notification.blueHourMorning)
    }    
    @IBAction func bluehourEveningSwitched(_ sender: UISwitch) {
        self.defaults.set(sender.isOn, forKey: K.UserDefaults.Notification.blueHourEvening)
    }
}
//MARK: - UITableViewDelegate
extension NotifyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // clear AccessorryType
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            let cell:ReminderTimingCell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as! ReminderTimingCell
            cell.accessoryType = .none
        }
        
        // set AccessoryType
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        // auto-deselect animation
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension NotifyViewController: UITableViewDataSource {
    
    // Num of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return K.REMINDER_TIMING_MODEL.count
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: ReminderTimingCell = tableView.dequeueReusableCell(withIdentifier: "ReminderTimingCell") as! ReminderTimingCell
            
        cell.cellTitle.text = K.REMINDER_TIMING_MODEL[indexPath.row]
        cell.accessoryType = indexPath.row == 0 ? .checkmark : .none
                
        return cell
    }
}
