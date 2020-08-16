//
//  ProductCollectionViewCell.swift
//  GrainsmartKarga
//
//  Created by user on 8/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import Nuke

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var imageProductIcon: UIImageView!
    
    func configureProductName(with product: Product) {
        labelProductName.text = product.displayName
        
        let imageUrl = product.iconUrl
        
        let request = ImageRequest(url: URL(string: imageUrl)!, targetSize: CGSize(width: 150, height: 100), contentMode: .aspectFill)
        
        Nuke.loadImage(with: request, into: imageProductIcon)
        
    }
}
