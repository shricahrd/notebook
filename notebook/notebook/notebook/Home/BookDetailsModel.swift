//
//  BookDetailsModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/17/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct BookDetailsModel : Mappable{
    
    var data : AdBook?
    var meta : RootMeta?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        data <- map["data"]
        meta <- map["meta"]
        
    }
    
}
