//
//  OrderHistoryTableViewController.swift
//  GrainsmartKarga
//
//  Created by user on 22/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import RealmSwift

class OrderHistoryTableViewController: UITableViewController {

    let realm = try! Realm()
    var orderHistoryDataSource: [OrderHistory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let orders = realm.objects(OrderHistory.self)
        orderHistoryDataSource = Array(orders)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderHistoryDataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(90)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = OrderHistoryTableViewCell()
        
        let order = orderHistoryDataSource[indexPath.row]
        
        if let orderCell = tableView.dequeueReusableCell(withIdentifier: "orderHistoryCell", for: indexPath) as? OrderHistoryTableViewCell {
            
            orderCell.configureOrderCell(orderHistory: order)
            
            cell = orderCell
        }
        
        return cell
    }
}
