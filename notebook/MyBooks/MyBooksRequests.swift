//
//  MyBooksRequests.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum MyBooksRequests: Request {
    case fetchUserBooks(paginator: Map?)
    
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
        case let .fetchUserBooks(paginator: paginator):
            print("parameters :- \(paginator?.JSON["limit"])")
            return ["limit": paginator?.JSON["limit"] ?? 20,
                    "next": paginator?.JSON["next"] ?? 0,
                    "page": paginator?.JSON["page"] ?? 1,
                    "prev": paginator?.JSON["prev"] ?? 0,
                    "total": paginator?.JSON["total"] ?? 20
            ]
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
