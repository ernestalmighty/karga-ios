//
//  ProductDetailViewController.swift
//  GrainsmartKarga
//
//  Created by user on 17/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var storeId: String = ""
    var selectedProduct: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedProduct?.displayName
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowProductDetailsTable" {
            let controller = segue.destination as! ProductDetailTableViewController
            controller.selectedProduct = self.selectedProduct
            controller.storeId = self.storeId
        }
    }
}
