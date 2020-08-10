//
//  MyBooksUseCases.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

class MyBooksUseCases {
    func fetchUserBooks(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: MyBooksRequests.fetchUserBooks, model: MyBooksResponseModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
}
