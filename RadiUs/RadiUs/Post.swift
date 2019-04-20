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
    // following replies;  messages, user who replied this post
    var replies : [String:String] = [:]
    
    init(postID:String, content:String){
        self.postID = postID
        self.content = content
    }
    
    // get repliers of this Post
    func getRepliers() -> [String] {
        var res = [String]()
        for (_,user) in replies {
            res.append(user)
        }
        return res
    }
    
    // get replies of this Post
    func getReplies() -> [String] {
        var res = [String]()
        for (message,_) in replies {
            res.append(message)
        }
        return res
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
