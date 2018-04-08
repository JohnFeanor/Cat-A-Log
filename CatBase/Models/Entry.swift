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
  
  @objc static var nomen = "Entry"
  @objc static var properties = [Entry.cageSize, Entry.catalogueRequired, Entry.hireCage, Entry.litterCage, Entry.ring1, Entry.ring2, Entry.ring3, Entry.ring4, Entry.ring5, Entry.ring6, Entry.willWork]
  
  fileprivate static var rings = ["ring1", "ring2", "ring3", "ring4", "ring5", "ring6"]
  
  @objc static var cageSize           = "cageSize"
  @objc static var catalogueRequired  = "catalogueRequired"
  @objc static var hireCage           = "hireCage"
  @objc static var litterCage         = "litterCage"
  @objc static var ring1              = "ring1"
  @objc static var ring2              = "ring2"
  @objc static var ring3              = "ring3"
  @objc static var ring4              = "ring4"
  @objc static var ring5              = "ring5"
  @objc static var ring6              = "ring6"
  @objc static var willWork           = "willWork"
  
  
  @NSManaged fileprivate(set) var cageSize: NSNumber
  @NSManaged fileprivate(set) var catalogueRequired: NSNumber
  @NSManaged fileprivate(set) var hireCage: NSNumber
  @NSManaged fileprivate(set) var litterCage: NSNumber
  @NSManaged fileprivate(set) var ring1: NSNumber
  @NSManaged fileprivate(set) var ring2: NSNumber
  @NSManaged fileprivate(set) var ring3: NSNumber
  @NSManaged fileprivate(set) var ring4: NSNumber
  @NSManaged fileprivate(set) var ring5: NSNumber
  @NSManaged fileprivate(set) var ring6: NSNumber
  @NSManaged fileprivate(set) var willWork: NSNumber
  @NSManaged fileprivate(set) var cat: Cat
  @NSManaged fileprivate(set) var show: Show
  
  
  override var description: String {
      return "\(self.cat.name)  \(self.cat.breed)"
  }
  
  @objc dynamic var name: String {
    return cat.name
  }
  
  @objc dynamic var breed: String {
    return cat.breed
  }
  
  @objc convenience init(entryData: [String : AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    if let context = context {
      let entryEntity = NSEntityDescription.entity(forEntityName: Entry.nomen, in: context)
      if entryEntity == nil {
        print("Cannot create new entry entity")
        abort()
      } else {
        self.init(entity: entryEntity!, insertInto: context)
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
              context.delete(existingCats[i])
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
  
  override func setValue(_ value: Any?, forUndefinedKey key: String) {
    print("Entry given undefined key: \(key)")
  }
  
  @objc func setCageToSmall() {
    cageSize = NSNumber(value: 0 as Int)
  }
  
  @objc var litter: Bool {
    get {
      return self.litterCage.boolValue
    }
    set {
     self.litterCage = NSNumber(value: newValue as Bool)
      if let size = Globals.cageTypes.sizes.last {
        cageSize = NSNumber(value: size)
      }
//      if let size = Globals.cageTypes.sizes.last as Int? {
//        cageSize = NSNumber(size!)
//      }
    }
  }
  
  fileprivate func setValuesTo(_ entryData: [String : AnyObject]) {
    for key in Entry.properties {
      if let value = entryData[key] {
        setValue(value, forKey: key)
      }
    }
  }
  
  @objc func updateTo(_ entryData: [String : AnyObject]) {
    self.setValuesTo(entryData)
    self.cat.setValuesTo(entryData)
  }
  
  @objc func dictionary()  -> [String : AnyObject] {
    return self.dictionaryWithValues(forKeys: Show.properties) as [String : AnyObject]
  }
  
  
  // **********************************
  // MARK: - Queries about the Entry
  // **********************************
  
  @objc var isInLitter: Bool {
    return litterCage.boolValue
  }
  
  func isInLitter(_ litter: Litter) -> Bool {
    
    // ** must not be a companion
    if cat.isCompanion { return false }
    
    // ** must be a kitten
    if !cat.isKitten { return false }
    
    // ** must have the same birthdate
    if cat.birthDate != litter.birthDate { return false}
    
    // ** must have the same sire
    if cat.sire != litter.sire { return false }
    
    // ** must have the same dam
    if cat.dam != litter.dam { return false }
    
    // if all are true, kitten is part of this litter
    return true
  }
  
  @objc var isKittenClass: Bool {
    if Breeds.nonPedigreeBreed(cat.breed) { return false }
    if !cat.isKitten { return false }
    return true
  }
  
  @objc var typeOfCage: String {
    if self.hireCage.boolValue {
      return Globals.cageTypes.names[_hireCageNumber]
    }
    if let index = Globals.cageTypes.sizes.index(of: self.cageSize.intValue) {
      return Globals.cageTypes.names[index]
    }
    return Globals.cageTypes.names[0]
  }
  
  @objc var rings: String {
    var ans = ""
    var count = 1
    for ring in Entry.rings {
      if let inThisRing = self.value(forKey: ring) as? NSNumber {
        if inThisRing.boolValue {
          ans += "\(count)"
        }
      }
      count += 1
    }
    return ans
  }
  
  @objc func inRing(_ ring: Int) -> Bool {
    if let inThisRing = self.value(forKey: Entry.rings[ring - 1]) as? NSNumber {
      return inThisRing.boolValue
    }
    return false
  }
 
  @objc func differentBreedTo(_ other: Entry?) -> Bool {
    guard let other = other
      else { return true }
    return self.cat.breed != other.cat.breed
  }
  
  @objc func newBreedTo(_ other: Entry?) -> Bool {
    if self.inDifferentSectionTo(other) { return true }
     return !self.cat.isCompanion && self.differentBreedTo(other)
  }
  
  @objc func newJudgingVarietyTo(_ other: Entry? ) -> Bool {
    guard let other = other
      else { return true }
    if differentBreedTo(other) { return true }
    return cat.judgingVariety != other.cat.judgingVariety
  }
  
  // return true if other is different breed or colour
  // not concerned about agouti type
  @objc func newColourTo(_ other: Entry?) -> Bool {
    guard let other = other
      else { return true }
    if differentBreedTo(other) { return true }
    return self.cat.colour != other.cat.colour
  }
  
  // return true if other is different challenge colour
  // takes agouti type into account
  @objc func newColourOrBreedTo(_ other: Entry?) -> Bool {
    guard let other = other
      else { return true }
    if differentBreedTo(other) { return true }
    return self.cat.colour != other.cat.colour
  }
  
  // return true if other is different challenge colour
  // takes agouti type into account
  @objc func newChallengeColourTo(_ other: Entry?) -> Bool {
    guard let other = other
      else { return true }
    if differentBreedTo(other) { return true }
    if self.cat.isMale {
      if !other.cat.isMale { return true }
    } else {
      if other.cat.isMale { return true }
    }
    if cat.isLimited { return cat.judgingVariety != other.cat.judgingVariety }
    return self.cat.colour != other.cat.colour
  }
  
  @objc func compareWith(_ anotherEntry: Entry) -> ComparisonResult {
    return self.cat.compareWith(anotherEntry.cat)
  }
  
  @objc func inDifferentSectionTo(_ other: Entry?) -> Bool {
    guard let other = other
      else { return true }
    if cat.isCompanion { return !other.cat.isCompanion }
    return self.cat.section != other.cat.section
  }
  
  @objc func inDifferentGroupTo(_ other: Entry?) -> Bool {
    guard let other = other
      else { return true }
    return Breeds.groupNumberOf(self.cat.breed) != Breeds.groupNumberOf(other.cat.breed)
  }
  
  //MARK: - searching queries for NSSearchField
  // --------------------------------------------------
  
  @objc dynamic var ringsEntered: String {
    var ans = ""
    var count = 0
    for ring in Entry.rings {
      count += 1
      if let inRing = self.value(forKey: ring) as? NSNumber {
        if inRing.boolValue { ans.append("\(count)") }
      }
    }
    return ans
  }
  
  @objc dynamic var worker: String {
    if self.willWork.boolValue {
      return "Yes"
    } else {
      return "No"
    }
  }
  
  @objc dynamic var hiring: String {
    if self.hireCage.boolValue {
      return "Yes"
    } else {
      return "No"
    }
  }
  
}
