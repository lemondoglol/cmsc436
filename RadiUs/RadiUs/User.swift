//
//  User.swift
//  RadiUs
//
//  Created by Admin on 4/18/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

//
// User class is used to store userInfo
//
import Foundation
import CoreLocation

class User {
    
    var firstName :String?
    var lastName :String?
    var emailAddress  :String?
    var password :String?
    
    init(firstName: String, lastName: String, emailAddress :String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.password = password
    }
    
}
