//
//	AdBook.swift
//
//	Create by Abdorahman Mahmoud on 14/2/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


struct AdBook : Mappable{

	var authors : [Author]?
	var bothPrice : Float?
	var cover : String?
	var createdAt : String?
	var descriptionField : String?
	var favouritesCount : Int?
	var genre : Genre?
	var giftCount : Int?
	var id : Int?
	var isFavourite : Bool?
	var isFeatured : Int?
	var isPurchased : Bool?
	var listenLink : String?
	var listenPrice : Float?
	var name : String?
    var shareLink: String?
    var purchaseType : String?{
        didSet{
            if let purchaseTypeValue = purchaseType{
                if purchaseTypeValue == PurchaseType.read.rawValue{
                    purchaseTypeMapped = .read
                }else if purchaseTypeValue == PurchaseType.listen.rawValue{
                    purchaseTypeMapped = .listen
                }else if purchaseTypeValue == PurchaseType.printed.rawValue{
                    purchaseTypeMapped = .printed
                }else if purchaseTypeValue == PurchaseType.both.rawValue{
                    purchaseTypeMapped = .both
                }else{
                    purchaseTypeMapped = .none
                }
            }else{
                purchaseTypeMapped = .none
            }
        }
    }
	var quotes : [Quote]?
	var readLink : String?
	var readPrice : Float?
    var printedPrice : Float?
	var recommendationsCount : Int?
    var isWriter: Bool?
    var isRecomended: Bool?
    var code: String?
    var readCode: String?
    var listenCode: String?
    
    var purchaseTypeMapped = PurchaseType.none
    
    init?(map: Map){}
    init(){}

	mutating func mapping(map: Map)
	{
		authors <- map["authors"]
		bothPrice <- map["both_price"]
		cover <- map["cover"]
		createdAt <- map["created_at"]
		descriptionField <- map["description"]
		favouritesCount <- map["favourites_count"]
		genre <- map["genre"]
		giftCount <- map["gift_count"]
		id <- map["id"]
		isFavourite <- map["is_favourite"]
		isFeatured <- map["is_featured"]
		isPurchased <- map["is_purchased"]
		listenLink <- map["listen_link"]
		listenPrice <- map["listen_price"]
		name <- map["name"]
		purchaseType <- map["purchase_type"]
		quotes <- map["quotes"]
		readLink <- map["read_link"]
		readPrice <- map["read_price"]
		recommendationsCount <- map["recommendations_count"]
        printedPrice <- map["printed_price"]
        isWriter <- map["is_writer"]
		isRecomended <- map["is_recomended"]
        code <- map["code"]
        
        readCode <- map["read_code"]
        listenCode <- map["listen_code"]
        shareLink <- map["share_link"]
	}

}
