//
//  TaskInvoicesGetter.swift
//  easyselling
//
//  Created by Pierre Gourgouillon on 26/01/2022.
//

import Foundation
import CoreData
import SwiftUI

class TaskInvoicesGetter {

    func getInvoices() {
        do {
            let fetchRequest = Invoice.fetchRequest()
            let objects = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {

        }
    }
}
