//
//  MyNavigationController.swift
//  CustomTabShapeTest
//
//  Created by Philipp Weiß on 16.11.18.
//  Copyright © 2018 pmw. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "Roboto", size: 14)]
        appearance.setTitleTextAttributes(attributes, for: .normal)
        self.tabBar.unselectedItemTintColor = UIColor.white
       
	}
}
