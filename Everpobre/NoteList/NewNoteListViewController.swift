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
//    let managedContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack!
    
    // MARK: - Initialization
    init(notebook: Notebook, coreDataStack: CoreDataStack) {
        self.notebook = notebook
        self.model = (notebook.notes?.array as? [Note]) ?? []
        self.coreDataStack = coreDataStack
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
        
        self.collectionView.backgroundColor = .lightGray
        
        // Añadimos los botones
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        let exportButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportCSV))
        
        self.navigationItem.rightBarButtonItems = [addButtonItem, exportButtonItem]
    }
    
    // MARK: - Actions
    @objc private func exportCSV() {
        self.coreDataStack.storeContainer.performBackgroundTask { [unowned self] context in
            var results: [Note] = []
            
            do {
               results = try self.coreDataStack.managedContext.fetch(self.notesFetchRequest(from: self.notebook))
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
            
            let exportPath = NSTemporaryDirectory() + "export.csv"
            let exportURL = URL(fileURLWithPath: exportPath)
            
            FileManager.default.createFile(atPath: exportPath, contents: Data(), attributes: nil)
            
            var fileHandle: FileHandle?
            
            do {
                fileHandle = try FileHandle(forWritingTo: exportURL)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
                fileHandle = nil
            }
            
            if let fileHandle = fileHandle {
                
                results.forEach { [weak self] note in
                    fileHandle.seekToEndOfFile()
                    guard let csvData = note.csv().data(using: .utf8,
                                                        allowLossyConversion: false)
                        else { return }
                    fileHandle.write(csvData)
                }
                
                fileHandle.closeFile()
                
                DispatchQueue.main.async { [weak self] in
                    self?.showExportFinishedAlert(exportPath)
                }
                
            } else {
                print("Not Could export data")
            }
            
        }
    }
    
    @objc private func addNote() {
        let newNoteVC = NoteDetailViewController(kind: .new(notebook: notebook), managedContext: coreDataStack.managedContext)
        newNoteVC.delegate = self
        let navVC = UINavigationController(rootViewController: newNoteVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    // MARK: - Utils
    private func notesFetchRequest(from notebook: Notebook) -> NSFetchRequest<Note> {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.fetchBatchSize = 50 // primeros 50
        fetchRequest.predicate = NSPredicate(format: "notebook == %@", notebook)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        return fetchRequest
    }
    
    private func showExportFinishedAlert(_ exportPath: String) {
        let message = "The file CSV is in \(exportPath)"
        let alertController = UIAlertController(title: "Export finished", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        
        self.present(alertController, animated: true)
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

// MARK: - UICollectionViewDelegate
extension NewNoteListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // averiguamos de que modelo se trata
        let note = self.model[indexPath.row]
        
        // mostramos el NoteDetailViewcontroller
        let noteDetailViewController = NoteDetailViewController(kind: .existing(note: note), managedContext: self.coreDataStack.managedContext)
        
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
