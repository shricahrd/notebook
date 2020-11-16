//
//  UISearchBar+NB.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/22/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
class CustomSearchBar: UISearchBar {
    
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        super.setShowsCancelButton(false, animated: false)
    }
}

class CustomSearchController: UISearchController {
    lazy var _searchBar: CustomSearchBar = {
        [unowned self] in
        let customSearchBar = CustomSearchBar(frame: CGRect.zero)
        return customSearchBar
        }()
    
    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }
}
