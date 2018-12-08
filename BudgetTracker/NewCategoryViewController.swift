//
//  NewCategoryViewController.swift
//  BudgetTracker
//
//  Created by Kelly Galakatos on 12/7/18.
//  Copyright © 2018 Kelly Galakatos. All rights reserved.
//

import UIKit
import CloudKit

class NewCategoryViewController: UIViewController {

    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var monthlyAmount: UITextField!
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let zone = CKRecordZone(zoneName: "CategoryZone")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveNewCategory(_ sender: Any) {
        if categoryName.text! == "" || monthlyAmount.text! == "" {
            let alert = UIAlertController(title: "Alert", message: "You must fill out a category name and a monthly amount.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        } else if Double(monthlyAmount.text!) == nil {
            let alert = UIAlertController(title: "Alert", message: "Amount must be a number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
            
        else {
            let name = categoryName.text as CKRecordValue?
            let amount = monthlyAmount.text as CKRecordValue?
            
            
            let record = CKRecord(recordType: "Category", zoneID: zone.zoneID)
            
            record.setObject(name, forKey: "name")
            record.setObject(amount, forKey: "amount")
            
            self.tabBarItem.isEnabled = false
            
            privateDatabase.save(record) { (record, error) in
                DispatchQueue.main.async {
                    self.tabBarItem.isEnabled = true
                    if let error = error {
                        print(error)
                    } else {
                        print("record saved")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
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
