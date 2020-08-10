//
//  ArchivedAdBook.swift
//  notebook
//
//  Created by hesham ghalaab on 7/17/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class ArchivedAdBook: NSObject , NSCoding{
    
    var authors : [ArchivedAuthor]?
    var bothPrice : Float?
    var cover : String?
    var createdAt : String?
    var descriptionField : String?
    var favouritesCount : Int?
    var genre : ArchivedGenre?
    var giftCount : Int?
    var id : Int?
    var isFavourite : Bool?
    var isFeatured : Int?
    var isPurchased : Bool?
    var listenLink : String?
    var listenPrice : Float?
    var name : String?
    var purchaseType : String?
    var quotes : [ArchivedQuote]?
    var readLink : String?
    var readPrice : Float?
    var printedPrice : Float?
    var recommendationsCount : Int?
    var isWriter: Bool?
    var isRecomended: Bool?
    var code: String?
    var readCode: String?
    var listenCode: String?
    
    init(authors : [ArchivedAuthor]? ,bothPrice : Float? ,cover : String? ,createdAt : String? ,descriptionField : String? ,favouritesCount : Int? ,genre : ArchivedGenre? ,giftCount : Int? ,id : Int? ,isFavourite : Bool? ,isFeatured : Int? ,isPurchased : Bool? ,listenLink : String? ,listenPrice : Float? ,name : String? ,purchaseType : String? ,quotes : [ArchivedQuote]? ,readLink : String? ,readPrice : Float? ,printedPrice : Float? ,recommendationsCount : Int? ,isWriter: Bool? ,isRecomended: Bool? ,code: String? ,readCode: String? ,listenCode: String?) {
        
        self.authors = authors
        self.bothPrice = bothPrice
        self.cover = cover
        self.createdAt = createdAt
        self.descriptionField = descriptionField
        self.favouritesCount = favouritesCount
        self.genre = genre
        self.giftCount = giftCount
        self.id = id
        self.isFavourite = isFavourite
        self.isFeatured = isFeatured
        self.isPurchased = isPurchased
        self.listenLink = listenLink
        self.listenPrice = listenPrice
        self.name = name
        self.purchaseType = purchaseType
        self.quotes = quotes
        self.readLink = readLink
        self.readPrice = readPrice
        self.printedPrice = printedPrice
        self.recommendationsCount = recommendationsCount
        self.isWriter = isWriter
        self.isRecomended = isRecomended
        self.code = code
        self.readCode = readCode
        self.listenCode = listenCode
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let authors = aDecoder.decodeObject(forKey: "AdBookAuthors") as? [ArchivedAuthor]
        let bothPrice = aDecoder.decodeObject(forKey: "AdBookBothPrice") as? Float
        let cover = aDecoder.decodeObject(forKey: "AdBookCover") as? String
        let createdAt = aDecoder.decodeObject(forKey: "AdBookCreatedAt") as? String
        let descriptionField = aDecoder.decodeObject(forKey: "AdBookDescriptionField") as? String
        let favouritesCount = aDecoder.decodeObject(forKey: "AdBookFavouritesCount") as? Int
        let genre = aDecoder.decodeObject(forKey: "AdBookGenre") as? ArchivedGenre
        let giftCount = aDecoder.decodeObject(forKey: "AdBookGiftCount") as? Int
        let id = aDecoder.decodeObject(forKey: "AdBookId") as? Int
        let isFavourite = aDecoder.decodeObject(forKey: "AdBookIsFavourite") as? Bool
        let isFeatured = aDecoder.decodeObject(forKey: "AdBookIsFeatured") as? Int
        let isPurchased = aDecoder.decodeObject(forKey: "AdBookIsPurchased") as? Bool
        let listenLink = aDecoder.decodeObject(forKey: "AdBookListenLink") as? String
        let listenPrice = aDecoder.decodeObject(forKey: "AdBookListenPrice") as? Float
        let name = aDecoder.decodeObject(forKey: "AdBookName") as? String
        let purchaseType = aDecoder.decodeObject(forKey: "AdBookPurchaseType") as? String
        let quotes = aDecoder.decodeObject(forKey: "AdBookQuotes") as? [ArchivedQuote]
        let readLink = aDecoder.decodeObject(forKey: "AdBookReadLink") as? String
        let readPrice = aDecoder.decodeObject(forKey: "AdBookReadPrice") as? Float
        let printedPrice = aDecoder.decodeObject(forKey: "AdBookPrintedPrice") as? Float
        let recommendationsCount = aDecoder.decodeObject(forKey: "AdBookRecommendationsCount") as? Int
        let isWriter = aDecoder.decodeObject(forKey: "AdBookIsWriter") as? Bool
        let isRecomended = aDecoder.decodeObject(forKey: "AdBookIsRecomended") as? Bool
        let code = aDecoder.decodeObject(forKey: "AdBookCode") as? String
        let readCode = aDecoder.decodeObject(forKey: "AdBookReadCode") as? String
        let listenCode = aDecoder.decodeObject(forKey: "AdBookListenCode") as? String
        self.init(authors: authors, bothPrice: bothPrice, cover: cover, createdAt: createdAt, descriptionField: descriptionField, favouritesCount: favouritesCount, genre: genre, giftCount: giftCount, id: id, isFavourite: isFavourite, isFeatured: isFeatured, isPurchased: isPurchased, listenLink: listenLink, listenPrice: listenPrice, name: name, purchaseType: purchaseType, quotes: quotes, readLink: readLink, readPrice: readPrice, printedPrice: printedPrice, recommendationsCount: recommendationsCount, isWriter: isWriter, isRecomended: isRecomended, code: code, readCode: readCode, listenCode: listenCode)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(authors, forKey: "AdBookAuthors")
        aCoder.encode(bothPrice, forKey: "AdBookBothPrice")
        aCoder.encode(cover, forKey: "AdBookCover")
        aCoder.encode(createdAt, forKey: "AdBookCreatedAt")
        aCoder.encode(descriptionField, forKey: "AdBookDescriptionField")
        aCoder.encode(favouritesCount, forKey: "AdBookFavouritesCount")
        aCoder.encode(genre, forKey: "AdBookGenre")
        aCoder.encode(giftCount, forKey: "AdBookGiftCount")
        aCoder.encode(id, forKey: "AdBookId")
        aCoder.encode(isFavourite, forKey: "AdBookIsFavourite")
        aCoder.encode(isFeatured, forKey: "AdBookIsFeatured")
        aCoder.encode(isPurchased, forKey: "AdBookIsPurchased")
        aCoder.encode(listenLink, forKey: "AdBookListenLink")
        aCoder.encode(listenPrice, forKey: "AdBookListenPrice")
        aCoder.encode(name, forKey: "AdBookName")
        aCoder.encode(purchaseType, forKey: "AdBookPurchaseType")
        aCoder.encode(quotes, forKey: "AdBookQuotes")
        aCoder.encode(readLink, forKey: "AdBookReadLink")
        aCoder.encode(readPrice, forKey: "AdBookReadPrice")
        aCoder.encode(printedPrice, forKey: "AdBookPrintedPrice")
        aCoder.encode(recommendationsCount, forKey: "AdBookRecommendationsCount")
        aCoder.encode(isWriter, forKey: "AdBookIsWriter")
        aCoder.encode(isRecomended, forKey: "AdBookIsRecomended")
        aCoder.encode(code, forKey: "AdBookCode")
        aCoder.encode(readCode, forKey: "AdBookReadCode")
        aCoder.encode(listenCode, forKey: "AdBookListenCode")
    }
}

