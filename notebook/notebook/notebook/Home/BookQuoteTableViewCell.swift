//
//  BookQuoteTableViewCell.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/18/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class BookQuoteTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = "BookQuoteTableViewCell"

    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var quoteTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    
    func setupView(){
        quoteTextLabel.font = UIFont.GulfBold(withSize: 13)
        quoteTextLabel.textColor = UIColor.white
    }
    
    func configureView(withQuote quote: String){
        quoteTextLabel.text = quote
    }

}
