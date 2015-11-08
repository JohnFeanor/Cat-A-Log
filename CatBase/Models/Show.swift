//
//  Show.swift
//  
//
//  Created by John Sandercock on 2/08/2015.
//
//

import Foundation
import CoreData


struct AddShowDataSheet {
  var affiliation   = Globals.showTypes[0]
  var date          = NSDate()
  var judges        = [["", "", "", "", "", ""], ["", "", "", "", "", ""]]
  var name: String  = "New Show"
  var numberOfRings = NSNumber(integer: 3)
}

class Show: NSManagedObject, CustomDebugStringConvertible {
  
  static var entity = "Show"
  static var properties = [Show.affiliation, Show.date, Show.judgeLH1, Show.judgeLH2, Show.judgeLH3, Show.judgeLH4, Show.judgeLH5, Show.judgeLH6, Show.judgeSH1, Show.judgeSH2, Show.judgeSH3, Show.judgeSH4, Show.judgeSH5, Show.judgeSH6, Show.name, Show.numberOfRings]
  let judgesLH = ["judgeLH1", "judgeLH2", "judgeLH3", "judgeLH4", "judgeLH5", "judgeLH6"]
  let judgesSH = ["judgeSH1", "judgeSH2", "judgeSH3", "judgeSH4", "judgeSH5", "judgeSH6"]
  
  static var affiliation       = "affiliation"
  static var date              = "date"
  static var judgeLH1          = "judgeLH1"
  static var judgeLH2          = "judgeLH2"
  static var judgeLH3          = "judgeLH3"
  static var judgeLH4          = "judgeLH4"
  static var judgeLH5          = "judgeLH5"
  static var judgeLH6          = "judgeLH6"
  static var judgeSH1          = "judgeSH1"
  static var judgeSH2          = "judgeSH2"
  static var judgeSH3          = "judgeSH3"
  static var judgeSH4          = "judgeSH4"
  static var judgeSH5          = "judgeSH5"
  static var judgeSH6          = "judgeSH6"
  static var name              = "name"
  static var numberOfRings     = "numberOfRings"
  
  // ************************************
  // MARK: - Properties
  // ************************************
  
  @NSManaged var affiliation: String
  @NSManaged var date: NSDate
  @NSManaged var judgeLH1: String
  @NSManaged var judgeLH2: String
  @NSManaged var judgeLH3: String
  @NSManaged var judgeLH4: String
  @NSManaged var judgeLH5: String
  @NSManaged var judgeLH6: String
  @NSManaged var judgeSH1: String
  @NSManaged var judgeSH2: String
  @NSManaged var judgeSH3: String
  @NSManaged var judgeSH4: String
  @NSManaged var judgeSH5: String
  @NSManaged var judgeSH6: String
  @NSManaged var name: String
  @NSManaged var numberOfRings: NSNumber
  @NSManaged var entries: NSMutableSet?
  
  // ************************************
  // MARK: - Initializer
  // ************************************
  
  convenience init(showData:[String : AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    let showEntity = NSEntityDescription.entityForName(Show.entity, inManagedObjectContext: context!)
    if showEntity == nil {
      print("Cannot create new show entity")
      abort()
    } else {
      self.init(entity: showEntity!, insertIntoManagedObjectContext: context)
      self.setValuesTo(showData)
    }
  }
  
  dynamic var showDateAsString: String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    let showDate = dateFormatter.stringFromDate(self.date)
    return showDate
  }
  
  dynamic var ringsInShow: String {
    let ans: String = "\(self.numberOfRings)"
    return ans
  }
  
  
  // Print a list of the cats in the show
  // ------------------------------------
  override var debugDescription: String {
    var ans: String = ""
    if let entries = self.entries {
      for entry in entries {
        if let entry = entry as? Entry {
          ans = ans + ", " + entry.cat.name
        }
      }
    }
    return ans
  }
  
  override var description: String {
    var ans: String = ""
    if let entries = self.entries {
      for entry in entries {
        if let entry = entry as? Entry {
          ans = ans + ", " + entry.cat.name
        }
      }
    }
    return ans
  }
  
  // ************************************
  // MARK: - Methods
  // ************************************
  
  // Set this show's properties to the values in a supplied dictionary
  // -----------------------------------------------------------------
  func setValuesTo(showData: [String : AnyObject]) {
    self.setValuesForKeysWithDictionary(showData)
  }
  
  // ************************************
  // MARK: - Queries about the show
  // ************************************
  
  
  // Is a cat born on a given date a kitten at this show?
  // ----------------------------------------------------
  func isKittenIfBornOn(birthDate: NSDate) -> Bool {
    let isAKitten = birthDate.lessThan(weeks: 0, months: 9, before: self.date)
    return isAKitten
  }
  
  // Is a cat born on a given date too young to enter this show?
  // -----------------------------------------------------------
  func isItTooYoungForShow(birthDate: NSDate) -> Bool {
    let minAge = Globals.minShowAge
    let isTooYoungForShow = birthDate.lessThan(weeks: minAge.weeks, months: minAge.months, before: self.date)
    return isTooYoungForShow
  }
  
  // Is a cat born on a given date able to be pending at this show?
  // --------------------------------------------------------------
  func canItBePending(birthDate: NSDate) -> Bool {
    let minAge = Globals.maxPendingAge
    let canBePending = birthDate.lessThan(weeks: minAge.weeks, months: minAge.months, before: self.date)
    return canBePending
  }
  
  // Is a cat born on a given date able to be in a litter?
  // ------------------------------------------------------
  func canItBeInALitter(birthDate: NSDate) -> Bool {
    let maxAge = Globals.minShowAge
    let canBeInLitter = birthDate.lessThan(weeks: maxAge.weeks, months: maxAge.months, before: self.date)
    return canBeInLitter
  }
  
  // return initials of judge judging breed <breedName> in ring <ring>
  // ------------------------------------------------------------------
  func judge(ring: Int, forBreed breedName: String) -> String {
    let groupNumber = Breeds.groupNumberOf(breedName)
    let longhair: Bool
    if self.affiliation == Globals.showTypes[0] {
      longhair = groupNumber != 1
    } else if self.affiliation == Globals.showTypes[1] {
      longhair = groupNumber == 0 || groupNumber == 1 || groupNumber == 5
    } else  {
      longhair = groupNumber == 0 || groupNumber == 3
    }
    if longhair {
      return self.valueForKey(judgesLH[ring]) as! String
    } else {
      return self.valueForKey(judgesSH[ring]) as! String
    }
  }
}
