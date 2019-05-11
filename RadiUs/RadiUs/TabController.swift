//
//  TabController.swift
//  RadiUs
//
//  Created by Justin Chao on 4/28/19.
//  Copyright © 2019 lemondog. All rights reserved.
//

import Foundation
import UIKit

let msGreen = UIColor(rgb: 0x00FA9A)
let limeGreen = UIColor(rgb: 0x90EE90)
let aliceBlue = UIColor(rgb: 0xF0F8FF)
let aquamarine = UIColor(rgb: 0x7FFFD4)
let loginText = UIColor(rgb: 0xFA8072)

class TabController : UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = loginText
        //self.tabBar.unselectedItemTintColor =
        self.tabBar.barTintColor = limeGreen
        self.tabBar.backgroundColor = limeGreen
        tabBar.isTranslucent = false
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        //self.tabBar.layer.cornerRadius = 50
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: view.frame.width, height: tabBar.frame.height), cornerRadius: 50)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        tabBar.layer.mask = mask
        
    }
}
