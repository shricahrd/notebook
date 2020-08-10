//
//  MostReadCollectionViewCell.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import SDWebImage

class MostReadCollectionViewCell: UICollectionViewCell {
    
    static let reusableIdentifier = "MostReadCollectionViewCell"
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView(){
        bookName.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        bookName.textColor = UIColor.white
        bookAuthor.font = UIFont.GulfBold(withSize: 12)
        bookAuthor.textColor = UIColor.NBGoldColor()
    }
    
    func configureCell(withImageURL imageURL: String, andBookName bookName: String, andBookAuthor bookAuthor: String){
        self.bookName.text = bookName
        self.bookAuthor.text = bookAuthor
        let urlString = imageURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL.init(string: urlString ?? "")
        coverImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "notebook_place_holder"), options: .allowInvalidSSLCertificates, completed: nil)
    }
    
    func setClearBackground(){
        containerView.backgroundColor = UIColor.clear
    }
}
