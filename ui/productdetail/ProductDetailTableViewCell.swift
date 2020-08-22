//
//  ProductDetailTableViewCell.swift
//  GrainsmartKarga
//
//  Created by user on 15/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import RealmSwift

class ProductDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var productVariantLabel: UILabel!
    @IBOutlet weak var productVariantQuantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var stocksLeftLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    let realm = try! Realm()
    
    var productVariant: ProductVariant?
    var quantityValue = 0
    var productImageUrl = ""
    var delegate: ProductDetailDelegate?
    var counter = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureProductDetail(productVariant: ProductVariant, quantity: Int, imageUrl: String) {
        self.productVariant = productVariant
        self.productImageUrl = imageUrl
        
        productVariantLabel.text = productVariant.displayName
        priceLabel.text = "Php " + String(productVariant.price)
        stocksLeftLabel.isHidden = false
        if(productVariant.stocksLeft == 0) {
            stocksLeftLabel.text = "*Sold out"
            quantityStepper.maximumValue = Double(productVariant.stocksLeft)
        } else if (productVariant.stocksLeft == 1) {
            stocksLeftLabel.text = "*1 stock left"
            quantityStepper.maximumValue = Double(productVariant.stocksLeft)
        } else if (productVariant.stocksLeft > 1 && productVariant.stocksLeft <= 5) {
            stocksLeftLabel.text = "*" + String(productVariant.stocksLeft) + " stocks left"
            quantityStepper.maximumValue = Double(productVariant.stocksLeft)
        } else {
            stocksLeftLabel.isHidden = true
            quantityStepper.maximumValue = .infinity
        }
        
        quantityStepper.value = Double(quantity)
        productVariantQuantityLabel.text = String(quantity)
        quantityValue = quantity
    }
    
    @IBAction func quantityStepperAction(_ sender: UIStepper) {
        let order = realm.objects(ProductOrder.self)
        let orderCount = order.filter {
            $0.variantId == self.productVariant?.productVariantId
        }.count
        
        productVariantQuantityLabel.text = String(Int(sender.value))
        
        let newStepperValue = Int(sender.value)
        if(newStepperValue > orderCount) {
            //increment
            let productOrder = ProductOrder()
            productOrder.variant = productVariant!.displayName
            productOrder.quantity = Int(sender.value)
            productOrder.category = productVariant!.category
            productOrder.iconUrl = self.productImageUrl
            productOrder.variantId = productVariant!.productVariantId
            productOrder.price = productVariant!.price
            
            try! realm.write {
                realm.add(productOrder)
            }
            
            print("Increment")
            delegate?.updateProductOrder(newOrder: productOrder, increment: true)
        } else if (newStepperValue < orderCount) {
            //decrement
            let order = realm.objects(ProductOrder.self).first(where: {
                $0.variantId == productVariant!.productVariantId
            })
            
            print("Decrement")
            print(order!.category)
            print(order!.variant)
            
            try! realm.write {
                realm.delete(order!)
            }
            
            delegate?.updateProductOrder(newOrder: order!, increment: false)
        }
    }
}
