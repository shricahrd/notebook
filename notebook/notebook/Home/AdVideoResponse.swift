//
//  AdVideoResponse.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/24/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct AdVideoResponse : Mappable{
    
    var data : AdImage?
    var meta : RootMeta?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        data <- map["data"]
        meta <- map["meta"]
        
    }
    
}
