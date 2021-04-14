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

postfix func ++(c: inout Character) -> Character {
  let s = String(c).unicodeScalars
  let i = s[s.startIndex].value
  c = Character(UnicodeScalar(i + 1)!)
  return Character(UnicodeScalar(i)!)
}

extension String {
  var fileName: String {
    return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
  }
  
  var fileExtension: String {
    return NSURL(fileURLWithPath: self).pathExtension ?? ""
  }
}

extension String {
  var singular: String {
    return self.replacingOccurrences(of: "s+$", with: "", options: .regularExpression)
  }
}

protocol Datamaker {
  var data: Data {get }
}

extension String: Datamaker {
  var data: Data {
    if let ans = self.data(using: String.Encoding.utf8) {
      return ans
    } else {
      fatalError("Cannot encode \"\(self)\"")
    }
  }
}

extension Patterns: Datamaker {
  var data: Data {
    let sRep = String(describing: self)
    if let ans = sRep.data(using: String.Encoding.utf8) {
      return ans
    } else {
      fatalError("Cannot encode \"\(self)\"")
    }
  }
}

extension Int: Datamaker {
  var data: Data {
    let sRep = String(self)
    if let ans = sRep.data(using: String.Encoding.utf8) {
      return ans
    } else {
      fatalError("Cannot encode \"\(self)\"")
    }
  }
}

extension Data: Datamaker {
  var data: Data {
    return self
  }
}

extension Data {
  mutating func add(data: Datamaker ...) {
    for datum in data {
      self.append(datum.data)
    }
  }
}

