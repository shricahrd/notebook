//
//  PaginatorMeta.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/21/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct PaginatorMeta : Mappable{
    
    var message : String?
    var paginator : Paginator?
    var status : Int?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        message <- map["message"]
        paginator <- map["paginator"]
        status <- map["status"]
        
    }
    
}
