//
//  MyBookTableViewCell.swift
//  notebook
//
//  Created by hesham ghalaab on 7/22/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift

class MyBookTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = "MyBookTableViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bookGenreLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var listenButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    
    var disposeBag = DisposeBag()
    var isFavoriteBook = Variable<Bool>(false)
    var favouriteButtonHandler: (()->())?
    var listenButtonHandler: (()->())?
    var readButtonHandler: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView(){
        bookGenreLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        bookNameLabel.font = UIFont.GulfBold(withSize: FontSize.small)
        writerLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        //priceLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
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
        bookGenreLabel.text = bookDetails.genre?.name
        writerLabel.text = bookDetails.authors?.first?.name
        let urlString = bookDetails.cover?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        bookCoverImage.sd_setImage(with: URL.init(string: urlString ?? ""), placeholderImage: #imageLiteral(resourceName: "notebook_place_holder"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        isFavoriteBook.value = bookDetails.isFavourite ?? false
        
        handlePurchaseScenario(isPurchased: bookDetails.isPurchased, purchaseType: bookDetails.purchaseTypeMapped)
    }
    @IBAction func favouriteButtonClicked(_ sender: UIButton) {
        revertFavouriteStatus()
        favouriteButtonHandler?()
    }
    
    func revertFavouriteStatus(){
        isFavoriteBook.value = !isFavoriteBook.value
    }
    
    @IBAction func readButtonClicked(_ sender: UIButton) {
        readButtonHandler?()
    }
    
    @IBAction func listenButtonclicked(_ sender: UIButton) {
        listenButtonHandler?()
    }
    
    func handlePurchaseScenario(isPurchased: Bool?, purchaseType: PurchaseType){
        guard let _isPurchased = isPurchased, _isPurchased == true else {
            handleReadAndListen(by: .unpaid)
            return
        }
        
        switch purchaseType{
        case .none:
            handleReadAndListen(by: .unpaid)
        case .read:
            handleReadAndListen(by: .boughtReadCopy)
        case .listen:
            handleReadAndListen(by: .boughtVoiceCopy)
        case .printed:
            handleReadAndListen(by: .unpaid)
        case .both:
            handleReadAndListen(by: .bothCopies)
        }
    }
    
    private func handleReadAndListen(by userToBookStatus: UserToBookStatus){
        switch userToBookStatus {
        case .bothCopies:
            handleReadAndListenUI(hasListen: true, hasRead: true)
        case .boughtReadCopy:
            handleReadAndListenUI(hasListen: false, hasRead: true)
        case .boughtVoiceCopy:
            handleReadAndListenUI(hasListen: true, hasRead: false)
        case .unpaid, .writer, .undefined:
            handleReadAndListenUI(hasListen: false, hasRead: false)
        }
    }
    
    private func handleReadAndListenUI(hasListen: Bool, hasRead: Bool){
        listenButton.isHidden = !hasListen
        readButton.isHidden = !hasRead
    }
}
