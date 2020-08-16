//
//  ProductOrder.swift
//  GrainsmartKarga
//
//  Created by user on 16/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import RealmSwift

// Dog model
class ProductOrder: Object {
    @objc dynamic var orderId = ""
    @objc dynamic var variantId = ""
    @objc dynamic var price: Float = 0.0
    @objc dynamic var category: String = ""
    @objc dynamic var variant: String = ""
    @objc dynamic var quantity: Int = 0
}
