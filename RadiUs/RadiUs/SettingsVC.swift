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
    var usingMiles = true
    var category: String = "All"
    
    @IBOutlet weak var saveRadiusButton: UIButton!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    @IBOutlet weak var setRadiusContainer: UIView!
    @IBOutlet weak var radiusEntry: UITextField!
    @IBOutlet weak var postTypeSelector: UISegmentedControl!
    
    @IBOutlet weak var milesOrKm: UISegmentedControl!
    
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
        saveRadiusButton.layer.backgroundColor = msGreen.cgColor
        
        setRadiusContainer.layer.cornerRadius = 25
        setRadiusContainer.layer.borderWidth = 2
        setRadiusContainer.layer.borderColor = loginText.cgColor
        
        radiusEntry.keyboardType = UIKeyboardType.decimalPad
        
        radiusEntry.text? = String(radius)
        
        milesOrKm.layer.cornerRadius = 15
        milesOrKm.layer.borderWidth = 2.0
        milesOrKm.layer.borderColor = loginText.cgColor
        milesOrKm.layer.masksToBounds = true
        postTypeSelector.layer.cornerRadius = 25
        postTypeSelector.layer.borderWidth = 2.0
        postTypeSelector.layer.borderColor = loginText.cgColor
        postTypeSelector.layer.masksToBounds = true
    }
    
//    @IBAction func milesKmChanged(_ sender: UISegmentedControl) {
//        switch milesOrKm.selectedSegmentIndex {
//        case 0:
//            //display as mi
//            radiusEntry.text = String(radius)
//            radiusEntry.placeholder = String(radius)
//
//        case 1:
//            print("switched to km")
//            let temp = radius*1.609
//            radiusEntry.text = String(Double(round(10*temp)/10))
//            radiusEntry.placeholder = String(Double(round(10*temp)/10))
//
//
//        default:
//            break
//        }
//    }
    
    @IBAction func changeCategory(_ sender: UISegmentedControl) {
        switch postTypeSelector.selectedSegmentIndex {
        case 0: category = "All"
        case 1: category = "#Food"
        case 2: category = "#Landmark"
        case 3: category = "#Event"
        default: print ("Uh oh. Something is wrong with the category segmented control.")
        }
    }
    
    @IBAction func saveRadius(_ sender: Any) {
        radiusEntry.resignFirstResponder()
        let radiusString: String = radiusEntry.text!
        radius = Double(radiusString) as! Double
        
        if(milesOrKm.selectedSegmentIndex == 0){
            //radiusEntry.placeholder = radiusEntry.text
            let temp = radius*1.609
            radius = Double(round(10*temp)/10)
        }
        else{
            let temp = radius/1.609
            radius = Double(round(10*temp)/10)
            
            //Pls Don't delete this stuff
//          radiusEntry.text = String(Double(round(10*temp)/10))
//          radiusEntry.placeholder = String(Double(round(10*temp)/10))
        }
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
