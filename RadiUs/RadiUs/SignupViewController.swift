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
    
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var textInputContainer: UIView!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    let msGreen = UIColor(rgb: 0x00FA9A)
    let limeGreen = UIColor(rgb: 0x90EE90)
    let aliceBlue = UIColor(rgb: 0xF0F8FF)
    let aquamarine = UIColor(rgb: 0x7FFFD4)
    let loginText = UIColor(rgb: 0xFA8072)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        
        createAccountButton.layer.cornerRadius = 20
        createAccountButton.layer.backgroundColor = aquamarine.cgColor
        createAccountButton.layer.borderColor = msGreen.cgColor
        createAccountButton.layer.borderWidth = 2
        
        usernameOutlet.layer.backgroundColor = UIColor.white.cgColor
        usernameOutlet.layer.cornerRadius = 0
        usernameOutlet.layer.borderWidth = 0
        usernameOutlet.layer.borderColor = msGreen.cgColor
        usernameOutlet.borderStyle = UITextField.BorderStyle.roundedRect
        
        passwordOutlet.layer.cornerRadius = 0
        passwordOutlet.layer.backgroundColor = UIColor.white.cgColor
        passwordOutlet.layer.borderWidth = 0
        passwordOutlet.layer.borderColor = msGreen.cgColor
        passwordOutlet.borderStyle = UITextField.BorderStyle.roundedRect
        
        firstName.layer.backgroundColor = UIColor.white.cgColor
        firstName.borderStyle = UITextField.BorderStyle.roundedRect
        lastName.layer.backgroundColor = UIColor.white.cgColor
        lastName.borderStyle = UITextField.BorderStyle.roundedRect
        
        textInputContainer.layer.cornerRadius = 20
        textInputContainer.layer.borderWidth = 2
        textInputContainer.layer.borderColor = msGreen.cgColor
    }
    
    /*
     LINK THE BUTTON TO THE ACTION BELOW (createAccountAction)
     
     For now, we'll allow any non-empty username. Once we sort out that whole mess (where we can't
     use periods), then maybe we'll force the username to be some email.
     
     We'll also allow any non-empty password. Probably will enforce it to be more strict (certain number of characters). Make sure the username doesn't already exist.
     
     Currently have no fields for first name and last name (I'll edit this function later after we have those fields in the storyboard).
     */
    @IBAction func createAccountAction(_ sender: UIButton) {
        
        if let usernameText = usernameOutlet.text {
            if let passwordText = passwordOutlet.text {
                
                // Check if the username and password are valid...
                if hasValidPassword() && hasValidUsername() {
                    
                    let user = User(firstName: "EDIT_THIS", lastName: "EDIT_THIS", emailAddress: usernameText, password: passwordText)
                    
                    checkIfUserExists(user: user) { (userExists) in
                        
                        if userExists {
                            let alert = UIAlertController(title: "Username already exists", message: "Please try a different username.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true)
                            
                        } else {
                            self.storeUserToFirebase(user: user)
                            self.segueToLogin()
                        }
                    }
                }
            }
        }
    }
    
    func segueToLogin() {
        let alert = UIAlertController(title: "Sign up successful!", message: "You've successfully created your account! Please log in.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
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
                let alert = UIAlertController(title: "Password is too short", message: "Your password should contain at least \(MIN_CHARACTERS_NEEDED) character.", preferredStyle: .alert)
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
    
    func checkIfUserExists(user: User, completion: @escaping (_ check: Bool) -> ()) {
        databaseRef.child("userTable").observeSingleEvent(of: .value, with: {(snapshot) in
            var userExist = false
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let userID = child.key
                if userID == user.emailAddress {
                    userExist = true;
                    break;
                }
            }
            completion(userExist)
        })
    }
}
