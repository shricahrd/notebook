//
//  LogoutViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import RxSwift

class ContactUsViewModel: NBParentViewModel {
    
    private var moreUseCases: MoreUseCases?
    private weak var contactUsViewController: ContactUsViewController?
    
    var disposeBag = DisposeBag()
    var mobileNumber = Variable<String>("")
    var message = Variable<String>("")
    var isValidMobileNumber: Bool = false
    var isValidMessage: Bool = false
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        moreUseCases = MoreUseCases()
        contactUsViewController = viewController as? ContactUsViewController
        
        mobileNumber.asObservable().subscribe({ [weak self] (mobile) in
            self?.isValidMobileNumber = (mobile.element?.count ?? 0) >= 7 && (mobile.element?.count ?? 0) <= 100
        }).disposed(by: disposeBag)
        
        message.asObservable().subscribe({ [weak self] (message) in
            self?.isValidMessage = !(message.element?.isEmpty ?? false)
        }).disposed(by: disposeBag)
    }
    
    func contactUs(withMobileNumber mobileNumber: String, andMessage message: String){
        self.contactUsViewController?.showLoadingView()
        let contactUsRequest = ContactUsRequestPayload(mobileNumber: mobileNumber, message: message, userId: LocalStore.userId() ?? "")
        moreUseCases?.requestBody = contactUsRequest
        moreUseCases?.contactUs(success: { [weak self] data in
            self?.contactUsViewController?.hideLoadingView()
            if let _ = data as? RootMeta{
                self?.contactUsViewController?.successHandler()
            }
            }, failure: { [weak self] (error) in
                self?.contactUsViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
                print(error.debugDescription)
        })
    }
    
}
