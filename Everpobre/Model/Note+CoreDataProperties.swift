//
//  Note+CoreDataProperties.swift
//  Everpobre
//
//  Created by Luis Herrera Lillo on 05-11-18.
//  Copyright © 2018 Luis Herrera Lillo. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var creationDate: NSDate?
    @NSManaged public var lastSeenDate: NSDate?
    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var image: NSData?
    @NSManaged public var notebook: Notebook?

}
