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
  
  static var positions: [String : Int] = [Cat.name : 0, Cat.registration : 1, Cat.title : 2, Cat.birthDate : 3, Cat.breed : 4, Cat.exhibitor : 5, Cat.challenge : 6, Cat.colour : 7, Cat.sire : 8, Cat.breeder : 9, Cat.sex : 10, Cat.dam : 11]
  
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
  
  convenience init(catData: [String : AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    let catEntity = NSEntityDescription.entityForName(Cat.entity, inManagedObjectContext: context!)
    if catEntity == nil {
      print("Cannot create new cat entity")
      abort()
    } else {
      self.init(entity: catEntity!, insertIntoManagedObjectContext: context)
      self.setValuesTo(catData)
    }
  }
  
  convenience init(array: [String], insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    let catEntity = NSEntityDescription.entityForName(Cat.entity, inManagedObjectContext: context!)
    if catEntity == nil {
      print("Cannot create new cat entity")
      abort()
    } else {
      print("Creating new cat entity")
      self.init(entity: catEntity!, insertIntoManagedObjectContext: context)
      for property in Cat.properties {
        switch property {
        case Cat.birthDate:
          let dateFormatter = NSDateFormatter()
          dateFormatter.dateFormat = "dd/MM/yy"
          let dateString = array[Cat.positions[Cat.birthDate]!]
          self.birthDate = dateFormatter.dateFromString(dateString)!
        case Cat.vaccinated:
          self.vaccinated = false
        case Cat.title:
          if array[Cat.positions[property]!] == "(null)" {
            self.title = ""
          } else {
            self.title = array[Cat.positions[property]!]
          }
        default:
          setValue(array[Cat.positions[property]!], forKey: property)
        }
      }
    }
  }
  
  func setValuesTo(entryData: [String : AnyObject]) {
    for key in Cat.properties {
      if let value = entryData[key] {
        setValue(value, forKey: key)
      }
    }
  }
  
  override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    print("Cat given undefined key: \(key)")
  }
  
  func dictionary()  -> NSDictionary {
    return self.dictionaryWithValuesForKeys(Show.properties)
  }
  
  var prefix: String {
    let parts = self.name.componentsSeparatedByString(" ")
    let first = parts.first
    return first ?? ""
  }
  
  // ************************
  // MARK: - YES/NO queries
  // ************************
  
  var registrationIsPending: Bool {
    return self.registration.caseInsensitiveCompare("Pending") == NSComparisonResult.OrderedSame
  }
  
  var isKitten: Bool {
    if let showDate = Globals.currentShow?.date {
      let ageInMonths = showDate.monthsDifferenceTo(self.birthDate)
      return ageInMonths < 9
    } else {
      return false
    }
  }
  
  var isEntire: Bool {
    return Sex.isEntire(self.sex) ?? false
  }
  
  var isCompanion: Bool {
    return !Breeds.nonPedigreeBreed(self.breed)
  }
  
  var isAgouti: Bool {
    return self.agoutiRank > -1
  }
  
  var isMale: Bool {
    return (Sex.rankOf(self.sex) % 2 != 0)
  }
 
  // *************************
  // MARK: - String queries
  // *************************
  
  var gender: String {
    if self.isKitten { return Challenges.nameOf(.kitten) }
    return self.sex
  }
  
  var group: String {
    return Breeds.nameOfGroupForBreed(self.breed)
  }
  
  var ageCategory: String {
    if Globals.kittenGroups.count < 3 {
      fatalError("There are \(Globals.kittenGroups.count) kitten age groups instead of 3")
    }
    let m = ageInMonths
    if m < Globals.kittenGroups[0] {
      return "under \(Globals.kittenGroups[0]) mths"
    }
    if m < Globals.kittenGroups[1] {
      return "under \(Globals.kittenGroups[1]) mths"
    }
    return "under \(Globals.kittenGroups[2]) mths"
  }
  
  var age: String {
    if let showDate = Globals.currentShow?.date {
      return self.birthDate.differenceInMonthsAndYears(showDate)
    }
    fatalError("Could not determine cat: \(self.name)'s age")
  }
  
  // *************************
  // MARK: - Ranking queries
  // *************************
  
  var groupNumber: Int {
    return Breeds.groupNumberOf(self.breed) ?? -1
  }
  
  var section: String {
    if self.isCompanion { return "Companion" }
    if self.isKitten { return "Kitten" }
    if self.isEntire { return "Entire" }
    return "Desexed"
  }
  
  var breedRank: Int {
    return Breeds.rankOf(self.breed) ?? 999
  }
  
  var agoutiRank: Int {
    if let ans = Globals.agoutiClasses.indexOf(self.breed) {
      return ans
    } else {
      return -1
    }
  }
  
  var colourRank: Int {
    
    if let ans = Colours.rankOf(self.colour, forBreed: self.breed) {
      return ans
    } else {
      return 999
    }
  }
  
  var ageRank: Int {
    if let showDate = Globals.currentShow?.date {
      let catAge = showDate.monthsDifferenceTo(self.birthDate)
      let ages = Globals.kittenGroups
      for age in ages {
        if catAge < age {
          return age
        }
      }
    }
    return 999
  }
  
  var ageInMonths: Int {
    if let showDate = Globals.currentShow?.date {
      return showDate.monthsDifferenceTo(self.birthDate)
    }
    return 0
  }
  
  var sexRank: Int {
    return Sex.rankOf(self.sex) ?? 999
  }
  
  // *************************
  // MARK: - Cat comparision
  // *************************
  
  func compareWith(anotherCat: Cat) -> NSComparisonResult {
    
    // first compare on group
    // ----------------------
    if self.groupNumber < anotherCat.groupNumber {
      return .OrderedAscending
    }
    if self.groupNumber > anotherCat.groupNumber {
      return .OrderedDescending
    }
    
    // then compare on section<kitten, entire, desexed>
    // -------------------------------------------------
    if self.section < anotherCat.section {
      return .OrderedAscending
    }
    if self.section > anotherCat.section {
      return .OrderedDescending
    }
    
    // then compare on breed
    // ----------------------
    if self.breedRank < anotherCat.breedRank {
      return .OrderedAscending
    }
    if self.breedRank > anotherCat.breedRank {
      return .OrderedDescending
    }
    
    // then on agouti (if agouti)
    // --------------------------
    if self.agoutiRank < anotherCat.agoutiRank {
      return .OrderedAscending
    }
    if self.agoutiRank > anotherCat.agoutiRank {
      return .OrderedDescending
    }
    
    // then on colour
    // --------------
    if self.colourRank < anotherCat.colourRank {
      return .OrderedAscending
    }
    if self.colourRank > anotherCat.colourRank {
      return .OrderedDescending
    }
    
    // then on age ranking
    // --------------------
    if self.ageRank < anotherCat.ageRank {
      return .OrderedAscending
    }
    if self.ageRank > anotherCat.ageRank {
      return .OrderedDescending
    }
    
    // then on <male>, <female>, <neuter>, <spay>
    // -------------------------------------------
    if self.sexRank < anotherCat.sexRank {
      return .OrderedAscending
    }
    if self.sexRank > anotherCat.sexRank {
      return .OrderedDescending
    }
    
    // then on age
    // ------------
    let comparison = self.birthDate.compare(anotherCat.birthDate)
    switch comparison {
    case .OrderedAscending, .OrderedDescending:
      return comparison
    default:
      break
    }
    
    //lastly on name
    return self.name.caseInsensitiveCompare(anotherCat.name)
  }
}

