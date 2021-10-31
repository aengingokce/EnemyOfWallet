//
//  ExpensesListVC.swift
//  EnemyWallet
//
//  Created by Ahmet Engin Gökçe on 29.10.2021.
//

import UIKit
import RealmSwift

class ExpensesListVC: UITableViewController {
    
    var expensesList : Results<Expense>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDatas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expensesList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "expensesCell")
        let totalPrice : Int = expensesList?[indexPath.row].detailsOfExpenses.sum(ofProperty: "price") ?? 0
        if let nameOfExpense = expensesList?[indexPath.row].nameOfExpense {
            cell.textLabel?.text = "\(nameOfExpense) - \(totalPrice)"
        } else {
            cell.textLabel?.text = "Not Found!"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailsOfExpensesVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsOfExpensesVC" {
            let destinationVC = segue.destination as! DetailsOfExpensesVC
            if let selectedIndex = tableView.indexPathForSelectedRow {
                destinationVC.selectedExpense = expensesList?[selectedIndex.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let deletedExpense = expensesList?[indexPath.row] {
                do {
                    try realm.write({
                        realm.delete(deletedExpense.detailsOfExpenses)
                        realm.delete(deletedExpense)
                    })
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func btnAddExpense(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Expense", message: "Type the expense you want to add", preferredStyle: .alert)
        alertController.addTextField { txtExpenseName in
            txtExpenseName.placeholder = "Name of the Expense"
        }
        let actionAdd = UIAlertAction(title: "Add", style: .default) { action in
            let txtExpenseName =  alertController.textFields![0]
            if !txtExpenseName.text!.isEmpty {
                let newExpense = Expense()
                newExpense.nameOfExpense = txtExpenseName.text!
                self.saveDatas(expense: newExpense)
                self.tableView.reloadData()
            }
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(actionAdd)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func saveDatas(expense : Expense) {
        do {
            try realm.write({
                realm.add(expense)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadDatas() {
        expensesList = realm.objects(Expense.self)
        tableView.reloadData()
    }
}
