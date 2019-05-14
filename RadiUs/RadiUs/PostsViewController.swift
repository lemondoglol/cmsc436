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
class PostsViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var databaseRef:DatabaseReference!
    
    var visiblePosts = [Post]()
    var tappedPost: Post?
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var searchRadius: Double?
    var searchCategory: String?
    
    @IBOutlet weak var tableViewOutlet: UITableView! {
        didSet {
            print("set del")
            tableViewOutlet.dataSource = self
            tableViewOutlet.delegate = self
            tableViewOutlet.rowHeight = UITableView.automaticDimension

        }
    }
    
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
        
        tableViewOutlet.roundCorners(corners: [.allCorners], radius: 40)
        
        self.navigationItem.title = "Posts Near You"
        
        // Set up location services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // Set up refresh controls (swipe and hold downward to refresh)
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(doRefresh), for: .valueChanged)
        tableViewOutlet.refreshControl = refresher
    }
    
    /*
     When the User switches to the Posts tab...
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("viewDidAppear() called from POSTS")
        
        // Get the radius and category from the settings tab
        let settingsVC = tabBarController!.viewControllers![2] as! SettingsVC
        searchRadius = settingsVC.radius
        searchCategory = settingsVC.category
        
        setUpLocationServices()
        updateVisiblePosts()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("viewDidDisappear() called from POSTS")
        locationManager.stopUpdatingLocation()
    }
    
    @objc func doRefresh() {
        updateVisiblePosts()
        tableViewOutlet.refreshControl?.endRefreshing()
    }
    
    // Called in viewDidAppear()
    func setUpLocationServices() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Called in viewDidAppear() and doRefresh()
    func updateVisiblePosts() {
        visiblePosts.removeAll(keepingCapacity: false)
        tableViewOutlet.reloadData()
        
        currentLocation = locationManager.location?.coordinate
        let currentLat: Double = currentLocation!.latitude
        let currentLong: Double = currentLocation!.longitude
        findPostsAround(userLatitude: currentLat, userLongtitude: currentLong, range: mileToMeters(miles: searchRadius!), category: searchCategory!) { (posts) in
            for post in posts {
                self.visiblePosts.append(post)
                self.sortPostsByDistance()
                self.tableViewOutlet.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visiblePosts.count
    }
    
    // When putting the Post into the cell, only put the "content" property for now
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        if let myCell = cell as? PostCell {
            
            myCell.postLabelOutlet.text = visiblePosts[indexPath.row].content

            
        }
        return cell
    }
    
    /*
     Function for tapping on a cell. When a user taps on the cell, a segue will be performed. We
     use a formal segue for this because we need to send the specific Post data to the new view.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewOutlet.deselectRow(at: indexPath, animated: true)
        tappedPost = visiblePosts[indexPath.row]
        performSegue(withIdentifier: "postAndRepliesSegue", sender: self)
    }
    
    /*
     There's two possible segues:
     postAndRepliesSegue: tap on post -> PostAndReplies View
     newPostSegue: tap on New Post button -> NewPost View
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postAndRepliesSegue" {
            let postAndRepliesVC = segue.destination as! PostAndRepliesViewController
            postAndRepliesVC.post = tappedPost // send the post information over
        } else if segue.identifier == "newPostSegue" {
            let newPostVC = segue.destination as! NewPostViewController
            newPostVC.currentLocation = self.currentLocation
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
            // do updating view here
            let coordinate1 = CLLocation(latitude: userLatitude, longitude: userLongtitude)
            for post in allPosts {
                let coordinate0 = CLLocation(latitude: post.latitude!, longitude: post.longitude!)
                let dist =  coordinate1.distance(from: coordinate0)
                
                //print("range \(range) distance \(dist) \(post.latitude!) \(post.longitude!) \(userLatitude) \(userLongtitude)")
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
    
    // Give it miles, it returns meters. Useful for handling CLLocation stuff.
    func mileToMeters(miles: Double) -> Double {
        return miles * 1609.34
    }
    
    func sortPostsByDistance() {
        visiblePosts.sort { (p1, p2) -> Bool in
            let p1Coordinate = CLLocation(latitude: p1.latitude!, longitude: p1.longitude!)
            let p2Coordinate = CLLocation(latitude: p2.latitude!, longitude: p2.longitude!)
            let currentCoord = CLLocation(latitude: currentLocation!.latitude, longitude: currentLocation!.longitude)
            
            let p1Distance = p1Coordinate.distance(from: currentCoord)
            let p2Distance = p2Coordinate.distance(from: currentCoord)
            return p1Distance < p2Distance
        }
    }
}
