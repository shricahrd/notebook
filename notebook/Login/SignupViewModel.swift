//
//  signupViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/25/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import RxSwift

class SignupViewModel: NBParentViewModel {
    
    private var loginUseCases: LoginUseCases?
    private weak var signupViewController: SignupViewController?
    var disposeBag = DisposeBag()
    
    var username = Variable<String>("")
    var gender = Variable<String>("")
    var birthDate = Variable<String>("")
    var mobileNumber = Variable<String>("")
    var email = Variable<String>("")
    var password = Variable<String>("")
    var confirmPassword = Variable<String>("")
    var isValidMobileNumber: Bool = false
    var isValidGender: Bool = false
    var isValidBirthDate: Bool = false
    var isValidEmail: Bool = false
    var isValidPassword: Bool = false
    var isValidConfirmPassword: Bool = false
    var isPasswordAndConfirmPasswordIdentical: Bool = false
    var isValidUsername: Bool = false
    
    var deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "defaultId"
    var deviceModel = UIDevice.current.model
    var firebaseToken = LocalStore.fcmToken()
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        loginUseCases = LoginUseCases()
        signupViewController = viewController as? SignupViewController
        mobileNumber.asObservable().subscribe({ [weak self] (mobile) in
            self?.isValidMobileNumber = mobile.element?.isvalidMobileNumber() ?? false
        }).disposed(by: disposeBag)
        
        password.asObservable().subscribe({ [weak self] (password) in
            self?.isValidPassword = (password.element?.isvalidPassword() ?? false)
            print("password.asObservable()")
        }).disposed(by: disposeBag)
        
        confirmPassword.asObservable().subscribe({ [weak self] (confirmPassword) in
            self?.isValidConfirmPassword = (confirmPassword.element?.isvalidPassword() ?? false)
            self?.isPasswordAndConfirmPasswordIdentical = (self?.confirmPassword.value == self?.password.value)
            print("confirmPassword.asObservable()")
        }).disposed(by: disposeBag)
        
        username.asObservable().subscribe({ [weak self] (username) in
            self?.isValidUsername = !(username.element?.isEmpty ?? false)
        }).disposed(by: disposeBag)
        
        gender.asObservable().subscribe({ [weak self] (gender) in
            self?.isValidGender = !(gender.element?.isEmpty ?? false)
        }).disposed(by: disposeBag)
        
        birthDate.asObservable().subscribe({ [weak self] (birthDate) in
            self?.isValidBirthDate = !(birthDate.element?.isEmpty ?? false)
        }).disposed(by: disposeBag)
        
        email.asObservable().subscribe({ [weak self] (email) in
            self?.isValidEmail = (email.element?.isValidEmail() ?? false)
        }).disposed(by: disposeBag)
    }
    
    func signup(withUsername username: String, andGender gender: String, andMobileNumber mobileNumber: String, andEmail email: String, andBirthDate birthDate: String, andPassword password: String){
        self.signupViewController?.showLoadingView()
        var genderValue = ""
        if gender == signupViewController?.genderPickerData.first {
            genderValue = "male"
        }
        if gender == signupViewController?.genderPickerData[1] {
            genderValue = "female"
        }
//        let genderValue = (gender == signupViewController?.genderPickerData.first ? "male" : "female")
        let signupRequest = SignupRequestPayload(fullName: username, gender: genderValue, mobileNumber: mobileNumber, email: email, birthDate: birthDate, password: password, deviceId: deviceId, deviceModel: deviceModel, firebaseToken: firebaseToken)
        loginUseCases?.requestBody = signupRequest
        loginUseCases?.signup(success: { [weak self] data in
            self?.signupViewController?.hideLoadingView()
            print("login success")
            self?.signupViewController?.signupButton.isEnabled = true
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
                self?.signupViewController?.gotoInterests()
            }
            }, failure: { [weak self] (error) in
                self?.signupViewController?.hideLoadingView()
                self?.signupViewController?.signupButton.isEnabled = true
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
                print(error.debugDescription)
        })
    }
    
}
