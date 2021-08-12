import UIKit
import ChameleonFramework

class SettingViewController: UIViewController {
    let myTabBar = TabBarController.singletonTabBar
    
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var timeFormatBG: UIView!
    @IBOutlet weak var aboutStackViewBG: UIView!
    @IBOutlet weak var settingTitleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerObservers()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initLayout()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        print("SettingView: viewDidAppear")
        if let color = myTabBar.BGImageColor {
            BGView.backgroundColor = UIColor(hexString: color)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("SettingView: viewWillDisappear")
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
        if let color = myTabBar.BGImageColor {
            BGView.backgroundColor = UIColor(hexString: color)
        }
    }
    
    
//MARK: - Init
    
    func initLayout() {
        aboutStackViewBG.layer.cornerRadius = 10
        timeFormatBG.layer.cornerRadius = 10
        settingTitleButton.addCharacterSpacing()
    }
    
}
