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
        
        // find and delete any Cat entities with the same registration (bar Pending)
        // -------------------------------------------------------------------------
        let registration = entryData[Cat.registration] as! String
        if registration != pending {
          let fetchResult = fetchEntitiesNamed(Cat.entity, inContext: context, usingFormat: "\(Cat.registration) LIKE[c] '\(registration)'")
          for object in fetchResult {
            context.deleteObject(object)
          }
        }
        
        // find and delete any Cat entities with the same name
        // ----------------------------------------------------
        let name = entryData[Cat.name] as! String
        let fetchResult = fetchEntitiesNamed(Cat.entity, inContext: context, usingFormat: "\(Cat.name) LIKE[c] '\(name)'")
        for object in fetchResult {
          context.deleteObject(object)
        }
        
        // create a new cat and set it as this entry's cat
        // -----------------------------------------------
        let newCat = Cat(catData: entryData, insertIntoManagedObjectContext: context)
        self.cat = newCat
      }
    } else {
      fatalError("Database corrupt - cannot load managedObjectContext")
    }
  }
  
  func fetchEntitiesNamed(entityName: String, inContext context:NSManagedObjectContext, usingFormat format: String) -> [NSManagedObject] {
    let fetchRequest = NSFetchRequest(entityName: entityName)
    fetchRequest.predicate = NSPredicate(format: format)
    let fetchResult: [NSManagedObject]
    do {
      fetchResult = try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
    } catch {
      print("\n** Error in fetch request **\n")
      fetchResult = []
    }
    print("****\nFetched these entities")
    print(fetchResult)
    print("")
    return fetchResult
  }
  
  override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    print("Entry given undefined key: \(key)")
  }
  
  func setValuesTo(entryData: [String : AnyObject]) {
    for key in Entry.properties {
      print("setting Entry property: \(key) ", appendNewline: false)
      if let value = entryData[key] {
        print("to: \(value)")
        setValue(value, forKey: key)
      }
      
    }
  }
  
  func dictionary()  -> [String : AnyObject] {
    return self.dictionaryWithValuesForKeys(Show.properties)
  }

}
