//
//  BookGiftViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/12/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import RxSwift

class BookGiftViewModel: NBParentViewModel {
    
    private var moreUseCases: MoreUseCases?
    private weak var bookGiftViewController: BookGiftViewController?
    
    var code = Variable<String>("")
    var isValidCode: Bool = false
   
    let disposeBag = DisposeBag()

    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        moreUseCases = MoreUseCases()
        bookGiftViewController = viewController as? BookGiftViewController
        
        code.asObservable().subscribe({ [weak self] (code) in
            self?.isValidCode = !(code.element?.isEmpty ?? false)
        }).disposed(by: disposeBag)
    }
    
   
    func purchaseBook(withOrderType orderType: String?, andCoupon coupon: String?, andBookId bookId: String){
        guard let bookIdInteger = Int(bookId) else {
            return
        }
        let book = PurchaseBook.init(book_id: bookIdInteger, quantity: 1)
        let requestBody = PurchaseBookRequestPayload.init(address: nil, coupon: coupon, orderType: orderType, books: [book])
        moreUseCases?.requestBody = requestBody
        moreUseCases?.purchaseBook(success: { [weak self] data in
            self?.bookGiftViewController?.dismiss(animated: true, completion: {
                self?.bookGiftViewController?.bookDetailsDelegate?.refresh()
            })
            
            }, failure: { [weak self] (error) in
                if let error = error as? NBErrorCase{
                    switch error{
                    case .unprocessableEntity(_, _, _):
                        self?.bookGiftViewController?.showAlert(withTitle: "", andMessage: "كوبون الخصم غير صحيح")
                    default:
                        self?.handleGenericErrors(error: error)
                    }
                }
        })
    }
    
   
}
