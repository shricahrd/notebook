//
//  MyBooksRequests.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import Alamofire

enum MyBooksRequests: Request {
    case fetchUserBooks
    
    var path: String {
        switch self {
        case .fetchUserBooks:
            return "user/books"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchUserBooks:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchUserBooks:
            return nil
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchUserBooks:
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
