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
//    var model: [deprecated_Notebook] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }
    
    var managedContext: NSManagedObjectContext!
    
//    var dataSource: [NSManagedObject] = [] {
//        didSet {
//            self.tableView.reloadData()
//        }
//    }
    
    private var fetchResultsController: NSFetchedResultsController<Notebook>!
    
    // Mark: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    // Mark: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureSearchController()
        self.showAll()
    }
    
    // MARK: - FetchResultsController - Utils
    func getFetchResultsController(with predicate: NSPredicate = NSPredicate(value: true)) -> NSFetchedResultsController<Notebook> {
        
        let fetchRequest: NSFetchRequest<Notebook> = Notebook.fetchRequest()
        fetchRequest.predicate = predicate
        
        let sort = NSSortDescriptor(key: #keyPath(Notebook.creationDate), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        fetchRequest.fetchBatchSize = 20
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    // Se hace uno nuevo para que la tabla observe el actual NSFetchedResultsController con los nuevos valores
    // EL FRC se queda con los valores estaticos observados, entonces cuando lo cambiamos, sigue observando
    // los valores anterior, por lo que hay que 'setearlo'
    private func setNewFetchResultsController(_ newfrc: NSFetchedResultsController<Notebook>) {
        let oldfrc = self.fetchResultsController
        
        if oldfrc != newfrc {
            self.fetchResultsController = newfrc
            newfrc.delegate = self
            
            do {
                try self.fetchResultsController.performFetch()
            } catch let error as NSError {
                print("Could not fetch \(error.localizedDescription)")
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - ReloadView
//    func reloadView() {
//
//        do {
//            dataSource = try managedContext.fetch(Notebook.fetchRequest())
//        }catch let error as NSError {
//            print(error.localizedDescription)
//            dataSource = []
//        }
//
//        self.populateTotalLabel()
//        tableView.reloadData()
//    }
    
    // MARK: - configureSearchController
    func configureSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search Notebook"
        self.navigationItem.searchController = search
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.definesPresentationContext = true
    }
    
    // MARK: - Utils
    func populateTotalLabel(with predicate: NSPredicate = NSPredicate(value: true)) {
        let fetchRequest = NSFetchRequest<NSNumber>(entityName: "Notebook")
        fetchRequest.resultType = .countResultType
        
        fetchRequest.predicate = predicate
        
        do {
            let countResult = try managedContext.fetch(fetchRequest)
            let count = countResult.first?.stringValue
            totalLabel.text = count
        } catch let error as NSError {
            print("Count not fetch: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - IBActions
    @IBAction func addNotebook(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Notebook", message: "Add a new Notebook", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else { return }
            
            // create notebook
            let notebook = Notebook(context: self.managedContext)
            notebook.name = nameToSave
            notebook.creationDate = NSDate()
            
            // save notebook data
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("TODO Error handling")
            }
            
            //self.reloadView()
            self.showAll()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension NotebookListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchResultsController.sections?[section] else { return 0 }
        
        return sectionInfo.numberOfObjects
        //return dataSource.count//model.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Obtenemos el modelo
        let notebook = fetchResultsController.object(at: indexPath)
        
        // Creamos la celda(o nos dan por caché)
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotebookListCell", for: indexPath) as! NotebookViewCell
        
        // sincronizamos vista y modelo
        cell.configure(with: notebook)
        
        // devolvemos la celda
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        guard let notebookToRemove = dataSource[indexPath.row] as? Notebook,
//            editingStyle == .delete
//        else { return }
        guard editingStyle == .delete else { return }
        
        let notebookToRemove = self.fetchResultsController.object(at: indexPath)
        
        // send notebook to remove
        self.managedContext.delete(notebookToRemove)
        
        // save managed Context
        do {
          try self.managedContext.save()
            //tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
        
//        self.reloadView()
        self.showAll()
    }
}

// MARK: - UITableViewDelegate
extension NotebookListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // obtenemos el modelo
//        let notebook = dataSource[indexPath.row] as! Notebook
        let notebook = self.fetchResultsController.object(at: indexPath)
        
        // mostramos el controlador de notas
//        let noteListViewController = NoteListViewController(notebook: notebook, managedContext: self.managedContext)
        
        let noteListViewController = NewNoteListViewController(notebook: notebook, managedContext: self.managedContext)

        self.show(noteListViewController, sender: nil)
    }
}

extension NotebookListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            // mostramos resultados filtrados
            self.showFilteredResults(with: text)
        } else {
            // mostramos todos los resultados
            self.showAll()
        }
    }
    
    private func showFilteredResults(with query: String) {
//        let fetchRequest = NSFetchRequest<Notebook>(entityName: "Notebook")
//        fetchRequest.resultType = .managedObjectResultType
//
//        let predicate = NSPredicate(format: "name CONTAINS[c] %@", query)
//        fetchRequest.predicate = predicate
//
//        do {
//            self.dataSource = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch \(error.localizedDescription)")
//            self.dataSource = []
//        }
//
//        populateTotalLabel(with: predicate)
        
        let predicate = NSPredicate(format: "name CONTAINS[c] %@", query)
        let frc = getFetchResultsController(with: predicate)
        
        setNewFetchResultsController(frc)
        
        populateTotalLabel(with: predicate)
    }
    
    private func showAll() {
        
//        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: Notebook.fetchRequest()) { [weak self] result in
//            guard let notebooks = result.finalResult else {
//                self?.dataSource = []
//                return
//            }
//
//            self?.dataSource = notebooks
//        }
//
//        do {
////            self.dataSource = try managedContext.fetch(asyncFetchRequest)
//            try self.managedContext.execute(asyncFetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch \(error.localizedDescription)")
//            self.dataSource = []
//        }
        
        // Actualizamos el fetchResultsController por cada busqueda de SearchController
        let frc = getFetchResultsController()
        setNewFetchResultsController(frc)
        
        do {
            try self.fetchResultsController.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error.localizedDescription)")
        }
        
        populateTotalLabel()
    }
}

extension NotebookListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
   
}
