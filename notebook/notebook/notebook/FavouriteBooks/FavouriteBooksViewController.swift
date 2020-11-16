//
//  FavouriteBooksViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavouriteBooksViewController: NBParentViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var favouriteBookTableView: UITableView!
    
    var favouriteBooksDataSourceVariable = Variable<[AdBook]>([])
    let disposeBag = DisposeBag()
    var favouriteBooksVM: FavouriteBooksViewModel?
    var variablesInitialized = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        favouriteBooksVM = FavouriteBooksViewModel(viewController: self)
        setupDataPresentationViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        landingLogic()
    }
    
    func setupView(){
        //loginButton.setGradientBackground(horizontalMode: true)
        loginButton.roundCorners(withRadius: 6)
        messageLabel.font = UIFont.GulfBold(withSize: FontSize.small)
    }
    
    
    func setupDataPresentationViews(){
        
        favouriteBookTableView.tableFooterView = UIView()
        let bookNib = UINib.init(nibName: BookTableViewCell.reusableIdentifier, bundle: nil)
        favouriteBookTableView.register(bookNib, forCellReuseIdentifier: BookTableViewCell.reusableIdentifier)
        favouriteBooksDataSourceVariable.asObservable()
            .bind(to: favouriteBookTableView.rx
                .items(cellIdentifier: BookTableViewCell.reusableIdentifier, cellType: BookTableViewCell.self)){ [weak self] (row, model: AdBook, cell: BookTableViewCell) in
                    cell.configureCell(withBookDetails: model)
                    cell.favouriteButtonHandler = { [weak self] in
                        self?.favouriteBookHandlerOfCell(withIndexPath: IndexPath.init(row: row, section: 0))
                    }
            }.disposed(by: disposeBag)
        
        favouriteBookTableView.rx.itemSelected.bind { [weak self] indexPath in
            if let bookDetails = self?.favouriteBooksDataSourceVariable.value[indexPath.row], let bookId = bookDetails.id{
                self?.openBookDetails(withBook: bookDetails, bookId: bookId)
            }
            }.disposed(by: disposeBag)
        
        favouriteBooksDataSourceVariable.asObservable().subscribe(onNext: { [weak self] (array) in
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
            favouriteBooksVM?.fetchUserFavouriteBooks()
        }else{
            handleNotLoggedInUser()
        }
    }
    
    func handleNotLoggedInUser(){
        containerView.isHidden = false
        messageLabel.text = "أهلا بك في نوت بوك يسعدنا إنضمامك إلينا"
        messageLabel.isUserInteractionEnabled = false
        loginButton.isHidden = false
    }
    
    func handleNoResultsView(){
        containerView.isHidden = false
        messageLabel.text = "ليس لديك أي كتب في المفضلة\n\n ابدأ بتصفح الكتب الآن"
        messageLabel.isUserInteractionEnabled = true
        loginButton.isHidden = true
        addGesture()
    }
    
    func addGesture(){
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.backToHome(_:)))
        guard messageLabel.gestureRecognizers?.isEmpty ?? true else {
            return
        }
        messageLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func backToHome(_ sender: UITapGestureRecognizer){
        tabBarController?.selectedIndex = 0
        if let nvc = tabBarController?.selectedViewController as? NBParentNavigationControllerViewController{
            nvc.popToRootViewController(animated: false)
        }
    }
    
    func favouriteBookHandlerOfCell(withIndexPath indexPath: IndexPath){
        favouriteBooksVM?.addToFavourites(ofCellWithIndexPath: indexPath)
    }
    
    func revertFavouriteForCell(withIndexPath indexPath: IndexPath){
        if let cell = favouriteBookTableView.cellForRow(at: indexPath) as? BookTableViewCell{
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
