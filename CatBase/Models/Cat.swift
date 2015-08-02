//
//  Cat.swift
//  
//
//  Created by John Sandercock on 2/08/2015.
//
//

import Foundation
import CoreData

struct CatRecord {
  var birthDate       = NSDate()
  var breed           = ""
  var breeder         = ""
  var challenge       = ""
  var colour          = ""
  var dam             = ""
  var exhibitor       = ""
  var name            = ""
  var registration    = ""
  var sex             = ""
  var sire            = ""
  var title           = ""
  var vaccinated      = NSNumber(bool: false)

}


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
  
  convenience init(catData: CatRecord, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    let catEntity = NSEntityDescription.entityForName(Cat.entity, inManagedObjectContext: context!)
    if catEntity == nil {
      println("Cannot create new cat entity")
      abort()
    } else {
      self.init(entity: catEntity!, insertIntoManagedObjectContext: context)
      self.birthDate = catData.birthDate
      self.breed = catData.breed
      self.breeder = catData.breeder
      self.challenge = catData.challenge
      self.colour = catData.colour
      self.dam = catData.dam
      self.exhibitor = catData.exhibitor
      self.name = catData.name
      self.registration = catData.registration
      self.sex = catData.sex
      self.sire = catData.sire
      self.title = catData.title
      self.vaccinated = catData.vaccinated
    }
  }
}


