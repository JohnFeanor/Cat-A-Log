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
  var minimumMonths = NSNumber(integer: 3)
  var minimumWeeks  = NSNumber(integer: 0)
  var name: String  = "New Show"
  var numberOfRings = NSNumber(integer: 3)
}

class Show: NSManagedObject {
  
  static var entity = "Show"
  static var properties = [Show.affiliation, Show.date, Show.judgeLH1, Show.judgeLH2, Show.judgeLH3, Show.judgeLH4, Show.judgeLH5, Show.judgeLH6, Show.judgeSH1, Show.judgeSH2, Show.judgeSH3, Show.judgeSH4, Show.judgeSH5, Show.judgeSH6, Show.minimumMonths, Show.minimumWeeks, Show.name, Show.numberOfRings]
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
  static var minimumMonths     = "minimumMonths"
  static var minimumWeeks      = "minimumWeeks"
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
  @NSManaged var minimumMonths: NSNumber
  @NSManaged var minimumWeeks:  NSNumber
  @NSManaged var name: String
  @NSManaged var numberOfRings: NSNumber
  @NSManaged var entries: NSSet?
  
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
  
  // ************************************
  // MARK: - Methods
  // ************************************
  
  // Set this show's properties to the values in a supplied dictionary
  // -----------------------------------------------------------------
  func setValuesTo(showData: [String : AnyObject]) {
    self.setValuesForKeysWithDictionary(showData)
  }
 
  // Private helper methods
  // ----------------------
  private func minAges(key: String) -> (months: Int, weeks: Int) {
    if let showDict = Globals.dataByGroup[self.affiliation] {
      let ages = showDict.valueForKey(key) as! [Int]
     return (ages[0], ages[1])
    }
    return (0, 0)
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
    let minAge = self.minAges(Headings.minAge)
    let isTooYoungForShow = birthDate.lessThan(weeks: minAge.weeks, months: minAge.months, before: self.date)
    return isTooYoungForShow
  }
  
  // Is a cat born on a given date able to be pending at this show?
  // --------------------------------------------------------------
  func canItBePending(birthDate: NSDate) -> Bool {
    let minAge = self.minAges(Headings.pending)
    let canBePending = birthDate.lessThan(weeks: minAge.weeks, months: minAge.months, before: self.date)
    return canBePending
  }
}
