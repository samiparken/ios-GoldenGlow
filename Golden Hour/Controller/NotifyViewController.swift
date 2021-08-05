import UIKit

class NotifyViewController: UIViewController {
    let myTabBar = TabBarController.singletonTabBar
    
    @IBOutlet weak var BGImageView: UIImageView!
    @IBOutlet weak var notificationTitleButton: UIButton!
    @IBOutlet weak var sunStackViewBG: UIView!
    @IBOutlet weak var reminderTimingTableView: UITableView!
        
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
    }
        
    override func viewDidAppear(_ animated: Bool) {
        print("NotifyView: viewDidAppear")
        if let imageName = myTabBar.BGImageViewName {
            BGImageView.image = UIImage(named: imageName)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("NotifyView: viewWillDisappear")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
//MARK: - For Notification Observers

    // for Notification Observers
    let keyForBGImage = Notification.Name(rawValue: BGImageUpdateNotificationKey)

    // Register Observers for updates
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SkyViewController.updateBGImage(notification:)), name: keyForBGImage, object: nil)
    }
    
    @objc func updateBGImage(notification: NSNotification) {
        BGImageView.image = UIImage(named: myTabBar.BGImageViewName!)
    }
    
    
//MARK: - Init
    func initLayout() {
        notificationTitleButton.addCharacterSpacing()
        sunStackViewBG.layer.cornerRadius = 10
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
    
}


/* from deleted NotifyTableViewController.swift
 
 
 
 */



//MARK: - UITableViewDelegate
extension NotifyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // clear AccessorryType
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
            cell?.accessoryType = .none
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
