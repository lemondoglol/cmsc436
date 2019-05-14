//
//  Post.swift
//  RadiUs
//
//  Created by Admin on 4/18/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import Foundation


class Post {
    
    // postID is going to be emailAddress
    var postID = ""
    // content of the post
    var content = ""
    var comments = [String]()
    var latitude: Double?
    var longitude: Double?
    var category: String?
    var date: String?
    
    init(postID:String, content:String, latitude: Double, longitude: Double, category: String, date: String) {
        self.postID = postID
        self.content = content
        self.latitude = latitude
        self.longitude = longitude
        comments = []
        self.category = category
        self.date = date
    }

}
