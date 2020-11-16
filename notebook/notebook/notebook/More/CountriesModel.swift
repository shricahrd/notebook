//
//  CountriesModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/5/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct CountriesModel : Mappable{
    
    var meta : RootMeta?
    var data: [CountryData]?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        meta <- map["meta"]
        data <- map["data"]
    }
}
