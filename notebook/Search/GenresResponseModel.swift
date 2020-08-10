//
//  GenresResponseModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/22/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct GenresResponseModel : Mappable{
    
    var data : [Genre]?
    var meta : RootMeta?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        data <- map["data"]
        meta <- map["meta"]
        
    }
}
