//
//  ProductDetailTableViewController.swift
//  GrainsmartKarga
//
//  Created by user on 15/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift
import Nuke

private let reuseIdentifier = "productDetailCell"

class ProductDetailTableViewController: UITableViewController, ProductDetailDelegate {
    
    var storeId: String = ""
    var selectedProduct: Product?
    var productDetailDataSource: [ProductDetail] = []
    let realm = try! Realm()
    var results: [ProductOrder] = []
    
    @IBOutlet var productDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        results = Array(realm.objects(ProductOrder.self))
        getProductVariants(storeId: self.storeId, productId: self.selectedProduct?.productId ?? "0")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return productDetailDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let productDetail = productDetailDataSource[section]
        
        let header = Bundle.main.loadNibNamed("ProductVariantHeaderView", owner: self, options: nil)?.last as! ProductVariantHeaderView
        header.configureHeaderView(productDetail: productDetail)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        header.tag = section
        header.addGestureRecognizer(tap)

        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(45)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let getTag = sender?.view?.tag else { return }
        let productDetail = productDetailDataSource[getTag]
        
        let showAlert = UIAlertController(title: productDetail.displayName, message: nil, preferredStyle: .alert)
        let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: 250, height: 230))

        let request = ImageRequest(url: URL(string: productDetail.imageUrl)!, targetSize: CGSize(width: 300, height: 330), contentMode: .aspectFill)
        Nuke.loadImage(with: request, into: imageView)
        
        showAlert.view.addSubview(imageView)
        let height = NSLayoutConstraint(item: showAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 330)
        let width = NSLayoutConstraint(item: showAlert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        showAlert.view.addConstraint(height)
        showAlert.view.addConstraint(width)
        showAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
            showAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(showAlert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productDetailDataSource[section].variants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = ProductDetailTableViewCell()
        
        let variant = productDetailDataSource[indexPath.section].variants[indexPath.row]
        
        if let productCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProductDetailTableViewCell {
            
            let orderList = results.filter({
                $0.variantId == variant.productVariantId
            })
            
            productCell.configureProductDetail(productVariant: variant, quantity: orderList.count, imageUrl: selectedProduct?.iconUrl ?? "")
            productCell.delegate = self
            
            cell = productCell
        }
        
        
        return cell
    }
    
    func getProductVariants(storeId: String, productId: String) {
        let db = Firestore.firestore()
        
        db.collection("stores").document(storeId)
            .collection("inventory")
            .document(productId)
            .collection("types")
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var list: [ProductDetail] = []
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    let displayName = document.data()["displayName"] as! String
                    let iconUrl = document.data()["iconUrl"] as! String
                    var description = ""
                    
                    if(document.data()["description"] != nil) {
                        description = document.data()["description"] as! String
                    }
                    
                    let productDetail = ProductDetail(
                        productDetailId: id, displayName: displayName, description: description, imageUrl: iconUrl, variants: []
                    )
                    
                    list.append(productDetail)
                }
                
                var counter = 0
                for productDetail in list {
                    db.collection("stores").document(storeId)
                    .collection("inventory")
                    .document(productId)
                    .collection("types")
                    .document(productDetail.productDetailId)
                    .collection("variants").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            var variantList: [ProductVariant] = []
                            for document in querySnapshot!.documents {
                                let id = document.documentID
                                let displayName = document.data()["displayName"] as! String
                                let price = document.data()["price"] as! Float
                                var stock = -1
                                if(document.data()["stock"] != nil) {
                                    stock = Int(document.data()["stock"] as! Float)
                                }
                                
                                let productVariant = ProductVariant(productVariantId: id, displayName: displayName, price: price, stocksLeft: Int(stock), category: productDetail.displayName,type: self.selectedProduct?.displayName ?? "")
                                variantList.append(productVariant)
                            }
                            
                            let detail = list.filter({
                                $0.productDetailId == productDetail.productDetailId
                            }).first
                            
                            detail?.variants = variantList
                            
                            counter += 1
                            
                            if(counter >= list.count) {
                                self.productDetailDataSource = list
                                self.productDetailTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateProductOrder(newOrder: ProductOrder, increment: Bool) {
        results = Array(realm.objects(ProductOrder.self))
    }
}
