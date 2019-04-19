//
//  ViewController.swift
//  RadiUs
//
//  Created by Admin on 4/18/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // used to call methods to access DATABASE
    var model:Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        model = Model()
    }


}

