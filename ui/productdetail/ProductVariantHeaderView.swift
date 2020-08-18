//
//  ProductVariantHeaderView.swift
//  GrainsmartKarga
//
//  Created by user on 15/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import Nuke

class ProductVariantHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var productDetailImage: UIImageView!
    @IBOutlet weak var productDetailLabel: UILabel!
    
    func configureHeaderView(productDetail: ProductDetail) {
        productDetailLabel.text = productDetail.displayName
        self.productDetailImage.image = UIImage(named: "ic_arrow_right")
    }
}
