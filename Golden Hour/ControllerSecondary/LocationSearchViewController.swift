//
//  LocationSearchViewController.swift
//  Golden Hour
//
//  Created by Sam on 2021-08-06.
//  Copyright © 2021 Sam. All rights reserved.
//

import UIKit

class LocationSearchViewController: UIViewController {
    let myTabBar = TabBarController.singletonTabBar

    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        navigationItem.searchController = searchController

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCurrentLocation()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//MARK: - Init
    func setCurrentLocation() {
        if let location = myTabBar.currentLocation {
            title = "📍" + location
        }
    }
}
