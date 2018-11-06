//
//  NoteMapViewController.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 05-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//

import UIKit
import MapKit

class NoteMapViewController: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var model: [Note] {
        didSet {
           self.mapView.addAnnotations(self.model)
        }
    }
    let locationManager = CLLocationManager()
    
    init(model: [Note]) {
        // nos encargamos de nuestras propias propiedades
        let filteredModel = model.filter { $0.location != nil }
        
        self.model = filteredModel
        
        // llamamos a super
        super.init(nibName: nil, bundle: nil)
        
        // propiedades de la super clase
        self.title = "Note Maps"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // Mark: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // asignamos delegados
        self.mapView.delegate = self
        locationManager.delegate = self
        
        locationManager.requestLocation()
    }

}

// MARK: - MKMapViewDelegate
extension NoteMapViewController: MKMapViewDelegate {
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        mapView.addAnnotations(self.model)
    }
}

// MARK: - CLLocationManagerDelegate
extension NoteMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last?.coordinate else { return }
        
        self.mapView.setCenter(CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
