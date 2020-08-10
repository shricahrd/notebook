//
//  CartViewController.swift
//  notebook
//  Created by Abdorahman Youssef on 4/3/19.
//  Copyright © 2019 clueapps. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import Realm
import RealmSwift
class CartViewController: NBParentViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var noResultsView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalPriceTextLabel: UILabel!
    @IBOutlet weak var proceedToPaymentButton: UIButton!
    @IBOutlet weak var cartTableView: UITableView!
    var cartBooksDataSourceVariable = Variable<[BookOfflineModel]>([])
    let disposeBag = DisposeBag()
    var cartVM: CartViewModel?
    var totalPrice: Float = 0{
        didSet{
            totalPriceLabel.text = "\(totalPrice)".cleanFloatNumber() + " دينار "
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cartVM = CartViewModel.init(viewController: self)
        setupView()
        setupDataPresentationView()
        cartVM?.fetchCartBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        title = "السلة"
        calculateTotalPrice()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? NBParentNavigationControllerViewController)?.addBackButton()
    }
    
    func setupView(){
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        proceedToPaymentButton.roundCorners(withRadius: 6)
        cartTableView.tableFooterView = UIView()
        totalPriceLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        totalPriceTextLabel.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        proceedToPaymentButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.vTiny)
    }
    
    func setupDataPresentationView(){
        
        cartTableView.tableFooterView = UIView()
        let cartNib = UINib.init(nibName: CartTableViewCell.reusableIdentifier, bundle: nil)
        cartTableView.register(cartNib, forCellReuseIdentifier: CartTableViewCell.reusableIdentifier)
        cartBooksDataSourceVariable.asObservable().bind(to: cartTableView.rx.items(cellIdentifier: CartTableViewCell.reusableIdentifier, cellType: CartTableViewCell.self)){ [weak self] (row, model: BookOfflineModel, cell: CartTableViewCell) in
            //cell.configureCell(withBookInfo: model)
            cell.additionButtonClosure = { [weak self] in
                self?.addCopyToCart(withBookId: model.bookId) ?? false
            }
            cell.minusButtonClosure = { [weak self] in
                self?.minusCopyFromCart(withBookId: model.bookId) ?? false
            }
            cell.deleteButtonClosure = { [weak self] in
                self?.deleteBookFromCart(withBookId: model.bookId)
            }
        }.disposed(by: disposeBag)
        
        cartBooksDataSourceVariable.asObservable().subscribe(onNext: { [weak self] (array) in
            if array.isEmpty {
                self?.handleNoResultsView()
            }else{
                self?.noResultsView.isHidden = true
            }
        }).disposed(by: disposeBag)
    }
    
    func addCopyToCart(withBookId id: Int) -> Bool{
        var updatedSuccessfully = false
        do{
            try NBParentViewController.realm?.write {
                if let cart = NBParentViewController.realm?.objects(Cart.self).first{
                    if let book = cart.books.first(where: { $0.bookId == id }){
                        book.counter += 1
                        cartBooksDataSourceVariable.value.forEach { (dataSourceBook) in
                            if dataSourceBook.bookId == book.bookId{
                                dataSourceBook.counter = book.counter
                            }
                        }
                        updatedSuccessfully = true
                    }
                }
            }
            calculateTotalPrice()
        }catch let err{
            print(err.localizedDescription)
            return updatedSuccessfully
        }
        return updatedSuccessfully
    }
    
    func minusCopyFromCart(withBookId id: Int) -> Bool{
        var updatedSuccessfully = false
        do {
            try NBParentViewController.realm?.write {
                if let cart = NBParentViewController.realm?.objects(Cart.self).first{
                    if let book = cart.books.first(where: { $0.bookId == id }){
                        book.counter -= 1
                        cartBooksDataSourceVariable.value.forEach { (dataSourceBook) in
                           if dataSourceBook.bookId == book.bookId{
                                dataSourceBook.counter = book.counter
                            }
                        }
                        updatedSuccessfully = true
                    }
                }
            }
            calculateTotalPrice()
        } catch let err {
            print(err.localizedDescription)
            return updatedSuccessfully
        }
        return updatedSuccessfully
    }
    
    func calculateTotalPrice(){
        totalPrice = 0
        do {
            try NBParentViewController.realm?.write {
                if let cart = NBParentViewController.realm?.objects(Cart.self).first{
                    cart.totalNumberOfItems = 0
                    cart.totalPrice = 0
                    for book in cart.books{
                        cart.totalNumberOfItems += book.counter
                        cart.totalPrice += (book.printedCopyPrice * Float(book.counter))
                    }
                    totalPrice = cart.totalPrice
                }
            }
            updateTotalPrice(withValue: totalPrice)
        } catch let err {
            showAlert(withTitle: "", andMessage: err.localizedDescription)
        }
    }
    
    func updateTotalPrice(withValue value: Float){
        totalPrice = value
    }
    
    func deleteBookFromCart(withBookId id: Int) {
        do {
            try NBParentViewController.realm?.write {
                if let cart = NBParentViewController.realm?.objects(Cart.self).first{
                   if let book = cart.books.first(where: { $0.bookId == id }){
                      NBParentViewController.realm?.delete(book)
                   }
                }
            }
            cartVM?.fetchCartBooks()
            calculateTotalPrice()
        } catch let err{
            showAlert(withTitle: "", andMessage: err.localizedDescription)
        }
    }

    @IBAction func proceedToPaymentButtonClicked(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "More", bundle: nil)
        if let addressVC = storyBoard.instantiateViewController(withIdentifier: "AddressViewController") as? AddressViewController{
            addressVC.isComingFromCart = true
            addressVC.booksToPurchase = getCartBooks()
            self.navigationController?.pushViewController(addressVC, animated: true)
        }
    }
    
    func getCartBooks() -> [PurchaseBook] {
        var booksList = [PurchaseBook]()
        self.cartBooksDataSourceVariable.value.forEach { (book) in
            let puchasableBook = PurchaseBook.init(book_id: book.bookId, quantity: book.counter)
            booksList.append(puchasableBook)
        }
        return booksList
    }
    
    func handleNoResultsView(){
        noResultsView.isHidden = false
        messageLabel.text = "ليس لديك أي كتب في السلة الآن\n\n تصفح الكتب"
        messageLabel.isUserInteractionEnabled = true
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
        navigationController?.popToRootViewController(animated: false)
    }
}
