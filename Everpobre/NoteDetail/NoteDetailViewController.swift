//
//  NoteDetailViewController.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 04-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import UIKit
import CoreData

protocol NoteDetailViewControllerDelegate: class {
    func noteDetailViewController(_ vc: NoteDetailViewController, didSaveNote note: Note)
}

class NoteDetailViewController: UIViewController {
    
    // Mark - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    @IBOutlet weak var lastSeenDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    // MARK: - Properties
    //let model: Note//deprecated_Note
    
    enum Kind {
        case new(notebook: Notebook)
        case existing(note: Note)
    }
    
    let managedContext: NSManagedObjectContext
    let kind: Kind
    
    weak var delegate: NoteDetailViewControllerDelegate?
    
    // MARK: - Initialization
    init(kind: Kind, managedContext: NSManagedObjectContext) {
        // Nos encargamos de nuestras propias propieades
        self.kind = kind
        self.managedContext = managedContext
        
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
            addSaveAndCancelButtonsInNav()
            
        case .existing:
            configureValues()
            addSaveAndCancelButtonsInNav()
        }
    }
    
    func configureValues() {
        self.title = kind.title
        
        self.titleTextField.text = kind.note?.title
        //        self.tagsLabel.text = self.model.tags?.joined(separator: ",")
        self.creationDateLabel.text = "Create \((kind.note?.creationDate as Date?)?.creationStringLabel() ?? "ND")"
        self.lastSeenDateLabel.text = "Seen \((kind.note?.lastSeenDate as Date?)?.creationStringLabel() ?? "Never")"
        self.descriptionLabel.text = kind.note?.text ?? "Type a text..."
    }
    
    
    // MARK: - Actions
    @objc private func saveNote() {
        switch kind {
        case .existing(let note):
            
            // editamos la nota
            note.title = self.titleTextField.text
            note.text = self.descriptionLabel.text
            note.lastSeenDate = NSDate()
            
            // Guardamos la nota
            do {
                try managedContext.save()
                self.delegate?.noteDetailViewController(self, didSaveNote: note)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
            
            // Nos devolvemos al controller anterior
            self.navigationController?.popViewController(animated: true)
            
        case .new(let notebook):
            
            // Creamos la nota
            let note = Note(context: self.managedContext)
            note.title = self.titleTextField.text
            note.text = self.descriptionLabel.text
            note.creationDate = NSDate()
            note.notebook = notebook
            
            // Añadimos la nota al Notebook
            if let notes = notebook.notes?.mutableCopy() as? NSMutableOrderedSet {
                notes.add(note)
                notebook.notes = notes
            }
            
            // Guardamos la nota
            do {
                try managedContext.save()
                self.delegate?.noteDetailViewController(self, didSaveNote: note)
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }
            
            // Cerramos la modal
            self.dismiss(animated: true)
            
        }
    }
    
    @objc private func cancel() {
        self.dismiss(animated: true)
    }
    
    @IBAction func pickImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.showPhotoMenu()
        }else {
            self.choosePhotoFromLibrary()
        }
    }
    
    // MARK: - Utils
    func addSaveAndCancelButtonsInNav() {
        // Creamos los botones
        let saveButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
        // Añadimos los botones al navigationItem
        self.navigationItem.rightBarButtonItem = saveButtonItem
        self.navigationItem.leftBarButtonItem = cancelButtonItem
    }
    
    private func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.takePhotoWithCamera()
        }
        let chooseFromLibrary = UIAlertAction(title: "Choose From Library", style: .default) { _ in
            self.choosePhotoFromLibrary()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(chooseFromLibrary)
        
        self.present(alertController, animated: true)
    }
    
    private func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true)
    }
    
    private func takePhotoWithCamera() {
        
    }
    
    
}

// MARK: - NoteDetailViewController.Kind Extension
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

// MARK: - UIImagePickerControllerDelegate
extension NoteDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Obtenemos la imagen
        let rawImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        
        
    }
}
