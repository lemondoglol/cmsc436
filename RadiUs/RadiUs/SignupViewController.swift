//
//  signupViewController.swift
//  RadiUs
//
//  Created by Justin Chao on 4/30/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import FirebaseDatabase
import Firebase
import CoreData
import CoreLocation

class SignupViewController : UIViewController{
    
    var databaseRef:DatabaseReference!
    
    /*
     Justin, you'll have to manually link the text fields to the outlets for both username
     and password (you can just ctrl-drag from the text field on the storyboard
     to each outlet). Then you should be fine when you push your storyboard.
     
     Also don't forget to do this for the createAccountAction button below
     */
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    let msGreen = UIColor(rgb: 0x00FA9A)
    let lightGreen = UIColor(rgb: 0x90EE90)
    let aliceBlue = UIColor(rgb: 0xF0F8FF)
    let lavendar = UIColor(rgb: 0xE6EEFA)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        
        createAccountButton.layer.cornerRadius = 20
        createAccountButton.layer.backgroundColor = lightGreen.cgColor
        createAccountButton.layer.borderColor = msGreen.cgColor
        createAccountButton.layer.borderWidth = 2
    }
    
    /*
     LINK THE BUTTON TO THE OUTLET BELOW (createAccountAction)
     
     For now, we'll allow any non-empty username. Once we sort out that whole mess (where we can't
     use periods), then maybe we'll force the username to be some email.
     
     We'll also allow any non-empty password. Probably will enforce it to be more strict (certain number of characters).
     
     Currently have no fields for first name and last name (I'll edit this function later after we have those fields in the storyboard).
     */
    @IBAction func createAccountAction(_ sender: UIButton) {
        if let usernameText = usernameOutlet.text {
            if let passwordText = passwordOutlet.text {
                
                // Check if the username and password are valid...
                if hasValidPassword() && hasValidUsername() {
                    let user = User(firstName: "EDIT_THIS", lastName: "EDIT_THIS", emailAddress: usernameText, password: passwordText)
                    storeUserToFirebase(user: user)
                }
            }
        }
    }
    
    func hasValidUsername() -> Bool {
        if let usernameText = usernameOutlet.text {
            if usernameText.isEmpty {
                // There's nothing in the username field, so send an alert
                let alert = UIAlertController(title: "Username cannot be empty", message: "Please enter your preferred username.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return false
            }
            
            if usernameText.contains(".") {
                // There's a period in the username, so send an alert
                let alert = UIAlertController(title: "Username cannot contain '.'", message: "Please remove any instances of '.' from your username.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return false
            }
        }
        return true
    }
    
    func hasValidPassword() -> Bool {
        let MIN_CHARACTERS_NEEDED = 1
        if let passwordText = passwordOutlet.text {
            
            if passwordText.count < MIN_CHARACTERS_NEEDED {
                // Password is too short, so send an alert
                let alert = UIAlertController(title: "Password is too short", message: "Your password should contain at least \(MIN_CHARACTERS_NEEDED) characters.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return false
            }
            
            if passwordText.contains(".") {
                // There's a period in the password, so send an alert
                let alert = UIAlertController(title: "Password cannot contain '.'", message: "Please remove any instances of '.' from your password.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                return false
            }
        }
        return true
    }
    
    func storeUserToFirebase(user :User) {
        print("Adding user to Firebase...")
        print("First name: \(user.firstName)")
        print("Last name: \(user.lastName)")
        print("email: \(user.emailAddress)")
        print("Password: \(user.password)")
        databaseRef.child("userTable").child(user.emailAddress!).setValue(user.emailAddress)
        databaseRef.child("userTable").child(user.emailAddress!).child("firstName").setValue(user.firstName!)
        databaseRef.child("userTable").child(user.emailAddress!).child("lastName").setValue(user.lastName!)
        databaseRef.child("userTable").child(user.emailAddress!).child("password").setValue(user.password!)
    }
}
