//
//	Data.swift
//
//	Create by Abdorahman Mahmoud on 6/3/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


struct LoginData : Mappable{

	var authorId : Int?
	var birthDate : String?
	var createdAt : String?
	var deletedAt : String?
	var email : String?
	var fullName : String?
	var gender : String?
	var id : Int?
	var isBlock : Int?
	var loginType : String?
	var mobileNumber : String?
	var token : String?
	var type : String?
	var updatedAt : String?

    init?(map: Map){}
	init(){}

	mutating func mapping(map: Map)
	{
		authorId <- map["author_id"]
		birthDate <- map["birth_date"]
		createdAt <- map["created_at"]
		deletedAt <- map["deleted_at"]
		email <- map["email"]
		fullName <- map["full_name"]
		gender <- map["gender"]
		id <- map["id"]
		isBlock <- map["is_block"]
		loginType <- map["login_type"]
		mobileNumber <- map["mobile_number"]
		token <- map["token"]
		type <- map["type"]
		updatedAt <- map["updated_at"]
	}

}
