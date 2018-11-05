//
//  NoteListViewController.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 04-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import UIKit
import CoreData

class NoteListViewController: UIViewController {
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
//    var model: [deprecated_Note] = [] {
//        didSet {
//            self.tableView.reloadData()
//        }
//    }
    
    var model: [Note] {
        guard let model = notebook.notes?.array else { return [] }
        
        return model as! [Note]
    }
    
    let notebook: Notebook //deprecated_Notebook
    let managedContext: NSManagedObjectContext
    
    // MARK: - Initialization
    init(notebook: Notebook, managedContext: NSManagedObjectContext) {
        // Nos encargamos de nuestras propias propiedades
        self.notebook = notebook
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
        
//        self.navigationController?.navigationBar.isTranslucent = false
        
        self.title = "Notes"
        
        // Creamos el boton
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        
        // Añadimos el boton
        self.navigationItem.rightBarButtonItem = addButtonItem
        
        setupTableView()
    }
    
    // MARK: - Setup TableView
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        view.addSubview(self.tableView)
        
        // Add contrains
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    // MARK: - Actions
    @objc func addNote() {
        let newNoteViewController = NoteDetailViewController(kind: .new(notebook: self.notebook), managedContext: self.managedContext)
        let navViewController = UINavigationController(rootViewController: newNoteViewController)
        
        self.present(navViewController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Obtenemos el modelo
        let note = self.model[indexPath.row]
        
        // creamos la celda
        let cell = UITableViewCell(style: .default, reuseIdentifier: "NoteCell")
        
        // sincronizamos modelo y vista
        cell.textLabel?.text = note.title
        
        // devolvemos la celda
        return cell
    }
}


// MARK: - UITableViewDelegate
extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // averiguamos de que modelo se trata
        let note = self.model[indexPath.row]
        
        // mostramos el NoteDetailViewcontroller
        let noteDetailViewController = NoteDetailViewController(kind: .existing(note: note), managedContext: self.managedContext)
        
        self.show(noteDetailViewController, sender: nil)
    }
}
