//
//  NBError.swift
//  notebook
//
//  Created by Abdorahman Youssef on 1/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper
import Log

protocol Convertable: Mappable {
    func convert(message: String?, statusCode: NSInteger?, errorModel: Mappable?) -> Error
    func convertPayload(withData data: Data?) -> Mappable?
}

enum NBErrorCase: Error {
    case sessionExpired(message: String?, code: Int?, errorModel: Mappable?)
    case loadingErrorGeneric(message: String?, code: Int?, errorModel: Mappable?)
    case noInternetConnection
    case unauthorized
    case irrecoverable(message: String?, code: Int?, errorModel: Mappable?)
    case genericError
    case notFound
    case unprocessableEntity(message: String?, code: Int?, errorModel: Mappable?)
    case internalServerError
    case gone(message: String?, code: Int?, errorModel: Mappable?)
}

enum StatusErrorCode: Int {
    case timeOut = 504
    case irrecoverable = 999
    case generic = 400
    case loadingTimeOut = 666
    case networkTimeOut = 408
    case forbidden = 403
    case internalServerError = 500
    case unauthorized = 401
    case notFound = 404
    case unprocessableEntity = 422
    case gone = 410
}

class NBError: Convertable {
    
    var errorMessage: String?
    var errorCode: String?
    var errors: [String: Any]?
    var meta: RootMeta?

    
    required init?(map: Map) {
        errorMessage <- map["message"]
        errorCode <- map["code"]
        errors <- map["errors"]
        meta <- map["meta"]
    }
    
    init() {}
    func mapping(map: Map) {}
    
    func convert(message: String?, statusCode: NSInteger?, errorModel: Mappable?) -> Error {

        var error: NBErrorCase?
        Logger().debug("Error Code:\(statusCode ?? -999)\n\(message ?? "default message")\n\(self)")
        
        NSLogv("Error Status:- %@   ErrorMessage:- %@  description:- %@", getVaList([String(describing: statusCode).replacingOccurrences(of: "\n", with: " ") , String(describing: message).replacingOccurrences(of: "\n", with: " ") , String(describing: self).replacingOccurrences(of: "\n", with: " ") ]))
        
        if statusCode == StatusErrorCode.generic.rawValue {
            guard errorModel != nil else {
                error = .irrecoverable(message: nil, code: nil, errorModel: nil)
                return error!
            }
            error = .genericError
        } else if statusCode == StatusErrorCode.unprocessableEntity.rawValue{
            error = .unprocessableEntity(message: message, code: statusCode, errorModel: errorModel)
        }else {
            error = sessionConvertedError(message: message, statusCode: statusCode, errorModel: errorModel)
        }
        
        return error ?? NBErrorCase.irrecoverable(message: nil, code: nil, errorModel: nil)
    }
    
    func sessionConvertedError(message: String?, statusCode: NSInteger?, errorModel: Mappable?) -> NBErrorCase? {
        
        var error: NBErrorCase?
        switch statusCode {
        case StatusErrorCode.forbidden.rawValue, StatusErrorCode.timeOut.rawValue, StatusErrorCode.loadingTimeOut.rawValue, StatusErrorCode.networkTimeOut.rawValue, NSURLErrorTimedOut:
            error = .sessionExpired(message: message, code: statusCode, errorModel: errorModel)
            
        case StatusErrorCode.irrecoverable.rawValue:
            error = .irrecoverable(message: message, code: statusCode, errorModel: errorModel)
        case StatusErrorCode.unauthorized.rawValue:
            error = .unauthorized
        case StatusErrorCode.notFound.rawValue:
            error = .notFound
        case StatusErrorCode.internalServerError.rawValue:
            error = .internalServerError
        case StatusErrorCode.gone.rawValue:
            error = .gone(message: message, code: statusCode, errorModel: errorModel)
        default:
            error = .irrecoverable(message: message, code: statusCode, errorModel: errorModel)
        }
        return error
    }
    
    func convertPayload(withData data: Data?) -> Mappable? {
        if let usableData = data {
            if let json = try? JSONSerialization.jsonObject(with: usableData, options: .mutableContainers) as? [String: Any]{
                guard let json = json as? [String : Any] else {
                    return nil
                }
                let mappedError = Mapper<NBError>().map(JSON: json)
                Logger().debug("Error model: \(json)\n")
                return mappedError
            }
            
        }
        return nil
    }
    
    
}

