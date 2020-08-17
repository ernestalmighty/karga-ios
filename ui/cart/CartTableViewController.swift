//
//  CartTableViewController.swift
//  GrainsmartKarga
//
//  Created by user on 16/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "productOrderCell"

class CartTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var results: [ProductOrder] = []
    var productOrderDataSource: [ProductOrder] = []
    @IBOutlet var orderTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        productOrderDataSource = Array(realm.objects(ProductOrder.self))
        orderTableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("OrderHeaderView", owner: self, options: nil)?.last as! OrderHeaderView
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(30)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productOrderDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = CartTableViewCell()
        
        let order = productOrderDataSource[indexPath.row]
        
        if let orderCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CartTableViewCell {
            
            orderCell.configureOrder(productOrder: order)
            
            cell = orderCell
        }
        
        return cell
        
    }
}
