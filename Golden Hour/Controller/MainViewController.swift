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

class MainViewController: UIViewController {
    
    @IBOutlet weak var currentLocationOutlet: UIButton!
    
    @IBOutlet weak var BGImageView: UIImageView!
    
    @IBOutlet weak var centerTopLabel: UILabel!
    @IBOutlet weak var timeDigitMin: UILabel!
    @IBOutlet weak var timeSaperator: UILabel!
    @IBOutlet weak var timeDigitSec: UILabel!
    @IBOutlet weak var centerButtomLabel: UILabel!
    
    @IBOutlet weak var buttomLabel: UILabel!
    
    // Managers
    var sunPositionManager = SunPositionManager()
    var locationManager = LocationManager()
    var timerManager = TimerManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegates
        sunPositionManager.delegate = self
        locationManager.delegate = self
        timerManager.delegate = self
        
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
    
    // Prepare for Switching Screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSearch" {
            let destinationVC = segue.destination as! SearchViewController
            //            destinationVC.totalPerPerson = calculatorBrain.getTotalPerPerson()
            //            destinationVC.splitNumber = calculatorBrain.getSplitNumber()
            //            destinationVC.tipPct = calculatorBrain.getTipPct()
        }
    }
}

//MARK: - SunPositionManagerDelegate
extension MainViewController: SunPositionManagerDelegate {
    
    // -2:Night / -1:Golden- / 1:Golden+ / 2:Day
    func didUpdateStatus(_ status: Int) {
        switch status {
        case -2: BGImageView.image = UIImage(named: "BG_Night")
        case -1:  BGImageView.image = UIImage(named: "BG_Golden-")
        case 1:  BGImageView.image = UIImage(named: "BG_Golden-")
        case 2:  BGImageView.image = UIImage(named: "BG_Day")
        default: BGImageView.image = UIImage(named: "BG_Start")
        }
    }
    
    func didUpdateRemainingTime(_ time: Int) {
        // Try Timer
        timerManager.remainingTime = time
        timerManager.startTimer()
    }
    
//    func didUpdateEndGoldenHour(_ endtime: Date) {
//        let calendar = Calendar.current
//        let hour = calendar.component(.hour, from: endtime)
//        let minute = calendar.component(.minute, from: endtime)
//        centerTopLabel.text = "Ends in"
//        centerButtomLabel.text = "Ends at " + String(format: "%02d:%02d", hour, minute)
//    }
    
    func didUpdateGoldenHour(_ next: [Date]) {
        let start = next[0]
        let end = next[1]
        
        centerTopLabel.text = "Lasts for"
        let last = Int( end.timeIntervalSince1970 - start.timeIntervalSince1970 )
        let lastMin: Int = last / 60
        let lastSec: Int = last % 60
        timeDigitMin.text = String(format: "%02d", lastMin)
        timeSaperator.text = ":"
        timeDigitSec.text = String(format: "%02d", lastSec)
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: start)
        let minute = calendar.component(.minute, from: start)
        
        centerButtomLabel.text = "Starts at " + String(format: "%02d:%02d", hour, minute)
    }
    
    func didUpdateSunsetTime(_ sunset: Date) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: sunset)
        let minute = calendar.component(.minute, from: sunset)
        print("Sunset : \(hour):\(minute)")
    }
    
    func didUpdateSunriseTime(_ sunrise: Date) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: sunrise)
        let minute = calendar.component(.minute, from: sunrise)
        print("Sunrise : \(hour):\(minute)")
    }
    
}

//MARK: - LocationManagerDelegate
extension MainViewController: LocationManagerDelegate {
    
    func didUpdateLocation(_ locationData: [Double]) {
        sunPositionManager.currentData.Longitude = locationData[0]
        sunPositionManager.currentData.Latitude = locationData[1]
        
        // Start Calculating
        sunPositionManager.startSunPositionSystem()
    }
    
    func didUpdateCityName(_ cityname: String) {
        self.currentLocationOutlet.setTitle(cityname, for: .normal)
    }
}

//MARK: - TimerManagerDelegate
extension MainViewController: TimerManagerDelegate {
    
    func didUpdateTimer(_ min: Int, _ sec: Int) {
        let minString: String = String(format: "%02d", min)
        let secString: String = String(format: "%02d", sec)
        
        timeDigitMin.text = minString
        timeSaperator.text = ":"
        timeDigitSec.text = secString
        
        // update SunAltitude every 5 seconds
        if (sec % 5 == 0)
        {
            sunPositionManager.updateCurrentAltitude()
            let sunAltitude = sunPositionManager.getCurrentAltitude()
            buttomLabel.text = String(format: "%2.2f", sunAltitude)
        }
    }
    
    func didEndTimer() {
        sunPositionManager.updateScreen()
    }
}
