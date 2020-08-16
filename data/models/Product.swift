//
//  Product.swift
//  GrainsmartKarga
//
//  Created by user on 10/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit

class Product {
    var productId: String
    var displayName: String
    var iconUrl: String
    var status: Bool
    
    init(productId: String, displayName: String, iconUrl: String, status: Bool) {
        self.productId = productId
        self.displayName = displayName
        self.iconUrl = iconUrl
        self.status = status
    }
}