class ArchivedAuthor: NSObject , NSCoding{
    
    var avatar : String?
    var bio : String?
    var id : Int?
    var name : String?
    
    init(avatar : String? ,bio : String? ,id : Int? ,name : String?) {
        self.avatar = avatar
        self.bio = bio
        self.id = id
        self.name = name
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let avatar = aDecoder.decodeObject(forKey: "authorAvatar") as? String
        let bio = aDecoder.decodeObject(forKey: "authorBio") as? String
        let id = aDecoder.decodeObject(forKey: "authorId") as? Int
        let name = aDecoder.decodeObject(forKey: "authorName") as? String
        self.init(avatar: avatar, bio: bio, id: id, name: name)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(avatar, forKey: "authorAvatar")
        aCoder.encode(bio, forKey: "authorBio")
        aCoder.encode(id, forKey: "authorId")
        aCoder.encode(name, forKey: "authorName")
    }
}


class ArchivedGenre: NSObject , NSCoding{
    
    var id : Int?
    var name : String?
    
    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "GenreId") as? Int
        let name = aDecoder.decodeObject(forKey: "GenreName") as? String
        self.init(id: id, name: name)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "GenreId")
        aCoder.encode(name, forKey: "GenreName")
    }
}

class ArchivedQuote: NSObject , NSCoding{
    
    var id : Int?
    var body : String?
    var bookId : Int?
    
    init(id: Int?, body: String?, bookId: Int?) {
        self.id = id
        self.body = body
        self.bookId = bookId
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObject(forKey: "QuoteId") as? Int
        let body = aDecoder.decodeObject(forKey: "QuoteBody") as? String
        let bookId = aDecoder.decodeObject(forKey: "QuoteBookId") as? Int
        self.init(id: id, body: body, bookId: bookId)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "QuoteId")
        aCoder.encode(body, forKey: "QuoteBody")
        aCoder.encode(bookId, forKey: "QuoteBookId")
    }
}
