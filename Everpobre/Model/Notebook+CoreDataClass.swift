//
//  Notebook+CoreDataClass.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 04-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Notebook)
public class Notebook: NSManagedObject {
    
    func csv() -> String {
        let exportedName = name ?? "Without Name"
        let exportedCreationDate = (creationDate as Date?)?.creationStringLabel() ?? "ND"
        
        return "\(exportedCreationDate),\(exportedName)"
    }
}
