//
//  ScrollViewPage2.swift
//  Golden Hour
//
//  Created by Sam on 9/15/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

class ScrollViewPage2: UIView {

    // Date Buttons
    @IBOutlet weak var dateLeftButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var dateRightButton: UIButton!
    
    // Weather & Sun SetRise
    @IBOutlet weak var setRiseIcon: UIButton!
    @IBOutlet weak var setRiseTimeLabel: UILabel!
    @IBOutlet weak var totalTimeIcon: UIButton!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    //Upper Bar Selector
    @IBOutlet weak var morningButton: UIButton!
    @IBOutlet weak var eveningButton: UIButton!
    @IBOutlet weak var selectorBar: UIView!
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    var tableViewCellData: [CellData] = []
    
    let minimumCellSize: CGFloat = 60
    
    // for Sharing Data
    let myTabBar = TabBarController.singletonTabBar

    override func awakeFromNib() {
        super.awakeFromNib()
                
        registerObservers()
        
        tableView.delegate = self
        tableView.dataSource = self
        setupTableView()
        
    }

//MARK: - Init
    func setupTableView() {
                
        // Background
        tableView.backgroundColor = .clear
        
        // Register TableViewCell
        tableView.register(UINib(nibName: "TimeTableCell", bundle: nil), forCellReuseIdentifier: "TimeTableCell")

    }
    
//MARK: - For Notification Observers
    
    // for Notification Observers
    let keyForMorningEveningReady = Notification.Name(rawValue: MorningEveningReadyNotificationKey)
    
    // Register Observers for updates
    func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ScrollViewPage2.updateState(notification:)), name: keyForMorningEveningReady, object: nil)
    }
    
    @objc func updateState(notification: NSNotification) {
        
        if myTabBar.isEvening {
            eveningButtonPressed((Any).self)
        } else {
            morningButtonPressed((Any).self)
        }
    }

//MARK: - Methods
    func setSunsetMode(){
        setRiseIcon.setImage(UIImage(systemName: "sunset"), for: .normal)
    }

    func setSunriseMode(){
        setRiseIcon.setImage(UIImage(systemName: "sunrise"), for: .normal)
    }
    
//MARK: - UI Actions
    @IBAction func morningButtonPressed(_ sender: Any) {
        
        // Button Color Change
        morningButton.setTitleColor(UIColor.white, for: .normal)
        eveningButton.setTitleColor(UIColor.darkGray, for: .normal)

        // Bar Animation
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.selectorBar.transform = CGAffineTransform(translationX: 0, y: 0)
        } completion: { (_) in
            // For second animation
        }
        
        // Weather Update
        totalTimeLabel.text = myTabBar.morningTotalTime
        totalTimeLabel.addCharacterSpacing()
        
        // Sunrise Update
        setRiseIcon.setImage(UIImage(systemName: "sunrise"), for: .normal)
        setRiseTimeLabel.text = myTabBar.sunriseTime
        setRiseTimeLabel.addCharacterSpacing()
        
        // TableView Update
        tableViewCellData = myTabBar.morningCellData
        tableView.reloadData()
        
    }
    
    @IBAction func eveningButtonPressed(_ sender: Any) {

        // Button Color Change
        morningButton.setTitleColor(UIColor.darkGray, for: .normal)
        eveningButton.setTitleColor(UIColor.white, for: .normal)

        // Bar Animation
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.selectorBar.transform = CGAffineTransform(translationX: self.selectorBar.frame.width, y: 0)
        } completion: { (_) in
            // For second animation
        }
        
        // Weather Update
        totalTimeLabel.text = myTabBar.eveningTotalTime
        totalTimeLabel.addCharacterSpacing()
        
        // Sunset Update
        setRiseIcon.setImage(UIImage(systemName: "sunset"), for: .normal)
        setRiseTimeLabel.text = myTabBar.sunsetTime
        setRiseTimeLabel.addCharacterSpacing()
        
        // TableView Update
        tableViewCellData = myTabBar.eveningCellData
        tableView.reloadData()
    }
    
    
    
}

//MARK: - UITableViewDelegate
extension ScrollViewPage2: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped TimeTableCell!")
    }
}

//MARK: - UITableViewDataSource
extension ScrollViewPage2: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
            return tableViewCellData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row % 2 == 0 {
            return 18
        }
        else {
            let size = tableView.frame.size.height/7
            return size < minimumCellSize ? minimumCellSize : size
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TimeTableCell = tableView.dequeueReusableCell(withIdentifier: "TimeTableCell", for: indexPath) as! TimeTableCell

        // Timestamp Mode
        if indexPath.row % 2 == 0 {
            cell.cellView.isHidden = true
            cell.timeLabel.isHidden = false
            cell.timeLabel.text = tableViewCellData[indexPath.row].timeString
            cell.timeLabel.addCharacterSpacing()

        }
        // Cell Mode
        else {
            cell.cellView.isHidden = false
            cell.timeLabel.isHidden = true
            cell.cellTitle.text = tableViewCellData[indexPath.row].stateString
            cell.cellDuration.text = tableViewCellData[indexPath.row].duration
            cell.cellTitle.addCharacterSpacing()
            cell.cellDuration.addCharacterSpacing()
            cell.cellSymbol.image = UIImage(named: tableViewCellData[indexPath.row].symbol)
        }
        
        cell.selectionStyle = .none

        return cell
    }
}

