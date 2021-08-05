// Development Process
// + Timer / Activate
// + Timer / Apply current time
// + API : Calculate Sun's altitude based on Location
// + API : Show City Name based on Location

import UIKit

class SkyViewController: UIViewController {
    let myTabBar = TabBarController.singletonTabBar
    
    @IBOutlet weak var BGImageView: UIImageView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var sunPulse: UIImageView!
    var waveView: UIView!
    var wave1: WaveView!
    var wave2: WaveView!
    var wave3: WaveView!
    let wave1Length: CGFloat = 250
    let wave2Length: CGFloat = 230
    let wave3Length: CGFloat = 200
    let wave1Amp: CGFloat = 20
    let wave2Amp: CGFloat = 25
    let wave3Amp: CGFloat = 30

    // Deallocate Notification Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegates
        scrollView.delegate = self

        // Initialize
        registerObservers()
        setupSunPulse()
        setupWave()
        setupScrollView()
        setupPageControl()
        
        // Screen Organize
        view.bringSubviewToFront(scrollView)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("SkyView: viewDidAppear")
        if let location = myTabBar.currentLocation {
            currentLocationButton.setTitle(location, for: .normal)
            currentLocationButton.addCharacterSpacing()
        }
        if let imageName = myTabBar.BGImageViewName {
            BGImageView.image = UIImage(named: imageName)
        }
        waveAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("SkyView: viewWillDisappear")

    }

    
//    // Prepare for Switching Screen
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToSearch" {
//            let destinationVC = segue.destination as! SearchViewController
//            //            destinationVC.totalPerPerson = calculatorBrain.getTotalPerPerson()
//            //            destinationVC.splitNumber = calculatorBrain.getSplitNumber()
//            //            destinationVC.tipPct = calculatorBrain.getTipPct()
//        }
//    }
    
    //MARK: - For Notification Observers

        // for Notification Observers
        let keyForCityName = Notification.Name(rawValue: CityNameUpdateNotificationKey)
        let keyForBGImage = Notification.Name(rawValue: BGImageUpdateNotificationKey)
        let keyForTimerUpdate = Notification.Name(rawValue: TimerUpdateNotificationKey)
        let keyForSunPulsePositionUpdate = Notification.Name(rawValue: SunPulsePositionUpdateNotificationKey)
        let keyForWavePositionUpdate = Notification.Name(rawValue: wavePositionUpdateNotificationKey)

        // Register Observers for updates
        func registerObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(SkyViewController.updateCityName(notification:)), name: keyForCityName, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(SkyViewController.updateBGImage(notification:)), name: keyForBGImage, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(SkyViewController.updateTimer(notification:)), name: keyForTimerUpdate, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(SkyViewController.updateSunPulsePosition(notification:)), name: keyForSunPulsePositionUpdate, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(SkyViewController.updateWavePosition(notification:)), name: keyForWavePositionUpdate, object: nil)
        }

        @objc func updateCityName(notification: NSNotification) {
            currentLocationButton.setTitle(myTabBar.currentLocation, for: .normal)
            currentLocationButton.addCharacterSpacing()
        }
        
        @objc func updateBGImage(notification: NSNotification) {
            BGImageView.image = UIImage(named: myTabBar.BGImageViewName!)
        }
        
        @objc func updateTimer(notification: NSNotification) {
            makePulse()
        }
        
        @objc func updateSunPulsePosition(notification: NSNotification) {
            updateSunPulsePosition()
        }
        @objc func updateWavePosition(notification: NSNotification) {
            updateWavePosition()
        }
    

