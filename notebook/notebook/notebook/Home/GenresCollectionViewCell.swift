//
//  GenresCollectionViewCell.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/18/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class GenresCollectionViewCell: UICollectionViewCell {
    
    static let reusableIdentifier = "GenresCollectionViewCell"
    
    @IBOutlet weak var genreTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView(){
        genreTitleLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        genreTitleLabel.textColor = UIColor.white
        containerView.roundCorners(withRadius: 22)
        containerView.layer.borderColor = UIColor.NBGoldColor().cgColor
        containerView.layer.borderWidth = 1
    }
    
    func configureCell(withTitle title: String){
        genreTitleLabel.text = title
    }
}
