//
//  SharedClient.swift
//  notebook
//
//  Created by Abdorahman Youssef on 1/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

final class SharedClient: APIClient {
    
    static let sharedInstance = SharedClient()
    var baseUrl: String = "https://notebooklib.com/v2/public/api/" //"http://admin.notebooklib.com/api/"
    
    private init() {}
    
    var errorModel: Convertable {
        return NBError()
    }
    
    var validStatusCodes: [Int] {
        return Array(200 ..< 300)
    }
    
    var headers: [String: String]? {
        
//        let token = LocalStore.token() == nil ? "" : LocalStore.token()
        
        return ["Content-Type": "application/json"]
        //, "Authorization": "Bearer \(token ?? "")"
    }
    
}
