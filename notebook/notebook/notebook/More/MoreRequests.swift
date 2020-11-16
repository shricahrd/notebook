//
//  MoreRequests.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import Alamofire

var deviceId = UIDevice.current.identifierForVendor?.uuidString ?? "defaultId"
var deviceModel = UIDevice.current.model

enum MoreRequests: Request {
    case logout
    case contactUs(contactUsRequestPayload: NBRequest)
    case updateProfile(editProfileRequestPayload: NBRequest)
    case changePassword(oldPass: String, newPass: String)
    case fetchAddress
    case fetchCountries
    case fetchAreas(byCountryCode: String)
    case createAddress(addressRequestPayload: NBRequest)
    case updateAddress(addressRequestPayload: NBRequest)
    case purchaseBook(purchaseBookRequestPayload: NBRequest)
    
    var path: String {
        switch self {
        case .logout:
            return "signout"
        case .contactUs:
            return "contact"
        case .updateProfile:
            return "user"
        case .changePassword:
            return "reset-password"
        case .fetchAddress:
            return "user/address"
        case .fetchCountries:
            return "country"
        case let .fetchAreas(byCountryCode: code):
            return "area?code=\(code)"
        case .createAddress, .updateAddress:
            return "user/address"
        case .purchaseBook:
            return "purchases/create"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .logout, .contactUs, .createAddress, .purchaseBook:
            return .post
        case .updateProfile, .changePassword, .updateAddress:
            return .put
        case .fetchAddress, .fetchCountries, .fetchAreas:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .logout:
            return ["device_id": deviceId,"device_model": deviceModel]
        case let .contactUs(contactUsRequestPayload: request):
            return request.parameters
        case let .updateProfile(editProfileRequestPayload: request):
            return request.parameters
        case let .changePassword(old,new):
            return ["current_password": old, "password": new]
        case .fetchAddress, .fetchCountries, .fetchAreas:
            return nil
        case let .createAddress(addressRequestPayload: request):
            return request.parameters
        case let .updateAddress(addressRequestPayload: request):
            return request.parameters
        case let .purchaseBook(purchaseBookRequestPayload: request):
            return request.parameters
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .logout:
            if let token = LocalStore.token(), !token.isEmpty{
                return ["Authorization": "Bearer \(token)", "platform": LocalStore.platform() ?? "iOS", "version": LocalStore.appVersion() ?? "1"]
            }
            return nil
        case .contactUs, .fetchCountries, .fetchAreas:
            return nil
        case .updateProfile, .changePassword, .fetchAddress, .createAddress, .updateAddress, .purchaseBook:
            if let token = LocalStore.token(), !token.isEmpty{
                return ["Authorization": "Bearer \(token)"]
            }
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
