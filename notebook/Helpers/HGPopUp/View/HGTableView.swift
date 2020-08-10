//
//  HGTableView.swift
//  HGPopUp
//
//  Created by hesham ghalaab on 5/25/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import UIKit

class HGTableView: UITableView {
    
    override var contentSize: CGSize{
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize{
        self.layoutIfNeeded()
        let padding: CGFloat = 100
        /// the view that have the title and the close button in the VC, change this if you change the height in the deisgn.
        let closeViewHeight: CGFloat = 50
        let height = UIScreen.main.bounds.height - padding - closeViewHeight
        let contentHeight = contentSize.height
        
        if contentHeight < height{
            return CGSize.init(width: UIView.noIntrinsicMetric, height: contentHeight)
        }else{
            return CGSize.init(width: UIView.noIntrinsicMetric, height: height)
        }
    }

}
