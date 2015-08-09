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
  
  static var entity = "Entry"
  static var properties = [Entry.cageSize, Entry.catalogueRequired, Entry.hireCage, Entry.ring1, Entry.ring2, Entry.ring3, Entry.ring4, Entry.ring5, Entry.ring6, Entry.willWork]
  
  static var cageSize           = "cageSize"
  static var catalogueRequired  = "catalogueRequired"
  static var hireCage           = "hireCage"
  static var ring1              = "ring1"
  static var ring2              = "ring2"
  static var ring3              = "ring3"
  static var ring4              = "ring4"
  static var ring5              = "ring5"
  static var ring6              = "ring6"
  static var willWork           = "willWork"
  
  
  @NSManaged var cageSize: NSNumber
  @NSManaged var catalogueRequired: NSNumber
  @NSManaged var hireCage: NSNumber
  @NSManaged var ring1: NSNumber
  @NSManaged var ring2: NSNumber
  @NSManaged var ring3: NSNumber
  @NSManaged var ring4: NSNumber
  @NSManaged var ring5: NSNumber
  @NSManaged var ring6: NSNumber
  @NSManaged var willWork: NSNumber
  @NSManaged var cat: Cat?
  @NSManaged var litter: Litter?
  @NSManaged var show: Show
  
  convenience init(entryData: NSDictionary, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    let entryEntity = NSEntityDescription.entityForName(Entry.entity, inManagedObjectContext: context!)
    if entryEntity == nil {
      print("Cannot create new entry entity")
      abort()
    } else {
      self.init(entity: entryEntity!, insertIntoManagedObjectContext: context)
      self.setValuesTo(entryData)
    }
  }
  
  func setValuesTo(entryData: NSDictionary) {
    self.setValuesForKeysWithDictionary(entryData as! [String : AnyObject])
  }
  
  func dictionary()  -> NSDictionary {
    return self.dictionaryWithValuesForKeys(Show.properties)
  }

}
