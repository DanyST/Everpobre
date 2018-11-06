//
//  SwitchViewController.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 06-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import UIKit

class SwitchViewController: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var viewForControllers: UIView!
    @IBOutlet weak var segmentedView: UISegmentedControl!
    
    // MARK: - Properties
    let notebook: Notebook
    let coreDataStack: CoreDataStack
    
    private lazy var noteListViewController: NewNoteListViewController = {
        
        // Instantiate View Controller
        var viewController = NewNoteListViewController(notebook: notebook, coreDataStack: coreDataStack)
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var noteMapViewController: NoteMapViewController = {
        
        // Instantiate View Controller
        var viewController = NoteMapViewController(model: (notebook.notes?.array as? [Note]) ?? [])
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    // MARK: - Initialization
    init(notebook: Notebook, coreDataStack: CoreDataStack) {
        self.notebook = notebook
        self.coreDataStack = coreDataStack
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup view
        self.setupView()
        
        // Añadimos los botones
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        
        self.navigationItem.rightBarButtonItem = addButtonItem
    }

    // MARK: - IBActions
    @IBAction func switchViewControllers(_ sender: Any) {
        updateView()
    }
    
    @objc func addNote() {
        let newNoteVC = NoteDetailViewController(kind: .new(notebook: notebook), managedContext: coreDataStack.managedContext)
        newNoteVC.delegate = self
        let navVC = UINavigationController(rootViewController: newNoteVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    private func add(asChildViewController viewController: UIViewController) {
        
        // Add Child View Controller
        addChild(viewController)

        
        // Add Child View as Subview
        viewForControllers.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = viewForControllers.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func updateView() {
        if segmentedView.selectedSegmentIndex == 0 {
            remove(asChildViewController: noteMapViewController)
            add(asChildViewController: noteListViewController)
            self.title = "Notes"
        } else {
            remove(asChildViewController: noteListViewController)
            add(asChildViewController: noteMapViewController)
             self.title = "Notes Map"
        }
    }
    
    func setupView() {
        updateView()
    }

}

// MARK: - NoteDetailViewControllerDelegate
extension SwitchViewController: NoteDetailViewControllerDelegate {
    func noteDetailViewController(_ vc: NoteDetailViewController, didSaveNote note: Note) {
        // Core Data actualiza automagicamente las notas
        noteListViewController.model = (notebook.notes?.array as? [Note]) ?? []
        noteMapViewController.model = (notebook.notes?.array as? [Note]) ?? []
    }
}
