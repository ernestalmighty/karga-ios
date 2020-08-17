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
        }
        
        quantityStepper.value = Double(quantity)
        productVariantQuantityLabel.text = String(quantity)
        quantityValue = quantity
    }
    
    @IBAction func quantityStepperAction(_ sender: UIStepper) {
        productVariantQuantityLabel.text = String(Int(sender.value))
        
        let newStepperValue = Int(sender.value)
        if(newStepperValue > quantityValue) {
            //increment
            let productOrder = ProductOrder()
            productOrder.variant = productVariant?.displayName as! String
            productOrder.quantity = Int(sender.value)
            productOrder.category = productVariant?.category as! String
            productOrder.iconUrl = self.productImageUrl
            productOrder.variantId = productVariant?.productVariantId as! String
            productOrder.price = productVariant?.price as! Float
            
            try! realm.write {
                realm.add(productOrder)
            }
        } else if (newStepperValue < quantityValue) {
            //decrement
            let order = realm.objects(ProductOrder.self).first!
            try! realm.write {
                realm.delete(order)
            }
        }
    }
}
