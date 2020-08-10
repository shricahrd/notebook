//
//  CountryCode2.swift
//  notebook
//
//  Created by Lenin Niclavos on 22/03/20.
//  Copyright © 2020 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper

struct CountryCodez : Mappable {
    var meta : NSDictionary?
    var Data : [CountriesData]?
    
    init?(map: Map){}
    init(){}
   
    
    mutating func mapping(map: Map) {
        
        meta <- map["meta"]
        Data <- map["data"]
    }
    
}


