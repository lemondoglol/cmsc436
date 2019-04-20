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
    // post_id:Post
    var posts :[String:Post] = [:]
    
    init(firstName: String, lastName: String, emailAddress :String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.password = password
    }
    
    func makePost(content: String) -> Post{
        let pid = emailAddress! + " " + String(posts.count)
        let post = Post(postID: pid, content: content)
        posts[pid] = post
        return post
    }
    
    func serialize() -> String {
        let res = ""
        return res
    }
    
    func deserialize() -> String {
        let res = ""
        return res
    }
    
}
