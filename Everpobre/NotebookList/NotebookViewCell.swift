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
}
