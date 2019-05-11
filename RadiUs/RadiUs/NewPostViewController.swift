//
//  NewPostViewController.swift
//  RadiUs
//
//  Created by Justin Vo on 5/4/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import FirebaseDatabase
import Firebase
import CoreData
import CoreLocation

/*
 This View Controller controls the view in which the User creates a new post (the view that shows after pressing New Post).
 */
class NewPostViewController: UIViewController {
    
    @IBOutlet weak var publicPostOutlet: UIButton!
    var databaseRef:DatabaseReference!
    
    let msGreen = UIColor(rgb: 0x00FA9A)
    let limeGreen = UIColor(rgb: 0x90EE90)
    let aliceBlue = UIColor(rgb: 0xF0F8FF)
    let aquamarine = UIColor(rgb: 0x7FFFD4)
    let loginText = UIColor(rgb: 0xFA8072)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        databaseRef = Database.database().reference()
        self.view.backgroundColor = aquamarine
        publicPostOutlet.layer.backgroundColor = limeGreen.cgColor
        publicPostOutlet.roundCorners(corners: [.topLeft, .topRight], radius: 50)
        
        publicPostOutlet.setTitleColor(loginText, for: .normal)
    }
}
