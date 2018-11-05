//
//  NewNoteListViewController.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 05-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import UIKit
import CoreData

class NewNoteListViewController: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model: [Note] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Properties
    let notebook: Notebook //deprecated_Notebook
    let managedContext: NSManagedObjectContext
    
    // MARK: - Initialization
    init(notebook: Notebook, managedContext: NSManagedObjectContext) {
        self.notebook = notebook
        self.model = (notebook.notes?.array as? [Note]) ?? []
        self.managedContext = managedContext
        super.init(nibName: "NewNoteListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notes"
        self.view.backgroundColor = .white
        
        // Añadimos los delegados
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // Registramos la celda personalizada
        let nib = UINib(nibName: "NoteListCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "NoteListCollectionViewCell")
        
        // Añadimos los botones
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem = addButtonItem
    }
    
    // MARK: - Actions
    @objc private func addNote() {
        let newNoteVC = NoteDetailViewController(kind: .new(notebook: notebook), managedContext: managedContext)
        newNoteVC.delegate = self
        let navVC = UINavigationController(rootViewController: newNoteVC)
        self.present(navVC, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension NewNoteListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Averiguamos de que modelo se trata
        let note = self.model[indexPath.row]
        
        // Creamos la celda( o nos la dan por cache)
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteListCollectionViewCell", for: indexPath) as! NoteListCollectionViewCell
        
        // sincronizamos vista y modelo
        cell.configure(with: note)

        // devolvemos la celda
        return cell
    }
    
    
}

extension NewNoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // averiguamos de que modelo se trata
        let note = self.model[indexPath.row]
        
        // mostramos el NoteDetailViewcontroller
        let noteDetailViewController = NoteDetailViewController(kind: .existing(note: note), managedContext: self.managedContext)
        
        // Nos conformamos al delegado de noteDetailViewController
        noteDetailViewController.delegate = self
        
        self.show(noteDetailViewController, sender: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewNoteListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
}

// MARK: - NoteDetailViewControllerDelegate
extension NewNoteListViewController: NoteDetailViewControllerDelegate {
    func noteDetailViewController(_ vc: NoteDetailViewController, didSaveNote note: Note) {
        // Core Data actualiza automagicamente las notas
        self.model = (notebook.notes?.array as? [Note]) ?? []
    }
}
