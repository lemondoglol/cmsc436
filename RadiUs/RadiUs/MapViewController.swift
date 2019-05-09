//
//  MapViewController.swift
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
import MapKit

/*
 This View Controller controls the Map tab (the one that displays the map).
 */
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var databaseRef:DatabaseReference!
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    let msGreen = UIColor(rgb: 0x00FA9A)
    let limeGreen = UIColor(rgb: 0x90EE90)
    let aliceBlue = UIColor(rgb: 0xF0F8FF)
    let aquamarine = UIColor(rgb: 0x7FFFD4)
    let loginText = UIColor(rgb: 0xFA8072)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Map: viewDidLoad() called")
        
        // Set up Firebase
        databaseRef = Database.database().reference()
        
        // Set up visuals
        self.view.backgroundColor = aquamarine
        
        // Set up location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("Permission granted, so start tracking")
            locationManager.startUpdatingLocation()
        } else {
            print("Trying to request permission...")
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.requestLocation()
        
        // Set up map
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print ("Update location from MAP")
        centerMap(onLocation: locations.last!.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    /*
     Centers the map on a given 2D corrdinate. This function is used whenever the location is updated.
     */
    func centerMap(onLocation loc: CLLocationCoordinate2D) {
        let radius: CLLocationDistance = 1000
        let region = MKCoordinateRegion(center: loc, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(region, animated: true)
    }
}
