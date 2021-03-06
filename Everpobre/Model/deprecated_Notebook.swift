//
//  Notebookbook.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 04-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import Foundation

struct deprecated_Notebook {
    
    // MARK: - Properties
    let name: String
    let creationDate: Date
    let notes: [deprecated_Note]
    
    static let dummyNotebookModel: [deprecated_Notebook] = [
        deprecated_Notebook(name: "Prueba 1", creationDate: Date(), notes:  [
            deprecated_Note(title: "Primera nota", text: nil, tags: nil, creationDate: Date(), lastSeenDate: nil),
            deprecated_Note(title: "Segunda nota", text: "Test", tags: nil, creationDate: Date(), lastSeenDate: nil),
            deprecated_Note(title: "Tercera nota", text: "Texto de prueba", tags: nil, creationDate: Date(), lastSeenDate: nil),
            deprecated_Note(title: "Cuarta nota", text: "Algo de contenido", tags: nil, creationDate: Date(), lastSeenDate: nil),
            deprecated_Note(title: "Quinta nota", text: nil, tags: nil, creationDate: Date(), lastSeenDate: nil)
            ]
        ),
        deprecated_Notebook(name: "Prueba 2", creationDate: Date().calculateDate(fromDaysBefore: 5), notes: []),
        deprecated_Notebook(name: "Prueba 3", creationDate: Date().calculateDate(fromDaysBefore: 7), notes: []),
        deprecated_Notebook(name: "Prueba 4", creationDate: Date().calculateDate(fromDaysBefore: 7), notes: []),
        deprecated_Notebook(name: "Prueba 5", creationDate: Date().calculateDate(fromDaysBefore: 7), notes: []),
        deprecated_Notebook(name: "Prueba 6", creationDate: Date().calculateDate(fromDaysBefore: 8), notes: []),
        deprecated_Notebook(name: "Prueba 7", creationDate: Date().calculateDate(fromDaysBefore: 9), notes: []),
        deprecated_Notebook(name: "Prueba 8", creationDate: Date().calculateDate(fromDaysBefore: 10), notes: [])
    ]
}

extension Date {
    func calculateDate(fromDaysBefore days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -days, to: self) ?? Date()
    }
}
