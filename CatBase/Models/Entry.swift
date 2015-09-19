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
  
  private static var rings = ["ring1", "ring2", "ring3", "ring4", "ring5", "ring6"]
  
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
  
  
  @NSManaged private(set) var cageSize: NSNumber
  @NSManaged private(set) var catalogueRequired: NSNumber
  @NSManaged private(set) var hireCage: NSNumber
  @NSManaged private(set) var litterCage: NSNumber
  @NSManaged private(set) var ring1: NSNumber
  @NSManaged private(set) var ring2: NSNumber
  @NSManaged private(set) var ring3: NSNumber
  @NSManaged private(set) var ring4: NSNumber
  @NSManaged private(set) var ring5: NSNumber
  @NSManaged private(set) var ring6: NSNumber
  @NSManaged private(set) var willWork: NSNumber
  @NSManaged private(set) var cat: Cat
  @NSManaged private(set) var show: Show
  
  
  override var description: String {
      return "\(self.cat.name)  \(self.cat.breed)"
  }
  
  dynamic var name: String {
    return cat.name
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

  
  // **********************************
  // MARK: - Changing property values
  // **********************************
  
  override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    print("Entry given undefined key: \(key)")
  }
  
  func setCageToSmall() {
    cageSize = NSNumber(integer: 0)
  }
  
  var litter: Bool {
    get {
      return self.litterCage.boolValue
    }
    set {
     self.litterCage = NSNumber(bool: newValue)
      if let size = Globals.cageTypes.sizes.last where newValue {
        cageSize = size
      }
    }
  }
  
  private func setValuesTo(entryData: [String : AnyObject]) {
    for key in Entry.properties {
      if let value = entryData[key] {
        setValue(value, forKey: key)
      }
      
    }
  }
  
  func updateTo(entryData: [String : AnyObject]) {
    self.setValuesTo(entryData)
    self.cat.setValuesTo(entryData)
  }
  
  func dictionary()  -> [String : AnyObject] {
    return self.dictionaryWithValuesForKeys(Show.properties)
  }
  
  
  // **********************************
  // MARK: - Queries about the Entry
  // **********************************
  
  var isInLitter: Bool {
      return litterCage.boolValue
  }
  
  func isInLitter(litter: Litter) -> Bool {
    
    // ** must not be a companion
    if cat.isCompanion { return false }
    
    // ** must be a kitten
    if !cat.isKitten { return false }
    
    // ** must have the same birthdate
    if !cat.birthDate.isEqualToDate(litter.birthDate) { return false}
    
    // ** must have the same sire
    if cat.sire != litter.sire { return false }
    
    // ** must have the same dam
    if cat.dam != litter.dam { return false }
    
    // if all are true, kitten is part of this litter
    return true
  }
  
  var isLitterKitten: Bool {
    if Breeds.nonPedigreeBreed(cat.breed) { return false }
    if !cat.isKitten { return false }
    return isInLitter
  }
  
  var typeOfCage: String {
    if let index = Globals.cageTypes.sizes.indexOf(self.cageSize.integerValue) {
      return Globals.cageTypes.names[index]
    }
    return Globals.cageTypes.names[0]
  }
  
  var rings: String {
    var ans = ""
    var count = 1
    for ring in Entry.rings {
      if let inThisRing = self.valueForKey(ring) as? NSNumber {
        if inThisRing.boolValue {
          ans += "\(count)"
        }
      }
      count++
    }
    return ans
  }
  
  func inRing(ring: Int) -> Bool {
    if let inThisRing = self.valueForKey(Entry.rings[ring - 1]) as? NSNumber {
      return inThisRing.boolValue
    }
    return false
  }
 
  func differentBreedTo(other: Entry?) -> Bool {
    guard let other = other
      else { return true }
    return self.cat.breed != other.cat.breed
  }
  
  func newBreedTo(other: Entry?) -> Bool {
     return !self.cat.isCompanion && self.differentBreedTo(other)
  }
  
  func newAgoutiTo(other: Entry? ) -> Bool {
    if !cat.isAgouti { return false }
    guard let other = other
      else { return true }
    if differentBreedTo(other) { return true }
    return cat.agoutiRank != other.cat.agoutiRank
  }
  
  // return true if other is different breed or colour
  // not concerned about agouti type
  func newColourTo(other: Entry?) -> Bool {
    guard let other = other
      else { return true }
    if differentBreedTo(other) { return true }
    return self.cat.colour != other.cat.colour
  }
  
  // return true if other is different challenge colour
  // takes agouti type into account
  func newChallengeColourTo(other: Entry?) -> Bool {
    guard let other = other
      else { return true }
    if differentBreedTo(other) { return true }
    if cat.isAgouti { return cat.agoutiRank != other.cat.agoutiRank }
    return self.cat.colour != other.cat.colour
  }
  
  func compareWith(anotherEntry: Entry) -> NSComparisonResult {
    return self.cat.compareWith(anotherEntry.cat)
  }
  
  func inDifferentSectionTo(other: Entry?) -> Bool {
    guard let other = other
      else { return true }
    return self.cat.section != other.cat.section
  }
}
