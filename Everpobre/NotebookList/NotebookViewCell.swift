//
//  NotebookViewCell.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 04-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import UIKit

class NotebookViewCell: UITableViewCell {
    
    // Mark - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    
    // Se recomienda siempre implementar este metodo
    override func prepareForReuse() {
        titleLabel.text = nil
        creationDateLabel.text = nil
    }
    
    // MARK: - Configure cell with Notebook
    func configure(with notebook: Notebook) {
        self.titleLabel.text = notebook.name
        self.creationDateLabel.text = self.creationString(from: notebook.creationDate)
    }
    
    // MARK: - Utils
    private func creationString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return "Create \(dateFormatter.string(from: date))"
    }
}
