//
//  Note+CoreDataClass.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 04-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit

@objc(Note)
public class Note: NSManagedObject {

}

extension Note {
    
    func csv() -> String {
        let exportedTitle = title ?? "Without Title"
        let exportedText = text ?? ""
        let exportedCreationDate = (creationDate as Date?)?.creationStringLabel() ?? "ND"
        
        return "\(exportedCreationDate),\(exportedTitle),\(exportedText)"
    }
}

extension Note: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: location?.latitude ?? 0, longitude: location?.longitude ?? 0)
    }
}
