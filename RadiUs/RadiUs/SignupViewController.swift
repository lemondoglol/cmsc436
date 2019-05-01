//
//  signupViewController.swift
//  RadiUs
//
//  Created by Justin Chao on 4/30/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import FirebaseDatabase
import Firebase
import CoreData
import CoreLocation

class SignupViewController : UIViewController{
    
    var databaseRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
    }
    
    
}
