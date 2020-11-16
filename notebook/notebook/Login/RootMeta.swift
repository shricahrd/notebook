//
//	Meta.swift
//
//	Create by Abdorahman Mahmoud on 6/3/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


struct RootMeta : Mappable{

	var message : String?
	var status : Int?


    init?(map: Map){}
    init(){}

	mutating func mapping(map: Map)
	{
		message <- map["message"]
		status <- map["status"]
		
	}
}
