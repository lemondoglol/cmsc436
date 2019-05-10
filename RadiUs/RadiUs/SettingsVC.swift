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
    var radius: Double = 5
    
    let msGreen = UIColor(rgb: 0x00FA9A)
    let limeGreen = UIColor(rgb: 0x90EE90)
    let aliceBlue = UIColor(rgb: 0xF0F8FF)
    let aquamarine = UIColor(rgb: 0x7FFFD4)
    let loginText = UIColor(rgb: 0xFA8072)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = aquamarine
    }
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
