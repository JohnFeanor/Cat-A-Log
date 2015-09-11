//
//  Globals.swift
//  CatBase
//
//  Created by John Sandercock on 4/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

typealias DictOfStringArray = [String : [String]]

extension NSControl {
  var currentBreed: String {
    get {
      return stringValue
    }
  }
}

extension NSTableView {
  override var currentBreed: String {
    get {
      let row = self.selectedRow
      if row > -1 {
        let view = self.viewAtColumn(0, row: row, makeIfNecessary: false) as? NSTableCellView
        let text = view?.objectValue as? String
        if let text = text {
          return text
        }
      }
      return ""
    }
  }
}
//
//struct AgeStruct {
//  var minimumAge: Int
//  var timeUnit : String
//}

struct Headings {
  static let minAge     = "MinAge"
  static let kittenAges = "kittenAges"
  static let pending    = "Pending"
  static let sexes      = "Sexes"
  static let challenges = "Challenges"
  static let groups     = "Groups"
  static let group      = "group"
  static let subgroups  = "subgroups"
  static let breeds     = "breeds"
}

enum Section: Int {
  case kitten = 0, entire, desexed
}

func >(left: Section, right: Section) -> Bool {
  return left.rawValue > right.rawValue
}

func <(left: Section, right: Section) -> Bool {
  return left.rawValue < right.rawValue
}

let pending = "Pending"

let space = " "
let apostrophy = "'"

let strLower = "[a-z]";
let strUpper = "[A-Z]"
let alpha = "[A-Z,a-z]"
let wordChar = "[A-Z,a-z,']"

let lowerCase = NSPredicate(format:"SELF MATCHES %@", strLower)
let upperCase = NSPredicate(format:"SELF MATCHES %@", strUpper)
let alphaCharacter = NSPredicate(format: "SELF MATCHES %@", alpha)
let breakCharacter = NSPredicate(format: "NOT SELF MATCHES %@", wordChar)
let wordCharacter = NSPredicate(format: "SELF MATCHES %@", wordChar)


//let months = "Months"
//let weeks = "Weeks"
let speaker = NSSpeechSynthesizer()

// MARK: - fetching from the Managed Object Context

func existingCatsWithRegistration(rego: String, orName name: String, inContext context: NSManagedObjectContext) -> [Cat]? {
  // find any cats with the same registration (unless pending)
  let sameRego: [Cat]
  if rego != pending {
    sameRego  = fetchCatsWithName(name, inContext: context)
  } else {
    sameRego = []
  }
  
  // find any cats with the same name
  let sameName = fetchCatsWithRegistration(rego, inContext: context)
  
  // put all those found cats into one big array
  let same = sameRego + sameName.filter { !sameRego.contains($0)}
  
  return same.isEmpty ? nil : same
}

func fetchEntitiesNamed(entityName: String, inContext context:NSManagedObjectContext, usingFormat format: String) -> [NSManagedObject] {
  let fetchRequest = NSFetchRequest(entityName: entityName)
  fetchRequest.predicate = NSPredicate(format: format)
  let fetchResult: [NSManagedObject]?
  do {
    fetchResult = try context.executeFetchRequest(fetchRequest) as? [NSManagedObject]
  } catch {
    print("\n** Error in fetch request **\n")
    return []
  }
  if let fetchResult = fetchResult {
    return fetchResult
  } else {
    return []
  }
}

func fetchCatsWithRegistration(registration: String, inContext context: NSManagedObjectContext) -> [Cat] {
  return fetchEntitiesNamed(Cat.entity, inContext: context, usingFormat: "\(Cat.registration) LIKE[c] \"\(registration)\"") as! [Cat]
}

func fetchCatsWithName(name: String, inContext context: NSManagedObjectContext) -> [Cat] {
  return fetchEntitiesNamed(Cat.entity, inContext: context, usingFormat: "\(Cat.name) LIKE[c] \"\(name)\"") as! [Cat]
}

// MARK: - reading in and writing arrays and dictionaries to Plists

func dictFromPList(listName: String) -> NSDictionary {
  let url = NSBundle.mainBundle().URLForResource(listName, withExtension:"plist")
  if let url = url {
    return NSDictionary(contentsOfURL:url)!
  } else {
    fatalError("Cannot load internal data \(listName)")
  }
}

