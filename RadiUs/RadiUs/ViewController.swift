//
//  ViewController.swift
//  RadiUs
//
//  Created by Admin on 4/18/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    var databaseRef : DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        databaseRef = Database.database().reference()
        databaseRef?.child("name").childByAutoId().setValue("helloWord")
    }


}

