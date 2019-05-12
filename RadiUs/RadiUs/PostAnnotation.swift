//
//  PostAnnotation.swift
//  RadiUs
//
//  Created by Justin Vo on 5/11/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import FirebaseDatabase
import Firebase
import CoreData
import CoreLocation
import MapKit

/*
 This class describes the annotation (the pins on the map). We need a custom one so that when we tap on
 the pin, we'll be sent to the PostAndReplies View.
 */
class PostAnnotation: NSObject, MKAnnotation {
    
    var thisPost: Post
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(_ post: Post) {
        thisPost = post
        let postCoordinate = CLLocationCoordinate2D(latitude: post.latitude!, longitude: post.longitude!)
        coordinate = postCoordinate
        title = post.content
        super.init()
    }
}
