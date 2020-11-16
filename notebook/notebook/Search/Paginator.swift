//
//  Paginator.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/21/19.
//  Copyright © 2019 clueapps. All rights reserved.
//
import Foundation
import ObjectMapper


struct Paginator : Mappable{
    
    var limit : Int?
    var next : AnyObject?
    var page : Int?
    var prev : AnyObject?
    var total : Int?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        limit <- map["limit"]
        next <- map["next"]
        page <- map["page"]
        prev <- map["prev"]
        total <- map["total"]
        
    }
}
