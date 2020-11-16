//
//  FavouriteBooksUseCases.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

class FavouriteBooksUseCases {
    func fetchUserFavouriteBooks(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: FavouriteBooksRequests.fetchUserFavouriteBooks, model: UserFavouriteBooksResponseModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
}
