//
//  PostAndRepliesViewController.swift
//  RadiUs
//
//  Created by Justin Vo on 5/10/19.
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
 This class represents the view that shows the original post and all of its replies.
 A user can see this view when he clicks on the post on the map or from the Posts tab.
 */
class PostAndRepliesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var databaseRef:DatabaseReference!
    
    var post: Post?
    var replies: [String]?
    
    @IBOutlet weak var tableViewOutlet: UITableView! {
        didSet {
            tableViewOutlet.dataSource = self
            tableViewOutlet.delegate = self
        }
    }
    
    @IBOutlet weak var postLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replies = post?.comments
        postLabel.text = post?.content
        
        // Set up Firebase
        databaseRef = Database.database().reference()
        
        // Set up refresh controls (swipe and hold downward to refresh)
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(doRefresh), for: .valueChanged)
        tableViewOutlet.refreshControl = refresher
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath)
        if let myCell = cell as? ReplyCell {
            myCell.replyLabelOutlet.text = replies![indexPath.row]
        }
        return cell
    }
    
    /*
     Disables the tapping of replies / comments.
     TODO: remove this if we want to make it so tapping a comment does something. Maybe show the full comment?
     TODO: go to attribute selector in storyboard and selection style -> None
     */
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    @objc func doRefresh() {
        updateComments()
        tableViewOutlet.refreshControl?.endRefreshing()
    }
    
    func updateComments() {
        retrieveSinglePostFromFirebase(postID: post!.postID) { (refreshedPost) in
            self.replies? = refreshedPost.comments
            self.tableViewOutlet.reloadData()
        }
    }
    
    func retrieveSinglePostFromFirebase(postID: String, completion: @escaping (_ p: Post) -> ()) {
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
            completion(res!)
        })
    }
    
    func makeCommentsOnPost(comment: String, postID: String) {
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
    
    // TODO: make and connect an actual input text field outlet
    var inputComment = "This is a comment with random number: \(Int.random(in: 0..<100))"
    func sendComment() {
        replies?.append(inputComment)
        tableViewOutlet.reloadData()
        makeCommentsOnPost(comment: inputComment, postID: post!.postID)
    }
    
    // TODO: remove this (testing purposes)
    @IBAction func testSendComment(_ sender: UIButton) {
        sendComment()
    }
}
