//
//  DetailsOfExpensesVC.swift
//  EnemyWallet
//
//  Created by Ahmet Engin Gökçe on 29.10.2021.
//

import UIKit
import RealmSwift

class DetailsOfExpensesVC: UITableViewController {
    
    let realm = try! Realm()
    var detailsOfExpenseList : Results<DetailOfExpense>?
    var selectedExpense : Expense? {
        didSet {
            loadDetails()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsOfExpenseList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "detailsOfExpensesCell")
        if let detailOfExpense = detailsOfExpenseList?[indexPath.row] {
            cell.textLabel?.text = "\(detailOfExpense.nameOfDetail) - \(detailOfExpense.price)"
        } else {
            cell.textLabel?.text = "Detail cannot be found!"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toEditExpenseVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditExpenseVC" {
            let destinationVC = segue.destination as! EditExpenseVC
            if let selectedIndex = tableView.indexPathForSelectedRow {
                if let selectedExpense = detailsOfExpenseList?[selectedIndex.row] {
                    destinationVC.selectedDetailOfExpense = selectedExpense
                    destinationVC.title = "Edit \(selectedExpense.nameOfDetail)"
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let selectedDetailOfExpense = detailsOfExpenseList?[indexPath.row] {
                do {
                    try realm.write({
                        realm.delete(selectedDetailOfExpense)
                    })
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func btnAddDetailOfExpense(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Detail", message: "Type details of expense", preferredStyle: .alert)
        alertController.addTextField { txtNameOfDetail in
            txtNameOfDetail.placeholder = "Detail Of Expense"
        }
        alertController.addTextField { txtDescriptionOfExpense in
            txtDescriptionOfExpense.placeholder = "Description Of Expense"
        }
        alertController.addTextField { txtPrice in
            txtPrice.placeholder = "Price"
            txtPrice.keyboardType = .numberPad
        }
        let actionAdd = UIAlertAction(title: "Add", style: .default) { action in
            let txtNameOfDetail = alertController.textFields![0]
            let txtDescriptionOfExpense = alertController.textFields![1]
            let txtPrice = alertController.textFields![2]
            
            if let selectedExpense = self.selectedExpense {
                do {
                    try self.realm.write({
                        let newExpense = DetailOfExpense()
                        newExpense.nameOfDetail = txtNameOfDetail.text ?? "Not Found"
                        newExpense.descriptionOfExpense = txtDescriptionOfExpense.text ?? "Not Found"
                        newExpense.price = Int(txtPrice.text ?? "-1")!
                        selectedExpense.detailsOfExpenses.append(newExpense)
                    })
                } catch {
                    print(error.localizedDescription)
                }
            }
            self.tableView.reloadData()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(actionAdd)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func loadDetails() {
        detailsOfExpenseList = selectedExpense?.detailsOfExpenses.sorted(byKeyPath: "nameOfDetail", ascending: true)
    }
}
