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

    @IBOutlet weak var BGImageView: UIImageView!
    @IBOutlet weak var currentLocationOutlet: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    let myTabBar = TabBarController.singletonTabBar

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
        setupSunSlider()
        setupGroundSlider()
        setupScrollView(w: 10)

        // Screen Organize
        view.bringSubviewToFront(scrollView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("SkyView: viewDidAppear")
        if let location = myTabBar.currentLocation {
            currentLocationOutlet.setTitle(location, for: .normal)
            currentLocationOutlet.addCharacterSpacing()
        }
        if let imageName = myTabBar.BGImageViewName {
            BGImageView.image = UIImage(named: imageName)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("SkyView: viewWillDisappear")

    }
    
    
    func setupScrollView(w: CGFloat) {
        // Initialize ScrollView
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * w, height: view.frame.height)
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
        sunSlider.maximumValue = 130
        sunSlider.value = 0
        
        // Constraints
        sunSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sunSlider)
        sunSlider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))  //rotate
        NSLayoutConstraint.activate([
            sunSlider.widthAnchor.constraint(equalTo: scrollView.heightAnchor),      //width from view.height
            sunSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sunSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        currentLocationOutlet.setTitle(myTabBar.currentLocation, for: .normal)
        currentLocationOutlet.addCharacterSpacing()
    }
    
    @objc func updateBGImage(notification: NSNotification) {
        BGImageView.image = UIImage(named: myTabBar.BGImageViewName!)
    }
    
    
}


//MARK: - UIScrollViewDelegate
extension SkyViewController: UIScrollViewDelegate {
    
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
                        
            // Disable Vertical Scrolling
            if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
               scrollView.contentOffset.y = 0
            }
            
            // Change Sun Slider
            sunSlider.value = Float(scrollView.contentOffset.x/view.frame.width * 10)
            groundSlider.value = Float(scrollView.contentOffset.x/view.frame.width * 10)
//            print(groundSlider.value)
        }
}


