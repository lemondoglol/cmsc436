//
//  PostsViewController.swift
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
 This View Controller controls the view that holds all of the nearby posts (the center tab).
 */
class PostsViewController: UIViewController {
    
    var databaseRef:DatabaseReference!
    
    let msGreen = UIColor(rgb: 0x00FA9A)
    let limeGreen = UIColor(rgb: 0x90EE90)
    let aliceBlue = UIColor(rgb: 0xF0F8FF)
    let aquamarine = UIColor(rgb: 0x7FFFD4)
    let loginText = UIColor(rgb: 0xFA8072)
    
    @IBOutlet weak var newPostOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        databaseRef = Database.database().reference()
        self.view.backgroundColor = aquamarine
        newPostOutlet.backgroundColor = limeGreen
        newPostOutlet.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        newPostOutlet.setTitleColor(loginText, for: .normal)
    }
}
