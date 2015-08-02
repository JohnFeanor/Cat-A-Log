//
//  Entry.swift
//  
//
//  Created by John Sandercock on 2/08/2015.
//
//

import Foundation
import CoreData

class Entry: NSManagedObject {

    @NSManaged var cageSize: NSNumber
    @NSManaged var catalogueRequired: NSNumber
    @NSManaged var hireCage: NSNumber
    @NSManaged var ring1: NSNumber
    @NSManaged var ring2: NSNumber
    @NSManaged var ring3: NSNumber
    @NSManaged var ring4: NSNumber
    @NSManaged var ring5: NSNumber
    @NSManaged var ring6: NSNumber
    @NSManaged var toBeDeleted: NSNumber
    @NSManaged var willWork: NSNumber
    @NSManaged var cat: Cat?
    @NSManaged var litter: Litter?
    @NSManaged var show: Show

}
