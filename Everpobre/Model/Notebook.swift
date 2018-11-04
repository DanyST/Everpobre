//
//  Notebookbook.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 04-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import Foundation

struct Notebook {
    let name: String
    let creationDate: Date
    
    static let dummyNotebookModel: [Notebook] = [
        Notebook(name: "Prueba 1", creationDate: Date()),
        Notebook(name: "Prueba 2", creationDate: Date().calculateDate(fromDaysBefore: 5)),
        Notebook(name: "Prueba 3", creationDate: Date().calculateDate(fromDaysBefore: 7)),
        Notebook(name: "Prueba 4", creationDate: Date().calculateDate(fromDaysBefore: 7)),
        Notebook(name: "Prueba 5", creationDate: Date().calculateDate(fromDaysBefore: 7)),
        Notebook(name: "Prueba 6", creationDate: Date().calculateDate(fromDaysBefore: 8)),
        Notebook(name: "Prueba 7", creationDate: Date().calculateDate(fromDaysBefore: 9)),
        Notebook(name: "Prueba 8", creationDate: Date().calculateDate(fromDaysBefore: 10))
    ]
}

extension Date {
    func calculateDate(fromDaysBefore days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -days, to: self) ?? Date()
    }
}
