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
  var date          = Date()
  var judges        = [["", "", "", "", "", ""], ["", "", "", "", "", ""]]
  var name: String  = "New Show"
  var numberOfRings = NSNumber(value: 3 as Int)
}

class Show: NSManagedObject {
  
  @objc static var nomen = "Show"
  @objc static var properties = [Show.affiliation, Show.date, Show.judgeLH1, Show.judgeLH2, Show.judgeLH3, Show.judgeLH4, Show.judgeLH5, Show.judgeLH6, Show.judgeSH1, Show.judgeSH2, Show.judgeSH3, Show.judgeSH4, Show.judgeSH5, Show.judgeSH6, Show.name, Show.numberOfRings]
  @objc let judgesLH = ["judgeLH1", "judgeLH2", "judgeLH3", "judgeLH4", "judgeLH5", "judgeLH6"]
  @objc let judgesSH = ["judgeSH1", "judgeSH2", "judgeSH3", "judgeSH4", "judgeSH5", "judgeSH6"]
  
  @objc static var affiliation       = "affiliation"
  @objc static var date              = "date"
  @objc static var judgeLH1          = "judgeLH1"
  @objc static var judgeLH2          = "judgeLH2"
  @objc static var judgeLH3          = "judgeLH3"
  @objc static var judgeLH4          = "judgeLH4"
  @objc static var judgeLH5          = "judgeLH5"
  @objc static var judgeLH6          = "judgeLH6"
  @objc static var judgeSH1          = "judgeSH1"
  @objc static var judgeSH2          = "judgeSH2"
  @objc static var judgeSH3          = "judgeSH3"
  @objc static var judgeSH4          = "judgeSH4"
  @objc static var judgeSH5          = "judgeSH5"
  @objc static var judgeSH6          = "judgeSH6"
  @objc static var name              = "name"
  @objc static var numberOfRings     = "numberOfRings"
  
  // ************************************
  // MARK: - Properties
  // ************************************
  
  @NSManaged var affiliation: String
  @NSManaged var date: Date
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
  
  @objc convenience init(showData:[String : AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    let showEntity = NSEntityDescription.entity(forEntityName: Show.nomen, in: context!)
    if showEntity == nil {
      print("Cannot create new show entity")
      abort()
    } else {
      self.init(entity: showEntity!, insertInto: context)
      self.setValuesTo(showData)
    }
  }
  
  @objc dynamic var showDateAsString: String {
    let dateFormatter = Foundation.DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    let showDate = dateFormatter.string(from: self.date)
    return showDate
  }
  
  @objc dynamic var ringsInShow: String {
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
  @objc func setValuesTo(_ showData: [String : AnyObject]) {
    self.setValuesForKeys(showData)
  }
  
  // ************************************
  // MARK: - Queries about the show
  // ************************************
  
  
  // Is a cat born on a given date a kitten at this show?
  // ----------------------------------------------------
  @objc func isKittenIfBornOn(_ birthDate: Date) -> Bool {
    let isAKitten = birthDate.lessThan(months: Globals.maxKittenAge, before: self.date)
    return isAKitten
  }
  
  // Is a cat born on a given date too young to enter this show?
  // -----------------------------------------------------------
  @objc func isItTooYoungForShow(_ birthDate: Date) -> Bool {
    let minAge = Globals.minShowAge
    let isTooYoungForShow = birthDate.lessThan(months: minAge.months, weeks: minAge.weeks, before: self.date)
    return isTooYoungForShow
  }
  
  // Is a cat born on a given date able to be pending at this show?
  // --------------------------------------------------------------
  @objc func canItBePending(_ birthDate: Date) -> Bool {
    let minAge = Globals.maxPendingAge
    let canBePending = birthDate.lessThan(months: minAge.months, weeks: minAge.weeks, before: self.date)
    return canBePending
  }
  
  // Is a cat born on a given date able to be in a litter?
  // ------------------------------------------------------
  @objc func canItBeInALitter(_ birthDate: Date) -> Bool {
    let maxAge = Globals.minShowAge
    let canBeInLitter = !birthDate.lessThan(months: maxAge.months, weeks: maxAge.weeks, before: self.date)
    return canBeInLitter
  }
  
  // return initials of judge judging breed <breedName> in ring <ring>
  // ------------------------------------------------------------------
  @objc func judge(_ ring: Int, forBreed breedName: String) -> String {
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
      return self.value(forKey: judgesLH[ring]) as! String
    } else {
      return self.value(forKey: judgesSH[ring]) as! String
    }
  }
}
