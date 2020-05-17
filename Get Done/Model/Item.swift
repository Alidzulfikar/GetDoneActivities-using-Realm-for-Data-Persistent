//
//  Item.swift
//  Get Done
//
//  Created by PHANTOM on 26/04/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self , property: "items")
    
}
