//
//  SearchViewController.swift
//  Golden Hour
//
//  Created by Sam on 8/29/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController {

    
    @IBOutlet weak var BGImageView: UIImageView!
    
    @IBOutlet weak var currentLocationOutlet: UIButton!
    
    // for Sharing Data
    let myTabBar = TabBarController.singletonTabBar
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("PlanView: viewDidAppear")
        currentLocationOutlet.setTitle(myTabBar.currentLocation, for: .normal)
        BGImageView.image = UIImage(named: myTabBar.BGImageViewName)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("PlanView: viewWillDisappear")
        print(myTabBar.BGImageViewName)
    }
    
    
    


}
