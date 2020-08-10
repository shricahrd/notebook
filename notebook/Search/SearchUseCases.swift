//
//  SearchUseCases.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/21/19.
//  Copyright © 2019 clueapps. All rights reserved.
//
import Foundation

class SearchUseCases {
    func searchBooks(withKeyword keyword: String?, andGenreId genreId: String?, andAuthorId authorId: String?, success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: SearchingRequests.searchBooks(keyword: keyword, genreId: genreId, authorId: authorId), model: SearchingResponseModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
    
    func fetchGenres(success: @escaping Success, failure: @escaping Failure) {
        SharedClient.sharedInstance.start(request: SearchingRequests.genres, model: GenresResponseModel(), success: { data in
            success(data)
        }, failure: { error in
            failure(error)
        })
    }
}
