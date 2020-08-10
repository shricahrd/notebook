//
//  SearchGenreCollectionViewCell.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/22/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class SearchGenreCollectionViewCell: UICollectionViewCell {
    
    static let reusableIdentifier = "SearchGenreCollectionViewCell"
    
    @IBOutlet weak var genreTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    let unselectedCellColor = UIColor.init(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView(){
        genreTitleLabel.font = UIFont.GulfBold(withSize: 12)
        genreTitleLabel.textColor = UIColor.white
        containerView.backgroundColor = unselectedCellColor
    }
    
    func configureCell(withTitle title: String){
        genreTitleLabel.text = title
        containerView.roundCorners(withRadius: frame.height / 2)
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                containerView.backgroundColor = UIColor.NBGoldColor()
            }else{
                containerView.backgroundColor = unselectedCellColor
            }
        }
    }

}
