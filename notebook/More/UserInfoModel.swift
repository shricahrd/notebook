//
//  UserInfoModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct UserInfo : Mappable{
    
    var apartmentNumber : AnyObject?
    var area : AnyObject?
    var authorId : AnyObject?
    var birthDate : String?
    var blockNumber : AnyObject?
    var city : AnyObject?
    var createdAt : String?
    var deletedAt : AnyObject?
    var email : String?
    var fullName : String?
    var gender : String?
    var id : Int?
    var isBlock : Int?
    var loginType : String?
    var mobileNumber : String?
    var roles : [AnyObject]?
    var street : AnyObject?
    var type : String?
    var updatedAt : String?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        apartmentNumber <- map["apartment_number"]
        area <- map["area"]
        authorId <- map["author_id"]
        birthDate <- map["birth_date"]
        blockNumber <- map["block_number"]
        city <- map["city"]
        createdAt <- map["created_at"]
        deletedAt <- map["deleted_at"]
        email <- map["email"]
        fullName <- map["full_name"]
        gender <- map["gender"]
        id <- map["id"]
        isBlock <- map["is_block"]
        loginType <- map["login_type"]
        mobileNumber <- map["mobile_number"]
        roles <- map["roles"]
        street <- map["street"]
        type <- map["type"]
        updatedAt <- map["updated_at"]
        
    }
}
