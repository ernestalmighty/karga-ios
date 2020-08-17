//
//  Store.swift
//  GrainsmartKarga
//
//  Created by user on 9/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import RealmSwift

class Store: Object {
    @objc dynamic var storeId: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lon: Double = 0.0
    @objc dynamic var contact: String = ""
    @objc dynamic var social: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var messenger: String = ""
    
    override class func primaryKey() -> String? {
        return "storeId"
    }
}
