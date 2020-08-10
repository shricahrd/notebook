//
//  SearchViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: NBParentViewController, UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var noResultView: UIView!
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var booksTableView: UITableView!
    
    var booksDataSourceVariable = Variable<[AdBook]>([])
    var genresDataSourceVariable = Variable<[Genre]>([])
    let disposeBag = DisposeBag()
    var searchVM: SearchViewModel?
    var timer: Timer?
    var keyword = String()
    var selectedGenreIndexPath = IndexPath(item: 0, section: 0)
    
    var variablesInitialized = false
    var genreId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchVM = SearchViewModel(viewController: self)
        setupView()
        setupDataPresentationViews()
        searchVM?.fetchGenres()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        setupSearchView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? NBParentNavigationControllerViewController)?.addBackButton()
    }
    
    func setupView(){
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setupSearchView(){
        title = "ابحث عن كتاب"
        let searchController: UISearchController = ({
            let controller = CustomSearchController(searchResultsController: nil)
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchResultsUpdater = self
            controller.searchBar.semanticContentAttribute = .forceRightToLeft
            controller.searchBar.setImage(#imageLiteral(resourceName: "icSearchWhite"), for: .search, state: .normal)
            controller.searchBar.placeholder = "ابحث باسم كتاب او اسم كاتب"
            controller.searchBar.barTintColor = UIColor.white
            controller.searchBar.backgroundColor =  UIColor.NBMainColor()
            controller.searchBar.delegate = self
            controller.definesPresentationContext = true
            return controller
        })()
        for subView in searchController.searchBar.subviews {
            for subview in subView.subviews {
                if subview.isKind(of: UITextField.self) {
                    if let textField: UITextField = subview as? UITextField{
                        textField.font = UIFont.GulfRegular(withSize: FontSize.tiny)
                        textField.tintColor = UIColor.white
                        textField.textColor = UIColor.white
                    }
                }
            }
        }
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBooks()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        keyword = searchController.searchBar.text ?? ""
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.searchBooks), userInfo: nil, repeats: false)
        
    }
    
    @objc func searchBooks(){
        searchVM?.searchBooks(withKeyword: keyword, withBookGenreId: genreId)
    }
    
    func setupDataPresentationViews(){
        let genreNib = UINib(nibName: SearchGenreCollectionViewCell.reusableIdentifier, bundle: nil)
        genresCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        genresCollectionView.register(genreNib, forCellWithReuseIdentifier: SearchGenreCollectionViewCell.reusableIdentifier )
        genresDataSourceVariable.asObservable()
            .bind(to: genresCollectionView.rx
                .items(cellIdentifier: SearchGenreCollectionViewCell.reusableIdentifier, cellType: SearchGenreCollectionViewCell.self)){ (row, model: Genre, cell: SearchGenreCollectionViewCell) in
                    cell.configureCell(withTitle: model.name ?? "")
            }.disposed(by: disposeBag)
        
        genresCollectionView.rx.itemSelected.bind { [weak self] indexPath in
            self?.genresCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            if let genreId = self?.genresDataSourceVariable.value[indexPath.item].id{
                self?.selectedGenreIndexPath = indexPath
                self?.genreId = String(genreId)
                self?.searchBooks()
            }else{
                self?.genreId = ""
                self?.searchBooks()
            }
            
        }.disposed(by: disposeBag)
        
        booksTableView.tableFooterView = UIView()
        let bookNib = UINib.init(nibName: BookTableViewCell.reusableIdentifier, bundle: nil)
        booksTableView.register(bookNib, forCellReuseIdentifier: BookTableViewCell.reusableIdentifier)
        booksDataSourceVariable.asObservable()
            .bind(to: booksTableView.rx
                .items(cellIdentifier: BookTableViewCell.reusableIdentifier, cellType: BookTableViewCell.self)){ [weak self] (row, model: AdBook, cell: BookTableViewCell) in
                    cell.configureCell(withBookDetails: model)
                    cell.favouriteButtonHandler = { [weak self] in
                        self?.favouriteBookHandlerOfCell(withIndexPath: IndexPath.init(row: row, section: 0))
                    }
            }.disposed(by: disposeBag)
        
        booksTableView.rx.itemSelected.bind { [weak self] indexPath in
            if let bookDetails = self?.booksDataSourceVariable.value[indexPath.row], let bookId = bookDetails.id{
                self?.openBookDetails(withBook: bookDetails, bookId: bookId)
            }
            }.disposed(by: disposeBag)
        
        booksDataSourceVariable.asObservable().subscribe(onNext: { [weak self] (array) in
            if array.isEmpty && (self?.variablesInitialized ?? false){
                self?.noResultView.isHidden = false
            }else{
                self?.noResultView.isHidden = true
            }
        }).disposed(by: disposeBag)
    }
    
    func favouriteBookHandlerOfCell(withIndexPath indexPath: IndexPath){
        searchVM?.addToFavourites(ofCellWithIndexPath: indexPath)
    }
    
    func revertFavouriteForCell(withIndexPath indexPath: IndexPath){
        if let cell = booksTableView.cellForRow(at: indexPath) as? BookTableViewCell{
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
    
    func selectGenre(){
        if let genreId = genreId{
            selectItem(withGenreId: genreId)
        }else{
            selectedGenreIndexPath.item = genresDataSourceVariable.value.count - 1
            genresCollectionView.selectItem(at: selectedGenreIndexPath, animated: false, scrollPosition: .centeredHorizontally)
            genresCollectionView.scrollToItem(at: selectedGenreIndexPath, at: .centeredHorizontally, animated: true)
        }
        searchBooks()
    }
    
    func selectItem(withGenreId genreId: String){
        var itemIndex = 0
        if let genreId = Int(genreId) {
            _ = genresDataSourceVariable.value.first { (genre) -> Bool in
                itemIndex += 1
                return genre.id == genreId
            }
            selectedGenreIndexPath.item = itemIndex - 1
            genresCollectionView.selectItem(at: selectedGenreIndexPath, animated: false, scrollPosition: .centeredHorizontally)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.genresCollectionView.scrollToItem(at: self.selectedGenreIndexPath, at: .centeredHorizontally, animated: false)
            }
        }else{
            self.genreId = ""
            selectedGenreIndexPath.item = genresDataSourceVariable.value.count - 1
            genresCollectionView.selectItem(at: selectedGenreIndexPath, animated: false, scrollPosition: .centeredHorizontally)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.genresCollectionView.scrollToItem(at: self.selectedGenreIndexPath, at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genresCollectionView{
            let tempLabel = UILabel.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 50, height: 50)))
            tempLabel.numberOfLines = 1
            tempLabel.text = genresDataSourceVariable.value[indexPath.row].name
            let newSize = tempLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let zeplinDesignedHeight: CGFloat = 30
            let padding: CGFloat = 20
            let minimumWidth: CGFloat = 80
            let newWidth = (newSize.width + padding) < minimumWidth ? minimumWidth: (newSize.width + padding)
            return CGSize.init(width: newWidth , height: zeplinDesignedHeight)
        }
        return CGSize.zero
    }
}
