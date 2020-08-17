//
//  CartViewController.swift
//  GrainsmartKarga
//
//  Created by user on 16/8/20.
//  Copyright © 2020 Ernest Martin Gayyed. All rights reserved.
//

import UIKit
import RealmSwift

class CartViewController: UIViewController {

    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deliveryView.layer.shadowRadius = 1
        deliveryView.layer.shadowOffset = .zero
        deliveryView.layer.shadowOpacity = 0.2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let result = Array(realm.objects(ProductOrder.self))
        let totalAmount = result.reduce(0, {$0 + $1.price})
        
        totalAmountLabel.text = String(totalAmount)
    }
    
    @IBAction func onProceedButtonClicked(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
