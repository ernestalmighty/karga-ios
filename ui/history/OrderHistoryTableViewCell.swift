//
//  OrderHistoryTableViewCell.swift
//  GrainsmartKarga
//
//  Created by user on 22/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var orderReference: UILabel!
    @IBOutlet weak var orderAmount: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureOrderCell(orderHistory: OrderHistory) {

        orderReference.text = "Ref no. " + orderHistory.id
        orderAmount.text = "Total amount: Php" + String(orderHistory.totalAmount)
        orderDate.text = "Date: " + orderHistory.date
    }
}
