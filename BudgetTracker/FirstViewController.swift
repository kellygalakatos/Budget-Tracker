//
//  FirstViewController.swift
//  BudgetTracker
//
//  Created by Kelly Galakatos on 12/7/18.
//  Copyright © 2018 Kelly Galakatos. All rights reserved.
//

import UIKit
import CloudKit

class FirstViewController: UIViewController {

    @IBOutlet weak var progressTracker: UIProgressView!
    var records = [CKRecord]()
    var records2 = [CKRecord]()
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let zone = CKRecordZone(zoneName: "CategoryZone")
    let zone2 = CKRecordZone(zoneName: "ExpenseZone")
    var totalBudget: Double = 0.0
    var whereUat: Double = 0.0
    var done: Bool = false
    var done2: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func queryCategories() {
        let query = CKQuery(recordType: "Category", predicate: NSPredicate(value: true))
        
        
        privateDatabase.perform(query, inZoneWith: zone.zoneID) { (records, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                } else {
                    self.records = records ?? []
                    
                    self.totalBudget = 0.0
                    
                    for record in self.records {
                        self.totalBudget += Double(record.object(forKey: "amount") as! String)!
                    }
                    
                    let query2 = CKQuery(recordType: "Expense", predicate: NSPredicate(value: true))
                    
                    
                    self.privateDatabase.perform(query2, inZoneWith: self.zone2.zoneID) { (records, error) in
                        DispatchQueue.main.async {
                            if let error = error {
                                print(error)
                            } else {
                                self.records2 = records ?? []
                                
                                self.whereUat = 0.0
                                
                                for record in self.records2 {
                                    self.whereUat += Double(record.object(forKey: "amount") as! String)!
                                }
                                
                                self.progressTracker.progress = Float(self.whereUat / self.totalBudget)
                            }
                        }
                    }
                }
            }
        }
    }
    
//    func queryExpenses() {
//        let query = CKQuery(recordType: "Expense", predicate: NSPredicate(value: true))
//        
//        
//        privateDatabase.perform(query, inZoneWith: zone2.zoneID) { (records, error) in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print(error)
//                } else {
//                    self.records2 = records ?? []
//                    
//                    self.whereUat = 0.0
//                    
//                    for record in self.records2 {
//                        self.whereUat += record.object(forKey: "amount") as! Float
//                    }
//                    
//                    self.done2 = true
//                    
//                    self.progressTracker.progress = self.whereUat / self.totalBudget
//                }
//            }
//        }
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        queryCategories()
//        queryExpenses()
        
//        while (done == false || done2 == false) {
//
//        }
//
//
//        progressTracker.progress = whereUat / totalBudget
    }


}

