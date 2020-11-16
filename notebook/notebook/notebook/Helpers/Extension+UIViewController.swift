//
//  Extension+UIViewController.swift
//  notebook
//
//  Created by hesham ghalaab on 7/19/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

extension UIViewController{
    func currentView() -> UIView{
        if let view = self.tabBarController?.view{
            return view
        }else if let view = self.navigationController?.view{
            return view
        }else{
            return self.view
        }
    }
}
