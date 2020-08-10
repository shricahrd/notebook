//
//  MyBooksArchiver.swift
//  notebook
//
//  Created by hesham ghalaab on 7/17/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

struct MyBooksArchiver {
    
    func save(myBooks: [AdBook]?){
        guard let myBooks = myBooks else {return}
        let archivedAdBooks = remodel(myBooks: myBooks)
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: archivedAdBooks)
        userDefaults.set(encodedData, forKey: "archivedAdBooks")
        userDefaults.synchronize()
    }
    
    func clear(){
         UserDefaults.standard.removeObject(forKey: "archivedAdBooks")
    }
    
    func getMyBooksResponseModel() -> [AdBook] {
        let userDefaults = UserDefaults.standard
        if let decoded = userDefaults.data(forKey: "archivedAdBooks"){
            // let json = try JSONSerialization.jsonObject(with: decoded, options: []) as? [String : Any]
            let decodedBooks = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [ArchivedAdBook]
            let books = remodel(myArchivedAdBook: decodedBooks)
            return books
        }else{
            print("cannot find books saved locally.")
            return []
        }
    }
    
    private func remodel(myBooks: [AdBook]) -> [ArchivedAdBook]{
        var archivedAdBooks = [ArchivedAdBook]()
        for book in myBooks{
            let genre = ArchivedGenre(id: book.genre?.id, name: book.genre?.name)
            var authors: [ArchivedAuthor]?
            var quotes: [ArchivedQuote]?
            
            if let _authors = book.authors{
                for author in _authors{
                    authors?.append(ArchivedAuthor(avatar: author.avatar,
                                                   bio: author.bio, id: author.id,
                                                   name: author.name))
                }
            }
            if let _quotes = book.quotes{
                for quote in _quotes{
                    quotes?.append(ArchivedQuote(id: quote.id, body: quote.body, bookId: quote.bookId))
                }
            }
            
            let archivedAdBook = ArchivedAdBook(authors: authors, bothPrice: book.bothPrice, cover: book.cover, createdAt: book.createdAt, descriptionField: book.descriptionField, favouritesCount: book.favouritesCount, genre: genre, giftCount: book.giftCount, id: book.id, isFavourite: book.isFavourite, isFeatured: book.isFeatured, isPurchased: book.isPurchased, listenLink: book.listenLink, listenPrice: book.listenPrice, name: book.name, purchaseType: book.purchaseType, quotes: quotes, readLink: book.readLink, readPrice: book.readPrice, printedPrice: book.printedPrice, recommendationsCount: book.recommendationsCount, isWriter: book.isWriter, isRecomended: book.isRecomended, code: book.code, readCode: book.readCode, listenCode: book.listenCode)
            
            archivedAdBooks.append(archivedAdBook)
        }
        return archivedAdBooks
    }
    
    private func remodel(myArchivedAdBook: [ArchivedAdBook]) -> [AdBook]{
        var myBooks = [AdBook]()
        
        for book in myArchivedAdBook{
            let genre: [String: Any] = ["id": book.genre?.id, "name": book.genre?.name]
            var authors: [[String : Any]]? = []
            var quotes: [[String: Any]]? = []
            
            if let _authors = book.authors{
                for author in _authors{
                    let value: [String: Any] = ["avatar": author.avatar, "bio": author.bio,
                                                "id": author.id, "name": author.name]
                    authors?.append(value)
                }
            }
            if let _quotes = book.quotes{
                for quote in _quotes{
                    let value: [String: Any] = ["id": quote.id, "body": quote.body, "book_id": quote.bookId]
                    quotes?.append(value)
                }
            }
            
            let json: [String: Any] = ["authors" : authors, "both_price" : book.bothPrice , "cover" : book.cover , "created_at" : book.createdAt , "description" : book.descriptionField , "favourites_count" : book.favouritesCount , "genre" : genre , "gift_count" : book.giftCount , "id" : book.id , "is_favourite" : book.isFavourite , "is_featured" : book.isFeatured , "is_purchased" : book.isPurchased , "listen_link" : book.listenLink , "listen_price" : book.listenPrice , "name" : book.name , "purchase_type" : book.purchaseType , "quotes" : quotes, "read_link" : book.readLink , "read_price" : book.readPrice , "printed_price" : book.printedPrice , "recommendations_count" : book.recommendationsCount, "is_writer": book.isWriter , "is_recomended": book.isRecomended , "code": book.code , "read_code": book.readCode , "listen_code": book.listenCode]
            
            if let myBook = AdBook(JSON: json){
                myBooks.append(myBook)
            }
        }
        
        return myBooks
    }
    
    
}
