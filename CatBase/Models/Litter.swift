//
//  Litter.swift
//  
//
//  Created by John Sandercock on 2/08/2015.
//
//

import Foundation
import CoreData

class Litter: NSManagedObject {

    @NSManaged var birthDate: NSDate
    @NSManaged var breed: String
    @NSManaged var breeder: String
    @NSManaged var dam: String
    @NSManaged var exhibitor: String
    @NSManaged var females: NSNumber
    @NSManaged var males: NSNumber
    @NSManaged var name: String
    @NSManaged var neuters: NSNumber
    @NSManaged var sire: String
    @NSManaged var speys: NSNumber
    @NSManaged var entries: NSSet?

}
