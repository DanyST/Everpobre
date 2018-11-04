//
//  NoteDetailViewController.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 04-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    // MARK: - Properties
    let model: Note
    
    // Mark - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var lastSeenDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    // MARK: - Initialization
    init(model: Note) {
        // Nos encargamos de nuestras propias propieades
        self.model = model
        
        // llamamos a super
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.syncModelWithView()
    }
    
    // MARK: - syncModelWithView
    func syncModelWithView() {
        self.title = "Detail"
        self.titleLabel.text = self.model.title
        self.tagsLabel.text = self.model.tags?.joined(separator: ",")
        self.creationDateLabel.text = "Create \(self.model.creationDate.creationStringLabel())"
        self.lastSeenDateLabel.text = "Seen \(self.model.lastSeenDate?.creationStringLabel() ?? "Never")"
        self.descriptionLabel.text = self.model.text ?? "Type a text..."
    }
    
}
