//
//  AdImage.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/29/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct AdImage : Mappable{
    
    var image : String?
    var id : Int?
    var name : String?
    var link: String?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        image <- map["image"]
        id <- map["id"]
        name <- map["name"]
        link <- map["link"]
    }
}
