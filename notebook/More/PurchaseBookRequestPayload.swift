//
//  PurchaseBookRequestPayload.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/7/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper

enum OrderType: String {
    case listen
    case read
    case both
    case coupon // you have 2hda2
    case printed
}

class PurchaseBookRequestPayload: NBRequest {
    
    var address: AddressData?
    var coupon: String?
    var orderType: String?
    var books = [PurchaseBook]()
    
    init(address: AddressData?, coupon: String?, orderType: String?, books: [PurchaseBook]) {
        super.init()
        
        parameters?["coupon"] = coupon
        parameters?["order_type"] = orderType
        
        if let addressData = try? JSONEncoder().encode(address){
            parameters?["address"] = try? JSONSerialization.jsonObject(with: addressData, options: .mutableContainers)
        }
        
        if let booksData = try? JSONEncoder().encode(books){
            parameters?["books"] = try? JSONSerialization.jsonObject(with: booksData, options: .mutableContainers)
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
        
        coupon <- map["coupon"]
        orderType <- map["order_type"]
        do{
            let addressMap = map["address"]
            if let jsonData = addressMap.currentValue{
                let jsonAddress = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                address = try JSONDecoder().decode(AddressData.self, from: jsonAddress)
            }
            
            let booksMap = map["books"]
            if let jsonData = booksMap.currentValue{
                let jsonBooks = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                books = try JSONDecoder().decode([PurchaseBook].self, from: jsonBooks)
            }
        } catch{
            print(error)
        }
    }
}


struct PurchaseBook : Codable{
    var book_id : Int?
    var quantity: Int?
}
