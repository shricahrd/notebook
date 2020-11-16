//
//  CartModels.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/3/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import RealmSwift

protocol DetachableObject: AnyObject {
    func detached() -> Self
}

extension Object: DetachableObject {
    func detached() -> Self {
        let detached = type(of: self).init()
        for property in objectSchema.properties {
            guard let value = value(forKey: property.name) else { continue }
            if let detachable = value as? DetachableObject {
                detached.setValue(detachable.detached(), forKey: property.name)
            } else {
                detached.setValue(value, forKey: property.name)
            }
        }
        return detached
    }
}

extension List: DetachableObject {
    
    func detached() -> List<Element> {
        let result = List<Element>()
        forEach {
            result.append($0)
        }
        return result
    }
    
}

/////////////////// Realm models \\\\\\\\\\\\\\\\
class Cart: Object {
    //@objc private(set) dynamic var id = 0
    @objc dynamic var id = ""
    @objc dynamic var userMobileNumber = ""
    @objc dynamic var totalPrice: Float = 0.0
    @objc dynamic var totalNumberOfItems = Int()
    var books = List<BookOfflineModel>()
    override static func primaryKey() -> String? {
        return "id"
    }
}

// MARK: ± is a custom operator like = but between structure and class.
infix operator ±: AssignmentPrecedence

class BookOfflineModel: Object {
    
    //@objc private(set) dynamic var id = 0
    @objc dynamic var id = ""
    @objc dynamic var bookId = Int()
    @objc dynamic var bookName = String()
    @objc dynamic var counter: Int = 0
    @objc dynamic var printedCopyPrice: Float = 0.0
    override static func primaryKey() -> String? {
             return "id"
    }
    
    static func ± (lhs: BookOfflineModel, rhs: AdBook) -> BookOfflineModel{
           lhs.bookName = rhs.name ?? ""
           lhs.bookId = rhs.id ?? 0
           lhs.printedCopyPrice = rhs.printedPrice ?? 10
           lhs.counter += 1
           return lhs
    }
}

