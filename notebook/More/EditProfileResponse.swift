//
//  EditProfileResponse.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct EditProfileResponse : Mappable{
    
    var meta : RootMeta?
    var userInfo : UserInfo?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        userInfo <- map["data"]
        meta <- map["meta"]
    }
}

