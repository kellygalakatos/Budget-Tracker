//
//  EditBudgetViewController.swift
//  BudgetTracker
//
//  Created by Kelly Galakatos on 12/7/18.
//  Copyright © 2018 Kelly Galakatos. All rights reserved.
//

import UIKit
import CloudKit

class EditBudgetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    let zone = CKRecordZone(zoneName: "CategoryZone")
    
    var records = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func queryExpenses() {
        let query = CKQuery(recordType: "Category", predicate: NSPredicate(value: true))
        
        
        privateDatabase.perform(query, inZoneWith: zone.zoneID) { (records, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                } else {
                    self.records = records ?? []
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        queryExpenses()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let record = records[indexPath.row]
        
        cell.textLabel?.text = record.object(forKey: "name") as? String
        cell.detailTextLabel?.text = record.object(forKey: "amount") as? String
        
        
        
        return cell
    }
    
    func deleteRecord(at indexPath: IndexPath) {
        let record = records[indexPath.row]
        
        privateDatabase.delete(withRecordID: record.recordID) { (recordID, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                } else {
                    print("record deleted")
                    
                    self.records.remove(at: indexPath.row)
                    
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRecord(at: indexPath)
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
