//
//  Expense.swift
//  EnemyWallet
//
//  Created by Ahmet Engin Gökçe on 29.10.2021.
//

import Foundation
import RealmSwift

class Expense : Object {
    @objc dynamic var nameOfExpense : String = ""
    let detailsOfExpenses = List<DetailOfExpense>()
}
