//
//  NBParentTabBarViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/12/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class NBParentTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    

    func setupView(){
        tabBar.barTintColor = UIColor.NBtabBarBGColor()
        tabBar.tintColor = UIColor.NBGoldColor()
        tabBar.unselectedItemTintColor = UIColor.white
        
        tabBar.semanticContentAttribute = .forceRightToLeft
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.GulfBold(withSize: 10)], for: .normal)
    }

}
