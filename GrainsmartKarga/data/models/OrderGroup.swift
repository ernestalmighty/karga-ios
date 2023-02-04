//
//  OrderGroup.swift
//  GrainsmartKarga
//
//  Created by user on 18/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit

class OrderGroup {
    var variantId: String
    var quantity: Int
    var variant: String
    var category: String
    var imageUrl: String
    var price: Float
    
    init(variantId: String, quantity: Int, variant: String, category: String, imageUrl: String, price: Float) {
        self.variantId = variantId
        self.quantity = quantity
        self.variant = variant
        self.category = category
        self.imageUrl = imageUrl
        self.price = price
    }
}
