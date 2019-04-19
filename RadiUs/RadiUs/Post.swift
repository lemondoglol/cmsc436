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
    // following contents    postID:contents
    var followingContents = [String:String]()
    
    init(postID:String, content:String){
        self.postID = postID
        self.content = content
    }
    
    func getFollowersID() -> [String] {
        var res = [String]()
        for (pid,_) in followingContents {
            res.append(pid)
        }
        return res
    }
}
