//
//  AuthorViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import UIKit

class AuthorViewModel: NBParentViewModel {
    
    private var homeUseCases: HomeUseCases?
    private var searchUseCases: SearchUseCases?
    private weak var authorViewController: AuthorViewController?
    var authorId = String()
    var shareLink = String()
    
    // this is the correct way to implement MVVM
    override init(){
        super.init()
        homeUseCases = HomeUseCases()
        searchUseCases = SearchUseCases()
    }

    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        homeUseCases = HomeUseCases()
        searchUseCases = SearchUseCases()
        authorViewController = viewController as? AuthorViewController
    }
    
    func initViewController() -> NBParentViewController?{
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        authorViewController = storyBoard.instantiateViewController(withIdentifier: "AuthorViewController") as? AuthorViewController
        authorViewController?.authorViewModel = self
        super.viewController = authorViewController
        return authorViewController
    }
    
    func addToFavourites(ofCellWithIndexPath indexPath: IndexPath){
        let bookDetails = authorViewController?.authorBooksDataSourceVariable.value[indexPath.row]
        if let bookId = bookDetails?.id, let isFav = bookDetails?.isFavourite{
            let integerbookId = Int(bookId)
            let bookIds = [integerbookId]
            homeUseCases?.addToFavourites(withBookIds: bookIds, success: { [weak self] data in
                if let _ = data as? BookDetailsModel{
                    self?.authorViewController?.authorBooksDataSourceVariable.value[indexPath.row].isFavourite = !isFav
                }
                }, failure: { [weak self] (error) in
                    self?.authorViewController?.revertFavouriteForCell(withIndexPath: indexPath)
                    if let error = error as? NBErrorCase{
                        self?.handleGenericErrors(error: error)
                    }
            })
        }
    }
    
    func fetchAuthorDetails(){
        guard !authorId.isEmpty else {
            return
        }
        self.authorViewController?.showLoadingView()
        homeUseCases?.fetchAuthorDetails(withAuthorId: authorId, success: { [weak self] data in
            if let data = data as? AuthorDetailsModel, let author = data.data{
                self?.authorViewController?.authorDetailsVariable.value = author
            }
            self?.authorViewController?.hideLoadingView()
            }, failure: { [weak self] (error) in
                self?.authorViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
        })
    }
    
    func fetchAuthorBooks(){
        guard !authorId.isEmpty else {
            return
        }
        self.authorViewController?.showLoadingView()
        searchUseCases?.searchBooks(withKeyword: nil, andGenreId: nil, andAuthorId: authorId, success: { [weak self] data in
            if let data = data as? SearchingResponseModel{
                self?.authorViewController?.authorBooksDataSourceVariable.value = data.data ?? []
            }
            self?.authorViewController?.hideLoadingView()
            }, failure: { [weak self] (error) in
                self?.authorViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
        })
    }
}
