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

class User {
    
    var firstName :String?
    var lastName :String?
    var emailAddress  :String?
    //          post_id:Post
    var posts = [String:Post]
    
    init(firstName: String, lastName: String, emailAddress :String) {
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
    }
    
    
    
}
