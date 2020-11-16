//
//  UserGenreTableViewCell.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserGenreTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = "UserGenreTableViewCell"

    @IBOutlet weak var genreNameLabel: UILabel!
    @IBOutlet weak var genreBooksCollectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    var books = Variable<[Book]>([])
    var selectCellHandler: ((_ viewController: NBParentViewController)->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupCollectionView()
        setupDataSource()
    }
    
    func setupView(){
        genreNameLabel.font = UIFont.GulfBold(withSize: FontSize.small)
        genreNameLabel.textColor = UIColor.NBGoldColor()
    }
    
    func setupCollectionView(){
        let mostReadNib = UINib.init(nibName: MostReadCollectionViewCell.reusableIdentifier, bundle: nil)
        genreBooksCollectionView.register(mostReadNib, forCellWithReuseIdentifier: MostReadCollectionViewCell.reusableIdentifier)
    }
    
    func setupDataSource(){
        books.asObservable()
            .bind(to: genreBooksCollectionView.rx
                .items(cellIdentifier: MostReadCollectionViewCell.reusableIdentifier, cellType: MostReadCollectionViewCell.self)){ (row, model: Book, cell: MostReadCollectionViewCell) in
                    let firstAuthor = model.authors?.first?.name
                    cell.configureCell(withImageURL: model.cover ?? "", andBookName: model.name ?? "", andBookAuthor: firstAuthor ?? "")
            }.disposed(by: disposeBag)
        
        genreBooksCollectionView.rx.itemSelected.bind { [weak self] indexPath in
            if let bookDetails = self?.books.value[indexPath.row], let bookId = bookDetails.id{
                self?.openBookDetails(withBookId: bookId)
            }
            }.disposed(by: disposeBag)
    }

    func configureCell(withGenreTitle genreTitle: String, andBooks books: [Book]){
        genreNameLabel.text = genreTitle
        self.books.value = books
    }
    
    func openBookDetails(withBookId bookId: Int){
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        if let bookDetailsVC = storyboard.instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController{
            let bookIdString = String(bookId)
            bookDetailsVC.bookId = bookIdString
            selectCellHandler?(bookDetailsVC)
        }
    }

}
