//
//  EditExpenseVC.swift
//  EnemyWallet
//
//  Created by Ahmet Engin Gökçe on 29.10.2021.
//

import UIKit
import RealmSwift

class EditExpenseVC: UIViewController {

    var selectedDetailOfExpense : DetailOfExpense?
    let realm = try! Realm()
    
    @IBOutlet weak var txtNameOfDetail: UITextField!
    @IBOutlet weak var txtDescriptionOfDetail: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var btnEdit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnEdit.layer.cornerRadius = 20
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setView()
    }
    
    @IBAction func btnEditDetail(_ sender: UIButton) {
        if let selectedDetailOfExpense = selectedDetailOfExpense {
            do {
                try realm.write({
                    selectedDetailOfExpense.nameOfDetail = txtNameOfDetail.text!
                    selectedDetailOfExpense.descriptionOfExpense = txtDescriptionOfDetail.text!
                    selectedDetailOfExpense.price = Int((txtPrice.text)!) ?? -1
                })
            } catch {
                print(error.localizedDescription)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func setView() {
        txtNameOfDetail.text = selectedDetailOfExpense?.nameOfDetail
        txtDescriptionOfDetail.text = selectedDetailOfExpense?.descriptionOfExpense
        txtPrice.text = "\(selectedDetailOfExpense?.price ?? -1)"
    }
    
}
