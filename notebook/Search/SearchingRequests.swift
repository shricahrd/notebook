//
//  SearchingRequests.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/21/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import Alamofire

enum SearchingRequests: Request {
    case searchBooks(keyword: String?, genreId: String?, authorId: String?)
    case genres
    
    var path: String {
        switch self {
        case .searchBooks:
            return "books"
        case .genres:
            return "genres"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .searchBooks, .genres:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .searchBooks(keyword: keyword, genreId: genreId, authorId: authorId):
            return ["keyword": keyword ?? "", "genre_id" : genreId ?? "", "author_id": authorId ?? ""]
        case .genres:
            return nil
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .searchBooks, .genres:
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
