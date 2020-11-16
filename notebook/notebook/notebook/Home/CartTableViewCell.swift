//
//  CartTableViewCell.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/3/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = "CartTableViewCell"

    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var minusButton: UIButton!
    
    var counter = 0{
        didSet{
            if counterLabel != nil{
                counterLabel.text = "\(counter)"
            }
        }
    }
    
    var additionButtonClosure: (()->(Bool))?
    var minusButtonClosure: (()->(Bool))?
    var deleteButtonClosure: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    func setupView(){
        containerView.roundCorners(withRadius: 10)
        minusButton.roundCorners(withRadius: 15)
        additionButton.roundCorners(withRadius: 15)
        counterLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        bookNameLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        priceLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        counterLabel.text = "\(counter)"
        priceLabel.text = "0 دينار"
    }
    
//    func configureCell(withBookInfo book: BookOfflineModel){
//        priceLabel.text = "\(book.printedCopyPrice)".cleanFloatNumber() + " دينار "
//        bookNameLabel.text = book.bookName
//        counter = book.counter
//    }

    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        deleteButtonClosure?()
    }
    
    @IBAction func additionButtonClicked(_ sender: UIButton) {
        if counter < 20{
            if additionButtonClosure?() ?? false {
                counter += 1
            }
        }
    }
    
    @IBAction func minusButtonClicked(_ sender: UIButton) {
        if counter > 1{
            if minusButtonClosure?() ?? false {
                counter -= 1
            }
        }
    }
}
