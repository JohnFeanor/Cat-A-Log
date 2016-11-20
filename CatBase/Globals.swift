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
        let view = self.view(atColumn: 0, row: row, makeIfNecessary: false) as? NSTableCellView
        let text = view?.objectValue as? String
        if let text = text {
          return text
        }
      }
      return ""
    }
  }
}

extension Date {
  
  var string: String {
    let formatter = Foundation.DateFormatter()
    formatter.dateFormat = "dd MM yy"
    return formatter.string(from: self)
  }
  
  
  func lessThan(months: Int = 0, weeks: Int = 0, before date2: Date) -> Bool {
    
    let calendar = Calendar.current
    
    var maxAge = DateComponents()
    maxAge.month = months
    maxAge.day = weeks * 7
    if let grownUpDate = (calendar as NSCalendar).date(byAdding: maxAge, to: self, options: NSCalendar.Options(rawValue: 0)) {
      if (calendar as NSCalendar).compare(grownUpDate, to: date2, toUnitGranularity: .day) == .orderedDescending {
        return true
      }
    }
    return false
  }
  
  func monthsDifferenceTo(_ otherDate: Date) -> Int {
    return Calendar.current.dateComponents([.month], from: otherDate, to: self).month ?? 0
  }
  
  func differenceInMonthsAndYears(_ otherDate: Date) -> String {
    let numberMonths = Calendar.current.dateComponents([.month], from: self, to: otherDate).month ?? 0
    if numberMonths < 0 {
      return "error"
    } else if numberMonths < 10 {
      return "0\(numberMonths)"
    } else if numberMonths < 12 {
      return "\(numberMonths)"
    } else {
      return "\(numberMonths / 12).\(numberMonths % 12)"
    }
  }
}

