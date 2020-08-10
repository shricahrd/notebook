//
//  ForgetPasswordConfirmationViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/31/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import RxSwift

class ForgetPasswordConfirmationViewModel: NBParentViewModel {
    
    private var loginUseCases: LoginUseCases?
    private weak var forgetPasswordConfirmationViewController: ForgetPasswordConfirmationViewController?
    var code = Variable<String>("")
    var isValidCode: Bool = false
    var newPassword = Variable<String>("")
    var isValidPassword: Bool = false
    var passwordConfirmation = Variable<String>("")
    var isValidPasswordConfirmation: Bool = false
    let disposeBag = DisposeBag()
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        loginUseCases = LoginUseCases()
        forgetPasswordConfirmationViewController = viewController as? ForgetPasswordConfirmationViewController
        
        code.asObservable().subscribe({ [weak self] (code) in
            self?.isValidCode = !(code.element?.isEmpty ?? false)
        }).disposed(by: disposeBag)
        
        newPassword.asObservable().subscribe({ [weak self] (newPassword) in
            self?.isValidPassword = newPassword.element?.isvalidPassword() ?? false
        }).disposed(by: disposeBag)
        
        passwordConfirmation.asObservable().subscribe({ [weak self] (password) in
            self?.isValidPasswordConfirmation = (self?.isValidPassword ?? false) && (password.element == self?.newPassword.value)
        }).disposed(by: disposeBag)
    }
    
    func forgetPassword(withCode code: String, andPassword password: String){
        self.forgetPasswordConfirmationViewController?.showLoadingView()
        loginUseCases?.forgetPassword(withCode: code, andPassword: password, success: { [weak self] data in
            if let _ = data as? RootMeta{
                self?.forgetPasswordConfirmationViewController?.showAlert(withTitle: "", andMessage: "تم التغيير بنجاح")
            }
            self?.forgetPasswordConfirmationViewController?.hideLoadingView()
            }, failure: { [weak self] (error) in
                self?.forgetPasswordConfirmationViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
        })
    }
}
