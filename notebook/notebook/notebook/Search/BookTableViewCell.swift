//
//  BookTableViewCell.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/22/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift

class BookTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = "BookTableViewCell"

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bookGenreLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bookCoverImage: UIImageView!
    
    var disposeBag = DisposeBag()
    var isFavoriteBook = Variable<Bool>(false)
    var favouriteButtonHandler: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView(){
        bookGenreLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        bookNameLabel.font = UIFont.GulfBold(withSize: FontSize.small)
        writerLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        priceLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        containerView.roundCorners(withRadius: 6)
        isFavoriteBook.asObservable().subscribe(onNext: {[weak self] (isFav) in
            if isFav{
                self?.favouriteButton.setImage(#imageLiteral(resourceName: "icFav-3"), for: .normal)
            }else{
                self?.favouriteButton.setImage(#imageLiteral(resourceName: "icFav-2"), for: .normal)
            }
        }).disposed(by: disposeBag)
    }
    
    func configureCell(withBookDetails bookDetails: AdBook){
        bookNameLabel.text = bookDetails.name
        var bookPrice: Float = 0.0
        if let readPrice = bookDetails.readPrice, readPrice != 0.0{
            bookPrice = readPrice
        }else if let printPrice = bookDetails.printedPrice, printPrice != 0.0{
            bookPrice = printPrice
        }else if let listenPrice = bookDetails.listenPrice, listenPrice != 0.0{
            bookPrice = listenPrice
        }
        priceLabel.text = "\(bookPrice)".cleanFloatNumber() + " دينار "
        bookGenreLabel.text = bookDetails.genre?.name
        writerLabel.text = bookDetails.authors?.first?.name
        let urlString = bookDetails.cover?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        bookCoverImage.sd_setImage(with: URL.init(string: urlString ?? ""), placeholderImage: #imageLiteral(resourceName: "notebook_place_holder"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        isFavoriteBook.value = bookDetails.isFavourite ?? false
    }
    @IBAction func favouriteButtonClicked(_ sender: UIButton) {
        revertFavouriteStatus()
        favouriteButtonHandler?()
    }
    
    func revertFavouriteStatus(){
        isFavoriteBook.value = !isFavoriteBook.value
    }
}