//MARK: - Init
    
    func setupScrollView() {
        // Initialize ScrollView
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: view.frame.height)
        
        // Initialize Pages
        let page1: ScrollViewPage1 = Bundle.main.loadNibNamed("ScrollViewPage1", owner: self, options: nil)?.first as! ScrollViewPage1
        let page2: ScrollViewPage2 = Bundle.main.loadNibNamed("ScrollViewPage2", owner: self, options: nil)?.first as! ScrollViewPage2
                
        // AddSubview Pages
        page1.frame = CGRect(x: view.frame.width * 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.addSubview(page1)

        page2.frame = CGRect(x: view.frame.width * 1, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.addSubview(page2)
    }
    
    func setupPageControl() {
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func setupWave() {        
        waveView = UIView(frame:CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height/2))
        view.addSubview(waveView)
        
        wave1 = WaveView(frame: CGRect(x: -wave1Length, y: 14, width: waveView.frame.width * 2, height: waveView.frame.height), wLength: wave1Length, wAmp: wave1Amp)
        wave1.backgroundColor = .clear
        waveView.addSubview(wave1)
        
        wave2 = WaveView(frame: CGRect(x: -wave2Length, y: 7, width: waveView.frame.width * 2, height: waveView.frame.height), wLength: wave2Length, wAmp: wave2Amp)
        wave2.backgroundColor = .clear
        waveView.addSubview(wave2)
        
        wave3 = WaveView(frame: CGRect(x: -wave3Length, y: 0, width: waveView.frame.width * 2, height: waveView.frame.height), wLength: wave3Length, wAmp: wave3Amp)
        wave3.backgroundColor = .clear
        waveView.addSubview(wave3)
    }
    
    func waveAnimation() {
        // Animation for wave1
        UIView.animate(withDuration: 3, delay: 0, options: [.curveLinear, .repeat] ) {
            self.wave1.frame.origin.x = 0
        } completion: { (_) in
            self.wave1.frame.origin.x = -self.wave1Length
        }
        
        // Animation for wave2
        UIView.animate(withDuration: 5, delay: 0, options: [.curveLinear, .repeat] ) {
            self.wave2.frame.origin.x = 0

        } completion: { (_) in
            self.wave2.frame.origin.x = -self.wave2Length
        }
        
        // Animation for wave3
        UIView.animate(withDuration: 7, delay: 0, options: [.curveLinear, .repeat] ) {
            self.wave3.frame.origin.x = 0

        } completion: { (_) in
            self.wave3.frame.origin.x = -self.wave3Length
        }
    }
    
    func setupSunPulse() {
        sunPulse = UIImageView(image: UIImage(named: "Sun"))
        sunPulse.frame = CGRect(x: (view.frame.width/2) - 35, y: -100, width: 70, height: 70)
        self.view.addSubview(sunPulse)
    }
    
    func makePulse() {
        if Int(myTabBar.timerSec)! % 2 == 0 {
            let pulse = PulseAnimation(numberOfPulses: 1, radius: 50, position: CGPoint(x: 35, y: 35), duration: 10)
            pulse.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            sunPulse.layer.insertSublayer(pulse, below: sunPulse.layer)
        }
    }

    
//MARK: - Methods
    func updateWavePosition() {
        let offsetRate = scrollView.contentOffset.x/view.frame.width
        let screenHeight = self.view.frame.height

        // Wave Vertical Position
        self.waveView.frame.origin.y = ((0.8 - myTabBar.wavePosition) * (offsetRate) + myTabBar.wavePosition ) * screenHeight

    }
    
    func updateSunPulsePosition() {
        let offsetRate = scrollView.contentOffset.x/view.frame.width
        let screenHeight = self.view.frame.height

        // SunPulse Vertical Position
        self.sunPulse.frame.origin.y = ((0.23 - myTabBar.sunPulsePosition) * (offsetRate) + myTabBar.sunPulsePosition ) * screenHeight
    }


//MARK: - Actions
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "goToSearch", sender: self)
        //locationManager.requestLocation()
    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "goToSearch", sender: self)
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        
    }
}

//MARK: - UIScrollViewDelegate
extension SkyViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetRate = scrollView.contentOffset.x/view.frame.width
        
        //Update Page Control
        let pageIndex = round(offsetRate)
        pageControl.currentPage = Int(pageIndex)
        
        // Disable Vertical Scrolling
        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
        
        updateWavePosition()
        updateSunPulsePosition()
    }
}


