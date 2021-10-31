//
//  DetailOfExpense.swift
//  EnemyWallet
//
//  Created by Ahmet Engin Gökçe on 29.10.2021.
//

import Foundation
import RealmSwift

class DetailOfExpense : Object {
    @objc dynamic var nameOfDetail : String = ""
    @objc dynamic var descriptionOfExpense : String = ""
    @objc dynamic var price : Int = -1
    var expense = LinkingObjects(fromType: Expense.self, property: "detailsOfExpenses")
}