extension String {
  var isPending: Bool {
    return self.caseInsensitiveCompare(pending) == ComparisonResult.orderedSame
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

func isTabby(_ colour: String) -> Bool {
  let color = colour.lowercased()
  return color.contains("tabby")
}

func andWhite(_ colour: String) -> Bool {
  let color = colour.lowercased()
  if color.contains(" white")    { return true }
  if color.contains("bi-colour") { return true }
  if color.contains("bicolour")  { return true }
  if color.contains("van")       { return true }
  
  return false
}

// ********************************
// MARK: - Other helper functions
// *******************************

func minAges(_ key: String) -> (months: Int, weeks: Int) {
  if let dict = Globals.dataByGroup[Globals.currentShowType] {
    let ages = dict.value(forKey: key) as! [Int]
    return (ages[0], ages[1])
  }
  return (0, 0)
}

func setAge(_ key: String, toWeeks weeks:Int? = nil, andMonths months: Int? = nil) {
  
}

func CCCAShow() -> Bool {
  return Globals.currentShowType == "CCCA Show"
}

// *************************************************
// MARK: - fetching from the Managed Object Context
// *************************************************

func existingCatsWithRegistration(_ rego: String, orName name: String, inContext context: NSManagedObjectContext) -> [Cat]? {
  // find any cats with the same registration (unless pending)
  let sameRego  = fetchCatsWithRegistration(rego, inContext: context)
  
  // find any cats with the same name
  let sameName = fetchCatsWithName(name, inContext: context)
  
  // put all those found cats into one big array
  let same = sameRego + sameName.filter { !sameRego.contains($0)}
  
  return same.isEmpty ? nil : same
}

func fetchEntitiesNamed(_ entityName: String, inContext context:NSManagedObjectContext, usingFormat format: String) -> [NSManagedObject] {
  let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
  fetchRequest.predicate = NSPredicate(format: format)
  let fetchResult: [NSManagedObject]?
  do {
    fetchResult = try context.fetch(fetchRequest) as? [NSManagedObject]
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

func fetchCatsWithRegistration(_ registration: String, inContext context: NSManagedObjectContext) -> [Cat] {
  if registration == pending {
    return []
  }
  return fetchEntitiesNamed(Cat.nomen, inContext: context, usingFormat: "\(Cat.registration) LIKE[c] \"\(registration)\"") as! [Cat]
}

func fetchCatsWithName(_ name: String, inContext context: NSManagedObjectContext) -> [Cat] {
  return fetchEntitiesNamed(Cat.nomen, inContext: context, usingFormat: "\(Cat.name) LIKE[c] \"\(name)\"") as! [Cat]
}

// ******************************************************************
// MARK: - reading in and writing arrays and dictionaries to Plists
// ******************************************************************


func dictFromPList(_ listName: String) -> NSDictionary {
  let url = Bundle.main.url(forResource: listName, withExtension:"plist")
  if let url = url {
    return NSDictionary(contentsOf:url)!
  } else {
    fatalError("Cannot load internal data \(listName)")
  }
}

func dict(_ dict: NSDictionary, toPlist listName: String) -> Bool {
  let url = Bundle.main.url(forResource: listName, withExtension:"plist")
  if let url = url {
    return dict.write(to: url, atomically: true)
  } else {
    return false
  }
}

func arrayFromPList(_ listName: String) -> [AnyObject]? {
  let url = Bundle.main.url(forResource: listName, withExtension:"plist")
  if let url = url {
    return (NSArray(contentsOf:url) as [AnyObject]?)
  } else {
    fatalError("Cannot load internal data \(listName)")
  }
}

func array(_ array: [Any], ToPlist listName: String) -> Bool {
  let url = Bundle.main.url(forResource: listName, withExtension:"plist")
  if let url = url {
    return (array as NSArray).write(to: url, atomically: true)
  } else {
    return false
  }
}

func readFile(_ fileName: String) -> Data {
  let path = Bundle.main.path(forResource: fileName, ofType: "txt")
  
  if let path = path {
    let d = FileManager.default.contents(atPath: path)
    if let d = d {
      return d
    }
  }
  fatalError("Cannot read data from \"\(fileName).txt\"")
}

// ***************************
// MARK: - querying the user
// ***************************

func areYouSure(_ message: String) -> Bool {
  return runAlertWithMessage(message, buttons: "OK", "Cancel") == NSAlertFirstButtonReturn
}

func errorAlert(message: String) {
  runAlertWithMessage(message, buttons: "OK")
}

func runAlertWithMessage(_ message: String, buttons: String ...) -> NSModalResponse {
  let alert = NSAlert()
  for button in buttons {
    alert.addButton(withTitle: button)
  }
  alert.messageText = message
  alert.alertStyle = .warning
  speaker.startSpeaking("Excuse me, \(message)")
  return alert.runModal()
}

// *******************
// MARK: - Globals
//********************

let _hireCageNumber = 5

class Globals: NSObject {

  @IBOutlet var theShowController: NSArrayController!
  @IBOutlet var theEntriesController: NSArrayController!
  
  static var dataByGroup:[String : NSDictionary] = {
    return dictFromPList("ShowFormats") as! [String : [String : [AnyObject]]]
    }() as [String : NSDictionary]

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
    let longDate = Foundation.DateFormatter()
    longDate.timeStyle = .none
    longDate.dateStyle = .long
    longDate.locale = Locale.current
    return longDate.string(from: currentShow!.date as Date)
  }
  
  dynamic var showTypes: [String] {
    return Globals.showTypes
  }
  
  static var showTypes: [String] = {
    let allKeys = Array(dataByGroup.keys)
    return allKeys.sorted(by: >)
    }()
 
  static var currentShowType: String {
    if currentShow == nil {
      print("Nil show when trying to get type for nil show")
    }
    return Globals.currentShow?.affiliation ?? Globals.defaultShowAffliation
  }
  
  static var numberOfRingsInShow: Int {
    if let show = Globals.currentShow {
      return show.numberOfRings.intValue
    } else {
      return 0
    }
  }
  
  fileprivate static var agouti: [String: [String]] = {
    return dictFromPList("agouti") as! [String: [String]]
  }()
  
  static var agoutiBreeds: [String]  {
    return Globals.agouti["breeds"]!
  }
  
  static var agoutiClasses: [String] {
    return Globals.agouti["classes"]!
  }
  
  static var cageTypes: (names:[String], sizes:[Int]) = {
    let path = Bundle.main.path(forResource: "CageTypes", ofType:"plist")
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
  
  static var litterCageLength: Int {
    return Globals.cageTypes.sizes[6]
  }
  
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
  
  class func setMinShowAge(weeks:Int? = nil, months: Int? = nil) {
    if weeks != nil { Globals.criticalAges[Headings.minShowAge]![0] = weeks! }
    if months != nil { Globals.criticalAges[Headings.minShowAge]![1] = months! }
  }
  
  class func setMaxLitterAge(weeks:Int? = nil, months: Int? = nil) {
    if weeks != nil { Globals.criticalAges[Headings.maxLitterAge]![0] = weeks! }
    if months != nil { Globals.criticalAges[Headings.maxLitterAge]![1] = months! }
  }
  
  class func setMaxPendingAge(weeks:Int? = nil, months: Int? = nil) {
    if weeks != nil { Globals.criticalAges[Headings.maxPendingAge]![0] = weeks! }
    if months != nil { Globals.criticalAges[Headings.maxPendingAge]![1] = months! }
  }
  
  class func setKittenAgeGroups(_ values: [Int]) {
    let size = values.count < 3 ? values.count : 3
    for index in 0 ..< size {
      Globals.criticalAges[Headings.kittenAgeGroups]![index] = values[index]
    }
  }
  
  class func setMaxKittenAge(months: Int) {
    Globals.criticalAges[Headings.kittenAgeGroups]![2] = months
  }
  
  class func saveCriticalAges() {
    if !dict(Globals.criticalAges as NSDictionary, toPlist: "CriticalAges") {
      print("Could not save critical ages")
    }
  }

 
  // ========================
  // MARK: - Methods
  // ========================
  
  func tableViewSelectionDidChange(_ aNotification: Notification) {
    Globals.currentShow = theShowController.selectedObjects?.first as? Show
    Globals.currentEntry = theEntriesController.selectedObjects?.first as? Entry
  }

}
