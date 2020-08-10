//
//  FavouriteBooksRequests.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import Alamofire

enum FavouriteBooksRequests: Request {
    case fetchUserFavouriteBooks
    
    var path: String {
        switch self {
        case .fetchUserFavouriteBooks:
            return "user/favourites"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchUserFavouriteBooks:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchUserFavouriteBooks:
            return nil
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchUserFavouriteBooks:
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
