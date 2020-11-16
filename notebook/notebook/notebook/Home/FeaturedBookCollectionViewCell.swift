//
//  FeaturedBookCollectionViewCell.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/18/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import SDWebImage

class FeaturedBookCollectionViewCell: UICollectionViewCell {
    
    static let reusableIdentifier = "FeaturedBookCollectionViewCell"
    @IBOutlet weak var bookImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView(){
        contentView.transform = CGAffineTransform.init(scaleX: -1, y: 1)
    }
    
    func configureCell(withCoverImageUrl coverImageUrl: String?){
        let urlString = coverImageUrl?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL.init(string: urlString ?? "")
        bookImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "notebook_place_holder"), options: .allowInvalidSSLCertificates, completed: nil)
    }
    
    func setCellShadow(){
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 10, y: bounds.height))
        shadowPath.addLine(to: CGPoint(x: bounds.width - 10, y: bounds.height))
        shadowPath.addLine(to: CGPoint(x: bounds.width - 10, y: bounds.height + 17))
        shadowPath.addLine(to: CGPoint(x: 10, y: bounds.height + 17))
        shadowPath.close()
        layer.shadowPath = shadowPath.cgPath
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 5
        layer.masksToBounds = false
    }
    
}
