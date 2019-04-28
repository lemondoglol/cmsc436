//
//  LoginViewController.swift
//  RadiUs
//
//  Created by Justin Chao on 4/28/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func login(_ sender: Any) {
        let tabController = storyboard?.instantiateViewController(withIdentifier: "TabController") as! TabController
        tabController.selectedViewController = tabController.viewControllers?[1]
        present(tabController, animated: true, completion: nil)
    }
    
}
