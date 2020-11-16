//
//	Author.swift
//
//	Create by Abdorahman Mahmoud on 14/2/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


struct Author : Mappable{

	var avatar : String?
	var bio : String?
	var id : Int?
	var name : String?
    var authorShareLink : String?

    init?(map: Map){}
    init(){}

	mutating func mapping(map: Map)
	{
		avatar <- map["avatar"]
		bio <- map["bio"]
		id <- map["id"]
		name <- map["name"]
        authorShareLink <- map["author_share_link"]
		
	}
}
