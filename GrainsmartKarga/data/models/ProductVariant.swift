//
//  ProductVariant.swift
//  GrainsmartKarga
//
//  Created by user on 15/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit

class ProductVariant {
    var productVariantId: String
    var displayName: String
    var price: Float
    var stocksLeft: Int
    var category: String
    var type: String
    
    init(productVariantId: String, displayName: String, price: Float, stocksLeft: Int, category: String, type: String) {
        self.productVariantId = productVariantId
        self.displayName = displayName
        self.price = price
        self.stocksLeft = stocksLeft
        self.category = category
        self.type = type
    }
}
