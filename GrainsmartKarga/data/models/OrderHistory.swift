//
//  OrderHistory.swift
//  GrainsmartKarga
//
//  Created by user on 22/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import RealmSwift

class OrderHistory: Object {
    @objc dynamic var id: String = "0"
    @objc dynamic var totalAmount: Float = 0.0
    @objc dynamic var date: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
