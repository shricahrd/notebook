//
//  MyBooksUseCases.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper

class MyBooksUseCases {
    func fetchUserBooks(paginator: Map?, success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: MyBooksRequests.fetchUserBooks(paginator: paginator), model: MyBooksResponseModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
}
