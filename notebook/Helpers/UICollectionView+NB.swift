//
//  UICollectionView+NB.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/26/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class IntrinsicSizeCollectionView: UICollectionView {
    // MARK: - lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.bounds.size.equalTo(self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            let intrinsicContentSize = self.contentSize
            return intrinsicContentSize
        }
    }
    
    // MARK: - setup
    func setup() {
        self.isScrollEnabled = false
        self.bounces = false
    }
}
