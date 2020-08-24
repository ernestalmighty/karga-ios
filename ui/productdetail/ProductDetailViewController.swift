//
//  ProductDetailViewController.swift
//  GrainsmartKarga
//
//  Created by user on 17/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ProductDetailViewController: UIViewController, GADBannerViewDelegate {

    var storeId: String = ""
    var selectedProduct: Product?
    @IBOutlet weak var detailBannerView: GADBannerView!
    @IBOutlet weak var tableContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedProduct?.displayName
        
        //detailBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        detailBannerView.adUnitID = "ca-app-pub-1965212949581065/9563614429"
        detailBannerView.rootViewController = self
        detailBannerView.load(GADRequest())
        detailBannerView.delegate = self
        detailBannerView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowProductDetailsTable" {
            let controller = segue.destination as! ProductDetailTableViewController
            controller.selectedProduct = self.selectedProduct
            controller.storeId = self.storeId
        }
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        let margins = view.layoutMarginsGuide
        tableContainerView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -50).isActive = true
        
        detailBannerView.isHidden = false
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
        let margins = view.layoutMarginsGuide
        tableContainerView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true
        
        detailBannerView.isHidden = true
    }
}
