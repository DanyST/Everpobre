//
//  NoteListCollectionViewCell.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 05-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import UIKit

class NoteListCollectionViewCell: UICollectionViewCell {
    
    // Mark: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    
    // MARK: - Properties
    var item: Note!
    
    
    // Mark: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Methods
    func configure(with item: Note) {
        backgroundColor = .red
        titleLabel.text = item.title
        creationDateLabel.text = (item.creationDate as Date?)?.creationStringLabel()
    }

}
