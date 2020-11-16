//
//  EditProfileViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import RxSwift

class EditProfileViewModel: NBParentViewModel {
    
    private var moreUseCases: MoreUseCases?
    private weak var editProfileViewController: EditProfileViewController?
    
    var userName = Variable<String>("")
    var birthDate = Variable<String>("")
    var gender = Variable<String>("")
    var mobileNumber = Variable<String>("")
    var countryCode = Variable<String>("")
    var email = Variable<String>("")
    
    var isValidUserName: Bool = false
    var isValidBirthDate: Bool = false
    var isValidGender: Bool = false
    var isValidEmail: Bool = false
    var isValidMobileNumber: Bool = false
    
    let disposeBag = DisposeBag()
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        moreUseCases = MoreUseCases()
        editProfileViewController = viewController as? EditProfileViewController
        
        userName.asObservable().subscribe({ [weak self] (userName) in
            self?.isValidUserName = !(userName.element?.isEmpty ?? false)
        }).disposed(by: disposeBag)
        
        birthDate.asObservable().subscribe({ [weak self] (birthDate) in
            self?.isValidBirthDate = !(birthDate.element?.isEmpty ?? false)
        }).disposed(by: disposeBag)
        
        gender.asObservable().subscribe({ [weak self] (gender) in
            self?.isValidGender = !(gender.element?.isEmpty ?? false)
        }).disposed(by: disposeBag)
        
        mobileNumber.asObservable().subscribe({ [weak self] (mobile) in
            self?.isValidMobileNumber = mobile.element?.isvalidMobileNumber() ?? false
        }).disposed(by: disposeBag)
        
        email.asObservable().subscribe({ [weak self] (email) in
            self?.isValidEmail = email.element?.isValidEmail() ?? false
        }).disposed(by: disposeBag)
    }
    
    func editProfile(withUsername username: String, andGender gender: String, andMobileNumber mobileNumber: String, andEmail email: String, andBirthDate birthDate: String){
        self.editProfileViewController?.showLoadingView()
        // TODO: add the new parameters.
        let genderValue = (gender == editProfileViewController?.genderPickerData.first ? "male" : "female")
        let editProfileRequest = EditProfileRequestPayload(mobileNumber: mobileNumber, gender: genderValue, fullname: username, email: email, birthDate: birthDate)
        
        moreUseCases?.requestBody = editProfileRequest
        moreUseCases?.updateProfile(success: { [weak self] data in
            self?.editProfileViewController?.hideLoadingView()
            if let data = data as? EditProfileResponse{
                LocalStore.save(email: data.userInfo?.email ?? "")
                LocalStore.save(phoneNumber: data.userInfo?.mobileNumber ?? "")
                LocalStore.save(username: data.userInfo?.fullName ?? "")
                LocalStore.save(gender: data.userInfo?.gender ?? "")
                LocalStore.save(birthdate: data.userInfo?.birthDate ?? "")
                
                self?.editProfileViewController?.showAlert(withTitle: "", andMessage: "تم الحفظ بنجاح")
            }
            }, failure: { [weak self] (error) in
                self?.editProfileViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
        })
    }
}
