//
//  SearchViewController.swift
//  Golden Hour
//
//  Created by Sam on 8/29/20.
//  Copyright © 2020 Sam. All rights reserved.
//

import UIKit
import Foundation

class PlanViewController: UIViewController {
    
    @IBOutlet weak var BGImageView: UIImageView!
    @IBOutlet weak var currentLocationOutlet: UIButton!

    @IBOutlet weak var mainContentView: UIView!

    
    // Content Cells
    
    
    @IBOutlet weak var lowSunView: UIView!
    @IBOutlet weak var goldenHourView: UIView!
    @IBOutlet weak var blueHourView: UIView!
    @IBOutlet weak var contentListStack: UIStackView!
    @IBOutlet weak var lowSunLabelBox: UIStackView!
    @IBOutlet weak var goldenHourLabelBox: UIStackView!
    @IBOutlet weak var blueHourLabelBox: UIStackView!
    
    
    
    
    
    // Bottom Selector Bar & Buttons
    @IBOutlet weak var morningButton: UIButton!
    @IBOutlet weak var eveningButton: UIButton!
    @IBOutlet weak var selectorBar: UIImageView!

    
    
    // for Sharing Data
    let myTabBar = TabBarController.singletonTabBar
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerObservers()

        setupMainContentViewBG()
        setupContentCells()
        

        
    
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
    
    func setupContentCells() {
                
        // Low Sun View
        var gradColor = setGradient(color1: 0x7698F0, color2: 0xD9C545)
        lowSunView.layer.addSublayer(gradColor)
        contentListStack.addSubview(lowSunView)
        lowSunView.bringSubviewToFront(lowSunLabelBox)
        
        // Golden Hour View
        gradColor = setGradient(color1: 0xD9C545, color2: 0xD85E52, color3: 0x4849C3)
        goldenHourView.layer.addSublayer(gradColor)
        contentListStack.addSubview(goldenHourView)
        goldenHourView.bringSubviewToFront(goldenHourLabelBox)
        
        // Blue Hour View
        gradColor = setGradient(color1: 0x4849C3, color2: 0x04015B)
        blueHourView.layer.addSublayer(gradColor)
        contentListStack.addSubview(blueHourView)
        blueHourView.bringSubviewToFront(blueHourLabelBox)
        
    }
    
    func setGradient(color1: UInt, color2: UInt, color3: UInt = 0) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = ( color3 == 0) ? [UIColor.init(rgb: color1).cgColor, UIColor.init(rgb: color2).cgColor] : [UIColor.init(rgb: color1).cgColor, UIColor.init(rgb: color2).cgColor, UIColor.init(rgb: color3).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
//        gradient.locations = [0, 1]
        
//        gradient.frame = lowSunView.bounds
        gradient.frame = CGRect(x:0, y: -lowSunView.frame.height/2, width:view.frame.width - 40, height:lowSunView.frame.height)
        gradient.cornerRadius = 15

        return gradient
    }
    
    func setupMainContentViewBG() {
        let contentBGView : UIView = UIView()
        contentBGView.frame = CGRect(x:0, y: view.frame.height / 9, width:view.frame.width, height: view.frame.height / 9 * 8)
        contentBGView.layer.backgroundColor = UIColor.black.cgColor
        contentBGView.layer.opacity = 0.8
        contentBGView.layer.cornerRadius = 25
        contentBGView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(contentBGView)
        
        view.bringSubviewToFront(mainContentView)

    }
    
    
    
    @IBAction func morningButtonPressed(_ sender: Any) {
        
        morningButton.setTitleColor(UIColor.white, for: .normal)
        eveningButton.setTitleColor(UIColor.darkGray, for: .normal)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.selectorBar.transform = CGAffineTransform(translationX: 0, y: 0)
        } completion: { (_) in
            // For second animation
        }
    }
    
    
    @IBAction func eveningButtonPressed(_ sender: Any) {

        morningButton.setTitleColor(UIColor.darkGray, for: .normal)
        eveningButton.setTitleColor(UIColor.white, for: .normal)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.selectorBar.transform = CGAffineTransform(translationX: self.selectorBar.frame.width, y: 0)
        } completion: { (_) in
            // For second animation
        }
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

//MARK: - For HEX Color Code
// *Usage*
// view.backgroundColor = UIColor.init(rgb: 0xF58634)     // + .cgColor
extension UIColor {
    convenience init(rgb: UInt) {
       self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
}
