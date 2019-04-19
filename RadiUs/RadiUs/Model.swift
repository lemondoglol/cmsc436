//
//  Model.swift
//  RadiUs
//
//  Created by Admin on 4/18/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import Foundation
import FirebaseDatabase
// this class is used to provide functionalities to access Database(upload and retrieve data)


// I will start this tmr, since I have another project due
class Model {
    var databaseRef : DatabaseReference?
    
    init(){
        databaseRef = Database.database().reference()
    }
}
