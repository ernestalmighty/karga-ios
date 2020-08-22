//
//  ProductDetailViewController.swift
//  GrainsmartKarga
//
//  Created by user on 17/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ProductDetailViewController: UIViewController {

    var storeId: String = ""
    var selectedProduct: Product?
    @IBOutlet weak var detailBannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedProduct?.displayName
        
        detailBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //detailBannerView.adUnitID = "ca-app-pub-1965212949581065/9563614429"
        detailBannerView.rootViewController = self
        detailBannerView.load(GADRequest())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowProductDetailsTable" {
            let controller = segue.destination as! ProductDetailTableViewController
            controller.selectedProduct = self.selectedProduct
            controller.storeId = self.storeId
        }
    }
}