func dict(dict: NSDictionary, toPlist listName: String) -> Bool {
  let url = NSBundle.mainBundle().URLForResource(listName, withExtension:"plist")
  if let url = url {
    return dict.writeToURL(url, atomically: true)
  } else {
    return false
  }
}

func arrayFromPList(listName: String) -> [AnyObject]? {
  let url = NSBundle.mainBundle().URLForResource(listName, withExtension:"plist")
  if let url = url {
    return (NSArray(contentsOfURL:url) as [AnyObject]?)
  } else {
    fatalError("Cannot load internal data \(listName)")
  }
}

func array(array: [String], ToPlist listName: String) -> Bool {
  let url = NSBundle.mainBundle().URLForResource(listName, withExtension:"plist")
  if let url = url {
    return (array as NSArray).writeToURL(url, atomically: true)
  } else {
    return false
  }
}

// MARK: - querying the user

func areYouSure(message: String) -> Bool {
  return runAlertWithMessage(message, buttons: "OK", "Cancel") == NSAlertFirstButtonReturn
}

func errorAlert(message message: String) {
  runAlertWithMessage(message, buttons: "OK")
}

func runAlertWithMessage(message: String, buttons: String ...) -> NSModalResponse {
  let alert = NSAlert()
  for button in buttons {
    alert.addButtonWithTitle(button)
  }
  alert.messageText = message
  alert.alertStyle = .WarningAlertStyle
  speaker.startSpeakingString("Excuse me, \(message)")
  return alert.runModal()
}

extension NSDate {

  func lessThan(weeks weeks:Int = 0, months: Int = 0, before date2: NSDate) -> Bool {
    let interval = NSDateComponents()
    interval.day = weeks * 7
    interval.month = months
    let calendar = NSCalendar.currentCalendar()
    let testDate = calendar.dateByAddingComponents(interval, toDate: self, options: [])
    if let testDate = testDate {
      if testDate.compare(date2) == NSComparisonResult.OrderedDescending {
        return true
      } else {
        return false
      }
    }
    print("Could not get a date from the calendar")
    return false
  }
  
  func monthsDifferenceTo(otherDate: NSDate) -> Int {
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components(.Month, fromDate: self, toDate: otherDate, options: [])
    return components.month
    
  }
}


class Globals: NSObject {

  @IBOutlet var theShowController: NSArrayController!
  @IBOutlet var theEntriesController: NSArrayController!

  static var currentShow: Show? = nil
  static var currentEntry: Entry? = nil
  
  static var dataByGroup:[String : NSDictionary] = {
    return dictFromPList("ShowFormats") as! [String : NSDictionary]
    }()
  
  static var kittenGroups: [Int] {
    if let currentAffiliation = Globals.currentShow?.affiliation {
      if let kittenAges = Globals.dataByGroup[currentAffiliation]?[Headings.kittenAges] as? [Int] {
        return kittenAges
      }
    }
    return []
  }
  
  private static var agouti: [String: [String]] = {
    return dictFromPList("agouti") as! [String: [String]]
  }()
  
  static var agoutiBreeds: [String]  {
    return Globals.agouti["breeds"]!
  }
  
  static var agoutiClasses: [String] {
    return Globals.agouti["classes"]!
  }
  
  static var showTypes: [String] = {
    let allKeys = Array(dataByGroup.keys)
    return allKeys.sort(>)
  }()
  
  static var cageTypes: (names:[String], sizes:[Int]) = {
    let path = NSBundle.mainBundle().pathForResource("CageTypes", ofType:"plist")
    if let path = path {
      let data = NSArray(contentsOfFile:path) as! [NSArray]
      var names: [String] = []
      var sizes: [Int] = []
      for item in data {
        let name = item[0] as! String
        let size = item[1] as! Int
        names += [name]
        sizes += [size]
      }
      return (names, sizes)
    } else {
      fatalError("Cannot load internal data: CageTypes")
    }
  }()
  
  dynamic var showTypes: [String] {
    return Globals.showTypes
  }
  
  
  // ========================
  // MARK: - Methods
  // ========================
  
  func tableViewSelectionDidChange(aNotification: NSNotification) {
    Globals.currentShow = theShowController.selectedObjects?.first as? Show
    Globals.currentEntry = theEntriesController.selectedObjects?.first as? Entry
  }

}
