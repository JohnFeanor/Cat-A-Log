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
  static var properties = [Entry.cageSize, Entry.catalogueRequired, Entry.hireCage, Entry.litterCage, Entry.ring1, Entry.ring2, Entry.ring3, Entry.ring4, Entry.ring5, Entry.ring6, Entry.willWork]
  
  static var cageSize           = "cageSize"
  static var catalogueRequired  = "catalogueRequired"
  static var hireCage           = "hireCage"
  static var litterCage         = "litterCage"
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
  @NSManaged var litterCage: NSNumber
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
  
  dynamic var count: Int {
    get {
      print("?? someone trying to count Entry \(cat?.name)")
      return 1
    }
    set {
      print("?? someone trying to set the count in Entry")
    }
  }
  
  convenience init(entryData: [String : AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    if let context = context {
      let entryEntity = NSEntityDescription.entityForName(Entry.entity, inManagedObjectContext: context)
      if entryEntity == nil {
        print("Cannot create new entry entity")
        abort()
      } else {
        self.init(entity: entryEntity!, insertIntoManagedObjectContext: context)
        self.setValuesTo(entryData)
        
        // find any cats with the same registration (unless pending)
        let registration = entryData[Cat.registration] as! String
        let name = entryData[Cat.name] as! String
        
        if let existingCats = existingCatsWithRegistration(registration, orName: name, inContext: context) {
          // set the first found cat to these new values
          // -------------------------------------------
          let existingCat = existingCats.first!
          existingCat.setValuesTo(entryData)
          self.cat = existingCat
          
          // delete any other found cats
          // ---------------------------
          let excessCats = existingCats.count - 1
          if excessCats > 0 {
            for i in 1 ... excessCats {
              context.deleteObject(existingCats[i])
            }
          }
          print("deleted \(excessCats) cats from database")
        } else {
          let newCat = Cat(catData: entryData, insertIntoManagedObjectContext: context)
          self.cat = newCat
        }
      }
    } else {
      fatalError("Database corrupt - cannot load managedObjectContext")
    }
  }
  
  override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    print("Entry given undefined key: \(key)")
  }
  
  private func setValuesTo(entryData: [String : AnyObject]) {
    for key in Entry.properties {
      print("setting Entry property: \(key) ", terminator: "")
      if let value = entryData[key] {
        print("to: \(value)")
        setValue(value, forKey: key)
      }
      
    }
  }
  
  func updateTo(entryData: [String : AnyObject]) {
    self.setValuesTo(entryData)
    self.cat?.setValuesTo(entryData)
  }
  
  func dictionary()  -> [String : AnyObject] {
    return self.dictionaryWithValuesForKeys(Show.properties)
  }
  
}
