//
//  NotebookListViewController.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 04-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import UIKit
import CoreData

class NotebookListViewController: UIViewController {

    // MARK: - Properties
    var model: [deprecated_Notebook] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var managedContext: NSManagedObjectContext!
    
    // Mark - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // Mark - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model = deprecated_Notebook.dummyNotebookModel
    }
}

// MARK: - UITableViewDataSource
extension NotebookListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Obtenemos el modelo
        let notebook = model[indexPath.row]
        
        // Creamos la celda(o nos dan por caché)
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotebookListCell", for: indexPath) as! NotebookViewCell
        
        // sincronizamos vista y modelo
        cell.configure(with: notebook)
        
        // devolvemos la celda
        return cell
    }
    
    
}

// MARK: - UITableViewDelegate
extension NotebookListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // obtenemos el modelo
        let notebook = model[indexPath.row]
        
        // mostramos el controlador de notas
        let noteListViewController = NoteListViewController(notebook: notebook)
        self.show(noteListViewController, sender: nil)
    }
}
