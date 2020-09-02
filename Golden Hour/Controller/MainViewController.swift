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
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var currentLocationOutlet: UIButton!
    
    @IBOutlet weak var centerTopLabel: UILabel!
    @IBOutlet weak var timeDigitMin: UILabel!
    @IBOutlet weak var timeSaperator: UILabel!
    @IBOutlet weak var timeDigitSec: UILabel!
    @IBOutlet weak var centerButtomLabel: UILabel!
    
    @IBOutlet weak var buttomLabel: UILabel!
    
    
    // For Timer
    var countdownTimer: Timer!
    var remainingTime: Int = 0
    
    // For Location
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Location Manager Delegate
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()  //ask location data permission
        locationManager.requestLocation()
        
        // Try Timer
        remainingTime = 1 * 60 + 30
        startTimer()

        
    }
    
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        let minutes: Int = (remainingTime / 60) % 60
        let seconds: Int = remainingTime % 60
        
        timeDigitMin.text = String(format: "%02d", minutes)
        timeDigitSec.text = String(format: "%02d", seconds)
        
        if remainingTime > 0 { remainingTime -= 1 }
        else { endTimer() }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        //self.performSegue(withIdentifier: "goToSearch", sender: self)
        locationManager.requestLocation()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSearch", sender: self)
    }
    

    
    // Prepare for Switching Screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearch" {
            let destinationVC = segue.destination as! SearchViewController
            //            destinationVC.totalPerPerson = calculatorBrain.getTotalPerPerson()
            //            destinationVC.splitNumber = calculatorBrain.getSplitNumber()
            //            destinationVC.tipPct = calculatorBrain.getTipPct()
        }
    }
    

    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        
    }
    
}



//MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {  // last is more accurate
            // Get longitude & latitude
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude

            // Get current date & time
            let date = Date()
            let GMT = Double(TimeZone.current.secondsFromGMT()) / 3600
            
            // Request SunPosition
            var sunModel: Spa_data = Spa_data(date, GMT, longitude: lon, latitude: lat)
            spa_calculate(spa: &sunModel)
            buttomLabel.text = String(format: "%2.2f", sunModel.declination)

        }
    }
}
