//
//  FavouriteBooksViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

class FavouriteBooksViewModel: NBParentViewModel {
    
    private var favouriteBooksUseCases: FavouriteBooksUseCases?
    private var homeUseCases: HomeUseCases?
    private weak var favouriteBooksViewController: FavouriteBooksViewController?
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        favouriteBooksUseCases = FavouriteBooksUseCases()
        homeUseCases = HomeUseCases()
        favouriteBooksViewController = viewController as? FavouriteBooksViewController
    }
    
    func fetchUserFavouriteBooks(){
        if !(favouriteBooksViewController?.variablesInitialized ?? false){
            favouriteBooksViewController?.showLoadingView()
        }
        favouriteBooksUseCases?.fetchUserFavouriteBooks(success: { [weak self] data in
            if let data = data as? UserFavouriteBooksResponseModel{
                if !(self?.favouriteBooksViewController?.variablesInitialized ?? false){
                    self?.favouriteBooksViewController?.variablesInitialized = true
                    self?.favouriteBooksViewController?.hideLoadingView()
                }
                self?.favouriteBooksViewController?.favouriteBooksDataSourceVariable.value = data.data ?? []
            }
            }, failure: { [weak self] (error) in
                if !(self?.favouriteBooksViewController?.variablesInitialized ?? false){
                    self?.favouriteBooksViewController?.variablesInitialized = true
                    self?.favouriteBooksViewController?.hideLoadingView()
                }
                if let error = error as? NBErrorCase{
                    switch error{
                    case .unauthorized:
                        self?.favouriteBooksViewController?.handleNotLoggedInUser()
                    default:
                        self?.handleGenericErrors(error: error)
                    }
                }
        })
    }
    
    func addToFavourites(ofCellWithIndexPath indexPath: IndexPath){
        let bookDetails = favouriteBooksViewController?.favouriteBooksDataSourceVariable.value[indexPath.row]
        if let bookId = bookDetails?.id, let isFav = bookDetails?.isFavourite{
            let integerbookId = Int(bookId)
            let bookIds = [integerbookId]
            homeUseCases?.addToFavourites(withBookIds: bookIds, success: { [weak self] data in
                if let _ = data as? BookDetailsModel{
                    let newValue = !isFav
                    self?.favouriteBooksViewController?.favouriteBooksDataSourceVariable.value[indexPath.row].isFavourite = newValue
                    if newValue == false{
                        self?.favouriteBooksViewController?.favouriteBooksDataSourceVariable.value.remove(at: indexPath.row)
                    }
                }
                }, failure: { [weak self] (error) in
                    self?.favouriteBooksViewController?.revertFavouriteForCell(withIndexPath: indexPath)
                    if let error = error as? NBErrorCase{
                        self?.handleGenericErrors(error: error)
                    }
            })
        }
    }
}
