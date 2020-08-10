//
//  LoginViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/6/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModel: NBParentViewModel {
    
    private var loginUseCases: LoginUseCases?
    private weak var loginViewController: LoginViewController?
    var disposeBag = DisposeBag()
    var mobileNumber = Variable<String>("")
    var password = Variable<String>("")
    var isValidMobileNumber: Bool = false
    var isValidPassword: Bool = false
    var deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "defaultId"
    var deviceModel = UIDevice.current.model
    var firebaseToken = LocalStore.fcmToken()
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        loginUseCases = LoginUseCases()
        loginViewController = viewController as? LoginViewController
        mobileNumber.asObservable().subscribe({ [weak self] (mobile) in
            self?.isValidMobileNumber = mobile.element?.isvalidMobileNumber() ?? false
        }).disposed(by: disposeBag)
        
        password.asObservable().subscribe({ [weak self] (password) in
            self?.isValidPassword = (password.element?.isvalidPassword() ?? false)
        }).disposed(by: disposeBag)
    }
    
    func login(withMobileNumber mobileNumber: String, andPassword password: String){
        self.loginViewController?.showLoadingView()
        let loginRequest = LoginRequestPayload(mobileNumber: mobileNumber, password: password, deviceId: deviceId, deviceModel: deviceModel, firebaseToken: firebaseToken)
        loginUseCases?.requestBody = loginRequest
        loginUseCases?.login(success: { [weak self] data in
            self?.loginViewController?.hideLoadingView()
            print("login success")
            self?.loginViewController?.loginButton.isEnabled = true
            if let data = data as? LoginResponse{
                LocalStore.save(token: data.data?.token ?? "")
                LocalStore.save(email: data.data?.email ?? "")
                LocalStore.save(username: data.data?.fullName ?? "")
                LocalStore.save(phoneNumber: data.data?.mobileNumber ?? "")
                LocalStore.save(gender: data.data?.gender ?? "")
                LocalStore.save(birthdate: data.data?.birthDate ?? "")
                
                if let userId = data.data?.id{
                    LocalStore.save(id: String(userId))
                }
                self?.loginViewController?.goToHome()
            }
            }, failure: { [weak self] (error) in
                self?.loginViewController?.hideLoadingView()
                self?.loginViewController?.loginButton.isEnabled = true
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
                print(error.debugDescription)
        })
    }
    
    func countryCodez(){
        self.loginViewController?.showLoadingView()
       
        loginUseCases?.CountryCode2(success: { [weak self] data in
            self?.loginViewController?.hideLoadingView()
            print(" success   \(data)")
            }, failure: { [weak self] (error) in
                self?.loginViewController?.hideLoadingView()
                print(error.debugDescription)
        })
    }
    
}
