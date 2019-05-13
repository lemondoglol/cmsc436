//
//  SettingsViewController.swift
//  RadiUs
//
//  Created by Justin Chao on 4/28/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import Foundation
import UIKit

/*
 This View Controller controls the Settings page.
 */
class SettingsVC : UIViewController {
    
    /*
     This variable is being read by the other tabs, so we must change this specific variable
     when actually changing the desired radius.
     
     Also, the unit we're using is miles.
     */
    var radius: Double = 20
    
    @IBOutlet weak var saveRadiusButton: UIButton!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    @IBOutlet weak var setRadiusContainer: UIView!
    @IBOutlet weak var radiusEntry: UITextField!
    
    let msGreen = UIColor(rgb: 0x00FA9A)
    let limeGreen = UIColor(rgb: 0x90EE90)
    let aliceBlue = UIColor(rgb: 0xF0F8FF)
    let aquamarine = UIColor(rgb: 0x7FFFD4)
    let loginText = UIColor(rgb: 0xFA8072)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = aquamarine
        
        logoutButtonOutlet.layer.backgroundColor = limeGreen.cgColor
        logoutButtonOutlet.roundCorners(corners: [.topLeft
            , .topRight], radius: 40)
        
        logoutButtonOutlet.setTitleColor(loginText, for: .normal)
        
        saveRadiusButton.setTitleColor(loginText, for: .normal)
        saveRadiusButton.layer.backgroundColor = limeGreen.cgColor
        
        setRadiusContainer.layer.cornerRadius = 25
        setRadiusContainer.layer.borderWidth = 2
        setRadiusContainer.layer.borderColor = msGreen.cgColor
        
        radiusEntry.keyboardType = UIKeyboardType.decimalPad
    }
    
    @IBAction func saveRadius(_ sender: Any) {
        radiusEntry.placeholder = radiusEntry.text
        radiusEntry.resignFirstResponder()
        //TODO update radius when pressed
    }
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
