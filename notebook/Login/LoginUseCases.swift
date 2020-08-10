//
//  LoginUseCases.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/6/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

class LoginUseCases {
    var requestBody = NBRequest()
    
    func login(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: LoginRequests.login(loginRequestPayload: requestBody as! LoginRequestPayload), model: LoginResponse(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func signup(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: LoginRequests.signup(signupRequestPayload: requestBody as! SignupRequestPayload), model: LoginResponse(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func updateUserGenres(withGenresIds genresIds: [Int], success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: LoginRequests.updateUserGenres(genresIds: genresIds), model: GenresResponseModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func fetchUserGenres(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: LoginRequests.fetchUserGenres, model: GenresResponseModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func forgetPassword(ofEmail email: String, success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: LoginRequests.forgetPassword(email: email), model: RootMeta(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func forgetPassword(withCode code: String, andPassword password: String, success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: LoginRequests.forgetPasswordConfirmation(code: code, password: password), model: RootMeta(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func CountryCode2(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: LoginRequests.CountryCode2, model: CountryCodez(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
}
