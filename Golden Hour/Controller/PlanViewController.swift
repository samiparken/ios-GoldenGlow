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

    @IBOutlet weak var mainContentView: UIView!

    
    
    // Line
    
    @IBOutlet weak var line1Left: UIView!
    @IBOutlet weak var line1Right: UIView!
    
    
    
    // for Sharing Data
    let myTabBar = TabBarController.singletonTabBar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainContentView()
        registerObservers()
        
        
        
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
    
    func setupMainContentView() {
        
        let contentBGView : UIView = UIView()
        contentBGView.frame = CGRect(x:0, y: view.frame.height / 7, width:view.frame.width, height: view.frame.height / 7 * 6)
        contentBGView.layer.backgroundColor = UIColor.black.cgColor
        contentBGView.layer.opacity = 0.3
        contentBGView.layer.cornerRadius = 25
        contentBGView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(contentBGView)
        view.bringSubviewToFront(mainContentView)
                
//        line1Left.layer.backgroundColor = UIColor.white.cgColor
//        view.addSubview(line1Left)
//        view.bringSubviewToFront(line1Left)
    }
    
    
    
    
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
    }
    
    @objc func updateBGImage(notification: NSNotification) {
        BGImageView.image = UIImage(named: myTabBar.BGImageViewName)
    }
}

//MARK: - Custom Rounded Border
extension UIView {
    func topRoundedCorners(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topLeft , .topRight],
            cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}


//MARK: - Custom Side Border
extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height, width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}


//MARK:- UILabel Character Spacing
extension UILabel {
  func addCharacterSpacing(kernValue: Double = 1.30) {
    if let labelText = text, labelText.count > 0 {
      let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}
