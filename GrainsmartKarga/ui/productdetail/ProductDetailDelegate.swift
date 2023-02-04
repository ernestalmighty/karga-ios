//
//  ProductDetailDelegate.swift
//  GrainsmartKarga
//
//  Created by user on 21/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

protocol ProductDetailDelegate: class {
    func updateProductOrder(newOrder: ProductOrder, increment: Bool)
}
