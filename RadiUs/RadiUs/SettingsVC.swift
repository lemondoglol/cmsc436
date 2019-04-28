//
//  SettingsViewController.swift
//  RadiUs
//
//  Created by Justin Chao on 4/28/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
