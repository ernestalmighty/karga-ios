//
//  CartTableViewCell.swift
//  GrainsmartKarga
//
//  Created by user on 16/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import Nuke

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var orderImageView: UIImageView!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderVariantLabel: UILabel!
    @IBOutlet weak var orderQuantityLabel: UILabel!
    @IBOutlet weak var orderAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureOrder(productOrder: ProductOrder) {
        orderNameLabel.text = productOrder.category
        orderVariantLabel.text = productOrder.variant + " @ Php " + String(productOrder.price)
        orderQuantityLabel.text = "Qty: " + String(productOrder.quantity)
        orderAmount.text = String(productOrder.price)
        
        let request = ImageRequest(url: URL(string: productOrder.iconUrl)!, targetSize: CGSize(width: 150, height: 100), contentMode: .aspectFill)
        
        Nuke.loadImage(with: request, into: orderImageView)
    }

}
