//
//  TabBarController.swift
//  Golden Hour
//
//  Created by Sam on 9/21/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var BGImageViewName: String = ""
    var currentLocation: String = ""
    
    
    static let singletonTabBar = TabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
}
