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

/*
 This View Controller controls the View in which the User can log in.
 */
class LoginViewController : UIViewController, CLLocationManagerDelegate {
    
    var databaseRef:DatabaseReference!
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var appLabel: UILabel!
    @IBOutlet weak var usernameOutlet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var textInputContainer: UIView!
    
    let msGreen = UIColor(rgb: 0x00FA9A)
    let limeGreen = UIColor(rgb: 0x90EE90)
    let aliceBlue = UIColor(rgb: 0xF0F8FF)
    let aquamarine = UIColor(rgb: 0x7FFFD4)
    let loginText = UIColor(rgb: 0xFA8072)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference()
        
        loginButton.layer.cornerRadius = 25
        loginButton.layer.backgroundColor = aquamarine.cgColor
        loginButton.layer.borderColor = msGreen.cgColor
        loginButton.layer.borderWidth = 2
        loginButton.setTitleColor(loginText, for: .normal)
        signupButton.setTitleColor(loginText, for: .normal)
        
        signupButton.layer.cornerRadius = 25
        signupButton.layer.backgroundColor = aquamarine.cgColor
        signupButton.layer.borderColor = msGreen.cgColor
        signupButton.layer.borderWidth = 2
        
        
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
        
        textInputContainer.layer.cornerRadius = 25
        textInputContainer.layer.borderWidth = 2
        textInputContainer.layer.borderColor = loginText.cgColor

        setUpLocationServices()
    }
    
    func setUpLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
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
                    self.usernameOutlet.text = ""
                    self.passwordOutlet.text = ""
                    print("user logged In")
                    userExist = true;
                    break;
                }
            }
            if userExist == false {
                let alert = UIAlertController(title: "Could not verify", message: "Your username or password was entered incorrectly", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                
                print("user does not exist")
            }
        })
    }
    
    func segueToTabBar() {
        let tabController = self.storyboard?.instantiateViewController(withIdentifier: "TabController") as! TabController
        tabController.selectedViewController = tabController.viewControllers?[1]
        self.present(tabController, animated: true, completion: nil)
    }
    
    @IBAction func signup(_ sender: Any) {
        let signupController = self.storyboard?.instantiateViewController(withIdentifier: "SignupView") as! SignupViewController

        self.show(signupController, sender: self)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
