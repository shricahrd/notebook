//
//	UserGenre.swift
//
//	Create by Abdorahman Mahmoud on 14/2/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


struct UserGenre : Mappable{

	var books : [Book]?
	var id : Int?
	var name : String?


    init?(map: Map){}
    init(){}

	mutating func mapping(map: Map)
	{
		books <- map["books"]
		id <- map["id"]
		name <- map["name"]
		
	}
}
