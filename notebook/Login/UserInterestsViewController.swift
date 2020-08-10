//
//  UserInterestsViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/26/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserInterestsViewController: NBParentViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var customFlowLayout: AlignedCollectionViewFlowLayout!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var browseButton: UIButton!
    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var chooseInterestsTextLabel: UILabel!
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var screenHeaderLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var userInterestsVM: UserInterestsViewModel?
    var genresDataSourceVariable = Variable<[Genre]>([])
    let minimumNumberOfGenres = 1
    var selectedGenresIds = [Int]()
    var isEditingUserInterests = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userInterestsVM = UserInterestsViewModel.init(viewController: self)
        setupView()
        setupDataPresentationViews()
        setIsEditing(withValue: isEditingUserInterests)
        userInterestsVM?.fetchGenres()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? NBParentNavigationControllerViewController)?.addBackButton()
    }

    func setIsEditing(withValue value: Bool){
        userInterestsVM?.isEditingUserGenres = value
    }
    
    func setupView(){
        title = "تعديل اهتماماتي"
        skipButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        browseButton.titleLabel?.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        screenHeaderLabel.font = UIFont.GulfBold(withSize: FontSize.small)
        screenTitleLabel.font = UIFont.GulfBold(withSize: FontSize.small)
        chooseInterestsTextLabel.font = UIFont.GulfRegular(withSize: FontSize.vTiny)
        //browseButton.setGradientBackground(horizontalMode: true)
        browseButton.roundCorners(withRadius: 6)
        genresCollectionView.allowsMultipleSelection = true
        customFlowLayout.minimumLineSpacing = 24
        customFlowLayout.minimumInteritemSpacing = 12
        customFlowLayout.horizontalAlignment = .right
    }
    
    func setupDataPresentationViews(){
        let genreNib = UINib(nibName: SearchGenreCollectionViewCell.reusableIdentifier, bundle: nil)
        genresCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        genresCollectionView.register(genreNib, forCellWithReuseIdentifier: SearchGenreCollectionViewCell.reusableIdentifier)
        genresDataSourceVariable.asObservable()
            .bind(to: genresCollectionView.rx
                .items(cellIdentifier: SearchGenreCollectionViewCell.reusableIdentifier, cellType: SearchGenreCollectionViewCell.self)){ (row, model: Genre, cell: SearchGenreCollectionViewCell) in
                    cell.configureCell(withTitle: model.name ?? "")
            }.disposed(by: disposeBag)
        
        genresCollectionView.rx.itemSelected.bind { [weak self] indexPath in
            if let genreId = self?.genresDataSourceVariable.value[indexPath.item].id{
                self?.selectedGenresIds.append(genreId)
            }else{
                self?.showAlert(withTitle: "error", andMessage: "couldn't find genre id!")
                self?.genresCollectionView.deselectItem(at: indexPath, animated: false)
            }
            }.disposed(by: disposeBag)
        
        genresCollectionView.rx.itemDeselected.bind { [weak self] indexPath in
            if let genreId = self?.genresDataSourceVariable.value[indexPath.item].id{
                self?.selectedGenresIds = self?.selectedGenresIds.filter({ (itemGenreId) -> Bool in
                    return itemGenreId != genreId
                }) ?? []
            }else{
                self?.showAlert(withTitle: "error", andMessage: "couldn't find genre id!")
                self?.genresCollectionView.deselectItem(at: indexPath, animated: false)
            }
        }.disposed(by: disposeBag)
    }
    
    @IBAction func browseButtonClicked(_ sender: UIButton) {
        print(selectedGenresIds)
        if selectedGenresIds.count >= minimumNumberOfGenres{
            userInterestsVM?.updateUserGenres(withGenresIds: selectedGenresIds)
        }else{
            showAlert(withTitle: "", andMessage: "اختر واحدة على الأقل/nأو قم بالتخطي")
        }
    }
    
    @IBAction func skipButtonClicked(_ sender: UIButton) {
        if isEditingUserInterests{
            self.navigationController?.popViewController(animated: true)
        }else{
            goToHome()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == genresCollectionView{
            let tempLabel = UILabel.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: 50, height: 50)))
            tempLabel.numberOfLines = 1
            tempLabel.text = genresDataSourceVariable.value[indexPath.row].name
            let newSize = tempLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let zeplinDesignedHeight: CGFloat = 37
            let padding: CGFloat = 20
            let minimumWidth: CGFloat = 107
            let newWidth = (newSize.width + padding) < minimumWidth ? minimumWidth: (newSize.width + padding)
            return CGSize.init(width: newWidth , height: zeplinDesignedHeight)
        }
        return CGSize.zero
    }
    
    func setUserGenres(withGenres genres: [Genre]){
        genres.forEach { (genre) in
            if let id = genre.id{
                selectedGenresIds.append(id)
                selectItem(withId: id)
            }
        }
    }
    
    func selectItem(withId id: Int){
        
        for i in 0..<genresDataSourceVariable.value.count{
            if genresDataSourceVariable.value[i].id == id{
                let indexPath = IndexPath.init(item: i, section: 0)
                genresCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
            }
        }
    }
    
}
