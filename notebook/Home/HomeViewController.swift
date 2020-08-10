//
//  HomeViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/14/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class HomeViewController: NBParentViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var homeVM: HomeViewModel?
    let disposeBag = DisposeBag()
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var featuredBooksCollectionView: UICollectionView!
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var mostReadCollectionView: UICollectionView!
    @IBOutlet weak var userGenresTableView: UITableView!
    @IBOutlet weak var bookQouteImage: UIImageView!
    @IBOutlet weak var noInternetView: UIView!
    
    var featuredBooksDataSourceVariable = Variable<[AdBook]>([])
    var genresDataSourceVariable = Variable<[Genre]>([])
    var mostReadBooksDataSourceVariable = Variable<[AdBook]>([])
    var userGenresDataSourceVariable = Variable<[UserGenre]>([])
    var adImageDataSourceVariable = Variable<AdImage>(AdImage())
    lazy var refreshControl = UIRefreshControl()
    var link: String?
    
    var selectedBookQouteImageFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var selectedBookQouteImage: UIImageView!
    var selectedBookQouteImageScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDataPresentationViews()
        homeVM = HomeViewModel(viewController: self)
        bookQouteImage.roundCorners(withRadius: 6)
        homeVM?.fetchAdVideoURL()
        homeVM?.fetchHomeData(withLoader: true)
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        scrollView.refreshControl = refreshControl
        sendDeviceInfo()
        
        bookQouteImage.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapBookQouteImage))
        bookQouteImage.addGestureRecognizer(gesture)
    }
    
    @objc func onTapBookQouteImage(){
        print("onTapBookQouteImage")
        if let link = self.link{
            guard let url = URL(string: link) else { return }
            UIApplication.shared.open(url)
        }else{
            fullScreen(for: bookQouteImage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        (navigationController as? NBParentNavigationControllerViewController)?.addCartButton()
    }
    
    @objc func refresh(sender: AnyObject){
        homeVM?.fetchHomeData()
    }
    
    func setupDataPresentationViews(){
        let featuredNib = UINib(nibName: FeaturedBookCollectionViewCell.reusableIdentifier, bundle: nil)
        featuredBooksCollectionView.register(featuredNib, forCellWithReuseIdentifier: FeaturedBookCollectionViewCell.reusableIdentifier)
        featuredBooksCollectionView.transform = CGAffineTransform.init(scaleX: -1, y: 1)
        featuredBooksDataSourceVariable.asObservable()
            .bind(to: featuredBooksCollectionView.rx
                .items(cellIdentifier: FeaturedBookCollectionViewCell.reusableIdentifier, cellType: FeaturedBookCollectionViewCell.self))
            { (row, model: AdBook, cell: FeaturedBookCollectionViewCell) in
                cell.configureCell(withCoverImageUrl: model.cover)
                cell.setCellShadow()
            }.disposed(by: disposeBag)
        
        featuredBooksCollectionView.rx.itemSelected.bind { [weak self] indexPath in
            if let bookDetails = self?.featuredBooksDataSourceVariable.value[indexPath.row], let bookId = bookDetails.id{
                self?.openBookDetails(withBook: bookDetails, bookId: bookId)
            }
        }.disposed(by: disposeBag)
        
        let genreNib = UINib(nibName: GenresCollectionViewCell.reusableIdentifier, bundle: nil)
        genresCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        genresCollectionView.register(genreNib, forCellWithReuseIdentifier: GenresCollectionViewCell.reusableIdentifier )
        genresDataSourceVariable.asObservable()
            .bind(to: genresCollectionView.rx
                .items(cellIdentifier: GenresCollectionViewCell.reusableIdentifier, cellType: GenresCollectionViewCell.self)){ (row, model: Genre, cell: GenresCollectionViewCell) in
                    cell.configureCell(withTitle: model.name ?? "")
            }.disposed(by: disposeBag)
        
        genresCollectionView.rx.itemSelected.bind { [weak self] indexPath in
            if let genre = self?.genresDataSourceVariable.value[indexPath.row], let genreId = genre.id{
                let genreIdString = String(genreId)
                self?.openSearch(withGenreId: genreIdString)
            }else{
                self?.openSearch(withGenreId: "")
            }
            }.disposed(by: disposeBag)
        
        let mostReadNib = UINib(nibName: MostReadCollectionViewCell.reusableIdentifier, bundle: nil)
        mostReadCollectionView.register(mostReadNib, forCellWithReuseIdentifier: MostReadCollectionViewCell.reusableIdentifier)
        mostReadBooksDataSourceVariable.asObservable()
            .bind(to: mostReadCollectionView.rx
                .items(cellIdentifier: MostReadCollectionViewCell.reusableIdentifier, cellType: MostReadCollectionViewCell.self)){ (row, model: AdBook, cell: MostReadCollectionViewCell) in
                    let firstAuthor = model.authors?.first?.name
                    cell.configureCell(withImageURL: model.cover ?? "", andBookName: model.name ?? "", andBookAuthor: firstAuthor ?? "")
        }.disposed(by: disposeBag)
        
        mostReadCollectionView.rx.itemSelected.bind { [weak self] indexPath in
            if let bookDetails = self?.mostReadBooksDataSourceVariable.value[indexPath.row], let bookId = bookDetails.id{
                self?.openBookDetails(withBook: bookDetails, bookId: bookId)
            }
            }.disposed(by: disposeBag)
        
        userGenresTableView.tableFooterView = UIView()
        let userGenresNib = UINib.init(nibName: UserGenreTableViewCell.reusableIdentifier, bundle: nil)
        userGenresTableView.register(userGenresNib, forCellReuseIdentifier: UserGenreTableViewCell.reusableIdentifier)
        
        userGenresDataSourceVariable.asObservable().bind(to: userGenresTableView.rx.items(cellIdentifier: UserGenreTableViewCell.reusableIdentifier, cellType: UserGenreTableViewCell.self)){ [weak self] (row, model: UserGenre, cell: UserGenreTableViewCell) in
            cell.configureCell(withGenreTitle: model.name ?? "", andBooks: model.books ?? [])
            cell.selectCellHandler = { [weak self] viewController in
                self?.gotoBookDetails(withViewController: viewController)
            }
        }.disposed(by: disposeBag)
        
        adImageDataSourceVariable.asObservable().subscribe(onNext: { [weak self] (adImageObject) in
            let urlString = adImageObject.image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            self?.bookQouteImage.sd_setImage(with: URL(string: urlString ?? ""), placeholderImage: #imageLiteral(resourceName: "notebook_place_holder"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        }).disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genresCollectionView{
            let tempLabel = UILabel.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 50, height: 50)))
            tempLabel.numberOfLines = 1
            tempLabel.text = genresDataSourceVariable.value[indexPath.row].name
            let newSize = tempLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let zeplinDesignedHeight: CGFloat = 44
            let padding: CGFloat = 20
            let minimumWidth: CGFloat = 80
            let newWidth = (newSize.width + padding) < minimumWidth ? minimumWidth: (newSize.width + padding)
            return CGSize.init(width: newWidth , height: zeplinDesignedHeight)
        }
        return CGSize.zero
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
    
    func openSearch(withGenreId genreId: String){
        let storyboard = UIStoryboard.init(name: "Search", bundle: nil)
        if let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController{
            searchVC.genreId = genreId
            navigationController?.pushViewController(searchVC, animated: true)
        }
    }

    func gotoBookDetails(withViewController viewController: NBParentViewController){
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func sendDeviceInfo(){
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "defaultId"
        let deviceModel = UIDevice.current.model
        homeVM?.deviceInfo(withDeviceId: deviceId, andDeviceModel: deviceModel)
    }
    
    @IBAction func onTapGoToMyBooks(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
}

extension HomeViewController{
    
    func fullScreen(for sender: UIImageView) {
        selectedBookQouteImageScrollView = UIScrollView(frame: UIScreen.main.bounds)
        selectedBookQouteImageScrollView.backgroundColor = .clear
        selectedBookQouteImageScrollView.delegate = self
        selectedBookQouteImageScrollView.minimumZoomScale = 1.0
        selectedBookQouteImageScrollView.maximumZoomScale = 10.0
        
        let imageView = sender
        selectedBookQouteImageFrame = imageView.frame
        selectedBookQouteImage = UIImageView(image: imageView.image)
        selectedBookQouteImage.frame = selectedBookQouteImageFrame
        selectedBookQouteImage.backgroundColor = .black
        selectedBookQouteImage.contentMode = .scaleAspectFit
        selectedBookQouteImage.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
        selectedBookQouteImage.addGestureRecognizer(tap)
        
        currentView().addSubview(selectedBookQouteImageScrollView)
        selectedBookQouteImageScrollView.addSubview(selectedBookQouteImage)
        self.navigationController?.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = .lightContent
        
        UIView.animate(withDuration: 0.3) {
            self.selectedBookQouteImage.frame = UIScreen.main.bounds
        }
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        UIApplication.shared.statusBarStyle = .default
        
        UIView.animate(withDuration: 0.2, animations: {
            let imageView = sender.view as! UIImageView
            imageView.frame = self.selectedBookQouteImageFrame
            
        }) { (success) in
            if success{
                sender.view?.removeFromSuperview()
                self.selectedBookQouteImage.removeFromSuperview()
                self.selectedBookQouteImageScrollView.removeFromSuperview()
                self.selectedBookQouteImage = nil
                self.selectedBookQouteImageScrollView = nil
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if selectedBookQouteImageScrollView == scrollView{
            return selectedBookQouteImage
        }else{
            return UIView()
        }
    }
}
