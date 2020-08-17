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
        
        let request = ImageRequest(url: URL(string: productDetail.imageUrl)!, targetSize: CGSize(width: 50, height: 50), contentMode: .aspectFill)
        Nuke.loadImage(with: request, into: productDetailImage)
    }
}
