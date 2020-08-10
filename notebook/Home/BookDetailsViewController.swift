//
//  BookDetailsViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/10/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
//import FolioReaderKit

enum UserToBookStatus {
    case writer
    case unpaid
    case boughtVoiceCopy
    case boughtReadCopy
    case bothCopies
    case undefined
}

enum PurchaseType: String {
    case read = "read"
    case listen = "listen"
    case both = "both"
    case printed
    case none = ""
}

protocol BookDetailsDelegate: class {
    func refresh()
}

var bookListenerVC: BookListenerViewController?

class BookDetailsViewController: NBParentViewController, UIGestureRecognizerDelegate, BookDetailsDelegate {

    //Outlets
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var detailsContentView: UIView!
    @IBOutlet weak var bookGenreLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var rateNumberLabel: UILabel!
    @IBOutlet weak var bookAuthorButton: UIButton!
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    
    @IBOutlet weak var readCopyTextLabel: UILabel!
    @IBOutlet weak var readCopyPriceLabel: UILabel!
    @IBOutlet weak var readCopyBuyButton: UIButton!
    
    @IBOutlet weak var voiceCopyTextLabel: UILabel!
    @IBOutlet weak var voiceCopyBuyButton: UIButton!
    @IBOutlet weak var voiceCopyPriceLabel: UILabel!
    
    @IBOutlet weak var bothTextLabel: UILabel!
    @IBOutlet weak var bothBuyButton: UIButton!
    @IBOutlet weak var bothPriceLabel: UILabel!
    
    @IBOutlet weak var printedCopyTextLabel: UILabel!
    @IBOutlet weak var printedCopyPriceLabel: UILabel!
    @IBOutlet weak var printedCopyBuyButton: UIButton!
    
    @IBOutlet weak var quotesTableView: IntrisicTableView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var recommendationsCollectionView: UICollectionView!
    
    //Constraints
    @IBOutlet weak var readCopyViewDefaultHeight: NSLayoutConstraint!
    @IBOutlet weak var voiceCopyViewDefaultHeight: NSLayoutConstraint!
    @IBOutlet weak var bothViewDefaultHeight: NSLayoutConstraint!
    //@IBOutlet weak var giftViewDefaultHeight: NSLayoutConstraint!
    @IBOutlet weak var printedViewDefaultHeight: NSLayoutConstraint!
    @IBOutlet var bookQoutesTextTitleHeightConstraint: NSLayoutConstraint!
    @IBOutlet var quotesTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var giftBookButton: UIButton!
    @IBOutlet weak var giftBookTextLabel: UILabel!
    @IBOutlet weak var giftBookView: UIView!
    @IBOutlet weak var iHaveAGiftButton: UIButton!
    @IBOutlet weak var iHaveAGiftView: UIView!
    @IBOutlet weak var recommendBookButton: UIButton!
    @IBOutlet weak var recommendBookView: UIView!
    
    var fromAppDelegate: Bool = false
    var bookId: String?
    private var bookDetailsVM: BookDetailsViewModel?
    var bookDetails: AdBook? // used only for passing its value to bookDetails in bookDetailsVM
    let disposeBag = DisposeBag()
    var userToBookStatus: UserToBookStatus = .undefined
    var bookQuotes = Variable<[Quote]>([])
    var isFavoriteBook = Variable<Bool>(false)
    var recommendationsDataSource = Variable<[AdBook]>([])
    var bookReadingLink = ""
    var bookListeningLink = ""
    var authorId: String?
    var shareLink: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bookDetailsVM = BookDetailsViewModel(viewController: self)
        bookDetailsVM?.bookDetails.asObservable().subscribe(onNext: { [weak self] (bookDetails) in
            if  bookDetails.id != nil{
                self?.setupViews(WithBookDetails: bookDetails)
            }
        }).disposed(by: disposeBag)
        
