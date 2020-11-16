//
//  AreasModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/5/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import ObjectMapper


struct AreasModel : Mappable{
    
    var meta : RootMeta?
    var data: [AreaData]?
    
    init?(map: Map){}
    init(){}
    
    mutating func mapping(map: Map)
    {
        meta <- map["meta"]
        do{
            let areasMap = map["data"]
            if let jsonData = areasMap.currentValue{
                let jsonAreas = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                data = try JSONDecoder().decode([AreaData].self, from: jsonAreas)
            }
        } catch{
            print(error)
        }
    }
}
