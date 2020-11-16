//
//  UseCases.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/14/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

class HomeUseCases {
    func fetchHomeData(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: HomeRequests.fetchHomeData, model: HomeModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func fetchBookDetails(withBookId bookId: String, success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: HomeRequests.fetchBookDetails(bookId: bookId), model: BookDetailsModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func addToFavourites(withBookIds bookIds: [Int], success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: HomeRequests.addToFavourites(bookIds: bookIds), model: BookDetailsModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func fetchAuthorDetails(withAuthorId authorId: String, success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: HomeRequests.fetchAuthorDetails(withAuthorId: authorId), model: AuthorDetailsModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    
    func recommendBooks(withBookIds bookIds: [Int], success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: HomeRequests.recommendBook(withBookIds: bookIds), model: BookDetailsModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func fetchAdVideoURL(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: HomeRequests.adVideo, model: AdVideoResponse(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    var requestBody = NBRequest()
    func deviceInfo(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: HomeRequests.deviceInfo(deviceInfo: requestBody as! DeviceInfoRequestPayload), model: RootMeta(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
}
