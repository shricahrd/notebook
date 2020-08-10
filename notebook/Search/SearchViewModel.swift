//
//  SearchViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/22/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

class SearchViewModel: NBParentViewModel {
    
    private var searchUseCases: SearchUseCases?
    private var homeUseCases: HomeUseCases?
    private weak var searchViewController: SearchViewController?
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        searchUseCases = SearchUseCases()
        homeUseCases = HomeUseCases()
        searchViewController = viewController as? SearchViewController
    }
    
    func searchBooks(withKeyword keyword: String?, withBookGenreId genreId: String?){
        self.searchViewController?.showLoadingView()
        searchUseCases?.searchBooks(withKeyword: keyword, andGenreId: genreId, andAuthorId: nil, success: { [weak self] data in
            if let data = data as? SearchingResponseModel{
                self?.searchViewController?.variablesInitialized = true
                self?.searchViewController?.booksDataSourceVariable.value = data.data ?? []
            }
            self?.searchViewController?.hideLoadingView()
            }, failure: { [weak self] (error) in
                self?.searchViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
        })
    }
    
    func fetchGenres(){
        self.searchViewController?.showLoadingView()
        searchUseCases?.fetchGenres(success: { [weak self] data in
            if let data = data as? GenresResponseModel{
                let defaultItem = Genre(JSON: ["id" : "", "name": "الكل"])
                self?.searchViewController?.genresDataSourceVariable.value = data.data?.reversed() ?? []
                if let defaultItem = defaultItem{
                    self?.searchViewController?.genresDataSourceVariable.value.append(defaultItem)
                }
                self?.searchViewController?.selectGenre()
            }
            self?.searchViewController?.hideLoadingView()
            }, failure: { [weak self] (error) in
                self?.searchViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
        })
    }
    
    func addToFavourites(ofCellWithIndexPath indexPath: IndexPath){
        let bookDetails = searchViewController?.booksDataSourceVariable.value[indexPath.row]
        if let bookId = bookDetails?.id, let isFav = bookDetails?.isFavourite{
            let integerbookId = Int(bookId)
            let bookIds = [integerbookId]
            homeUseCases?.addToFavourites(withBookIds: bookIds, success: { [weak self] data in
                if let _ = data as? BookDetailsModel{
                    self?.searchViewController?.booksDataSourceVariable.value[indexPath.row].isFavourite = !isFav
                }
            }, failure: { [weak self] (error) in
                self?.searchViewController?.revertFavouriteForCell(withIndexPath: indexPath)
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
            })
        }
    }
    
}