        if let bookDetails = bookDetails{
            bookDetailsVM?.bookDetails.value = bookDetails
        }else{
            // because some classes will not pass bookDetails to this class , we pass bookDetails just because of the offline storage , but the old code did handle it by passing only the id and then fetching the request.
            if let bookId = bookId {
                bookDetailsVM?.fetchBookDetails(withBookId: bookId)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupViews(){
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        detailsContentView.roundCorners(withRadius: 8)
        readCopyBuyButton.roundCorners(withRadius: 12)
        voiceCopyBuyButton.roundCorners(withRadius: 12)
        bothBuyButton.roundCorners(withRadius: 12)
        printedCopyBuyButton.roundCorners(withRadius: 12)
        recommendBookButton.roundCorners(withRadius:  14)
        giftBookButton.roundCorners(withRadius: 14)
        iHaveAGiftButton.roundCorners(withRadius: 14)
        setupDataPresentationViews()
        detailsContentView.isOpaque = false
        detailsContentView.backgroundColor = UIColor.NBMainColor().withAlphaComponent(0.9)
        
        giftBookView.isHidden = true
        iHaveAGiftView.isHidden = true
        recommendBookView.isHidden = true
    }
    
    func setupDataPresentationViews(){
        
        quotesTableView.tableFooterView = UIView()
        let quoteNib = UINib.init(nibName: BookQuoteTableViewCell.reusableIdentifier, bundle: nil)
        quotesTableView.register(quoteNib, forCellReuseIdentifier: BookQuoteTableViewCell.reusableIdentifier)
        quotesTableView.rowHeight = UITableView.automaticDimension
        quotesTableView.estimatedRowHeight = 80
        bookQuotes.asObservable().bind(to: quotesTableView.rx.items(cellIdentifier: BookQuoteTableViewCell.reusableIdentifier, cellType: BookQuoteTableViewCell.self)){ [weak self] (row, model: Quote, cell: BookQuoteTableViewCell) in
            cell.configureView(withQuote: model.body ?? "-")
            if row + 1 == self?.bookQuotes.value.count{
                cell.seperatorView.isHidden = true
            }
            }.disposed(by: disposeBag)
        
        isFavoriteBook.asObservable().subscribe(onNext: {[weak self] (isFav) in
            if isFav{
                self?.favoriteButton.setImage(#imageLiteral(resourceName: "icFav-3"), for: .normal)
            }else{
                self?.favoriteButton.setImage(#imageLiteral(resourceName: "icFav-2"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
        let mostReadNib = UINib(nibName: MostReadCollectionViewCell.reusableIdentifier, bundle: nil)
        recommendationsCollectionView.register(mostReadNib, forCellWithReuseIdentifier: MostReadCollectionViewCell.reusableIdentifier)
        
        recommendationsDataSource.asObservable()
            .bind(to: recommendationsCollectionView.rx
                .items(cellIdentifier: MostReadCollectionViewCell.reusableIdentifier, cellType: MostReadCollectionViewCell.self)){ (row, model: AdBook, cell: MostReadCollectionViewCell) in
                    let firstAuthor = model.authors?.first?.name
                    cell.setClearBackground()
                    cell.configureCell(withImageURL: model.cover ?? "", andBookName: model.name ?? "", andBookAuthor: firstAuthor ?? "")
            }.disposed(by: disposeBag)
        
        recommendationsCollectionView.rx.itemSelected.bind { [weak self] indexPath in
            if let bookDetails = self?.recommendationsDataSource.value[indexPath.row], let bookId = bookDetails.id{
                self?.openBookDetails(withBook: bookDetails, bookId: bookId)
            }
            }.disposed(by: disposeBag)
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
    
    func setupViews(WithBookDetails bookDetails: AdBook){
        
        let urlString = bookDetails.cover?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        bookCoverImage.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: #imageLiteral(resourceName: "notebook_place_holder"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        bookGenreLabel.text = bookDetails.genre?.name
        bookNameLabel.text  = bookDetails.name
        authorId = ""
        if let authorId = bookDetails.authors?.first?.id{
            self.authorId = String(authorId)
        }
        bookAuthorButton.setTitle(bookDetails.authors?.first?.name, for: .normal)
        let recommendationCounter = bookDetails.recommendationsCount ?? 0
        let recommendationText = recommendationCounter > 1 ? "رشحوا" : "رشح"
        rateNumberLabel.text = "\(recommendationCounter) \(recommendationText) هذا الكتاب"
        bookDescriptionLabel.text = bookDetails.descriptionField
        if bookDetails.isWriter ?? false{
            userToBookStatus = .writer
        }else{
            if (bookDetails.isPurchased ?? false){
                
                switch bookDetails.purchaseTypeMapped{
                case .none:
                    userToBookStatus = .unpaid
                case .read:
                    userToBookStatus = .boughtReadCopy
                case .listen:
                    userToBookStatus = .boughtVoiceCopy
                case .printed:
                    userToBookStatus = .unpaid
                case .both:
                    userToBookStatus = .bothCopies
                }
                
            }else{
                userToBookStatus = .unpaid
            }
        }
        setupBookStatusView(withBookDetails: bookDetails)
        bookQuotes.value = bookDetails.quotes ?? []
        if (bookDetails.quotes?.count ?? 0) == 0 {
            bookQoutesTextTitleHeightConstraint.constant = 0
            quotesTableViewHeightConstraint.isActive = true
        }
        isFavoriteBook.value = bookDetails.isFavourite ?? false
        if let id = bookDetails.genre?.id {
            let stringId = String(id)
            fetchRecommendedBooks(withBookGenreId: stringId)
        }
        
        self.shareLink = bookDetails.shareLink
    }
    
    func fetchRecommendedBooks(withBookGenreId genreId: String){
        bookDetailsVM?.fetchRecommendedBooks(withBookGenreId: genreId)
    }
    
    func setupBookStatusView(withBookDetails bookDetails: AdBook){
        
        if userToBookStatus == .writer{
            setupViewForWriterStatus(withBookDetails: bookDetails)
        }else{
            
            var onlyPrintedAvailable = true
            
            if bookDetails.printedPrice == nil || bookDetails.printedPrice == 0{
                hidePrintedCopyView()
            }else{
                setupPrintedCopyView(withPrice: bookDetails.printedPrice ?? 0)
            }
            
            if bookDetails.listenPrice == nil || bookDetails.listenPrice == 0{
                hideVoiceCopyView()
            }else{
                onlyPrintedAvailable = false
            }
            
            if bookDetails.readPrice == nil || bookDetails.readPrice == 0{
                hideReadCopyView()
            }else{
                onlyPrintedAvailable = false
            }
            
            if bookDetails.bothPrice == nil || bookDetails.bothPrice == 0{
                hideBothView()
            }else{
                onlyPrintedAvailable = false
            }
            
            switch userToBookStatus {
            case .unpaid:
                setupViewForUnpaidStatus(withBookDetails: bookDetails)
            case .boughtVoiceCopy:
                setupViewForVoiceStatus(withBookDetails: bookDetails)
            case .boughtReadCopy:
                setupViewForReadStatus(withBookDetails: bookDetails)
            case .bothCopies:
                setupViewForBothStatus(withBookDetails: bookDetails)
            case .undefined, .writer:
                return
            }
            
            if onlyPrintedAvailable{
                hideGiftBookView()
            }
        }
        view.layoutIfNeeded()
    }
    
    func setupViewForUnpaidStatus(withBookDetails bookDetails: AdBook){
        setupReadCopyView(withPrice: bookDetails.readPrice ?? 0)
        setupVoiceCopyView(withPrice: bookDetails.listenPrice ?? 0)
        setupBothView(withPrice: bookDetails.bothPrice ?? 0)
        giftBookTextLabel.text = ""
        setup(giftBookViewisHidden: true, iHaveAGiftViewIsHidden: false, recommendBookViewIsHidden: true)
    }
    
    func setupViewForReadStatus(withBookDetails bookDetails: AdBook){
        setupBoughtReadCopyView(withLink: bookDetails.readLink ?? "")
        setupVoiceCopyView(withPrice: bookDetails.listenPrice ?? 0)
        hideBothView()
        checkPrices(in: bookDetails)
        setupRecommendationView(withStatus: bookDetails.isRecomended ?? false)
    }
    
    func setupViewForVoiceStatus(withBookDetails bookDetails: AdBook){
        setupReadCopyView(withPrice: bookDetails.readPrice ?? 0)
        setupBoughtVoiceCopyView(withLink: bookDetails.listenLink ?? "")
        hideBothView()
        checkPrices(in: bookDetails)
        setupRecommendationView(withStatus: bookDetails.isRecomended ?? false)
    }
    
    func setupViewForBothStatus(withBookDetails bookDetails: AdBook){
        setupBoughtVoiceCopyView(withLink: bookDetails.listenLink ?? "")
        setupBoughtReadCopyView(withLink: bookDetails.readLink ?? "")
        hideBothView()
        setup(giftBookViewisHidden: true, iHaveAGiftViewIsHidden: true, recommendBookViewIsHidden: false)
        setupRecommendationView(withStatus: bookDetails.isRecomended ?? false)
    }
    
    func checkPrices(in bookDetails: AdBook){
        let hasListenPrice = bookDetails.listenPrice != nil && bookDetails.listenPrice != 0
        let hasReadPrice = bookDetails.readPrice != nil && bookDetails.readPrice != 0
        
        if hasListenPrice && hasReadPrice {
            setup(giftBookViewisHidden: true, iHaveAGiftViewIsHidden: false, recommendBookViewIsHidden: false)
        }else if hasListenPrice || hasReadPrice{
            setup(giftBookViewisHidden: true, iHaveAGiftViewIsHidden: true, recommendBookViewIsHidden: false)
        }else if !hasListenPrice && !hasReadPrice{
            setup(giftBookViewisHidden: true, iHaveAGiftViewIsHidden: true, recommendBookViewIsHidden: false)
        }
    }
    
    func setup(giftBookViewisHidden: Bool, iHaveAGiftViewIsHidden: Bool, recommendBookViewIsHidden: Bool){
        giftBookView.isHidden = giftBookViewisHidden
        iHaveAGiftView.isHidden = iHaveAGiftViewIsHidden
        recommendBookView.isHidden = recommendBookViewIsHidden
    }
    
    func setupViewForWriterStatus(withBookDetails bookDetails: AdBook){
        hideReadCopyView()
        hideVoiceCopyView()
        hideBothView()
        hidePrintedCopyView()
        
        setup(giftBookViewisHidden: false, iHaveAGiftViewIsHidden: true, recommendBookViewIsHidden: true)
        
        giftBookTextLabel.text = "لديك \(bookDetails.giftCount ?? 0) اهداءات"
    }
    
    func hideGiftBookView(){
        giftBookView.isHidden = true
        giftBookTextLabel.text = ""
    }
    
    func setupReadCopyView(withPrice price: Float){
        readCopyTextLabel.text = "كتاب الكتروني"
        readCopyPriceLabel.text = "\(price)".cleanFloatNumber() + " دينار "
        readCopyBuyButton.setTitle("شراء", for: .normal)
        readCopyBuyButton.backgroundColor = UIColor.NBGoldColor()
        readCopyBuyButton.addTarget(self, action: #selector(buyReadCopy(_:)), for: .touchUpInside)
    }
    
    func setupBoughtReadCopyView(withLink link: String){
        readCopyTextLabel.text = "كتاب الكتروني"
        readCopyPriceLabel.text = ""
        readCopyBuyButton.setTitle("اقرأ", for: .normal)
        readCopyBuyButton.backgroundColor = UIColor.NBGreenColor()
        bookReadingLink = link
        readCopyBuyButton.addTarget(self, action: #selector(openBookReader(_:)), for: .touchUpInside)
    }
    
    func hideReadCopyView(){
        readCopyTextLabel.text = ""
        readCopyPriceLabel.text = ""
        readCopyBuyButton.setTitle("", for: .normal)
        readCopyViewDefaultHeight.constant = 0
    }
    
    func setupVoiceCopyView(withPrice price: Float){
        voiceCopyTextLabel.text = "كتاب صوتي"
        voiceCopyPriceLabel.text = "\(price)".cleanFloatNumber() + " دينار "
        voiceCopyBuyButton.setTitle("شراء", for: .normal)
        voiceCopyBuyButton.backgroundColor = UIColor.NBGoldColor()
        voiceCopyBuyButton.removeTarget(self, action: #selector(openBookListener(_:)), for: .touchUpInside)
        voiceCopyBuyButton.addTarget(self, action: #selector(buyVoiceCopy(_:)), for: .touchUpInside)
    }
    
    func setupBoughtVoiceCopyView(withLink link: String){
        voiceCopyTextLabel.text = "كتاب صوتي"
        voiceCopyPriceLabel.text = ""
        voiceCopyBuyButton.setTitle("استمع", for: .normal)
        voiceCopyBuyButton.backgroundColor = UIColor.NBGreenColor()
        bookListeningLink = link
        
        voiceCopyBuyButton.removeTarget(self, action: #selector(buyVoiceCopy(_:)), for: .touchUpInside)
        voiceCopyBuyButton.addTarget(self, action: #selector(openBookListener(_:)), for: .touchUpInside)
    }
    
    func hideVoiceCopyView(){
        voiceCopyTextLabel.text = ""
        voiceCopyPriceLabel.text = ""
        voiceCopyBuyButton.setTitle("", for: .normal)
        voiceCopyViewDefaultHeight.constant = 0
    }
    
    func setupBothView(withPrice price: Float){
        bothTextLabel.text = "كلاهما"
        bothPriceLabel.text = "\(price)".cleanFloatNumber() + " دينار "
        bothBuyButton.setTitle("شراء", for: .normal)
        bothBuyButton.backgroundColor = UIColor.NBGoldColor()
        bothBuyButton.addTarget(self, action: #selector(buyBothCopies(_:)), for: .touchUpInside)
    }
    
    func hideBothView(){
        bothTextLabel.text = ""
        bothPriceLabel.text = ""
        bothBuyButton.setTitle("", for: .normal)
        bothViewDefaultHeight.constant = 0
    }
    
    func setupPrintedCopyView(withPrice price: Float){
        printedCopyTextLabel.text = "نسخة مطبوعة"
        printedCopyPriceLabel.text = "\(price)".cleanFloatNumber() + " دينار "
        printedCopyBuyButton.setTitle("أضف إلى السلة", for: .normal)
        printedCopyBuyButton.backgroundColor = UIColor.NBGoldColor()
        printedCopyBuyButton.addTarget(self, action: #selector(self.addToCartButtonClicked(_:)), for: .touchUpInside)
    }
    
    func hidePrintedCopyView(){
        printedCopyTextLabel.text = ""
        printedCopyPriceLabel.text = ""
        printedCopyBuyButton.setTitle("", for: .normal)
        printedViewDefaultHeight.constant = 0
    }
    
    func setupRecommendationView(withStatus isRecommended: Bool){
        giftBookTextLabel.text = ""
        if isRecommended{
            recommendBookButton.setTitle("لقد قمت بترشيح الكتاب", for: .normal)
        }else{
            recommendBookButton.setTitle("رشح الكتاب", for: .normal)
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        if fromAppDelegate {
            goToHome()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        if let bookId = bookId{
            if let integerbookId = Int(bookId){
                revertFavouriteStatus()
                let bookIds = [integerbookId]
                bookDetailsVM?.addToFavourites(withBookIds: bookIds)
            }
        }
    }
    
    func revertFavouriteStatus(){
        isFavoriteBook.value = !isFavoriteBook.value
    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
        //let appURL = "https://itunes.apple.com/app/id1463468370"
        //guard let appURL = shareLink else { return }
        let appURL = "\(shareLink ?? "")"
        if let myWebsite = URL(string: appURL) {
            let objectsToShare = [myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = view
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    @objc func openBookReader(_ sender: UIButton){
        print("book url: \(bookReadingLink)")
        checkBookFileExists(withLink: bookReadingLink){ [weak self] downloadedURL in
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
    
    @objc func openBookListener(_ sender: UIButton){
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
                bookListenerVC?.coverImageLink = bookDetailsVM?.bookDetails.value.cover ?? ""
                bookListenerVC?.bookName = bookDetailsVM?.bookDetails.value.name ?? ""
            }else{
                bookListenerVC?.newAudioWillBeLoaded = false
            }
            
            self.navigationController?.pushViewController(bookListenerVC!, animated: true)
        }
    }
    
    @IBAction func bookAuthorButtonClicked(_ sender: UIButton) {
        if let authorId = authorId, !authorId.isEmpty{
            let authorViewModel = AuthorViewModel()
            authorViewModel.authorId = authorId
            if let authorViewController = authorViewModel.initViewController(){
                navigationController?.pushViewController(authorViewController, animated: true)
            }
        }
    }
    
    @objc func addToCartButtonClicked(_ sender: UIButton){
        if let bookDetails = bookDetailsVM?.bookDetails.value, bookDetails.id != nil{
//            AddBookToCartLogic(withBookDetails: bookDetails)
//            (navigationController as? NBParentNavigationControllerViewController)?.goToCart()
        }
    }
    
    
    @IBAction func iHaveAGift(_ sender: UIButton) {
        //flow of enter a coupon to get the book
        performSegue(withIdentifier: "BookGiftSegue", sender: self)
    }
    
    @IBAction func giftBook(_ sender: UIButton) {
        guard (bookDetailsVM?.bookDetails.value.giftCount ?? 0) > 0 else {
            showAlert(withTitle: "عفوا", andMessage: "لديك 0 اهداءات")
            return
        }
        
        guard let value  = bookDetailsVM?.bookDetails.value else{
            showAlert(withTitle: "", andMessage: "كود الخدمة غير متوفر!")
            return
        }
        
        let appURL = "https://itunes.apple.com"
        var message = "قم باستخدام هذا الكود لتتمكن من الحصول على كتابي مجانا"
        message.append("\n")
        if let readCode = value.readCode{
            message.append("كود الكتاب الالكتروني")
            message.append("\n")
            message.append(readCode)
            message.append("\n")
        }
        
        if let listenCode = value.listenCode{
            message.append("كود الكتاب الصوتي")
            message.append("\n")
            message.append(listenCode)
            message.append("\n")
        }
        message.append("و لتحميل التطبيق من هنا")
        message.append("\n")
        message.append("\(appURL)")
        
        let objectsToShare = [message]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookGiftSegue"{
            if let destination = segue.destination as? BookGiftViewController{
                destination.bookId = bookId
                destination.bookDetailsDelegate = self
            }
        }
    }
    
    @IBAction func recommendTheBook(_ sender: UIButton) {
        // call recommend book API
        guard let bookIdString = bookId else {
            showAlert(withTitle: "", andMessage: "حدث خطأ غير متوقع")
            return
        }
        
        if let bookIdInteger = Int(bookIdString){
            bookDetailsVM?.recommendBook(withBookIds: [bookIdInteger])
        }
    }
    
    @objc func buyReadCopy(_ sender: UIButton){
        bookDetailsVM?.purchaseBook(withOrderType: OrderType.read.rawValue, andCoupon: nil)
    }
    
    @objc func buyVoiceCopy(_ sender: UIButton){
        bookDetailsVM?.purchaseBook(withOrderType: OrderType.listen.rawValue, andCoupon: nil)
    }
    
    @objc func buyBothCopies(_ sender: UIButton){
        bookDetailsVM?.purchaseBook(withOrderType: OrderType.both.rawValue, andCoupon: nil)
    }
    
    func refresh() {
        if let bookId = bookId {
            bookDetailsVM?.fetchBookDetails(withBookId: bookId)
        }
    }
}


// cart functionality
extension BookDetailsViewController{

    func AddBookToCartLogic(withBookDetails bookDetails: AdBook){

        if let cart = NBParentViewController.realm?.objects(Cart.self).first{
            addToCart(intoCart: cart, withBookDetails: bookDetails)
        }else{
            createNewCart(withBookDetails: bookDetails)
        }
    }

    func addToCart(intoCart cart: Cart, withBookDetails bookDetails: AdBook){
        do{
            try NBParentViewController.realm?.write {

                if var existedBook = cart.books.filter({$0.bookId == bookDetails.id ?? 0}).first{
                    existedBook = existedBook ± bookDetails

                }else{
                    //add new book
                    var newBook = BookOfflineModel()
                    newBook = newBook ± bookDetails
                    cart.books.append(newBook)
                }

                //update cart total quantity and total price
                cart.totalNumberOfItems = 0
                cart.totalPrice = 0
                for book in cart.books{
                    cart.totalNumberOfItems += book.counter
                    cart.totalPrice += (book.printedCopyPrice * Float(book.counter))
                }

                //save cart updates
               NBParentViewController.realm?.add(cart, update: true)

            }
        }catch let err{
            showAlert(withTitle: "", andMessage: err.localizedDescription)
        }
    }

    func createNewCart(withBookDetails bookDetails: AdBook){
        let newCart = Cart()
        addToCart(intoCart: newCart, withBookDetails: bookDetails)
    }
    
}

