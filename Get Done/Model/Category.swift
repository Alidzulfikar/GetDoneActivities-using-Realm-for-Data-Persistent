//
//  Category.swift
//  Get Done
//
//  Created by PHANTOM on 26/04/20.
//  Copyright © 2020 Dzulfikar Ali. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String?
    @objc dynamic var colour: String = ""
    var items = List<Item>()
    
}
