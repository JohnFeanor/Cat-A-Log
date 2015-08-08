//
//  Cat.swift
//  
//
//  Created by John Sandercock on 2/08/2015.
//
//

import Foundation
import CoreData

class Cat: NSManagedObject {
  
  static var entity = "Cat"
  static var properties = [Cat.birthDate, Cat.breed, Cat.breeder, Cat.challenge, Cat.colour, Cat.dam, Cat.exhibitor, Cat.name, Cat.registration, Cat.sex, Cat.sire, Cat.title, Cat.vaccinated]
  
  static var birthDate    = "birthDate"
  static var breed        = "breed"
  static var breeder      = "breeder"
  static var challenge    = "challenge"
  static var colour       = "colour"
  static var dam          = "dam"
  static var exhibitor    = "exhibitor"
  static var name         = "name"
  static var registration = "registration"
  static var sex          = "sex"
  static var sire         = "sire"
  static var title        = "title"
  static var vaccinated   = "vaccinated"
  
  @NSManaged var birthDate: NSDate
  @NSManaged var breed: String
  @NSManaged var breeder: String
  @NSManaged var challenge: String
  @NSManaged var colour: String
  @NSManaged var dam: String
  @NSManaged var exhibitor: String
  @NSManaged var name: String
  @NSManaged var registration: String
  @NSManaged var sex: String
  @NSManaged var sire: String
  @NSManaged var title: String
  @NSManaged var vaccinated: NSNumber
  @NSManaged var entries: NSSet?
  
  convenience init(catData: NSDictionary, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    let catEntity = NSEntityDescription.entityForName(Cat.entity, inManagedObjectContext: context!)
    if catEntity == nil {
      print("Cannot create new cat entity")
      abort()
    } else {
      self.init(entity: catEntity!, insertIntoManagedObjectContext: context)
      self.setValuesTo(catData)
    }
  }

  func setValuesTo(catData: NSDictionary) {
    self.setValuesForKeysWithDictionary(catData as! [String : AnyObject])
  }
  
  func dictionary()  -> NSDictionary {
    return self.dictionaryWithValuesForKeys(Show.properties)
  }

  // MARK: - YES/NO queries
  
  var registrationPending: Bool {
    return self.registration.caseInsensitiveCompare("Pending") == NSComparisonResult.OrderedSame
  }
}


