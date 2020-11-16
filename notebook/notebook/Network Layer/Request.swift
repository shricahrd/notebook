//
//  Request.swift
//  notebook
//
//  Created by Abdorahman Youssef on 1/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Alamofire
import Foundation

public enum DataType {
    case JSON
    case data
}

public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var dataType: DataType { get }
}

import ObjectMapper

class NBRequest: Mappable {
    var parameters: [String: Any]?
    
    init() {
        parameters = [:]
    }
    
    required init?(map: Map) {
        parameters = [:]
    }
    
    func mapping(map: Map) {
        
    }
}
