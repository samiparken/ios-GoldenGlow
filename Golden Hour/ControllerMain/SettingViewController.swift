import UIKit
import ChameleonFramework

class SettingViewController: UIViewController {
    let myTabBar = TabBarController.singletonTabBar
    
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var BGImageView: UIImageView!
    @IBOutlet weak var aboutStackViewBG: UIView!
    @IBOutlet weak var settingTitleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerObservers()
        
        BGView.backgroundColor = UIColor(hexString: "4E89CB")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initLayout()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        print("SettingView: viewDidAppear")
        if let imageName = myTabBar.BGImageViewName {
            BGImageView.image = UIImage(named: imageName)
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
        BGImageView.image = UIImage(named: myTabBar.BGImageViewName!)
    }
    
    
//MARK: - Init
    
    func initLayout() {
        aboutStackViewBG.layer.cornerRadius = 10
        settingTitleButton.addCharacterSpacing()
        
        
    }
    
}
