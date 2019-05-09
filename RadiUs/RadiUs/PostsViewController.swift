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
class PostsViewController: UIViewController, CLLocationManagerDelegate {
    
    var databaseRef:DatabaseReference!
    
    var locationManager = CLLocationManager()
    var previousLocation: CLLocation?
    
    let msGreen = UIColor(rgb: 0x00FA9A)
    let limeGreen = UIColor(rgb: 0x90EE90)
    let aliceBlue = UIColor(rgb: 0xF0F8FF)
    let aquamarine = UIColor(rgb: 0x7FFFD4)
    let loginText = UIColor(rgb: 0xFA8072)
    
    @IBOutlet weak var newPostOutlet: UIButton!
    
    /*
     Because the Login segues to this ViewController, this is the first ever viewDidLoad()
     called upon logging in.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Posts: viewDidLoad() called")
        
        // Set up Firebase
        databaseRef = Database.database().reference()
        
        // Set up visuals
        self.view.backgroundColor = aquamarine
        newPostOutlet.backgroundColor = limeGreen
        newPostOutlet.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        newPostOutlet.setTitleColor(loginText, for: .normal)
        
        // Set up location services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("Permission granted, so start tracking")
            locationManager.startUpdatingLocation()
        } else {
            print("Trying to request permission...")
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print ("Update loc from POSTS")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}
