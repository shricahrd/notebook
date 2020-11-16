//
//  MyBooksViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper

class MyBooksViewModel: NBParentViewModel {
    
    private var myBooksUseCases: MyBooksUseCases?
    private var homeUseCases: HomeUseCases?
    private weak var myBooksViewController: MyBooksViewController?
    
    var limit: Int = 20
    var page: Int = 0
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        myBooksUseCases = MyBooksUseCases()
        homeUseCases = HomeUseCases()
        myBooksViewController = viewController as? MyBooksViewController
    }
    
    
    
    func fetchUserBooks(){
        if !(myBooksViewController?.variablesInitialized ?? false) {
            myBooksViewController?.showLoadingView()
        }
        
        page = page + 1
        
        let map = Map(mappingType: .fromJSON, JSON: ["limit": limit,
                                                     "next": 0,
                                                     "page": page,
                                                     "prev": 0,
                                                     "total": 20])
        
        myBooksUseCases?.fetchUserBooks(paginator: map, success: { [weak self] data in
            if let data = data as? MyBooksResponseModel{
                if !(self?.myBooksViewController?.variablesInitialized ?? false) {
                    self?.myBooksViewController?.hideLoadingView()
                    self?.myBooksViewController?.variablesInitialized = true
                }
                
                if let myBookArr = data.data {
                    
                    if myBookArr.count > 0 {
                        self?.myBooksViewController?.myBooksDataSourceVariable.value.append(contentsOf: myBookArr)
                        MyBooksArchiver().save(myBooks: myBookArr)
                    }else {
                        if let page = self?.page {
                            self?.page = page - 1
                        }
                    }
                }
                
                
                
            }
            }, failure: { [weak self] (error) in
                if !(self?.myBooksViewController?.variablesInitialized ?? false){
                    self?.myBooksViewController?.hideLoadingView()
                    self?.myBooksViewController?.variablesInitialized = true
                }
                if let error = error as? NBErrorCase{
                    switch error{
                    case .unauthorized:
                        self?.myBooksViewController?.handleNotLoggedInUser()
                    case .noInternetConnection:
                        // TODO: load the books that are saved locally.
                        if !(self?.myBooksViewController?.variablesInitialized ?? false) {
                            self?.myBooksViewController?.hideLoadingView()
                            self?.myBooksViewController?.variablesInitialized = true
                        }
                        let myArchivedBooks = MyBooksArchiver().getMyBooksResponseModel()
                        self?.myBooksViewController?.myBooksDataSourceVariable.value = myArchivedBooks
                    default:
                        self?.handleGenericErrors(error: error)
                    }
                }
        })
    }
    
    func addToFavourites(ofCellWithIndexPath indexPath: IndexPath){
        let bookDetails = myBooksViewController?.myBooksDataSourceVariable.value[indexPath.row]
        if let bookId = bookDetails?.id, let isFav = bookDetails?.isFavourite{
            let integerbookId = Int(bookId)
            let bookIds = [integerbookId]
            homeUseCases?.addToFavourites(withBookIds: bookIds, success: { [weak self] data in
                if let _ = data as? BookDetailsModel{
                    self?.myBooksViewController?.myBooksDataSourceVariable.value[indexPath.row].isFavourite = !isFav
                }
                }, failure: { [weak self] (error) in
                    self?.myBooksViewController?.revertFavouriteForCell(withIndexPath: indexPath)
                    if let error = error as? NBErrorCase{
                        self?.handleGenericErrors(error: error)
                    }
            })
        }
    }
}
