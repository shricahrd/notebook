//
//  LoginRequests.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/6/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import Alamofire

enum LoginRequests: Request {
    case login(loginRequestPayload: LoginRequestPayload)
    case signup(signupRequestPayload: SignupRequestPayload)
    case updateUserGenres(genresIds: [Int])
    case fetchUserGenres
    case forgetPassword(email: String)
    case forgetPasswordConfirmation(code: String, password: String)
    case CountryCode2
    
    var path: String {
        switch self {
        case .login:
            return "signin"
        case .signup:
            return "signup"
        case .updateUserGenres, .fetchUserGenres:
            return "user/genres"
        case .forgetPassword, .forgetPasswordConfirmation:
            return "forget-password"
        case .CountryCode2:
            return "countries"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .signup, .updateUserGenres, .forgetPassword:
            return .post
        case .fetchUserGenres:
            return .get
        case .forgetPasswordConfirmation:
            return .put
        case .CountryCode2:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .login(loginRequestPayload):
            return loginRequestPayload.parameters
        case let .signup(signupRequestPayload):
            return signupRequestPayload.parameters
        case let .updateUserGenres(genresIds: ids):
            return ["genre_id": ids]
        case .fetchUserGenres,.CountryCode2:
            return nil
        case let .forgetPassword(email: email):
            return ["email": email]
        case let .forgetPasswordConfirmation(code: code, password: pass):
            return ["code": code, "password": pass]
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .login, .signup:
            var dictionary = ["platform": LocalStore.platform() ?? "iOS", "version": LocalStore.appVersion() ?? "1", "Accept": "application/json", "X-Requested-With": "XMLHttpRequest"]
            if let token = LocalStore.token(), !token.isEmpty{
                dictionary["Authorization"] = "Bearer \(token)"
            }
            return dictionary
        case .updateUserGenres, .fetchUserGenres:
            if let token = LocalStore.token(), !token.isEmpty{
                return ["Authorization": "Bearer \(token)"]
            }
            return nil
        case .forgetPassword, .forgetPasswordConfirmation,.CountryCode2:
            return nil
        }
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringCacheData
    }
    
    var dataType: DataType {
        return DataType.JSON
    }
}
