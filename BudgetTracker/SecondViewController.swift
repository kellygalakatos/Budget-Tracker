//
//  SecondViewController.swift
//  BudgetTracker
//
//  Created by Kelly Galakatos on 12/7/18.
//  Copyright © 2018 Kelly Galakatos. All rights reserved.
//

import UIKit
import CloudKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var categories: [String] = [""]
    var chosenCategory: String = ""
    var records = [CKRecord]()
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var amountText: UITextField!
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let zone = CKRecordZone(zoneName: "ExpenseZone")
    let zone2 = CKRecordZone(zoneName: "CategoryZone")
   
    @IBAction func saveButton(_ sender: Any) {
        if amountText.text! == "" || descriptionText.text! == "" || categories.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "You must have at least one category and must fill out a description and an amount.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
            self.present(alert, animated: true, completion: nil)
        } else if Double(amountText.text!) == nil {
            let alert = UIAlertController(title: "Alert", message: "Amount must be a number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        else {
            let category = chosenCategory as CKRecordValue?
            let description = descriptionText.text as CKRecordValue?
            let amount = amountText.text as CKRecordValue?
            
      
            let record = CKRecord(recordType: "Expense", zoneID: zone.zoneID)
            
            record.setObject(category, forKey: "category")
            record.setObject(description, forKey: "ddescription")
            record.setObject(amount, forKey: "amount")
            
            self.tabBarItem.isEnabled = false
            
            privateDatabase.save(record) { (record, error) in
                DispatchQueue.main.async {
                    self.tabBarItem.isEnabled = true
                    if let error = error {
                        print(error)
                    } else {
                        print("record saved")
                        self.amountText.text = ""
                        self.descriptionText.text = ""
                    }
                }
            }
        }
        
    }
    
    func queryExpenses() {
        let query = CKQuery(recordType: "Category", predicate: NSPredicate(value: true))
        
        
        privateDatabase.perform(query, inZoneWith: zone2.zoneID) { (records, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                } else {
                    self.records = records ?? []
                    self.categories = []
                    for record in self.records {
                        self.categories.append(record.object(forKey: "name") as! String)
                    }
                    if self.categories == [] {
                        self.categories = [""]
                    }
                    self.categoryPicker.reloadAllComponents()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        queryExpenses()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chosenCategory = categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}


