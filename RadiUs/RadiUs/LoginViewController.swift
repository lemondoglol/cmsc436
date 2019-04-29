//
//  LoginViewController.swift
//  RadiUs
//
//  Created by Justin Chao on 4/28/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import Firebase
import CoreData
import CoreLocation

class LoginViewController : UIViewController{
    
    var databaseRef:DatabaseReference!
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
    }
    
    /*
     Will most likely add an alert if the logInVerify fails, saying something like
     "Username is not valid, username doesn't exist, or username or password are not
     valid."
     
     FOR TESTING: using username: rc@fakemailcom and password: abc123 will work.
     */
    @IBAction func login(_ sender: Any) {
        if let usernameText = usernameOutlet.text {
            if let passwordText = passwordOutlet.text {
                logInVerify(emailAddress: usernameText, password: passwordText)
            }
        }
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
                    self.segueToTabBar()
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
    
    func segueToTabBar() {
        let tabController = self.storyboard?.instantiateViewController(withIdentifier: "TabController") as! TabController
        tabController.selectedViewController = tabController.viewControllers?[1]
        self.present(tabController, animated: true, completion: nil)
    }
}
