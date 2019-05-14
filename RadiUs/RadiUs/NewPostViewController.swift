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
    
    @IBOutlet weak var surroundingScrollView: UITextView!
    
    @IBOutlet weak var inputPostOutlet: UITextView!
    @IBOutlet weak var postTypeSelector: UISegmentedControl!
    @IBOutlet weak var customTagEntry: UIView!
    
    @IBOutlet weak var addTagButton: UIButton!
    @IBOutlet weak var tagEntryField: UITextField!
    var databaseRef:DatabaseReference!
    
    var currentLocation: CLLocationCoordinate2D?
    var tagSaver = ""
    
    let msGreen = UIColor(rgb: 0x00FA9A)
    let limeGreen = UIColor(rgb: 0x90EE90)
    let aliceBlue = UIColor(rgb: 0xF0F8FF)
    let aquamarine = UIColor(rgb: 0x7FFFD4)
    let loginText = UIColor(rgb: 0xFA8072)
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch postTypeSelector.selectedSegmentIndex
        {
        case 0:
        tagEntryField.isUserInteractionEnabled = true
        tagEntryField.placeholder = "#YourCustomTag"
            tagEntryField.text = tagSaver
            addTagButton.isUserInteractionEnabled = true
        case 1:
            tagEntryField.isUserInteractionEnabled = false
            
            if(tagEntryField.placeholder == "#YourCustomTag"){
                tagSaver = tagEntryField.text ?? ""
            }
            
            tagEntryField.placeholder = "#Food"
            
            tagEntryField.text = ""
            addTagButton.isUserInteractionEnabled = false
        case 2:
            tagEntryField.isUserInteractionEnabled = false
            
            if(tagEntryField.placeholder == "#YourCustomTag"){
                tagSaver = tagEntryField.text ?? ""
            }
            
            tagEntryField.placeholder = "#Landmark"
            tagEntryField.text = tagSaver
            
            tagEntryField.text = ""
            addTagButton.isUserInteractionEnabled = false
        case 3:
            tagEntryField.isUserInteractionEnabled = false
            
            if(tagEntryField.placeholder == "#YourCustomTag"){
                tagSaver = tagEntryField.text ?? ""
            }
            
            tagEntryField.placeholder = "#Event"
            tagEntryField.text = tagSaver
            
            tagEntryField.text = ""
            addTagButton.isUserInteractionEnabled = false
            
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        databaseRef = Database.database().reference()
        self.view.backgroundColor = aquamarine
        publicPostOutlet.layer.backgroundColor = limeGreen.cgColor
        publicPostOutlet.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        
        self.navigationItem.title = "Post Something New"
        
        publicPostOutlet.setTitleColor(loginText, for: .normal)
        
        surroundingScrollView.layer.cornerRadius = 25
        
        surroundingScrollView.layer.borderColor = loginText.cgColor
        surroundingScrollView.layer.borderWidth = 2
    
        //postTypeSelector.ignoreCornerRadius()
        postTypeSelector.layer.cornerRadius = 25
        postTypeSelector.layer.borderWidth = 2.0
        postTypeSelector.layer.borderColor = loginText.cgColor
        postTypeSelector.layer.masksToBounds = true
        
        customTagEntry.layer.cornerRadius = 25
        customTagEntry.layer.borderWidth = 2
        customTagEntry.layer.borderColor = loginText.cgColor
        
    }
    
    /*
     Tapping the Send button will create a new post. The empty field in the view where the User can type
     in will be sent as the Post's content, then sent to Firebase. When tapping Send, an alert will pop
     up to notify the user that the Post as been created. Send the user back to the PostsView.
     */
    @IBAction func sendAction(_ sender: UIButton) {
        makeNewPost(content: inputPostOutlet.text, latitude: currentLocation!.latitude, longitude: currentLocation!.longitude)
        let alert = UIAlertController(title: "Success!", message: "You've successfully created your post!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
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
    
    func makeNewPost(content: String, latitude: Double, longitude: Double) {
        var post:Post!
        databaseRef.child("postTable").observeSingleEvent(of: .value, with: {(snapshot) in
            var count = 0
            count = Int(snapshot.childrenCount)
            print ("this is count: \(count)")
            post = Post(postID: String(count), content: content, latitude: latitude, longitude: longitude)
            self.databaseRef.child("postTable").child(post.postID).setValue(post.postID)
            self.databaseRef.child("postTable").child(post.postID).child("content").setValue(post.content)
            self.databaseRef.child("postTable").child(post.postID).child("latitude").setValue(post.latitude)
            self.databaseRef.child("postTable").child(post.postID).child("longitude").setValue(post.longitude)
            self.databaseRef.child("postTable").child(post.postID).child("comments").setValue(post.comments)
        })
    }
}

extension UISegmentedControl {
    
    func ignoreCornerRadius() {
        
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        
        let normalImage = renderer.image { (context) in
            tintColor.setStroke()
            context.stroke(bounds)
        }
        let selectedImage = renderer.image { (context) in
            tintColor.setFill()
            context.fill(bounds)
        }
        
        setBackgroundImage(normalImage, for: .normal, barMetrics: .default)
        setBackgroundImage(selectedImage, for: .selected, barMetrics: .default)
        
    }
}
