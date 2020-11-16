
//
//  AuthorViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class AuthorViewController: NBParentViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var authorBooksTableView: UITableView!
    @IBOutlet weak var tableTitleLabel: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authoBioLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorBioContainerView: UIView!
    @IBOutlet weak var pathImageView: UIImageView!
    
    var authorBooksDataSourceVariable = Variable<[AdBook]>([])
    private var disposeBag = DisposeBag()
    var authorViewModel: AuthorViewModel?
    var authorDetailsVariable = Variable<Author>(Author())
    
    var authorShareLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        setupDataPresentationViews()
        authorViewModel?.fetchAuthorDetails()
        authorViewModel?.fetchAuthorBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    func setupView(){
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        (navigationController as? NBParentNavigationControllerViewController)?.addBackButton()
        (navigationController as? NBParentNavigationControllerViewController)?.addPlayButton()
        authorImage.roundCorners(withRadius: authorImage.bounds.height / 2)
        authorBioContainerView.roundCorners(withRadius: 8)
        pathImageView.image = pathImageView.image?.withRenderingMode(.alwaysTemplate)
        
    }
    
    func setupDataPresentationViews(){
        authorDetailsVariable.asObservable().subscribe(onNext: { [weak self] (author) in
            self?.setupView(withAuthorDetails: author)
        }).disposed(by: disposeBag)
        
        authorBooksTableView.tableFooterView = UIView()
        let bookNib = UINib.init(nibName: BookTableViewCell.reusableIdentifier, bundle: nil)
        authorBooksTableView.register(bookNib, forCellReuseIdentifier: BookTableViewCell.reusableIdentifier)
        authorBooksDataSourceVariable.asObservable()
            .bind(to: authorBooksTableView.rx
                .items(cellIdentifier: BookTableViewCell.reusableIdentifier, cellType: BookTableViewCell.self)){ [weak self] (row, model: AdBook, cell: BookTableViewCell) in
                    cell.configureCell(withBookDetails: model)
                    cell.favouriteButtonHandler = { [weak self] in
                        self?.favouriteBookHandlerOfCell(withIndexPath: IndexPath.init(row: row, section: 0))
                    }
            }.disposed(by: disposeBag)
        
        authorBooksTableView.rx.itemSelected.bind { [weak self] indexPath in
            if let bookDetails = self?.authorBooksDataSourceVariable.value[indexPath.row], let bookId = bookDetails.id{
                self?.openBookDetails(withBook: bookDetails, bookId: bookId)
            }
            }.disposed(by: disposeBag)
    }
    
    func setupView(withAuthorDetails author: Author) {
        let urlString = author.avatar?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        authorImage.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: #imageLiteral(resourceName: "notebook_place_holder"), options: .allowInvalidSSLCertificates, completed: nil)
        authorNameLabel.text = author.name
        title = author.name
        authoBioLabel.text = author.bio
        tableTitleLabel.text = "كتب \(author.name ?? "")"
        
        if let authorShareLink = author.authorShareLink {
            self.authorShareLink = authorShareLink
        }
    }
    
    func favouriteBookHandlerOfCell(withIndexPath indexPath: IndexPath){
        authorViewModel?.addToFavourites(ofCellWithIndexPath: indexPath)
    }
    
    func revertFavouriteForCell(withIndexPath indexPath: IndexPath){
        if let cell = authorBooksTableView.cellForRow(at: indexPath) as? BookTableViewCell{
            cell.revertFavouriteStatus()
        }
    }
    
    func openBookDetails(withBook book: AdBook, bookId: Int){
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        if let bookDetailsVC = storyboard.instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController{
            let bookIdString = String(bookId)
            bookDetailsVC.bookId = bookIdString
            bookDetailsVC.bookDetails = book
            navigationController?.pushViewController(bookDetailsVC, animated: true)
        }
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        let appURL = "\(self.authorShareLink ?? "")"
        if let myWebsite = URL(string: appURL) {
            let objectsToShare = [myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
