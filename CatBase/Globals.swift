//
//  Globals.swift
//  CatBase
//
//  Created by John Sandercock on 4/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

typealias DictOfStringArray = [String : [String]]


// ********************************
// MARK: - Extensions
// *******************************

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

extension NSDate {
  
  var string: String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd-MM-yy"
    return formatter.stringFromDate(self)
  }

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
    
    return components.month < 0 ? components.month * -1 : components.month
  }
  
  func differenceInMonthsAndYears(otherDate: NSDate) -> String {
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Month, .Year], fromDate: self, toDate: otherDate, options: [])
    let month: String
    if components.month < 10 {
      month = "0\(components.month)"
    } else {
      month = "\(components.month)"
    }
    return "\(components.year).\(month)"
  }
}

extension String {
  var isPending: Bool {
    return self.caseInsensitiveCompare(pending) == NSComparisonResult.OrderedSame
  }
}

// ********************************
// MARK: - Structures
// *******************************

struct Headings {
  static let maxLitterAge     = "maxLitterAge"
  static let minShowAge       = "minShowAge"
  static let kittenAgeGroups  = "kittenAgeGroups"
  static let maxPendingAge    = "maxPendingAge"
  static let sexes      = "Sexes"
  static let challenges = "Challenges"
  static let groups     = "Groups"
  static let group      = "group"
  static let subgroups  = "subgroups"
  static let breeds     = "breeds"
}

// ********************************
// MARK: - Constants
// *******************************

let pending = "Pending"
let maxNumberOfRings = 6

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

let speaker = NSSpeechSynthesizer()

// ********************************
// MARK: - Agouti helper functions
// *******************************

struct Agouti {
  static let notAgouti      = -1
  static let agouti         = 0
  static let agoutiWhite    = 1
  static let nonAgouti      = 2
  static let nonAgoutiWhite  = 3
}

func isTabby(colour: String) -> Bool {
  let color = colour.lowercaseString
  return color.containsString("tabby")
}

func andWhite(colour: String) -> Bool {
  let color = colour.lowercaseString
  if color.containsString(" white")    { return true }
  if color.containsString("bi-colour") { return true }
  if color.containsString("bicolour")  { return true }
  if color.containsString("van")       { return true }
  
  return false
}

// ********************************
// MARK: - Other helper functions
// *******************************

func minAges(key: String) -> (months: Int, weeks: Int) {
  if let dict = Globals.dataByGroup[Globals.currentShowType] {
    let ages = dict.valueForKey(key) as! [Int]
    return (ages[0], ages[1])
  }
  return (0, 0)
}

func setAge(key: String, toWeeks weeks:Int? = nil, andMonths months: Int? = nil) {
  
}

// *************************************************
// MARK: - fetching from the Managed Object Context
// *************************************************

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

// ******************************************************************
// MARK: - reading in and writing arrays and dictionaries to Plists
// ******************************************************************

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

func readFile(fileName: String) -> NSData {
  let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
  
  if let path = path {
    let d = NSFileManager.defaultManager().contentsAtPath(path)
    if let d = d {
      return d
    }
  }
  fatalError("Cannot read data from \"\(fileName).txt\"")
}

// ***************************
// MARK: - querying the user
// ***************************

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

// *******************
// MARK: - Globals
//********************

class Globals: NSObject {

  @IBOutlet var theShowController: NSArrayController!
  @IBOutlet var theEntriesController: NSArrayController!
  
  static var dataByGroup:[String : NSDictionary] = {
    return dictFromPList("ShowFormats") as! [String : [String : [AnyObject]]]
    }()

  static var currentShow: Show? = nil
  static var currentEntry: Entry? = nil
  static var defaultShowAffliation: String {
    let ans = Globals.showTypes.first ?? "ACF Show"
    return ans
  }
  
  static var currentShowName: String {
    if currentShow == nil {
      return ""
    }
    return currentShow!.name
  }
  
  static var currentShowDate: String {
    if currentShow == nil {
      fatalError("Nil show when trying to get date for nil show")
    }
    let longDate = NSDateFormatter()
    longDate.timeStyle = .NoStyle
    longDate.dateStyle = .LongStyle
    longDate.locale = NSLocale.currentLocale()
    return longDate.stringFromDate(currentShow!.date)
  }
  
  dynamic var showTypes: [String] {
    return Globals.showTypes
  }
  
  static var showTypes: [String] = {
    let allKeys = Array(dataByGroup.keys)
    return allKeys.sort(>)
    }()
 
  static var currentShowType: String {
    if currentShow == nil {
      print("Nil show when trying to get type for nil show")
    }
    return Globals.currentShow?.affiliation ?? Globals.defaultShowAffliation
  }
  
  static var numberOfRingsInShow: Int {
    if let show = Globals.currentShow {
      return show.numberOfRings.integerValue
    } else {
      return 0
    }
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
  
  // ========================
  // MARK: - Critical ages
  // ========================

  static var criticalAges: [String : [Int]] = {
    return dictFromPList("CriticalAges") as! [String : [Int]]
  }()
  
  static var minShowAge: (weeks: Int, months: Int) {
    return (Globals.criticalAges[Headings.minShowAge]![0], Globals.criticalAges[Headings.minShowAge]![1])
  }
  
  static var maxLitterAge: (weeks: Int, months: Int) {
    return (Globals.criticalAges[Headings.maxLitterAge]![0], Globals.criticalAges[Headings.maxLitterAge]![1])
  }
  
  static var maxPendingAge: (weeks: Int, months: Int) {
    return (Globals.criticalAges[Headings.maxPendingAge]![0], Globals.criticalAges[Headings.maxPendingAge]![1])
  }
  
  static var kittenAgeGroups: [Int] {
    return Globals.criticalAges[Headings.kittenAgeGroups]!
  }
  
  static var maxKittenAge: Int {
    return kittenAgeGroups[2]
  }
  
  class func setMinShowAge(weeks weeks:Int? = nil, months: Int? = nil) {
    if weeks != nil { Globals.criticalAges[Headings.minShowAge]![0] = weeks! }
    if months != nil { Globals.criticalAges[Headings.minShowAge]![1] = months! }
  }
  
  class func setMaxLitterAge(weeks weeks:Int? = nil, months: Int? = nil) {
    if weeks != nil { Globals.criticalAges[Headings.maxLitterAge]![0] = weeks! }
    if months != nil { Globals.criticalAges[Headings.maxLitterAge]![1] = months! }
  }
  
  class func setMaxPendingAge(weeks weeks:Int? = nil, months: Int? = nil) {
    if weeks != nil { Globals.criticalAges[Headings.maxPendingAge]![0] = weeks! }
    if months != nil { Globals.criticalAges[Headings.maxPendingAge]![1] = months! }
  }
  
  class func setKittenAgeGroups(values: [Int]) {
    let size = values.count < 3 ? values.count : 3
    for index in 0 ..< size {
      Globals.criticalAges[Headings.kittenAgeGroups]![index] = values[index]
    }
  }
  
  class func setMaxKittenAge(months months: Int) {
    Globals.criticalAges[Headings.kittenAgeGroups]![2] = months
  }
  
  class func saveCriticalAges() {
    if !dict(Globals.criticalAges, toPlist: "CriticalAges") {
      print("Could not save critical ages")
    }
  }

 
  // ========================
  // MARK: - Methods
  // ========================
  
  func tableViewSelectionDidChange(aNotification: NSNotification) {
    Globals.currentShow = theShowController.selectedObjects?.first as? Show
    Globals.currentEntry = theEntriesController.selectedObjects?.first as? Entry
  }

}
