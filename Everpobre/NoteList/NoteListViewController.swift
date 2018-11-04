//
//  NoteListViewController.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 04-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import UIKit

class NoteListViewController: UIViewController {
    
    // MARK: - Properties
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    var notes: [Note] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let notebook: Notebook
    
    // MARK: - Initialization
    init(notebook: Notebook) {
        // Nos encargamos de nuestras propias propiedades
        self.notebook = notebook
        
        // llamamos a super
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notes from: \(self.notebook.name)"
        
        setupTableView()
        
        self.notes = notebook.notes
    }
    
    // MARK: - Setup TableView
    func setupTableView() {
        self.tableView.dataSource = self
        
        view.addSubview(self.tableView)
        
        // Add contrains
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
