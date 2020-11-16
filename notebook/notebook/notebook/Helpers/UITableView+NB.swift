//
//  UITableView+NB.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/1/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import UIKit

class IntrisicTableView: UITableView{
    override open var contentSize: CGSize {
        didSet{
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize{
        return contentSize
    }
}
