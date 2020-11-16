//
//  BookDetailsViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/17/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import RxSwift

class  BookDetailsViewModel: NBParentViewModel {
    
    private var homeUseCases: HomeUseCases?
    private var searchUseCases: SearchUseCases?
    private var moreUseCases: MoreUseCases?
    private weak var bookDetailsViewController: BookDetailsViewController?
    var bookDetails = Variable<AdBook>(AdBook())
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        homeUseCases = HomeUseCases()
        searchUseCases = SearchUseCases()
        moreUseCases = MoreUseCases()
        bookDetailsViewController = viewController as? BookDetailsViewController
    }
    
    func fetchBookDetails(withBookId bookId: String){
        self.bookDetailsViewController?.showLoadingView()
        homeUseCases?.fetchBookDetails(withBookId: bookId, success: { [weak self] data in
            if let data = data as? BookDetailsModel{
                if let bookDetails = data.data{
                    self?.bookDetails.value = bookDetails
                }
            }
            self?.bookDetailsViewController?.hideLoadingView()
            }, failure: { [weak self] (error) in
                self?.bookDetailsViewController?.hideLoadingView()
                print(error.debugDescription)
        })
    }
    
    func addToFavourites(withBookIds bookIds: [Int]){
        homeUseCases?.addToFavourites(withBookIds: bookIds, success: { data in
            if let data = data as? BookDetailsModel{
                if let response = data.meta{
                    print("\(response.message ?? "")")
                }
            }
            }, failure: { [weak self] (error) in
                self?.bookDetailsViewController?.revertFavouriteStatus()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
        })
    }
    
    func fetchRecommendedBooks(withBookGenreId genreId: String){
        self.bookDetailsViewController?.showLoadingView()
        searchUseCases?.searchBooks(withKeyword: nil, andGenreId: genreId, andAuthorId: nil, success: { [weak self] data in
            if let data = data as? SearchingResponseModel{
                self?.bookDetailsViewController?.recommendationsDataSource.value = data.data ?? []
            }
            self?.bookDetailsViewController?.hideLoadingView()
            }, failure: { [weak self] (error) in
                self?.bookDetailsViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    switch error{
                    case .noInternetConnection:
                        print(error.localizedDescription)
                    default:
                        self?.handleGenericErrors(error: error)
                    }
                }
        })
    }
    
    func purchaseBook(withOrderType orderType: String?, andCoupon coupon: String?){
        let book = PurchaseBook.init(book_id: bookDetails.value.id, quantity: 1)
        let requestBody = PurchaseBookRequestPayload.init(address: nil, coupon: coupon, orderType: orderType, books: [book])
        moreUseCases?.requestBody = requestBody
        self.bookDetailsViewController?.showLoadingView()
        moreUseCases?.purchaseBook(success: { [weak self] data in
            self?.bookDetailsViewController?.hideLoadingView()
            if let response = data as? PurchaseBookResponse, let url = response.data?.paymentUrl, let invoice = response.data?.invoiceId{
                self?.bookDetailsViewController?.continuePayment(withUrl: url, andInvoice: invoice)
            }
            }, failure: { [weak self] (error) in
                self?.bookDetailsViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    switch error{
                    default:
                        self?.handleGenericErrors(error: error)
                    }
                }
        })
    }
    
    func recommendBook(withBookIds bookIds: [Int]){
        self.viewController?.showLoadingView()
        guard let bookId = bookIds.first else {
            return
        }
        homeUseCases?.recommendBooks(withBookIds: bookIds, success: { [weak self] data in
            if let data = data as? BookDetailsModel{
                if let response = data.meta{
                    print("\(response.message ?? "")")
                    self?.fetchBookDetails(withBookId: "\(bookId)")
                }
            }
            self?.viewController?.hideLoadingView()
        }, failure: { [weak self] (error) in
            self?.viewController?.hideLoadingView()
            if let error = error as? NBErrorCase{
                self?.handleGenericErrors(error: error)
            }
        })
    }
}
