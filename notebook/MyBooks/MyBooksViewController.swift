//
//  MyBooksViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
//import FolioReaderKit

class MyBooksViewController: NBParentViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var myBooksTableView: UITableView!
    
    var myBooksDataSourceVariable = Variable<[AdBook]>([])
    let disposeBag = DisposeBag()
    var myBooksVM: MyBooksViewModel?
    var variablesInitialized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        myBooksVM = MyBooksViewModel(viewController: self)
        setupDataPresentationViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        landingLogic()
    }
    
    func setupView(){
        //loginButton.setGradientBackground(horizontalMode: true)
        loginButton.roundCorners(withRadius: 6)
    }
    
    func setupDataPresentationViews(){
        
        myBooksTableView.tableFooterView = UIView()
        let bookNib = UINib.init(nibName: MyBookTableViewCell.reusableIdentifier, bundle: nil)
        myBooksTableView.register(bookNib, forCellReuseIdentifier: MyBookTableViewCell.reusableIdentifier)
        myBooksDataSourceVariable.asObservable()
            .bind(to: myBooksTableView.rx
                .items(cellIdentifier: MyBookTableViewCell.reusableIdentifier, cellType: MyBookTableViewCell.self)){ [weak self] (row, model: AdBook, cell: MyBookTableViewCell) in
                    cell.configureCell(withBookDetails: model)
                    
                    cell.favouriteButtonHandler = { [weak self] in
                        self?.favouriteBookHandlerOfCell(withIndexPath: IndexPath.init(row: row, section: 0))
                    }
                    cell.readButtonHandler = { [weak self] in
                        self?.readButtonHandler(at: IndexPath.init(row: row, section: 0))
                    }
                    cell.listenButtonHandler = { [weak self] in
                        self?.listenButtonHandler(at: IndexPath.init(row: row, section: 0))
                    }
            }.disposed(by: disposeBag)
        
        myBooksTableView.rx.itemSelected.bind { [weak self] indexPath in
            if let bookDetails = self?.myBooksDataSourceVariable.value[indexPath.row], let bookId = bookDetails.id{
                self?.openBookDetails(withBook: bookDetails, bookId: bookId)
            }
            }.disposed(by: disposeBag)
        
        myBooksDataSourceVariable.asObservable().subscribe(onNext: { [weak self] (array) in
            if array.isEmpty && (self?.variablesInitialized ?? false){
                self?.handleNoResultsView()
            }else{
                self?.containerView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
    }
    
    func landingLogic(){
        if let token = LocalStore.token(), !token.isEmpty{ // logged in
            containerView.isHidden = true
            myBooksVM?.fetchUserBooks()
        }else{
            handleNotLoggedInUser()
        }
    }
    
    func handleNotLoggedInUser(){
        containerView.isHidden = false
        messageLabel.text = "أهلا بك في نوت بوك يسعدنا إنضمامك إلينا"
        loginButton.isHidden = false
    }
    
    func handleNoResultsView(){
        containerView.isHidden = false
        messageLabel.text = "ليس لديك أي كتاب"
        loginButton.isHidden = true
    }

    func favouriteBookHandlerOfCell(withIndexPath indexPath: IndexPath){
        myBooksVM?.addToFavourites(ofCellWithIndexPath: indexPath)
    }
    
    func readButtonHandler(at indexPath: IndexPath){
        guard let link = myBooksDataSourceVariable.value[indexPath.row].readLink else {return}
        print("book url: \(link)")
        checkBookFileExists(withLink: link){ [weak self] downloadedURL in
            guard let self = self else{
                return
            }
//            let config = FolioReaderConfig()
//            config.displayTitle = true
//            config.tintColor = UIColor.NBMainColor()
//            config.canChangeScrollDirection = true
//            config.shouldHideNavigationOnTap = false
//            config.allowSharing = false
//            config.enableTTS = false
//            
//            let folioReader = FolioReader()
//            folioReader.presentReader(parentViewController: self, withEpubPath: downloadedURL.path, andConfig: config)
        }
    }
    
    func listenButtonHandler(at indexPath: IndexPath){
        let bookDetails = myBooksDataSourceVariable.value[indexPath.row]
        guard let bookListeningLink = bookDetails.listenLink else {return}
        print(bookListeningLink)
        
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "BookListenerViewController") as? BookListenerViewController{
            // our propose here is to make the audio work even if the viewcontroller poped from the navigation stack so here we make checks for that.
            
            if bookListenerVC == nil{
                // so the view contorller not opened before
                bookListenerVC = vc
            }
            
            if (bookListenerVC?.link ?? "") != bookListeningLink{
                // if the current opened link equal to the link that we will opened so we will never pass the new values because they are already there.
                bookListenerVC?.newAudioWillBeLoaded = true
                bookListenerVC?.link = bookListeningLink
                bookListenerVC?.coverImageLink = bookDetails.cover ?? ""
                bookListenerVC?.bookName = bookDetails.name ?? ""
            }else{
                bookListenerVC?.newAudioWillBeLoaded = false
            }
            
            self.navigationController?.pushViewController(bookListenerVC!, animated: true)
        }
    }
    
    func revertFavouriteForCell(withIndexPath indexPath: IndexPath){
        if let cell = myBooksTableView.cellForRow(at: indexPath) as? MyBookTableViewCell{
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
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        super.goToLogin()
    }
}
