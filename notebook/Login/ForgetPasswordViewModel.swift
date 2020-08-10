//
//  ForgetPasswordViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/31/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import RxSwift

class ForgetPasswordViewModel: NBParentViewModel {
    
    private var loginUseCases: LoginUseCases?
    private weak var forgetPasswordViewController: ForgetPasswordViewController?
    var email = Variable<String>("")
    var isValidEmail: Bool = false
    let disposeBag = DisposeBag()
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        loginUseCases = LoginUseCases()
        forgetPasswordViewController = viewController as? ForgetPasswordViewController
        
        email.asObservable().subscribe({ [weak self] (email) in
            self?.isValidEmail = email.element?.isValidEmail() ?? false
        }).disposed(by: disposeBag)
    }
    
    func forgetPassword(withEmail email: String){
        self.forgetPasswordViewController?.showLoadingView()
        loginUseCases?.forgetPassword(ofEmail: email, success: { [weak self] data in
            if let _ = data as? RootMeta{
                self?.forgetPasswordViewController?.gotoForgetPasswordConfirmation()
            }
            self?.forgetPasswordViewController?.hideLoadingView()
            }, failure: { [weak self] (error) in
                self?.forgetPasswordViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
        })
    }
}
