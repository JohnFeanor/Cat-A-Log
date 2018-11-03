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
  
  enum Category {
    case companion
    case kitten
    case open
    case gold
    case platinum
  }
  
  @objc static var nomen = "Cat"
  @objc static var properties = [Cat.name, Cat.registration, Cat.title, Cat.birthDate, Cat.breed, Cat.breeder, Cat.challenge, Cat.colour, Cat.dam, Cat.exhibitor, Cat.sex, Cat.sire, Cat.vaccinated]
  
  @objc static var positions: [String : Int] = [Cat.name : 0, Cat.registration : 1, Cat.title : 2, Cat.birthDate : 3, Cat.breed : 4, Cat.breeder : 5, Cat.challenge : 6, Cat.colour : 7, Cat.dam : 8, Cat.exhibitor : 9, Cat.sex : 10, Cat.sire : 11]
  
  @objc static var birthDate    = "birthDate"
  @objc static var breed        = "breed"
  @objc static var breeder      = "breeder"
  @objc static var challenge    = "challenge"
  @objc static var colour       = "colour"
  @objc static var dam          = "dam"
  @objc static var exhibitor    = "exhibitor"
  @objc static var name         = "name"
  @objc static var registration = "registration"
  @objc static var sex          = "sex"
  @objc static var sire         = "sire"
  @objc static var title        = "title"
  @objc static var vaccinated   = "vaccinated"
  
  @NSManaged var birthDate: Date
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
  
  @objc convenience init(catData: [String : AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    let catEntity = NSEntityDescription.entity(forEntityName: Cat.nomen, in: context!)
    if catEntity == nil {
      print("Cannot create new cat entity")
      abort()
    } else {
      self.init(entity: catEntity!, insertInto: context)
      self.setValuesTo(catData)
    }
  }
  
  @objc dynamic var birthDateAsString: String {
    let dateFormatter = Foundation.DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yy"
    let date = dateFormatter.string(from: self.birthDate)
    return date
  }
  
  var catString: String {
    var ans: String = ""
    for key in Cat.properties {
      switch key {
      case Cat.birthDate:
        ans.append("\(self.birthDateAsString )\t")
      case Cat.vaccinated:
        break
      default:
        let s = self.value(forKey: key) as? String
        if s != nil && !s!.isEmpty {
          ans.append("\(s!)\t")
        } else {
          ans.append(" \t")
        }
      }
    }
    return ans
  }
  
  @objc convenience init(array: [String], insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    let catEntity = NSEntityDescription.entity(forEntityName: Cat.nomen, in: context!)
    if catEntity == nil {
      fatalError("Cannot create new cat entity")
    } else {
      self.init(entity: catEntity!, insertInto: context)
      for property in Cat.properties {
        switch property {
        case Cat.birthDate:
          let dateFormatter = Foundation.DateFormatter()
          dateFormatter.dateFormat = "dd/MM/yy"
          let dateString = array[Cat.positions[Cat.birthDate]!]
          self.birthDate = dateFormatter.date(from: dateString)!
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
  
  func setValuesTo(_ entryData: [String : AnyObject]) {
    for key in Cat.properties {
      if let value = entryData[key] {
        setValue(value, forKey: key)
      }
    }
  }
  
  func setValuesToArray(_ array: [String]) {
    setValue(array[Cat.positions[Cat.dam]!], forKey: Cat.dam)
    setValue(array[Cat.positions[Cat.sire]!], forKey: Cat.sire)
    setValue(array[Cat.positions[Cat.breeder]!], forKey: Cat.breeder)
    setValue(array[Cat.positions[Cat.exhibitor]!], forKey: Cat.exhibitor)
    
  }
  
  override func setValue(_ value: Any?, forUndefinedKey key: String) {
    print("Cat given undefined key: \(key)")
  }
  
  @objc func dictionary()  -> NSDictionary {
    return self.dictionaryWithValues(forKeys: Show.properties) as NSDictionary
  }
  
  var prefix: String {
    let parts = self.name.components(separatedBy: " ")
    let first = parts.first
    return first ?? ""
  }
  
  // ************************
  // MARK: - YES/NO queries
  // ************************
  
  var registrationIsPending: Bool {
    return self.registration.isPending
  }
  
  @objc var ageinMonths: Int {
    if let showDate = Globals.currentShow?.date {
      let ageInMonths = showDate.monthsDifferenceTo(self.birthDate)
      return ageInMonths
    } else {
      return -1
    }
  }
  
  var isKitten: Bool {
    guard let currentShow = Globals.currentShow
      else { fatalError("CurrentShow is nil when trying to determine if cat is a kitten") }
    return currentShow.isKittenIfBornOn(self.birthDate)
  }
  
  var isEntire: Bool {
    return Sex.isEntire(self.sex) ?? false
  }
  
  var isCompanion: Bool {
    return Breeds.nonPedigree(breed: self.breed)
  }
  
  var isTabby: Bool {
    return colour.lowercased().contains("tabby")
  }
  
  var isMale: Bool {
    guard let rank = Sex.rank(of: self.sex)
      else { return false }
    return (rank % 2 == 0)
  }
  
  var isLimited : Bool {
    if Globals.currentShowType == Affiliation.NSWCFA {
      return false
    }
    return Globals.patternedBreeds.contains(self.breed)
  }
  
  var hasWhite: Bool {
    let color = colour.lowercased()
    if color.contains("& white")    { return true }
    if color.contains("bi-colour") { return true }
    if color.contains("bicolour")  { return true }
    if color.contains("van")       { return true }
    
    return false
  }
  
  
  // *************************
  // MARK: - String queries
  // *************************
  
  var titleAndName: String {
    let ans = title + " " + name
    return ans.condensingWhitespace
  }
  
  var ownerAndBreeder: String {
    if isCompanion { return "Ex:\(exhibitor)" }
    if breeder.caseInsensitiveCompare(exhibitor) == .orderedSame {
      return "Br/Ex:\(breeder)"
    }
    return "Br:\(breeder) Ex:\(exhibitor)"
  }
  
  var parents: String {
    if isCompanion { return "" }
    return sire + " \\'d7 " + dam
  }
  
  var gender: String {
    if self.isKitten { return Challenges.name(ranked: .kitten) }
    return self.sex
  }
  
  var classDetails: String {
    if Globals.organiseKittensByAgeGroups && self.isKitten {
      return "\(sex) Kitten under \(ageRank) months"
    } else if self.isKitten {
      return "\(sex) Kitten"
    }
    return "\(sex) class"
  }
  
  var group: String {
    return Breeds.groupName(for: self.breed)
  }
  
  var subGroup: String {
    return self.group + " " + self.sectionName
  }
  
  var ageCategory: String {
    if Globals.kittenAgeGroups.count < 3 {
      fatalError("There are \(Globals.kittenAgeGroups.count) kitten age groups instead of 3")
    }
    let m = ageInMonths
    if m < Globals.kittenAgeGroups[0] {
      return "under \(Globals.kittenAgeGroups[0]) mths"
    }
    if m < Globals.kittenAgeGroups[1] {
      return "under \(Globals.kittenAgeGroups[1]) mths"
    }
    return "under \(Globals.kittenAgeGroups[2]) mths"
  }
  
  var age: String {
    if let showDate = Globals.currentShow?.date {
      return self.birthDate.differenceInMonthsAndYears(showDate)
    }
    fatalError("Could not determine cat: \(self.name)'s age")
  }
  
  var sectionName: String {
    if self.isCompanion { return "" }
    if self.isKitten { return Globals.currentSections[0] }
    if self.isEntire { return Globals.currentSections[1] }
    return Globals.currentSections.last ?? "Desexed"
  }
  
  var sectionNameAsSingle: String {
    if self.isCompanion { return "" }
    if self.isKitten { return Globals.currentSections[0].singular }
    if self.isEntire { return Globals.currentSections[1].singular }
    return Globals.currentSections.last?.singular ?? "Desexed"
  }
  
  var breedSection: String {
    if isCompanion {return breed }
    return self.breed + " " + self.sectionName
  }
  
  // *************************
  // MARK: - Ranking queries
  // *************************
/**
is the cat a `.companion, .kitten, .open, .gold or .platinum`
 */
  var category: Category {
    if isCompanion { return .companion }
    if isKitten { return .kitten }
    if Challenges.currentList.count > 2, challenge == Challenges.currentList[2] { return .gold }
    if Challenges.currentList.count > 3, challenge == Challenges.currentList[3] { return .platinum}
    return .open
  }
/**
returns the ranking value of the group which this breed of this cat is in
*/
  var groupNumber: Int {
    return Breeds.groupNumber(of: self.breed)
  }
/**
 returns the ranking value of the breed of this cat
 */
  var breedRank: Int {
    return Breeds.rank(of: self.breed) ?? 999
  }
/**
 ranks the cat, kitten = 1, entire = 2, desexed = 3
 */
  var section: Int {
    if self.isKitten { return 1 }
    if self.isEntire { return 2 }
    return 3
  }
/**
 ranks the cat on its pattern
 */
  var patternRank: Patterns {
    guard isLimited else {
      return .colourClass
    }
    if Globals.currentShowType == Affiliation.CCCA {
      let color = colour.lowercased()
      if breed == "Ragdoll" {
        if color.contains("mitted") { return .mitted }
        if self.hasWhite { return .bicolour }
        return .pointed
      } else if breed == "Bengal" {
        if color.contains("brown") { return .brown }
        if color.contains("sepia") { return .sepia }
        if color.contains("mink") { return .mink }
        if color.contains("silver") { return .silver }
        return .lynxPoint
      } else {
        if hasWhite { return .patched }
        if isTabby  { return .patterned }
        if color.contains("tortie") { return .patterned }
        if color.contains("point")  { return .pointed }
        if color.contains("smoke")  { return .silver }
        if color.contains("silver") { return .silver }
        if color.contains("tipped") { return .silver }
        return .solid
      }
    } else if Globals.nationalAffiliation == .ACF {        // is a ACF style show
      if isTabby {
        if hasWhite {
          return.agoutiWhite
        } else {
          return.agouti
        }
      } else {
        if hasWhite {
          return .nonAgoutiWhite
        } else {
          return .nonAgouti
        }
      }
    }
    return .colourClass
  }
  
  var colourRank: Int {
    if let ans = Colours.rank(of: self.colour, forBreed: self.breed) {
      return ans
    } else {
      return 999
    }
  }
  
  var ageRank: Int {
    if let showDate = Globals.currentShow?.date {
      let catAge = showDate.monthsDifferenceTo(self.birthDate)
      for age in Globals.kittenAgeGroups {
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
    return Sex.rank(of: self.sex) ?? 999
  }
  
  // *************************
  // MARK: - Cat comparision
  // *************************
  
  func compare(with anotherCat: Cat) -> Bool {
    
    // first compare on group
    // ----------------------
    if self.groupNumber < anotherCat.groupNumber {
      return true
    }
    if self.groupNumber > anotherCat.groupNumber {
      return false
    }
    
    // then compare on section<kitten, entire, desexed>
    // -------------------------------------------------
    if self.section < anotherCat.section {
      return true
    }
    if self.section > anotherCat.section {
      return false
    }
    
    // then compare on breed
    // ----------------------
    if self.breedRank < anotherCat.breedRank {
      return true
    }
    if self.breedRank > anotherCat.breedRank {
      return false
    }
    
    // then on pattern
    // --------------------------
    if self.patternRank < anotherCat.patternRank {
      return true
    }
    if self.patternRank > anotherCat.patternRank {
      return false
    }
    
    // then on colour
    // --------------
    if self.colourRank < anotherCat.colourRank {
      return true
    }
    if self.colourRank > anotherCat.colourRank {
      return false
    }
    
    // then on age ranking - if used
    // --------------------
    if organiseKittensByAgeGroups {
      if self.ageRank < anotherCat.ageRank {
        return true
      }
      if self.ageRank > anotherCat.ageRank {
        return false
      }
    }
    
    // then on <male>, <female>, <neuter>, <spay>
    // -------------------------------------------
    if self.sexRank < anotherCat.sexRank {
      return true
    }
    if self.sexRank > anotherCat.sexRank {
      return false
    }
    
    // then on age
    // ------------
    let comparison = self.birthDate.compare(anotherCat.birthDate)
    switch comparison {
    case .orderedAscending:
      return true
    case .orderedDescending:
      return false
    default:
      break
    }
    
    //lastly on name
    switch self.name.caseInsensitiveCompare(anotherCat.name) {
    case .orderedAscending:
      return true
    default:
      return false
    }
  }

  func NSWcompare(with anotherCat: Cat) -> Bool {
    
    // first compare on group
    // ----------------------
    if self.groupNumber < anotherCat.groupNumber {
      return true
    }
    if self.groupNumber > anotherCat.groupNumber {
      return false
    }
    
    // then kittens first
    // -------------------------------------------------
    if self.isKitten && !anotherCat.isKitten {
      return true
    }
    if !self.isKitten && anotherCat.isKitten {
      return false
    }
    
    // then on <male>, <female>, <neuter>, <spay>
    // -------------------------------------------
    if self.sexRank < anotherCat.sexRank {
      return true
    }
    if self.sexRank > anotherCat.sexRank {
      return false
    }
    
    // then compare on breed
    // ----------------------
    if self.breedRank < anotherCat.breedRank {
      return true
    }
    if self.breedRank > anotherCat.breedRank {
      return false
    }
    
    // then on pattern
    // --------------------------
    if self.patternRank < anotherCat.patternRank {
      return true
    }
    if self.patternRank > anotherCat.patternRank {
      return false
    }
    
    // then on colour
    // --------------
    if self.colourRank < anotherCat.colourRank {
      return true
    }
    if self.colourRank > anotherCat.colourRank {
      return false
    }
    
    // then on age
    // ------------
    switch self.birthDate.compare(anotherCat.birthDate) {
    case .orderedAscending:
      return true
    case .orderedDescending:
      return false
    default:
      break
    }
    
    //lastly on name
    switch self.name.caseInsensitiveCompare(anotherCat.name) {
    case .orderedAscending:
      return true
    default:
      return false
    }
  }
}

