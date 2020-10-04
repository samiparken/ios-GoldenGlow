//
//  ViewController.swift
//  Golden Hour
//
//  Created by Sam on 8/27/20.
//  Copyright © 2020 Sam. All rights reserved.
//
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
    
    
    // Initial UISliders
    var sunSlider = UISlider(frame:CGRect(x: 0, y: 0, width: 100, height: 20))
    var groundSlider = UISlider(frame:CGRect(x: 0, y: 0, width: 100, height: 20))
            
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
        setupScrollView()
        setupPageControl()
        setupSunSlider()
        setupGroundSlider()

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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("SkyView: viewWillDisappear")

    }
    
    
    func setupScrollView() {
        // Initialize ScrollView
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: view.frame.height)
        
        
        // Initialize Slides
        let page1:ScrollViewPage1 = Bundle.main.loadNibNamed("ScrollViewPage1", owner: self, options: nil)?.first as! ScrollViewPage1
        let page2:ScrollViewPage2 = Bundle.main.loadNibNamed("ScrollViewPage2", owner: self, options: nil)?.first as! ScrollViewPage2
                
        // Subview slides
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
    
    func setupGroundSlider() {
        
        // Custom UISlider
        groundSlider.setThumbImage(UIImage(named: "Ground4"), for: .normal)
        groundSlider.minimumTrackTintColor = UIColor.clear
        groundSlider.maximumTrackTintColor = UIColor.clear
        groundSlider.minimumValue = 0
        groundSlider.maximumValue = 100
        groundSlider.value = 0

        // Constraints
        groundSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(groundSlider)
        groundSlider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))  //rotate
        NSLayoutConstraint.activate([
            groundSlider.widthAnchor.constraint(equalTo: view.heightAnchor),      //width from view.height
            groundSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: view.frame.height * 0.6),
            groundSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    func setupSunSlider() {
        
        // Custom UISlider
        sunSlider.setThumbImage(UIImage(named: "Sun"), for: .normal)
        sunSlider.minimumTrackTintColor = UIColor.clear
        sunSlider.maximumTrackTintColor = UIColor.clear
        sunSlider.minimumValue = -20
        sunSlider.maximumValue = 120
        sunSlider.value = 0
        
        // Constraints
        sunSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sunSlider)
        sunSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))  //rotate
        NSLayoutConstraint.activate([
            sunSlider.widthAnchor.constraint(equalTo: scrollView.heightAnchor),      //width from view.height
            sunSlider.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            sunSlider.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "goToSearch", sender: self)
        //locationManager.requestLocation()
    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "goToSearch", sender: self)
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        
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

    // Register Observers for updates
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SkyViewController.updateCityName(notification:)), name: keyForCityName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SkyViewController.updateBGImage(notification:)), name: keyForBGImage, object: nil)
    }

    @objc func updateCityName(notification: NSNotification) {
        currentLocationButton.setTitle(myTabBar.currentLocation, for: .normal)
        currentLocationButton.addCharacterSpacing()
    }
    
    @objc func updateBGImage(notification: NSNotification) {
        BGImageView.image = UIImage(named: myTabBar.BGImageViewName!)
    }
    
    
}


//MARK: - UIScrollViewDelegate
extension SkyViewController: UIScrollViewDelegate {
    
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
                        
            //Update Page Control
            let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
            pageControl.currentPage = Int(pageIndex)
            
            // Disable Vertical Scrolling
            if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
               scrollView.contentOffset.y = 0
            }
            
            // Change Sun Slider
            sunSlider.value = Float(scrollView.contentOffset.x/view.frame.width * 100)
            groundSlider.value = Float(scrollView.contentOffset.x/view.frame.width * 100)
        }
}


