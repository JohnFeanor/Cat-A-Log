//
//  Show.swift
//  
//
//  Created by John Sandercock on 2/08/2015.
//
//

import Foundation
import CoreData

class Show: NSManagedObject {
  
  static var entity = "Show"
  static var properties = [Show.affiliation, Show.date, Show.judgeLH1, Show.judgeLH2, Show.judgeLH3, Show.judgeLH4, Show.judgeLH5, Show.judgeLH6, Show.judgeSH1, Show.judgeSH2, Show.judgeSH3, Show.judgeSH4, Show.judgeSH5, Show.judgeSH6, Show.minimumAgeMonths, Show.minimumAgeWeeks, Show.name, Show.numberOfRings]
  
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
  static var minimumAgeMonths  = "minimumAgeMonths"
  static var minimumAgeWeeks   = "minimumAgeWeeks"
  static var name              = "name"
  static var numberOfRings     = "numberOfRings"
  
  @NSManaged var affiliation: NSNumber
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
  @NSManaged var minimumAgeMonths: NSNumber
  @NSManaged var minimumAgeWeeks: NSNumber
  @NSManaged var name: String
  @NSManaged var numberOfRings: NSNumber
  @NSManaged var entries: NSSet?
    
  convenience init(showData:NSDictionary, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    let showEntity = NSEntityDescription.entityForName(Show.entity, inManagedObjectContext: context!)
    if showEntity == nil {
      print("Cannot create new cat entity")
      abort()
    } else {
      self.init(entity: showEntity!, insertIntoManagedObjectContext: context)
      self.setValuesTo(showData)
    }
  }
  
  func setValuesTo(showData: NSDictionary) {
    self.setValuesForKeysWithDictionary(showData as! [String : AnyObject])
  }
  
  func dictionary()  -> NSDictionary {
    return self.dictionaryWithValuesForKeys(Show.properties)
  }
}
