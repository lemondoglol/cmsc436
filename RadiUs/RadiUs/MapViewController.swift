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
    
    var databaseRef: DatabaseReference!
    
    var tappedPost: Post?
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var searchRadius: Double?
    var searchCategory: String?
    
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
        
        // Set up map
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    /*
     Since we're using tab bar controllers, it'll be useful to use viewDidAppear(). Whenever the user
     switches to this tab, it'll load all of the annotations and will start updating locations again.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("viewDidAppear() called from MAP")
        
        // Get the radius and category from the settings tab
        let settingsVC = tabBarController!.viewControllers![2] as! SettingsVC
        searchRadius = settingsVC.radius
        searchCategory = settingsVC.category
        
        // Request location upon switching tab, forcing the map to center on the user. This will call the
        // didUpdateLocations for the locationManager
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            print("Trying to request permission...")
            locationManager.requestWhenInUseAuthorization()
        }
        
        currentLocation = locationManager.location?.coordinate
        
        // Refresh the visible annotations
        mapView.removeAnnotations(mapView.annotations)
        setupAnnotations()
    }
    
    /*
     When the user switches tab, stop updating the location.
     */
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("viewDidDisappear() called from MAP")
        locationManager.stopUpdatingLocation()
    }
    
    /*
     Sets up all the annotations using our custom PostAnnotation class. Each annotation contains a Post.
     */
    func setupAnnotations() {
        let currentLat: Double = currentLocation!.latitude
        let currentLong: Double = currentLocation!.longitude
        findPostsAround(userLatitude: currentLat, userLongtitude: currentLong, range: mileToMeters(miles: searchRadius!), category: searchCategory!) { (posts) in
            for post in posts {
                // print("Adding annotation of post: \(post.postID)")
                let postAnnotation = PostAnnotation(post)
                // postAnnotation.title = post.postID
                // postAnnotation.subtitle = post.content
                // let postCoordinate = CLLocationCoordinate2D(latitude: post.latitude!, longitude: post.longitude!)
                // postAnnotation.coordinate = postCoordinate
                self.mapView.addAnnotation(postAnnotation)
            }
        }
    }
    
    // Ignore this usually; will only be called when the simulator doesn't have a location set
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("error: \(error.localizedDescription) ... Make sure to set a location in the simulator through Debug -> Location...")
    }
    
    /*
     This function is called every time a new update comes in from the location manager
     (so basically whenever the user moves around).
     First, it centers the map onto the user. It then creates a circle around that user, with
     a specific radius shown below.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print ("Update location from MAP")
        centerMap(onLocation: locations.last!.coordinate)
        
        mapView.removeOverlays(mapView.overlays) // remove previous circle
        let circleRadius: CLLocationDistance = mileToMeters(miles: searchRadius!)
        let circle = MKCircle(center: locations.last!.coordinate, radius: circleRadius)
        mapView.addOverlay(circle)
        
        currentLocation = locations.last!.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle = (overlay as? MKCircle)!
        let renderer = MKCircleRenderer(circle: circle)
        renderer.lineWidth = 3
        renderer.strokeColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is PostAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    /*
     This function controls what happens when the user taps on the (i) on the right side of the annotation view. It will send the user
     to the PostAndReplies View with the contents being the tapped Post's contents.
     */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let postAnnotation = view.annotation as! PostAnnotation
        tappedPost = postAnnotation.thisPost
        performSegue(withIdentifier: "mapToPostSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapToPostSegue" {
            let postAndRepliesVC = segue.destination as! PostAndRepliesViewController
            postAndRepliesVC.post = tappedPost // send the post information over
        }
    }
    
    /*
     Centers the map on a given 2D corrdinate. This function is used whenever the location is updated.
     The region scales with how big the searchRadius is
     */
    func centerMap(onLocation loc: CLLocationCoordinate2D) {
        let calculatedExpansion = (searchRadius! * 2) + (searchRadius! * 0.5)
        let regionRadius: CLLocationDistance = mileToMeters(miles: calculatedExpansion)
        let region = MKCoordinateRegion(center: loc, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    // Give it miles, it returns meters. Useful for handling CLLocation stuff.
    func mileToMeters(miles: Double) -> Double {
        return miles * 1609.34
    }
    
    /*
     Although we're using miles as the unit, we always use mileToMeters() (look above) when dealing with
     CLLocation stuff, 'cause they like meters. The range parameter will usually, correctly be in meters.
     */
    func findPostsAround(userLatitude:Double, userLongtitude:Double, range: Double, category: String, completion: @escaping (_ posts: [Post]) -> ()) {
        var res = [Post]()
        databaseRef.child("postTable").observeSingleEvent(of: .value, with: {(snapshot) in
            var allPosts:[Post] = [Post]()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let postID = child.key
                let content = child.childSnapshot(forPath: "content").value as? String
                let latitude = child.childSnapshot(forPath: "latitude").value as? Double
                let longitude = child.childSnapshot(forPath: "longitude").value as? Double
                var comments = child.childSnapshot(forPath: "comments").value as? [String]
                let category = child.childSnapshot(forPath: "category").value as? String
                let date = child.childSnapshot(forPath: "date").value as? String
                let post = Post(postID: postID, content: content!, latitude: latitude!, longitude: longitude!, category: category!, date: date!)
                if comments == nil {
                    comments = [String]()
                }
                post.comments = comments!
                allPosts.append(post)
            }
            let coordinate1 = CLLocation(latitude: userLatitude, longitude: userLongtitude)
            for post in allPosts {
                let coordinate0 = CLLocation(latitude: post.latitude!, longitude: post.longitude!)
                let dist =  coordinate1.distance(from: coordinate0)
                
                if (dist <= range) {
                    if category == post.category || category == "All" {
                        res.append(post)
                    }
                }
            }
            print("Amount of posts found: \(res.count)")
            completion(res)
        })
    }
}
