//
//  NoteDetailViewController.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 04-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {
    
    // Mark - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var lastSeenDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    // MARK: - Properties
    //let model: Note//deprecated_Note
    
    enum Kind {
        case new
        case existing(Note)
    }
    
    let kind: Kind
    
    // MARK: - Initialization
    init(kind: Kind) {
        // Nos encargamos de nuestras propias propieades
        self.kind = kind
        
        // llamamos a super
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure(with: self.kind)
    }
    
    // MARK: - Configure View
    func configure(with kind: Kind) {
        switch kind {
        case .new:
            
            // Creamos los botones
            let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
            let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
            
            // Añadimos los botones al navigationItem
            self.navigationItem.rightBarButtonItem = saveButtonItem
            self.navigationItem.leftBarButtonItem = cancelButtonItem
            
        case .existing:
            configureValues()
        }
    }
    
    func configureValues() {
        self.title = kind.title
        
        self.titleLabel.text = kind.note?.title
        //        self.tagsLabel.text = self.model.tags?.joined(separator: ",")
        self.creationDateLabel.text = "Create \((kind.note?.creationDate as Date?)?.creationStringLabel() ?? "ND")"
        self.lastSeenDateLabel.text = "Seen \((kind.note?.lastSeenDate as Date?)?.creationStringLabel() ?? "Never")"
        self.descriptionLabel.text = kind.note?.text ?? "Type a text..."
    }
    
    // MARK: - Actions
    @objc func saveNote() {
        
    }
    
    @objc func cancel() {
        self.dismiss(animated: true)
    }
    
}

private extension NoteDetailViewController.Kind {
    var note: Note? {
        guard case let .existing(note) = self else { return nil }
        return note
    }
    
    var title: String {
        switch self {
        case .existing:
            return "Detail"
        case .new:
            return "New Note"
        }
    }
}
