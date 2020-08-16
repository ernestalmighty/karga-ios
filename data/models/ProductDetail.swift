//
//  ProductDetail.swift
//  GrainsmartKarga
//
//  Created by user on 15/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit

class ProductDetail {
    var productDetailId: String
    var displayName: String
    var description: String
    var imageUrl: String
    var variants: [ProductVariant]
    
    init(productDetailId: String, displayName: String, description: String, imageUrl: String, variants: [ProductVariant]) {
        self.productDetailId = productDetailId
        self.displayName = displayName
        self.description = description
        self.imageUrl = imageUrl
        self.variants = variants
    }
}
