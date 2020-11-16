//
//  Requests.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/14/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import Alamofire

enum HomeRequests: Request {
    case fetchHomeData
    case fetchBookDetails(bookId: String?)
    case addToFavourites(bookIds: [Int])
    case fetchAuthorDetails(withAuthorId: String)
    case recommendBook(withBookIds: [Int])
    case adVideo
    case deviceInfo(deviceInfo: DeviceInfoRequestPayload)
    
    var path: String {
        switch self {
        case .fetchHomeData:
            return "home"
        case let .fetchBookDetails(bookId):
            return "books/\(bookId ?? "")"
        case .addToFavourites:
            return "user/favourites"
        case let .fetchAuthorDetails(authorId):
            return "authors/\(authorId)"
        case .recommendBook:
            return "user/recommendations"
        case .adVideo:
            return "video-ad"
        case .deviceInfo:
            return "device"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchHomeData, .fetchBookDetails, .fetchAuthorDetails, .adVideo:
            return .get
        case .addToFavourites, .recommendBook, .deviceInfo:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchHomeData, .fetchBookDetails, .fetchAuthorDetails, .adVideo:
            return nil
        case let .addToFavourites(bookIds: ids):
            return ["book_id": ids]
        case let .recommendBook(withBookIds: ids):
            return ["book_id": ids]
        case let .deviceInfo(deviceInfo: deviceInfo):
            return deviceInfo.parameters
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .fetchAuthorDetails, .adVideo:
            return nil
        case .addToFavourites, .recommendBook, .fetchHomeData, .fetchBookDetails:
            if let token = LocalStore.token(), !token.isEmpty{
                return ["Authorization": "Bearer \(token)"]
            }
            return nil
        case .deviceInfo:
            var dictionary = ["platform": LocalStore.platform() ?? "iOS", "version": LocalStore.appVersion() ?? "1", "Accept": "application/json"]
            if let token = LocalStore.token(), !token.isEmpty{
                dictionary["Authorization"] = "Bearer \(token)"
            }
            return dictionary
        }
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringCacheData
    }
    
    var dataType: DataType {
        return DataType.JSON
    }
}
