//
//  ViewController.swift
//  RadiUs
//
//  Created by Admin on 4/18/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import Firebase
import CoreData
import CoreLocation


// firebase link
// https://radius-9c8dc.firebaseio.com/

// caution. Firebase cant store variables with '.' inside, so make sure emailaddress does not include .

/*
 This file is just holding all of Ryan's Firebase functions, and currently isn't actually linked to any View.
 Each View Controller should have its own View in which it controls (so the Map tab has a file called MapViewController.swift).
 */
class ViewController: UIViewController {
    
    var currentUser: User!
    var databaseRef:DatabaseReference!
    let locationManager = CLLocationManager()
    
    let msGreen = UIColor(rgb: 0x00FA9A)
    let limeGreen = UIColor(rgb: 0x90EE90)
    let aliceBlue = UIColor(rgb: 0xF0F8FF)
    let aquamarine = UIColor(rgb: 0x7FFFD4)
    let loginText = UIColor(rgb: 0xFA8072)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        databaseRef = Database.database().reference()
        logIN(firstName: "Ryan", lastName: "Chen", emailAddress: "rc@fakemailcom", password: "abc123")
        self.view.backgroundColor = aquamarine
        // uncomment this to see how it works
        test()
    }
    
    // call logIN when everytime user run this app
    func logIN(firstName:String, lastName:String, emailAddress:String, password: String){
        currentUser = User(firstName: firstName, lastName: lastName, emailAddress: emailAddress, password: password)
    }
    
    // logIn verify, if success, then do the segue, call this method before call logIn method
    func logInVerify(emailAddress:String, password:String){
        databaseRef.child("userTable").observeSingleEvent(of: .value, with: {(snapshot) in
            var userExist = false
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let userID = child.key
                let ps = child.childSnapshot(forPath: "password").value as? String
                if userID == emailAddress && password == ps {
                    // do the segues here
                    print("user logged In")
                    userExist = true;
                    break;
                }
            }
            if userExist == false {
                // handle it if user failed to logIn
                print("user not exist")
            }
        })
    }
    
    // sign up verify, if success, then do the segue, call this method before call logIn method
    func signUpVerify(user: User){
        databaseRef.child("userTable").observeSingleEvent(of: .value, with: {(snapshot) in
            var userExist = false
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let userID = child.key
                if userID == user.emailAddress {
                    userExist = true;
                    break;
                }
            }
            if userExist == true {
                print("user already exist")
            } else {
                // you can add this user to the firebase
            }
        })
    }
    
    // you can run this method to see how it works
    func test() {
        let p1 = Post(postID: "0", content: "good", latitude: 0, longitude: 0)
        let p2 = Post(postID: "1", content: "haha", latitude: 1, longitude: 1)
        storeUserToFirebase(user: currentUser)
        makeNewPost(content: "i just made another new post", latitude: 4.5, longitude: 3.3)
        storeSinglePostToFirebase(post: p1)
        storeSinglePostToFirebase(post: p2)
        findPostsAround(userLatitude: 0, userLongtitude: 0, range: 10)
        makeCommentsOnPost(comment: "rc add a a anew comment", postID: "1")
        retrieveSinglePostFromFirebase(postID: "1")
        retrieveAllPostsFromFirebase()
        
        logInVerify(emailAddress: "rc@fakemailcom", password: "abc123")
        logInVerify(emailAddress: "rcs@fakemailcom", password: "abc123")
    }
    
    /*
     other methods
     */
    // find posts around current loction in range
    func findPostsAround(userLatitude:Double, userLongtitude:Double, range: Double){
        var res = [Post]()
        databaseRef.child("postTable").observeSingleEvent(of: .value, with: {(snapshot) in
            var allPosts:[Post] = [Post]()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let postID = child.key
                let content = child.childSnapshot(forPath: "content").value as? String
                let latitude = child.childSnapshot(forPath: "latitude").value as? Double
                let longitude = child.childSnapshot(forPath: "longitude").value as? Double
                var comments = child.childSnapshot(forPath: "comments").value as? [String]
                let post = Post(postID: postID, content: content!, latitude: latitude!, longitude: longitude!)
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
                    res.append(post)
                }
            }
            // TODO
            // do updating view here, data was stored in 'res'
            print("here \(res)")
        })
    }
    
    // make a comment to a post with postID
    func makeCommentsOnPost(comment: String, postID: String){
        var post:Post!
        databaseRef.child("postTable").observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let postkeyID = child.key
                if postkeyID != postID {
                    continue
                }
                let content = child.childSnapshot(forPath: "content").value as? String
                let latitude = child.childSnapshot(forPath: "latitude").value as? Double
                let longitude = child.childSnapshot(forPath: "longitude").value as? Double
                var comments = child.childSnapshot(forPath: "comments").value as? [String]
                let res = Post(postID: postkeyID, content: content!, latitude: latitude!, longitude: longitude!)
                post = res
                if comments == nil {
                    comments = [String]()
                }
                post.comments = comments!
                break
            }
            post!.comments.append(comment)
            self.databaseRef.child("postTable").child(post.postID).child("content").setValue(post.content)
            self.databaseRef.child("postTable").child(post.postID).child("latitude").setValue(post.latitude)
            self.databaseRef.child("postTable").child(post.postID).child("longitude").setValue(post.longitude)
            self.databaseRef.child("postTable").child(post.postID).child("comments").setValue(post.comments)
        })
    }
    
    // make a new post
    func makeNewPost(content:String, latitude:Double, longitude:Double){
        var post:Post!
        databaseRef.child("postTable").observeSingleEvent(of: .value, with: {(snapshot) in
            var count = 0
            count = Int(snapshot.childrenCount)
            post = Post(postID: String(count), content: content, latitude: latitude, longitude: longitude)
            self.databaseRef.child("postTable").child(post.postID).setValue(post.postID)
            self.databaseRef.child("postTable").child(post.postID).child("content").setValue(post.content)
            self.databaseRef.child("postTable").child(post.postID).child("latitude").setValue(post.latitude)
            self.databaseRef.child("postTable").child(post.postID).child("longitude").setValue(post.longitude)
            self.databaseRef.child("postTable").child(post.postID).child("comments").setValue(post.comments)
        })
    }
    
    /*
        retrieve data from firebase
     */
    // retrieve single post from firebase
    func retrieveSinglePostFromFirebase(postID: String) {
        var res:Post?
        databaseRef.child("postTable").observeSingleEvent(of: .value, with: {(snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let cID = child.key
                if cID != postID {
                    continue
                }
                let content = child.childSnapshot(forPath: "content").value as? String
                let latitude = child.childSnapshot(forPath: "latitude").value as? Double
                let longitude = child.childSnapshot(forPath: "longitude").value as? Double
                var comments = child.childSnapshot(forPath: "comments").value as? [String]
                let post = Post(postID: postID, content: content!, latitude: latitude!, longitude: longitude!)
                if comments == nil {
                    comments = [String]()
                }
                post.comments = comments!
                res = post
                break
            }
            // TODO
            // do updating view here, data is stored in 'res'
            print("retrieveing single postID with \(postID) \(res?.content)")
        })
    }
    
    // retrieve all posts from firebase
    func retrieveAllPostsFromFirebase(){
        databaseRef.child("postTable").observeSingleEvent(of: .value, with: {(snapshot) in
            var allPosts:[Post] = [Post]()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let postID = child.key
                let content = child.childSnapshot(forPath: "content").value as? String
                let latitude = child.childSnapshot(forPath: "latitude").value as? Double
                let longitude = child.childSnapshot(forPath: "longitude").value as? Double
                var comments = child.childSnapshot(forPath: "comments").value as? [String]
                let post = Post(postID: postID, content: content!, latitude: latitude!, longitude: longitude!)
                if comments == nil {
                    comments = [String]()
                }
                post.comments = comments!
                allPosts.append(post)
            }
            // TODO
            // do updating view here, data is stored in 'allPosts'
            print("all \(allPosts)")
        })
    }

    /*
        store data to firebase
     */
    // store user into firebase
    func storeUserToFirebase(user :User) {
        databaseRef.child("userTable").child(user.emailAddress!).setValue(user.emailAddress)
        databaseRef.child("userTable").child(user.emailAddress!).child("firstName").setValue(user.firstName!)
        databaseRef.child("userTable").child(user.emailAddress!).child("lastName").setValue(user.lastName!)
        databaseRef.child("userTable").child(user.emailAddress!).child("password").setValue(user.password!)
    }
    // store post into firebase
    func storeSinglePostToFirebase(post :Post) {
        databaseRef.child("postTable").child(post.postID).setValue(post.postID)
        databaseRef.child("postTable").child(post.postID).child("content").setValue(post.content)
        databaseRef.child("postTable").child(post.postID).child("latitude").setValue(post.latitude)
        databaseRef.child("postTable").child(post.postID).child("longitude").setValue(post.longitude)
        databaseRef.child("postTable").child(post.postID).child("comments").setValue(post.comments)
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
