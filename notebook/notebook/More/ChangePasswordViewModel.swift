//
//  ChangePasswordViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/30/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import RxSwift

class ChangePasswordViewModel: NBParentViewModel {
    
    private var moreUseCases: MoreUseCases?
    private weak var changePasswordViewController: ChangePasswordViewController?
    
    var oldPassword = Variable<String>("")
    var isValidOldPassword: Bool = false
    var newPassword = Variable<String>("")
    var isValidNewPassword: Bool = false
    var newPasswordConfirmation = Variable<String>("")
    var isValidNewPasswordConfirmation: Bool = false
    let disposeBag = DisposeBag()
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        moreUseCases = MoreUseCases()
        changePasswordViewController = viewController as? ChangePasswordViewController
        
        oldPassword.asObservable().subscribe({ [weak self] (password) in
            self?.isValidOldPassword = password.element?.isvalidPassword() ?? false
        }).disposed(by: disposeBag)
        
        newPassword.asObservable().subscribe({ [weak self] (password) in
            self?.isValidNewPassword = (password.element?.isvalidPassword() ?? false) && (password.element != self?.oldPassword.value)
        }).disposed(by: disposeBag)
        
        newPasswordConfirmation.asObservable().subscribe({ [weak self] (password) in
            self?.isValidNewPasswordConfirmation = (self?.isValidNewPassword ?? false) && (password.element == self?.newPassword.value)
        }).disposed(by: disposeBag)
    }
    
    func changePassword(withOldPassword oldPassword: String, andNewPassword newPassword: String){
        self.changePasswordViewController?.showLoadingView()
        moreUseCases?.changePassword(withOldPass: oldPassword, andNewPass: newPassword, success: { [weak self] data in
            self?.changePasswordViewController?.hideLoadingView()
            if let _ = data as? RootMeta{
                self?.changePasswordViewController?.showAlert(withTitle: "", andMessage: "تم التعديل بنجاح", completion: { (action) in
                    self?.changePasswordViewController?.navigationController?.popViewController(animated: true)
                })
            }
            }, failure: { [weak self] (error) in
                self?.changePasswordViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    switch error{
                    case .unprocessableEntity:
                        self?.changePasswordViewController?.handleWrongOldPasswordEntry()
                    default:
                        self?.handleGenericErrors(error: error)
                    }
                }
        })
    }
}