extension NSControl {
  @objc var currentBreed: String {
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
  
  var description: String {
    let formatter = Foundation.DateFormatter()
    formatter.dateFormat = "dd MMM yyyy"
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
    } else if numberMonths < 4 {
      let numberWeeks = (Calendar.current.dateComponents([.day], from: self, to: otherDate).day  ?? 0) / 7
      return "\(numberWeeks) Weeks"
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
  
  var condensingWhitespace: String {
    return self.components(separatedBy: .whitespacesAndNewlines)
      .filter { !$0.isEmpty }
      .joined(separator: " ")
  }
  
  var initials: String {
    let name = String(self.prefix(upTo: self.firstIndex(of: "(") ?? self.endIndex))
    return String(name.components(separatedBy: .whitespaces).compactMap({ $0.first }))
  }
  
  func firstWord() -> String {
    if let myRange = self.firstIndex(of: " ") {
      return String(self.prefix(upTo: myRange))
    }
    else {
      return self
    }
  }
}

extension Array where Element == String {
  var initials: [String] {
    return self.map({ $0.initials })
  }
}

// ********************************
// MARK: - Structures
// *******************************

enum Headings {
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
  static let sections   = "Sections"
}

enum Affiliation : String {
  case ACF = "ACF Show"
  case COWA = "COAWA Show"
  case QFA = "QFA Show"
  case FCCQ = "FCCQ Show"
  case catsNSW = "Cats NSW Show"
  case CCCA = "CCCA Show"
  case GCCFSA = "GCCFSA Show"
  case NSWCFA = "NSWCFA Show"
}

extension Affiliation {
  static func ==(lhs: String, rhs: Affiliation) -> Bool {
    return lhs == rhs.rawValue
  }
  
  static func ==(lhs: String?, rhs: Affiliation) -> Bool {
    guard let lhs = lhs
      else { return false }
    return lhs == rhs.rawValue
  }

  static func !=(lhs: String, rhs: Affiliation) -> Bool {
    return !(lhs == rhs.rawValue)
  }
  
  static func !=(lhs: String?, rhs: Affiliation) -> Bool {
    guard let lhs = lhs
      else { return false }
    return !(lhs == rhs.rawValue)
  }
}

enum NationalAffiliations: String {
  case ACF = "ACF"
  case CCCA = "CCCA"
}

struct OrderedList<T:Equatable>: Sequence, IteratorProtocol {
  private let myArray: [T]
  private var present: [Bool]
  private var myCount = 0
  
  init(with possibleElements: [T]) {
    myArray = possibleElements
    present = Array(repeating: false, count: possibleElements.count)
  }
  
  var array: [T] {
  return myArray
  }
  
  var last: T? {
    return myArray.last
  }
  
  var count: Int {
    return myArray.count
  }
  
  mutating func next() -> T? {
    while myCount < myArray.count {
      defer { myCount += 1 }
      if present[myCount] { return  myArray[myCount] }
    }
    return nil
  }
  
  mutating func append(_ nextElement: T) {
    if let i = myArray.firstIndex(of: nextElement) {
      present[i] = true
    }
  }
}


struct AwardList {
    var group: ACFGroup
    var male, female: Bool
}

enum GroupName: String {
    case group1 = "Group 1", group2 = "Group 2", group3 = "Group 3", group4 = "Group 4", longhair = "Longhair", shorthair = "Shorthair", companion = "Companion"
    
    var acfEquivalent: [ACFGroup] {
        switch self {
        case .group1, .longhair:
            return [ACFGroup.group1]
        case .group2:
            return [ACFGroup.group2]
        case .group3:
            return [ACFGroup.group3]
        case .group4, .companion:
            return [ACFGroup.group4]
        case .shorthair:
            return [ACFGroup.group2, ACFGroup.group3]
        }
    }
    
}

enum ACFGroup: Int, CustomStringConvertible {
  mutating func increment() {
    self = ACFGroup(rawValue: self.rawValue + 1) ?? .exceeded
  }
  
  case group1 = 0
  case group2, group3, group4, exceeded
  
  var description: String {
    switch self {
    case .group1:
      return "Group One"
    case .group2:
      return "Group Two"
    case .group3:
      return "Group Three"
    case .group4:
      return "Group Four"
    case .exceeded:
      return "Exceeded"
    }
  }
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
// MARK: - Judging varities
// *******************************

enum Patterns: Int, Comparable, CustomStringConvertible {
  case colourClass = 0
  case agouti, agoutiWhite, nonAgouti, nonAgoutiWhite
  case mitted, bicolour
  case brown, sepia, mink, lynxPoint
  case solid, patched, patterned, silver, pointed
  
  var description: String {
    switch self {
    case .colourClass: return "Standard"
    case .agouti : return "Agouti"
    case .agoutiWhite : return "Agouti & White"
    case .nonAgouti : return "Non Agouti"
    case .nonAgoutiWhite : return "Non Agouti & White"
    case .mitted: return "Mitted"
    case .bicolour: return "BiColour"
    case .brown : return "Brown"
    case .sepia : return "Sepia"
    case .mink : return "Mink"
    case .lynxPoint: return "Lynx Point"
    case .solid: return "Solid"
    case .patched : return "Patched"
    case .patterned : return "Patterned"
    case .silver : return "Silver"
    case .pointed : return "Pointed"
    }
  }
  
  static func ==(lhs: Patterns, rhs: Patterns) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
  
  static func <(lhs: Patterns, rhs: Patterns) -> Bool {
    return lhs.rawValue < rhs.rawValue
  }
}

func categoryName(for category: Cat.Category) -> String {
  switch category {
  case .companion:
    return " Award of Merit "
  case .kitten:
    return " Best in Section "
  default:
    return " Challenge "
  }
}

// ********************************
// MARK: - General queries
// *******************************

let QFAShowType   = "QFA Show"
let NSWShowType   = "Cats NSW Show"
let COAWAShowType = "COAWA Show"
let CCCAShowType  = "CCCA Show"
let ACFShowType   = "ACF Show"

var organiseKittensByAgeGroups: Bool {
  let answer: Bool
  let showType = Globals.currentShowType
  switch (showType) {
  case ACFShowType, QFAShowType:
    answer = true
    break;
  default:
    answer = false
    break;
  }
  return answer
}

var bestInSectionKittens: Bool {
  let answer: Bool
  switch (Globals.currentShowType) {
  case NSWShowType, CCCAShowType:
    answer = true
    break;
  default:
    answer = false
    break;
  }
  return answer
}


var ACFAoEAwards: Bool {
  let answer: Bool
  switch (Globals.currentShowType) {
  case NSWShowType, ACFShowType, QFAShowType:
    answer = true
    break;
  default:
    answer = false
    break;
  }
  return answer
}

// ********************************
// MARK: - Other helper functions
// *******************************

var isCCCAShow : Bool {
  return Globals.currentShowType == Affiliation.CCCA
}

func endRingRow(places :Int = 5) -> Data {
  var data = Data()
  guard places > 0 else { return data }
  let num = places > 6 ? 6 : places
  for i in 1...num {
    let s = "\\cell}\n{\\pard\\intbl \\s36 \\f47\\qc\\fs24\\li0\\ri0\\langnp3081 \(i)"
    data.add(data: s)
  }
  
  for _ in num ... 5 {
    data.add(data: "\\cell}\n{\\pard\\intbl \\s36 \\f47\\qc\\fs24\\li0\\ri0\\langnp3081")
  }
  data.add(data: "\\cell}\n\\row}")
  
  return data
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
  return runAlertWithMessage(message, buttons: "OK", "Cancel") == NSApplication.ModalResponse.alertFirstButtonReturn
}

func errorAlert(message: String) {
  _ = runAlertWithMessage(message, buttons: "OK")
}

func runAlertWithMessage(_ message: String, buttons: String ...) -> NSApplication.ModalResponse {
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
    return dictFromPList("ShowFormats") as! [String : [String : AnyObject]]
    }() as [String : NSDictionary]

  static var currentSections: [String] {
    guard let showData = Globals.dataByGroup[currentShowType]
      else { print("Cannot get data for '\(currentShowType)'"); return [] }
    let e = (showData[Headings.sections] as? [String]) ?? []
    return e
  }
  
  static var currentShow: Show? = nil
  static var currentEntry: Entry? = nil
  static var defaultShowAffliation: Affiliation {
    let ans = Globals.showTypes.first ?? .ACF
    return ans
  }
  
 static var currentShowName: String {
    return currentShow?.name ?? ""
  }
  
  static var currentShowDate: String {
    if currentShow == nil {
      fatalError("Nil show when trying to get date for current show")
    }
    let longDate = Foundation.DateFormatter()
    longDate.timeStyle = .none
    longDate.dateStyle = .long
    longDate.locale = Locale.current
    return longDate.string(from: currentShow!.date as Date)
  }
  
  @objc dynamic var showTypes: [String] {
    return Globals.showTypes.map { $0.rawValue }
  }
  
  static var showTypes: [Affiliation] = {
    let allKeys = Array(dataByGroup.keys)
    return allKeys.sorted(by: <).map { return Affiliation(rawValue: $0) ?? .ACF }
    }()
 
  /**
   returns the state body that this show is affiliated to
 */
  static var currentShowType: String {
    if currentShow == nil {
      errorAlert(message: "No show selected")
    }
    return Globals.currentShow?.affiliation ?? Globals.defaultShowAffliation.rawValue
  }
  
  static var numberOfRingsInShow: Int {
    if let show = Globals.currentShow {
      return show.numberOfRings.intValue
    } else {
      return 0
    }
  }
  
  static var organiseKittensByAgeGroups: Bool {
    guard let answer = Globals.dataByGroup[Globals.currentShowType]?["organiseKittensByAgeGroups"] as? Bool
      else { errorAlert(message: "Cannot find switch 'organiseKittensByAgeGroups' for show type '\(Globals.currentShowType)'"); return true }
    return answer
  }
  
  fileprivate static var patternClassed: [String: [String: [String]]] = {
    guard let ans = dictFromPList("PatternClassed") as? [String: [String: [String]]]
      else { errorAlert(message: "Cannot load the data base of pattern restricted breeds"); return [:]}
    return ans
  }()
  
  static var patternedBreeds: [String]  {
    guard let dict = Globals.patternClassed[nationalAffiliation.rawValue.uppercased()]
      else { errorAlert(message: "Cannot get patterned breeds for affliation '\(nationalAffiliation)'"); return [] }
    guard let answer = dict["breeds"]
      else { errorAlert(message: "Cannot load the list pattern restricted breeds"); return []}
    return answer
  }
  
  static var patternClasses: [String] {
    guard let dict = Globals.patternClassed[nationalAffiliation.rawValue]
      else { print("Cannot get pattern classes for affliation '\(nationalAffiliation)'"); return []}
    return dict["classes"] ?? []
  }
  
  static var nationalAffiliation: NationalAffiliations {
    guard let string = dataByGroup[Globals.currentShowType]?["nationalAffiliation"] as? String
      else { errorAlert(message: "Cannot find the national affiliation for show type '\(Globals.currentShowType)'"); return .ACF}
    guard let answer = NationalAffiliations(rawValue: string)
      else { errorAlert(message: "Erronous value '\(string)' given as the national affiliation for show type '\(Globals.currentShowType)'"); return .ACF}
    return answer
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

  @objc static var criticalAges: [String : [Int]] = {
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
  
  @objc static var kittenAgeGroups: [Int] {
    return Globals.criticalAges[Headings.kittenAgeGroups]!
  }
  
  @objc static var maxKittenAge: Int {
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
  
  @objc class func setKittenAgeGroups(_ values: [Int]) {
    let size = values.count < 3 ? values.count : 3
    for index in 0 ..< size {
      Globals.criticalAges[Headings.kittenAgeGroups]![index] = values[index]
    }
  }
  
  @objc class func setMaxKittenAge(months: Int) {
    Globals.criticalAges[Headings.kittenAgeGroups]![2] = months
  }
  
  @objc class func saveCriticalAges() {
    if !dict(Globals.criticalAges as NSDictionary, toPlist: "CriticalAges") {
      print("Could not save critical ages")
    }
  }

 
  // ========================
  // MARK: - Methods
  // ========================
  
  @objc func tableViewSelectionDidChange(_ aNotification: Notification) {
    Globals.currentShow = theShowController.selectedObjects?.first as? Show
    Globals.currentEntry = theEntriesController.selectedObjects?.first as? Entry
  }

}
