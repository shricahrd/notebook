//
//  MoreUseCases.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

class MoreUseCases {
    func logout(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: MoreRequests.logout, model: LogoutModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    var requestBody = NBRequest()
    
    func contactUs(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: MoreRequests.contactUs(contactUsRequestPayload: requestBody as! ContactUsRequestPayload), model: RootMeta(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func updateProfile(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: MoreRequests.updateProfile(editProfileRequestPayload: requestBody as! EditProfileRequestPayload), model: EditProfileResponse(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func changePassword(withOldPass oldPass: String, andNewPass newPass: String, success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: MoreRequests.changePassword(oldPass: oldPass, newPass: newPass), model: RootMeta(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func fetchAddress( success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: MoreRequests.fetchAddress, model: UserAddressResponse(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func fetchCountryCodes( success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: MoreRequests.fetchCountries, model: CountriesModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func fetchAreas(withCountryCode code: String, success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: MoreRequests.fetchAreas(byCountryCode: code), model: AreasModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func createAdderss(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: MoreRequests.createAddress(addressRequestPayload: requestBody as! UpsertAddressRequestPayload), model: UpsertUserAddressResponse(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func updateAdderss(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: MoreRequests.updateAddress(addressRequestPayload: requestBody as! UpsertAddressRequestPayload), model: UpsertUserAddressResponse(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func purchaseBook(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: MoreRequests.purchaseBook(purchaseBookRequestPayload: requestBody as! PurchaseBookRequestPayload), model: PurchaseBookResponse(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
}
