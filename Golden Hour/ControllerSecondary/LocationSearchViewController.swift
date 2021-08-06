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
            
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCurrentLocation()
    }
    
    
//MARK: - Init
    func setCurrentLocation() {
        if let location = myTabBar.currentLocation {
            title = "📍" + location
        }
    }
}


//MARK: - UISearchResultsUpdating
extension LocationSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        print(text)
    }
        
}
