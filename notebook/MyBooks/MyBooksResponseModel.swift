//
//  MyBooksResponseModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct MyBooksResponseModel : Mappable{
    
    var data : [AdBook]?
    var paginatorMeta : PaginatorMeta?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        data <- map["data"]
        paginatorMeta <- map["meta"]
        
    }
}
