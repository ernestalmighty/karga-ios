//
//  ProductCollectionViewController.swift
//  GrainsmartKarga
//
//  Created by user on 9/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import Firebase

class ProductCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var storeId: String = ""
    var productDataSource: [Product] = []
    var selectedProduct: Product?
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getProducts(storeId: self.storeId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = ProductCollectionViewCell()
        
        if let productCell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as? ProductCollectionViewCell {
            productCell.configureProductName(with: productDataSource[indexPath.row])
            
            cell = productCell
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected product: \(productDataSource[indexPath.row].displayName)")
        self.selectedProduct = productDataSource[indexPath.row]
        
        self.performSegue(withIdentifier: "segueShowProductDetails", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        // splace between two cell vertically
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (productCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size / 2 + 50)
    }
    
    func getProducts(storeId: String) {
        let db = Firestore.firestore()
        db.collection("stores").document(storeId).collection("inventory").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var list: [Product] = []
                for document in querySnapshot!.documents {
                    let productId = document.documentID
                    let displayName = document.data()["displayName"] as! String
                    let iconUrl = document.data()["iconUrl"] as! String
                    let status = document.data()["status"] as! Bool
                    
                    let product = Product(
                        productId: productId, displayName: displayName, iconUrl: iconUrl, status: status
                    )
                    
                    list.append(product)
                }
                
                self.productDataSource = list
                self.productCollectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowProductDetails" {
            let controller = segue.destination as! ProductDetailViewController
            controller.selectedProduct = self.selectedProduct
            controller.storeId = self.storeId
            self.selectedProduct = nil
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(self.selectedProduct == nil) {
            return false
        } else {
            return true
        }
    }
}
