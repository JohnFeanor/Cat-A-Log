//
//  Printing.swift
//  CatBase
//
//  Created by John Sandercock on 6/09/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa
// MARK: - Extensions
extension Data {
  mutating func appendRow(_ data: Datamaker ...) {
    self.append(excelSheet[Start_row]!)
    for datum in data {
      self.append(datum.data)
    }
    self.append(excelSheet[End_row]!)
  }
}

// MARK: - Variables and constants

let ringName = ["Ring One", "Ring Two", "Ring Three", "Ring Four", "Ring Five", "Ring Six"]


// MARK: Strings used
let challenge    = NSLocalizedString("Challenge", tableName: "general", comment: "Challenge")
let awardOfMerit  = NSLocalizedString("Award of Merit", tableName: "general", comment: "Award of merit")
let bestInSection = NSLocalizedString("Best In Section", tableName: "general", comment: "Best In Section")

// MARK: Keys used
fileprivate let Start_workbook      = "Start workbook"
fileprivate let Open_sheet          = "Open sheet"
fileprivate let End_open            = "End open"
fileprivate let Gold_sheet          = "Gold sheet"
fileprivate let End_gold            = "End gold"
fileprivate let Platinum_sheet      = "Platinum sheet"
fileprivate let End_platinum        = "End platinum"
fileprivate let Exhibitor_sheet     = "Exhibitor sheet"
fileprivate let End_exhibitor       = "End exhibitor"
fileprivate let Companion_sheet     = "Companion sheet"
fileprivate let End_companion       = "End companion"
fileprivate let Kitten_sheet        = "Kitten sheet"
fileprivate let End_kitten          = "End kitten"
fileprivate let List_sheet          = "List sheet"
fileprivate let End_list            = "End list"
fileprivate let Statistics_sheet    = "Statistics sheet"
fileprivate let End_statistics      = "End statistics"
fileprivate let Number_data         = "Number data"
fileprivate let String_data         = "String data"
fileprivate let Start_row           = "Start row"
fileprivate let Hiring_row          = "Hiring row"
fileprivate let Workers_row         = "Workers row"
fileprivate let Catalogue_row       = "Catalogue row"
fileprivate let End_row             = "End row"
fileprivate let End_cell            = "End cell"
fileprivate let End_sheet           = "End sheet"
fileprivate let End_workbook        = "End workbook"

// MARK: RTF data
fileprivate let newLine = "\\pard\\par\n"
fileprivate let ninePoint = "\\f1\\fs18 "
fileprivate let blankParagraph = "{\\pard\\fs24\\par}\n\n"
fileprivate let smallSpace = "{\\pard\\fs8\\keepn\\par}\n\n"
fileprivate let endParagraph = "\\par}\n"
fileprivate let endTableRow = "\\row}\n"
fileprivate let endTableCell = "\\cell}\n"
fileprivate let endCellEndRow = "\\cell}\n\\row}\n"
fileprivate let boxEndingLocations = [7320, 7900, 8480, 9060, 9640, 10220]

fileprivate let boxBeforeRings = readFile("boxBeforeRings")
fileprivate let ringNotInShow = readFile("Ring not in show")
fileprivate let ringInShow = readFile("Ring in show")
fileprivate let detailsFromRingBoxes = readFile("detailsFromRingBoxes")
fileprivate let endRingBoxRow = readFile("endRingBoxRow")

fileprivate let fileHeader = readFile("fileHeader")
fileprivate let welcomePages = readFile("welcomePages")
fileprivate let groupHeadingRow = readFile("group heading row")
fileprivate let subGroupHeadingRow = readFile("sub-group heading row")
fileprivate let subGroupCloseRow = readFile("sub-group close row")
fileprivate let footerText = readFile("footerText")
fileprivate let closeFooter = readFile("closeFooter")

fileprivate let catDetailsToParents = readFile("cat details to parents")
fileprivate let catDetailsToNumber = readFile("cat details to number")
fileprivate let catDetailsToName = readFile("cat details to name")
fileprivate let catDetailsToClass = readFile("cat details to class")

fileprivate let colourHeadingRow = readFile("colour heading row")

fileprivate let startFirstSection = readFile("startFirstSection")
fileprivate let startNewSection = readFile("startNewSection")
fileprivate let startBestOfRow = readFile("startBestOfRow")
fileprivate let detailsBeforeChallenge = readFile("detailsBeforeChallenge")

fileprivate let catNotInRing = readFile("cat not in ring")
fileprivate let catInRing = readFile("cat in ring")
fileprivate let blankCell = readFile("blankCell")

fileprivate let bestOfBreedStart = readFile("Best of breed start")
fileprivate let bestOfBreedToName = readFile("Best of breed to breedname")
fileprivate let bestOfBreedToLastName = readFile("Best of breed to last breedname")
fileprivate let bestOfBreedNameToEnd = readFile("Best of breed name to end")

fileprivate let ACFAwardsStart = readFile("ACF awards start")
fileprivate let ACFAwardstoSectionName = readFile("ACF awards to section name")
fileprivate let ACFAwardsFromSectionName = readFile("ACF awards from section name to end")

fileprivate let bestInShowStart = readFile("Best in Show heading")
fileprivate let bestInShowToRingNumber = readFile("Best in Show to ring number")
fileprivate let bestInShowFromRingNumber = readFile("Best in Show from number to end of table")

fileprivate let bestExhibitStart = readFile("Best Exhibit start")
fileprivate let bestExhibitToJudge1 = readFile("Best Exhibit to Judge 1")
fileprivate let bestExhibitJudge1ToJudge2 = readFile("Best Exhibit Judge1 to Judge2")
fileprivate let bestExhibitFromJudges = readFile("Best Exhibit from Judges")

fileprivate let notesBeginFilePart2 = readFile("notesBeginFilePart2")
fileprivate let notesToJudgeName = readFile("notesToJudgeName")
fileprivate let notesFromSectionName = readFile("notesFromSectionName")
fileprivate let notesToSubSectionName = readFile("notesToSubSectionName")
fileprivate let notesFromSubSectionName = readFile("notesFromSubSectionName")
fileprivate let notesToColour = readFile("notesToColour")
fileprivate let notesToCageNumber = readFile("notesToCageNumber")
fileprivate let notesFromCageToClass = readFile("notesFromCageToClass")
fileprivate let notesToAge = readFile("notesToAge")
fileprivate let notesFromAge = readFile("notesFromAge")
fileprivate let notesToAward = readFile("notesToAward")
fileprivate let notesFromAwardToEndOfRow = readFile("notesFromAwardToEndOfRow")
fileprivate let notesNewSectionBreak = readFile("notesNewSectionBreak")
fileprivate let notesBlankCell = readFile("notesBlankCell")
fileprivate let notesTopTenStart = readFile("notesTopTenStart")
fileprivate let notesTopTenFinish = readFile("notesTopTenFinish")
fileprivate let notesBestOfBreedStart = readFile("notesBestOfBreedStart")
fileprivate let notesBestOfBreedCell = readFile("notesBestOfBreedCell")
fileprivate let notesBestOfBreedCellEnd = readFile("notesBestOfBreedCellEnd")
fileprivate let notesBestOfBreedCellFinal = readFile("notesBestOfBreedCellFinal")
fileprivate let notesBestExhibit = readFile("notesBestExhibit")

fileprivate let judgesACFAwards1 = readFile("judgesACFawards1")
fileprivate let judgesACFAwards2 = readFile("judgesACFawards2")
fileprivate let judgesACFAwards3 = readFile("judgesACFawards3")
fileprivate let judgesACFAwards4 = readFile("judgesACFawards4")

fileprivate let top5Table = readFile("top5table")
fileprivate let top5RingToRing = readFile("top5RingToRing")
fileprivate let top5RingToSection = readFile("top5RingToSection")
fileprivate let top5Start = readFile("top5Start")
fileprivate let notesTop5Start = readFile("notesTop5Start")
fileprivate let notesTop5Finish = readFile("notesTop5Finish")

fileprivate func beginRTF(row i:Int) -> String {
  return "{\\trowd \\irow\(i)\\irowband\(i)\\trkeep\n"
}

func bookMark(_ name: String) -> String {
  let hypenated = name.replacingOccurrences(of: " ", with: "_")
  let ans = "{\\*\\bkmkstart \(hypenated)}\(name){\\*\\bkmkend \(hypenated)}\\cell }\n"
  return ans
}

var ringBoxes: Data {
  let numberOfRings = Globals.currentShow?.numberOfRings ?? 3
  var i = 0
  var data = Data()
  while i < Int(truncating: numberOfRings) {
    data.add(data: ringInShow, "\(boxEndingLocations[i])\n")
    i += 1
  }
  while i < 6 {
    data.add(data: ringNotInShow, "\(boxEndingLocations[i])\n")
    i += 1
  }
  return data
}

private var infoBlock: String {
  // get the user's calendar
  let userCalendar = Calendar.current
  
  // choose which date and time components are needed
  let requestedComponents: Set<Calendar.Component> = [
    .year,
    .month,
    .day,
    .hour,
    .minute,
    .second
  ]
  
  guard let show = Globals.currentShow else { return " " }
  let name = show.name
  // get the components
  let dt = userCalendar.dateComponents(requestedComponents, from: show.date)
  let dateInfo =  "{\\creatim\\yr\(dt.year ?? 2018)\\mo\(dt.month ?? 0)\\dy\(dt.day ?? 0)\\hr\(dt.hour ?? 0)\\min\(dt.minute ?? 0)}"
  
  return """
  {\\info
  {\\title \(name)}
  {\\author John Sandercock}
  {\\operator John Sandercock}
  \(dateInfo)
  {\\*\\company Feanor Birmans}
  }
  
  """
}

func judgeInitials(for group: String = "Longhair") -> String {
  guard let show = Globals.currentShow else { return " " }
  return show.judges(for: group).initials.filter({ !$0.isEmpty }).reduce("", { $0 + "\t" + $1 })
}

func excelDataFor(cage: Int, cat: Cat) -> Data {
  let myData = NSMutableData()
  myData.append(excelSheet[Start_row]!)
  myData.append(xmlNumber(cage))
  myData.append(xmlString(cat.registration))
  myData.append(xmlString(cat.title))
  myData.append(xmlString(cat.name))
  myData.append(xmlString(cat.sex))
  myData.append(xmlString(cat.colour))
  myData.append(xmlString(cat.breed))
  myData.append(xmlString(cat.group.rawValue))
  myData.append(xmlString(cat.exhibitor))
  myData.append(xmlString(cat.breeder))
  myData.append(xmlString(cat.challenge))
  if let currentShow = Globals.currentShow {
    let judges = currentShow.judges(for: cat.group.rawValue)
    for judge in judges {
      myData.append(xmlString(judge))
    }
  }
  myData.append(excelSheet[End_row]!)
  return myData as Data
}

private let excelSheet: [String : Data] = {
  let e = dictFromPList("Excel list") as! [String: String]
  var f: [String : Data] = [:]
  for (name, string) in e {
    f[name] = string.data
  }
  return f
}()

private let places: [Data]  = {
  let e = arrayFromPList("Places") as! [String]
  var ans : [Data] = []
  for string in e {
    ans.append(string.data)
  }
  return ans
}()


// MARK: - struct definitions

struct Litter {
  static var _number: Character = "A"
  var number: Character
  var name: String
  var birthDate: Date
  var breed: String
  var sire: String
  var dam: String
  var breeder: String
  var exhibitor: String
  var females: Int = 0
  var males: Int = 0
  var neuters: Int = 0
  var spays: Int = 0
  
  var groupNumber: Int {
    return Breeds.groupNumber(of: self.breed)
  }
  
  var age: String {
    if let showDate = Globals.currentShow?.date {
      return self.birthDate.differenceInMonthsAndYears(showDate)
    }
    return "No show date"
  }
  
  var ownerAndBreeder: String {
    if breeder.caseInsensitiveCompare(exhibitor) == .orderedSame {
      return "Br/Ex:\(breeder)"
    }
    return "Br:\(breeder) Ex:\(exhibitor)"
  }
  
  var kittens: String {
    // write out number of male & female kittens
    var numberOfKittens = String()
    if males > 0 {
      numberOfKittens += "\(males) \(Sex.name(ranked: 0))"
      if males > 1 { numberOfKittens += "s" }
    }
    if neuters > 0 {
      numberOfKittens += "\(neuters) \(Sex.name(ranked: 2))"
      if neuters > 1 { numberOfKittens += "s" }
    }
    if females > 0 {
      numberOfKittens += "\(females) \(Sex.name(ranked: 1))"
      if females > 1 { numberOfKittens += "s" }
    }
    if spays > 0 {
      numberOfKittens += "\(spays) \(Sex.name(ranked: 3))"
      if spays > 1 { numberOfKittens += "s" }
    }
    return numberOfKittens
  }

  
  init(entry: Entry) {
    let cat = entry.cat
    let prefixes = cat.name.components(separatedBy: " ")
    if prefixes.isEmpty {
      name = ""
    } else {
      name = prefixes[0]
    }
    birthDate = cat.birthDate as Date
    breed = cat.breed
    sire = cat.sire
    dam = cat.dam
    breeder = cat.breeder
    exhibitor = cat.exhibitor
    
    number = Litter._number++
  }
  
  func contains(_ cat: Cat) -> Bool {
    if self.birthDate != cat.birthDate as Date { return false }
    if self.sire != cat.sire { return false }
    if self.dam != cat.dam { return false }
    return true
  }
  
  mutating func addKittenOfSex(_ sex: String) {
    switch sex {
    case Sex.sexes[0]:
      males += 1
    case Sex.sexes[1]:
      females += 1
    case Sex.sexes[2]:
      neuters += 1
    case Sex.sexes[3]:
     spays += 1
    default:
      break
    }
  }
}

struct exhibitDetails {
  var wantsCatalogue : Bool
  var cats: [(cage : Int, name: String)]
  
  init(catalogue: Bool, cage: Int, cat: String) {
    wantsCatalogue = catalogue
    cats = [ (cage, cat)]
  }
}

struct OpenChallenge {
  private var competitors: [Int] = []
  private var category: Cat.Category = .open
  
  mutating func append(_ number: Int) {
    competitors.append(number)
  }
  
  mutating func empty() {
    competitors = []
  }
}

struct PrestigeChallenge: CustomStringConvertible, Sequence, IteratorProtocol {
  private var _male: [Int] = []
  private var _female: [Int] = []
  private var _neuter: [Int] = []
  private var _spay: [Int] = []
  var type: String
  var description: String {
    return type
  }
  
  init(challenge type: String) {
    self.type = type
  }
  
  subscript(row: Int) -> [Int] {
    get {
      switch row {
      case 0:
        return _male
      case 1:
        return _female
      case 2:
        return _neuter
      case 3:
        return _spay
      default:
        fatalError("Challenge subscript out of range")
      }
    }
    set {
      switch row {
      case 0:
        _male = newValue
      case 1:
        _female = newValue
      case 2:
        _neuter = newValue
      case 3:
        _spay = newValue
      default:
        fatalError("Challenge subscript out of range")
      }
    }
  }
  
  var male: String {
    return _male.isEmpty ? "Neuter" : "Male"
  }
  
  var female: String {
    return _female.isEmpty ? "Spay" : "Female"
  }
  
  var count: Int {
    var inCount = 0
    for i in 0 ... 3 {
      if !self[i].isEmpty {
        inCount += 1
      }
    }
    return inCount
  }
  
  private var _i = 0
  mutating func next() -> (String, String)? {
    defer { _i += 1 }
    switch _i {
    case 0:
      return _male.isEmpty ? ("", "") : ("Male \(type)", "\(_male.count > 1 ? "between " : " ")\(_male)")
    case 1:
      return _female.isEmpty ? ("", "") : ("Female \(type)", "\(_female.count > 1 ? "between " : " ")\(_female)")
    case 2:
      return _neuter.isEmpty ? ("", "") : ("Neuter \(type)", "\(_neuter.count > 1 ? "between " : " ")\(_neuter)")
    case 3:
      return _spay.isEmpty ? ("", "") : ("Spay \(type)", "\(_spay.count > 1 ? "between " : " ")\(_spay)")
    default:
      return nil
    }
  }
  
  mutating func empty() {
    _male = []
    _female = []
    _neuter = []
    _spay = []
  }
} // End of PrestigeChallenge

struct ACFAward: Sequence, IteratorProtocol {
  private var group1 = [false, false, false, false]
  private var group2 = [false, false, false, false]
  private var group3 = [false, false, false, false]
  private var group4 = [false, false, false, false]
  private var groupCount = ACFGroup.group1
  private var sexCount = SexType.male {
    didSet {
      if sexCount == .male { groupCount.increment() }
    }
  }
  
  subscript(row: ACFGroup) -> [Bool] {
    get {
      switch row {
      case .group1:
        return group1
      case .group2:
        return group2
      case .group3:
        return group3
      case .group4:
        return group4
      default:
        return []
      }
    }
  }
  
  mutating func add(cat: Cat?) {
    guard let cat = cat else { return }
    guard !cat.isKitten else {  return }
    guard !cat.isCompanion else { return }
    
    let sex = Swift.max(Swift.min(3, cat.sexRank), 0)
    switch Breeds.ACFgroupNumber(of: cat.breed) {
    case .group1:
      group1[sex] = true
    case .group2:
      group2[sex] = true
    case .group3:
      group3[sex] = true
    case .group4:
      group4[sex] = true
    default:
      break
    }
  }
  
  mutating func next() -> String? {
    defer { sexCount.increment() }
    if groupCount == .exceeded { return nil }
    while !self[groupCount][sexCount.rawValue] {
      sexCount.increment()
      if groupCount == .exceeded { return nil }
    }
    return "\(groupCount) \(sexCount)"
  }
    
    func awardsFor(group: GroupName, isEntire: Bool) -> [AwardList] {
        let male = isEntire ? 0 : 2
        let female = isEntire ? 1 : 3
        var ans: [AwardList] = []
        let acfGroups = group.acfEquivalent
        for acfGroup in acfGroups {
            ans.append(AwardList(group: acfGroup, male: self[acfGroup][male], female: self[acfGroup][female]))
        }
        return ans
    }
} // end struct ACFAward

struct JudgeData {
  var myData: [Data] = []
  let show: Show
  let showDate: String
  init(show: Show) {
    self.show = show
    showDate = show.date.description
    let i = show.numberOfRings.intValue
    for _ in 1 ... i {
      myData.append(Data())
    }
  }
  
  mutating func add(openChallenges: [Int], for category: Cat.Category) {
    // add an open challenge
    for (index, _) in myData.enumerated() {
      myData[index].add(data: notesBlankCell, notesToAward, categoryName(for: category), ninePoint)
      if openChallenges.count > 1 {
        myData[index].add(data: "between ")
      }
      myData[index].add(data: "\(openChallenges)", notesFromAwardToEndOfRow)
    }
  }
  
  mutating func add(prestigeChallenges: PrestigeChallenge, for category: Cat.Category) {
    // add a prestige challenge
    for (index, _) in myData.enumerated() {
      if prestigeChallenges.count > 0 {
        myData[index].add(data: blankCell)
      }
      for (challenge, contestants) in prestigeChallenges {
        if !challenge.isEmpty {
          myData[index].add(data: notesToAward, challenge, categoryName(for: category), ninePoint, contestants, notesFromAwardToEndOfRow)
        }
      }
    }
  }
  
  mutating func add(award info: String, for numberOfCats: Int) {
// for judges notes, always write at least one award
    let p = placesFor(cats: numberOfCats) - 1
    let numberPlaces: Int = p < 0 ? 0 : p
    
    for (index, _) in myData.enumerated() {
      myData[index].add(data: notesBlankCell)
      for i in 0 ... numberPlaces {
        myData[index].add(data: notesToAward, places[i], info, notesFromAwardToEndOfRow)
      }
    }
  }
  
  private var _privCount = [false, false, false, false, false, false]
  
  mutating func add(section: String) {
// insert a section break, and create a new header
    let judgename = show.judges(for: section)
    for (index, _) in myData.enumerated() {
      if _privCount[index] {
        myData[index].add(data: "\n\\sect\\sectd\\sectdefaultcl\n")
      } else {
        _privCount[index] = true
      }
      myData[index].add(data: notesToJudgeName, "\(show.name) \(ringName[index])\tJudge:  \(judgename[index])", endParagraph)
    }
  }
  
  mutating func addBestOf (breeds: [String]) {
    // Add the Best Of Breed table for the judge
    for (index, _) in myData.enumerated() {
      guard !breeds.isEmpty else { return }
      myData[index].add(data: notesBestOfBreedStart)
      for (i, breed) in breeds.enumerated() {
        guard Breeds.pedigree(breed: breed) else { break }
        myData[index].add(data: beginRTF(row: i), notesBestOfBreedCell, breed, notesBestOfBreedCellEnd)
      }
      
      myData[index].add(data: notesBestExhibit, blankParagraph)
    }
  }
  
  mutating func add(topTen cat: Cat) {
// Add the top ten table at the end of section (e.g Longhair Kittens)
    guard Globals.currentShow?.affiliation != Affiliation.NSWCFA
      else { return }
     for (index, _) in myData.enumerated() {
      myData[index].add(data: newLine, notesTopTenStart, cat.subGroup, notesTopTenFinish)
    }
  }
  
  mutating func add(top5 cat:Cat) {
    guard Globals.currentShow?.affiliation == Affiliation.NSWCFA
      else { return }
    guard !cat.isCompanion else { return }
    let grp = cat.isKitten ? "Kittens" : "Cats"
    for (index, _) in myData.enumerated() {
      myData[index].add(data: notesTop5Start, grp, notesTop5Finish)
    }
  }

  mutating func add(group: String) {
// Add the group heading - e.g. Longhair Kittens
    for (index, _) in myData.enumerated() {
      myData[index].add(data: groupHeadingRow, bookMark(group), endTableRow)
    }
  }

  mutating func add(subgroup: String) {
// Add the sub group heading - e.g. Birman Kittens
    for (index, _) in myData.enumerated() {
      myData[index].add(data: blankParagraph, notesToSubSectionName, subgroup, notesFromSubSectionName, smallSpace)
    }
  }
  
  mutating func add(colour: String) {
// Add the colour
    for (index, _) in myData.enumerated() {
      myData[index].add(data: notesToColour, colour, endCellEndRow)
    }
  }
  
  mutating func add(cage cageNumber: Int, entry: Entry, classDetails: String) {
    for (index, _) in myData.enumerated() {
      myData[index].add(data: notesToCageNumber, cageNumber, notesFromCageToClass, classDetails, endCellEndRow)
      let birthDateAndAge = "\(entry.cat.birthDate.string)\\line \(entry.cat.age)"
      let entered = entry.rings[index] ? "" : "N/E"
      myData[index].add(data: notesToAge, birthDateAndAge, notesFromAge, entered, endCellEndRow)
    }
  }
  
  mutating func add(litter: Litter) {
    for (index, _) in myData.enumerated() {
      myData[index].add(data: notesToCageNumber, "Litter \(litter.number)", notesFromCageToClass, "\(litter.breed) Litter \(litter.kittens)", endCellEndRow)
      let birthDateAndAge = "\(litter.birthDate.string)\\line \(litter.age)"
      let entered = ""
      myData[index].add(data: notesToAge, birthDateAndAge, notesFromAge, entered, endCellEndRow)
    }
  }
    
    mutating func addLine() {
        // Write out a blank paragraph
        for (index, _) in myData.enumerated() {
            myData[index].add(data: blankParagraph)
        }
    }
    
    mutating func add(acfAwards: ACFAward, for cat: Cat) {
        if cat.isKitten { return }
        if cat.isCompanion { return }
        let values = acfAwards.awardsFor(group: cat.group, isEntire: cat.isEntire)
        let isEntire = cat.isEntire
        let male = isEntire ? SexType.male : SexType.neuter
        let female = isEntire ? SexType.female : SexType.spay
        for value in values {
            let groupName = value.group.description
            for (index, _) in myData.enumerated() {
                myData[index].add(data: judgesACFAwards1, groupName, judgesACFAwards2)
                if value.male { myData[index].add(data: judgesACFAwards3, "\(groupName) \(male)", judgesACFAwards4) }
                if value.female { myData[index].add(data: judgesACFAwards3, "\(groupName) \(female)", judgesACFAwards4) }
                myData[index].add(data: blankParagraph)
           }
        }
    }

    mutating func write(to url: URL) throws {
        let dirURL = url.deletingPathExtension().path
        for (index, data) in myData.enumerated() {
            var finalData = readFile("notesBeginFile")
            finalData.add(data: showDate)
            finalData.add(data: notesBeginFilePart2)
            finalData.add(data: infoBlock)
            finalData.append(data)
            finalData.add(data: endParagraph)
          
            let newURL = URL(fileURLWithPath: "\(dirURL) judges files ring \(index+1).rtf")
          
            do {
                try finalData.write(to: newURL)
            }
          
        }
    }
  
} // end struct JudgeData

struct CatalogueData {
  var myData = Data()
  let show: Show
  let name : String
  
  init(show: Show, name: String) {
    self.show = show
    self.name = name
    // Add the rtf file metadata
      myData.add(data: fileHeader, infoBlock, welcomePages)
    
    // Add the MS Word footer
      let showDate = show.date.description
      myData.add(data: footerText, "\(name) \(showDate)", closeFooter)
  }
  
  var awardRow: Data {
    let numberOfRings = show.numberOfRings.intValue
    var i = 0
    var data = Data(startBestOfRow)
    while i < numberOfRings {
      data.add(data: ringInShow, "\(boxEndingLocations[i])\n")
      i += 1
    }
    while i < 6 {
      data.add(data: ringNotInShow, "\(boxEndingLocations[i])\n")
      i += 1
    }
    data.add(data: detailsBeforeChallenge)
    return data
  }

  mutating func add(openChallenges: [Int], for category: Cat.Category) {
    // add an open challenge
      myData.add(data: blankCell, awardRow, categoryName(for: category), ninePoint)
      if openChallenges.count > 1 {
        myData.add(data: "between ")
      }
      myData.add(data: "\(openChallenges)", endRingBoxRow)
  }
  
  mutating func add(prestigeChallenges: PrestigeChallenge, for category: Cat.Category) {
    // add a prestige challenge
      if prestigeChallenges.count > 0 {
        myData.add(data: blankCell)
      }
      for (challenge, contestants) in prestigeChallenges {
        if !challenge.isEmpty {
          myData.add(data: awardRow, challenge, categoryName(for: category), ninePoint, contestants, endRingBoxRow)
        }
      }
  }
  
  mutating func add(award info: String, for numberOfCats: Int) {
    // for judges notes, always write at least one award
    let numberPlaces: Int = placesFor(cats: numberOfCats)
    guard numberPlaces > 0 else { return }

      myData.add(data: blankCell)
      for i in 0 ..< numberPlaces {
        myData.add(data: awardRow, places[i], info, endRingBoxRow)
      }
  }

  mutating func add(firstSection: String) {
    // insert the first section break, and create a new header
    myData.add(data: startFirstSection, judgeInitials(for: firstSection), endParagraph)
  }
  
  mutating func add(newSection: String) {
    // insert a section break, and create a new header
      myData.add(data: blankParagraph, startNewSection, judgeInitials(for: newSection), endParagraph)
  }

  mutating func add(group: String) {
    // Add the group heading - e.g. Longhair Kittens
      myData.add(data: groupHeadingRow, bookMark(group), endTableRow)
  }

  mutating func add(subgroup: String) {
    // Add the sub group heading - e.g. Birman Kittens
      myData.add(data: blankParagraph, subGroupHeadingRow, subgroup, subGroupCloseRow, smallSpace)
  }

  mutating func add(colour: String) {
    // Add the colour
      myData.add(data: colourHeadingRow, colour, endCellEndRow)
  }

  mutating func add(cage cageNumber: Int, entry: Entry, classDetails: String) {
    myData.add(data: catDetailsToNumber, cageNumber, catDetailsToName)
    myData.add(data: entry.cat.titleAndName, catDetailsToClass, classDetails, endCellEndRow)
    
    let birthDateAndAge = "\(entry.cat.birthDate.string)\\line \(entry.cat.age)"
    myData.add(data: boxBeforeRings, ringBoxes, detailsFromRingBoxes, birthDateAndAge, catDetailsToParents)
    let catParents = entry.cat.parents + "\\line " + entry.cat.registration + " " + entry.cat.ownerAndBreeder
    myData.add(data: catParents, endTableCell)
    let numberOfRings = show.numberOfRings.intValue
    for (count, include) in entry.rings.enumerated() {
      if count >= numberOfRings {
        myData.append(catInRing)
      } else if include {
        myData.append(catInRing)
      } else {
        myData.append(catNotInRing)
      }
    }
    myData.add(data: endTableRow)
  }
  
  mutating func add(litter: Litter) {
    myData.add(data: catDetailsToNumber, "Litter \(litter.number)", catDetailsToName)
    myData.add(data: "\(litter.name) \(litter.breed) Litter", catDetailsToClass, litter.kittens, endCellEndRow)
    
    print("\(litter.name) \(litter.breed) Litter :: \(litter.kittens)")
    let birthDateAndAge = "\(litter.birthDate.string)\\line \(litter.age)"
    print(birthDateAndAge)
    myData.add(data: boxBeforeRings, ringBoxes, detailsFromRingBoxes, birthDateAndAge, catDetailsToParents)
    let catParents = "\(litter.sire) \\'d7 \(litter.dam)\\line \(litter.ownerAndBreeder)"
    myData.add(data: catParents, endTableCell)
    let numberOfRings = show.numberOfRings.intValue
    for count in 1 ... maxNumberOfRings {
      if count > numberOfRings {
        myData.append(catInRing)
      } else {
        myData.append(catInRing)
      }
    }
    myData.add(data: endTableRow)
  }

  // create Best of Breed table
  mutating func add(breedTable: OrderedList<String>) {
    let breeds = breedTable.filter { Breeds.pedigree(breed: $0) }
    let lastElement = breeds.count - 1
    myData.add(data: bestOfBreedStart)
    for (index,breed) in breeds.enumerated() {
      if index == lastElement { myData.add(data: bestOfBreedToLastName, breed, bestOfBreedNameToEnd, blankParagraph) }
      else { myData.add(data: bestOfBreedToName, breed, bestOfBreedNameToEnd) }
    }
  }

  mutating func add(acfAwards: ACFAward) {
    myData.add(data: ACFAwardsStart)
    for award in acfAwards {
      myData.add(data: ACFAwardstoSectionName, award, ACFAwardsFromSectionName)
    }
  }
  
  mutating func addBestInShow() {
// Write out Best in Show awards
    guard Globals.currentShow?.affiliation != Affiliation.NSWCFA
      else { return }
    let numberOfRings = show.numberOfRings.intValue
    myData.add(data: bestInShowStart)
    for i in 0 ..< numberOfRings {
      myData.add(data: bestInShowToRingNumber, ringName[i], bestInShowFromRingNumber)
    }
  }

  mutating func addBestExhibits() {
//  Write out Best Exhibit for each judge
    let lhJudges = show.judges(for: "Longhair")
    let shJudges = show.judges(for: "Shorthair")
    myData.add(data: bestExhibitStart)
    let numberOfRings = show.numberOfRings.intValue
    for i in 0 ..< numberOfRings {
      myData.add(data: bestExhibitToJudge1, lhJudges[i], bestExhibitJudge1ToJudge2, shJudges[i], bestExhibitFromJudges)
    }
  }
  
  mutating func add(top5 cat: Cat) {
    // Write out the Top 5 table for NSWCFA shows
    guard Globals.currentShow?.affiliation == Affiliation.NSWCFA
      else { return }
    guard !cat.isCompanion else { return }
    let grp = cat.isKitten ? "Kitten" : "Cat"
    let nmbRings = Globals.currentShow?.numberOfRings.intValue ?? 4
    let number = (nmbRings + 1) / 2
    for i in (0 ..< number) {
      myData.add(data: top5Start, i * 2 + 1, top5RingToRing, i * 2 + 2, top5RingToSection, grp, top5Table)
    }
  }
    
    mutating func addLine() {
    // Write out a blank paragraph
        myData.add(data: blankParagraph)
    }
  
  mutating func write(to url: URL) throws {
    myData.add(data: endParagraph)
    
    do {
      try myData.write(to: url)
    }
  }

} // End struct CatalogueData
 
// MARK: - Helper functions
fileprivate func newURLfrom(_ oldURL : URL, with newName: String) -> URL {
  return oldURL.deletingLastPathComponent().appendingPathComponent(newName)
}

fileprivate func placesFor(cats num: Int) -> Int {
  if num < 2 { return 0 }
  if num < 3 { return 1 }
  if num < 6 { return 2 }
  if num < 9 { return 3 }
  return 5
}

fileprivate func xmlString(_ str: String) -> Data {
  var xmlStr = str.replacingOccurrences(of: "&", with: "&amp;")
  if xmlStr == "Platinum" {
    xmlStr = "Platinum or above"
  }
  return excelSheet[String_data]! + xmlStr.data + excelSheet[End_cell]!
}

fileprivate func xmlNumber(_ num: Int) -> Data {
  return excelSheet[Number_data]! + String(num).data + excelSheet[End_cell]!
}

fileprivate let xmlEmptyRow: Data = {
  return excelSheet[Start_row]! + excelSheet[End_cell]!
}()

extension MainWindowController {
  // ***************************************
  // MARK: -
  // ***************************************
  func printCatalog(_ filename: String, to url: URL) {
    guard let currentShow = Globals.currentShow
      else { errorAlert(message: "No show selected"); return }
    
    // MARK: Variable and constant declarations
    // catalogue RTF Data file
    let name = filename.fileName
    var catalogueFile = CatalogueData(show: currentShow, name: name)
    var judgesFile = JudgeData(show: currentShow)
//    let numberOfRings = currentShow.numberOfRings.intValue
    
    // Excel spreadsheet data files
    var openData        = excelSheet[Start_workbook]! + excelSheet[Open_sheet]!
    var goldData        = excelSheet[Gold_sheet]!
    var platinumData    = excelSheet[Platinum_sheet]!
    var companionData   = excelSheet[Companion_sheet]!
    var kittenData      = excelSheet[Kitten_sheet]!
    var listData        = excelSheet[List_sheet]!
    var statisticsData  = excelSheet[Statistics_sheet]!
    
    // Sets and arrays for recording information for spreadsheet
    var workers       = Set<String>()
    var catalogues    = Set<String>()
    var breedsPresent = OrderedList(with: Breeds.currentList)
    var acfAwardsPresent = ACFAward()
    let hiring        = NSCountedSet()
    var litters: [Litter] = []

    // Challenges
    var openChallenges: [Int] = []
    var goldChallenges = PrestigeChallenge(challenge: "Gold")
    var platinumChallenges = PrestigeChallenge(challenge: "Platinum")
    var cccaAwards = PrestigeChallenge(challenge: "CCCA")

    var exhibitors : [String : exhibitDetails] = [:]
    
    var cageNumber = 1
    var cagelength = 0
    var colourCount = 1
    var breedCount = 1

    var previousEntry: Entry? = nil

    let unsortedEntries = theEntriesController.arrangedObjects as AnyObject
    let sortEntries = unsortedEntries as! [Entry]
    let sortedEntrys: [Entry]
    if currentShow.affiliation == .NSWCFA {
      sortedEntrys = sortEntries.sorted(by: { return $0.cat.NSWcompare(with: $1.cat) })
    } else {
      sortedEntrys = sortEntries.sorted(by: { return $0.cat.compare(with: $1.cat) })
    }
    
    // MARK: sub routines
    // -------------------
    func doBestOfBreed(for numCats: Int, of entry: Cat? ) {
      guard let entry = entry else { return }
      if numCats == 0 { return }
      
      let info: String
      info = " \(entry.breed) \(entry.sectionNameAsSingle)"
      statisticsData.appendRow(xmlString(info), xmlNumber(numCats), xmlString("cages"), xmlString("length"), xmlNumber(cagelength), xmlString("mm"))
      if Breeds.pedigree(breed: entry.breed) {
        breedsPresent.append(entry.breed)
      }
      catalogueFile.add(award: info, for: numCats)
      
      if !entry.isCompanion {
        judgesFile.add(award: info, for: numCats)
      }
    }
    
    func doBestOfColour(for numCats: Int, of entry: Entry? ) {
      guard let entry = entry else { return }
      let info: String
      if entry.cat.isLimited {
        info = " \(entry.cat.patternRank.description) \(entry.cat.breed) \(entry.cat.sectionNameAsSingle)"
      } else {
        info = " \(entry.cat.colour) \(entry.cat.breed) \(entry.cat.sectionNameAsSingle)"
      }
      judgesFile.add(award: info, for: numCats)
      catalogueFile.add(award: info, for: numCats)
    }
    
    func doPrestigeChallenges( for listOfCats: inout PrestigeChallenge, of category: Cat.Category) {
      judgesFile.add(prestigeChallenges: listOfCats, for: category)
      catalogueFile.add(prestigeChallenges: listOfCats, for: category)

      listOfCats.empty()
    }
/**
Prints out the open challenges
  - parameter category: the category for this challenge [.kitten, .companion, .open, .gold or .platinum]
  - important: will empty the open challenges array if it prints challenges
  - Remark:
    - returns without doing anything if category is nil
    - returns without doing anything if the open challenges array is empty
    - if the category is `.kitten` and there is not a best in section for them, will return without doing anything
  - todo: possibly make this a method of the open challenge struct
 */
    func doOpenChallenges(for category: Cat.Category? ) {
      // ** check to make sure this is an entry
      guard let category = category
        else { return }
      // ** Kittens do not have challenges
      if category == .kitten && !bestInSectionKittens { return }
      guard !openChallenges.isEmpty else { return }
      // start RTF table row
      judgesFile.add(openChallenges: openChallenges, for: category)
      catalogueFile.add(openChallenges: openChallenges, for: category)
      
      // Clear the list of cats competing for challenge
      openChallenges = []
    }
    
/**
Check the entry `entry` in cage number `cage` for the challenge type required, and record it for when the challenges are printed out
  - parameter cage: The cage number of the cat
  - parameter entry: Optional entry - if nil, the function just returns
*/
    func recordChallenge(cage: Int, entry: Entry?) {
      guard let entry = entry else { return }
      guard !entry.cat.isKitten else { return }
      if Globals.nationalAffiliation == .ACF {
        switch entry.challenge {
        case .open:
          openChallenges.append(cage)
        case .gold:
          goldChallenges[entry.cat.sexRank].append(cage)
        case .platinum:
          platinumChallenges[entry.cat.sexRank].append(cage)
        default:
          break
        }
      } else {
        openChallenges.append(cage)
        if !entry.cat.title.isEmpty {
          cccaAwards[entry.cat.sexRank].append(cage)
        }
      }
    }
    
    // MARK: - Begin creating catalogue
    
    // MARK:  - Sort through and find litters
    for entry in sortedEntrys {
      var newLitter = true
      if entry.isInLitter {
        for litter in litters {
          if entry.isInLitter(litter) {
            newLitter = false
            break
          }
        }
        if newLitter {
          litters += [Litter(entry: entry)]
        }
      }
    }
    
    // MARK: Find all kittens in the litters
    //         Update them to show they are in litters
    for entry in sortedEntrys {
      for i in 0 ..< litters.count {
        guard entry.isInLitter(litters[i])
          else { continue }
        entry.litter = true
        litters[i].addKittenOfSex(entry.cat.sex)
      }
    }

    // ***************************************
    // MARK: - Begin loop
    // ***************************************
    for thisEntry in sortedEntrys {
        var fallOn = false
        
        // Check to see if we should print out challenges for last entry
        if thisEntry.newChallengeClassTo(previousEntry) {
            doOpenChallenges(for: previousEntry?.cat.category)
        }
        
        // Print out Best of colour for last entry
        if thisEntry.newColourClassTo(previousEntry) {
            doBestOfColour(for: colourCount, of: previousEntry)
            colourCount = 1
        } else {
            colourCount += 1
        }
        
        // Print out Best of breed for last entry
        if thisEntry.newBreedTo(previousEntry) {
            doBestOfBreed(for: breedCount, of: previousEntry?.cat)
            
            breedCount = 1
        } else {
            breedCount += 1
        }
        
        // write prestige challenges and top ten if required
        if let previousEntry = previousEntry, thisEntry.cat.subGroup != previousEntry.cat.subGroup {
            doPrestigeChallenges(for: &goldChallenges, of: previousEntry.cat.category)
            doPrestigeChallenges(for: &platinumChallenges, of: previousEntry.cat.category)
            doPrestigeChallenges(for: &cccaAwards, of: previousEntry.cat.category)
            judgesFile.add(topTen: previousEntry.cat)
            
            catalogueFile.add(top5: previousEntry.cat)
            judgesFile.add(top5: previousEntry.cat)
            
            judgesFile.add(acfAwards: acfAwardsPresent, for: previousEntry.cat)
        }
        
        var newSectionStarted = false
        // MARK: finish last section
        if thisEntry.cat.group != previousEntry?.cat.group {
            if let previousEntry = previousEntry {
              
              let breedsInThisGroup = Breeds.belongingTo(group: previousEntry.cat.group.rawValue)
              let breedsToList = breedsPresent.filter { breedsInThisGroup.contains($0) }
              judgesFile.addBestOf(breeds: breedsToList)
              
              catalogueFile.add(newSection: thisEntry.cat.group.rawValue)
            } else {
              catalogueFile.add(firstSection: thisEntry.cat.group.rawValue)
            }
            judgesFile.add(section: thisEntry.cat.group.rawValue)
            fallOn = true
            newSectionStarted = true
        }
        
        // Add the group heading - e.g. Longhair Kittens
        if fallOn || thisEntry.cat.subGroup != previousEntry?.cat.subGroup {
            
            // Write out litters for last group
            if let previousEntry = previousEntry, previousEntry.isKittenClass {
                var first = true
                for litter in litters {
                    if litter.groupNumber == previousEntry.cat.groupNumber {
                        if first {
                            first = false
                            judgesFile.add(subgroup: "\(previousEntry.cat.group) Litters")
                            catalogueFile.add(subgroup: "\(previousEntry.cat.group) Litters")
                        }
                        catalogueFile.add(litter: litter)
                        judgesFile.add(litter: litter)
                    }
                }
            }
            
            if !newSectionStarted {
                judgesFile.addLine()
                catalogueFile.addLine()
            }
            judgesFile.add(group: thisEntry.cat.subGroup)
            catalogueFile.add(group: thisEntry.cat.subGroup)
            fallOn = true
        }
        
        // Add the sub group heading - e.g. Birman Kittens
        if Breeds.breedsInGroupWith(breed: thisEntry.cat.breed) > 1 && (fallOn || thisEntry.cat.breed != previousEntry?.cat.breed) {
            judgesFile.add(subgroup: thisEntry.cat.breedSection)
            catalogueFile.add(subgroup: thisEntry.cat.breedSection)
            fallOn = true
        }
        
        if thisEntry.cat.isLimited {
            if fallOn || thisEntry.cat.patternRank != previousEntry?.cat.patternRank {
                judgesFile.add(colour: thisEntry.cat.patternRank.description)
                catalogueFile.add(colour: thisEntry.cat.patternRank.description)
                fallOn = true
            }
        }
        
        if fallOn || thisEntry.cat.colour != previousEntry?.cat.colour {
            // Add the colour
            judgesFile.add(colour: thisEntry.cat.colour)
            catalogueFile.add(colour: thisEntry.cat.colour)
            fallOn = true
        }
        
        // Add the cat details
        let classDetails: String
        if thisEntry.cat.classDetails != previousEntry?.cat.classDetails || fallOn {
            classDetails = thisEntry.cat.classDetails
        } else {
            classDetails = ""
        }
        catalogueFile.add(cage: cageNumber, entry: thisEntry, classDetails: classDetails)
        judgesFile.add(cage: cageNumber, entry: thisEntry, classDetails: classDetails)
        
        // MARK: record challenge
        recordChallenge(cage: cageNumber, entry: thisEntry)
        acfAwardsPresent.add(cat: thisEntry.cat)
        
        // MARK: write details to spreadsheet
        // ----------------------------
        listData.append(excelSheet[Start_row]!)
        listData.append(xmlNumber(cageNumber))
        listData.append(xmlString(thisEntry.cat.name))
        listData.append(xmlString(thisEntry.cat.exhibitor))
        listData.append(xmlString(thisEntry.cat.colour))
        listData.append(xmlString(thisEntry.cat.breed))
        listData.append(xmlString(thisEntry.cat.sex))
        listData.append(xmlString(thisEntry.cat.group.rawValue))
        listData.append(xmlString(thisEntry.cat.challenge))
        if thisEntry.isInLitter {
            for litter in litters {
                if thisEntry.isInLitter(litter) {
                    listData.append(xmlString("\(thisEntry.typeOfCage) \(litter.number)"))
                }
            }
        } else {
            listData.append(xmlString(thisEntry.typeOfCage))
        }
        listData.append(excelSheet[End_row]!)
        
        if thisEntry.cat.isCompanion {
            companionData.append(excelDataFor(cage: cageNumber, cat: thisEntry.cat))
        } else if thisEntry.cat.isKitten {
            kittenData.append(excelDataFor(cage: cageNumber, cat: thisEntry.cat))
        }  else {
            switch Challenges.type(thisEntry) {
            case .gold:
                goldData.append(excelDataFor(cage: cageNumber, cat: thisEntry.cat))
            case .platinum:
                platinumData.append(excelDataFor(cage: cageNumber, cat: thisEntry.cat))
            case .open:
                openData.append(excelDataFor(cage: cageNumber, cat: thisEntry.cat))
            default:
                break
            }
        }
        
        // Put this cat into its exhibitors list of entries
        // -------------------------------------------------
        if exhibitors[thisEntry.cat.exhibitor] == nil {
            exhibitors[thisEntry.cat.exhibitor] = exhibitDetails(catalogue: thisEntry.catalogueRequired.boolValue, cage: cageNumber, cat: thisEntry.cat.name)
        } else {
            exhibitors[thisEntry.cat.exhibitor]?.cats.append((cageNumber, thisEntry.cat.name))
        }
        
        // Will they work ??
        // ------------------
        if thisEntry.willWork.boolValue { workers.insert(thisEntry.cat.exhibitor) }
        
        // Do they need a catalogue ??
        // ----------------------------
        if thisEntry.catalogueRequired.boolValue { catalogues.insert(thisEntry.cat.exhibitor) }
        
        // Are they hiring a cage ??
        // --------------------------
        if thisEntry.hireCage.boolValue { hiring.add(thisEntry.cat.exhibitor) }
        
        // Add up cage sizes
        if !thisEntry.isInLitter { cagelength += thisEntry.cageSize.intValue }
        
        
        
        cageNumber += 1
        previousEntry = thisEntry
    } // End of main loop
    // ***************************************
    // MARK: Write challenges for last cat
    if let previousEntry = previousEntry {
      doOpenChallenges(for: previousEntry.cat.category)
      doBestOfColour(for: colourCount, of: previousEntry)
      doBestOfBreed(for: breedCount, of: previousEntry.cat)
      judgesFile.add(topTen: previousEntry.cat)
      doPrestigeChallenges(for: &goldChallenges, of: previousEntry.cat.category)
      doPrestigeChallenges(for: &platinumChallenges, of: previousEntry.cat.category)
      doPrestigeChallenges(for: &cccaAwards, of: previousEntry.cat.category)
      catalogueFile.add(top5: previousEntry.cat)
      judgesFile.add(top5: previousEntry.cat)
    }

    // MARK: Finish and write the catalogue file
    // ---------------------------------------------
    
    // write out Best of Breed table
    catalogueFile.add(breedTable: breedsPresent)
    
    // Write out ACF AoE awards
    if Globals.nationalAffiliation == .ACF {
      catalogueFile.add(acfAwards: acfAwardsPresent)
    }
    
    // Write out Best in Show awards
    catalogueFile.addBestInShow()
    
    //Write out Best Exhibit for each judge
    catalogueFile.addBestExhibits()
    
    do {
      try catalogueFile.write(to: url)
    } catch  {
      errorAlert(message: "Error writing file: \(error)")
    }
  
    do {
      try judgesFile.write(to: url)
    } catch  {
      errorAlert(message: "Error writing file: \(error)")
    }

    // MARK: Finish the Excel file
    // ---------------------------------------------
    openData.append(excelSheet[End_open]!)
    openData.append(goldData as Data)
    openData.append(excelSheet[End_gold]!)
    openData.append(platinumData as Data)
    openData.append(excelSheet[End_platinum]!)
    openData.append(companionData as Data)
    openData.append(excelSheet[End_companion]!)
    openData.append(kittenData as Data)
    openData.append(excelSheet[End_kitten]!)
    openData.append(listData as Data)
    openData.append(excelSheet[End_list]!)
    openData.append(statisticsData as Data)

    // Do hire cage data
    // --------------------------
    openData.append(excelSheet[Hiring_row]!)
    if hiring.count > 0 {
      for person in hiring {
        if let person = person as? String {
          openData.appendRow(xmlString(person), xmlNumber(hiring.count(for: person)))
        } else {
          fatalError("Object \(person) in hiring list is not a string")
        }
      }
    } else {
      openData.appendRow("NONE")
    }
    
    // Check to see if we have some workers
    // ---------------------------------------------
    openData.append(excelSheet[Workers_row]!)
    
    if workers.count > 0 {
      for person in workers {
        openData.appendRow(xmlString(person))
      }
    } else {
      openData.appendRow("None")
    }
    
    // Check to see who needs catalogues
    // -------------------------------------------
    openData.append(excelSheet[Catalogue_row]!)
    
    if catalogues.count > 0 {
      for person in catalogues {
        openData.appendRow(xmlString(person))
      }
    } else {
      openData.appendRow(xmlString("NONE"))
    }
    
    openData.append(excelSheet[End_statistics]!)
    
    // Add exhibitor list to spreadsheet
    // ----------------------------------
    openData.append(excelSheet[Exhibitor_sheet]!)
    for (exhibitor, exhibitDetails) in exhibitors {
      openData.append(excelSheet[Start_row]!)
      openData.append(xmlString(exhibitor))
      openData.append(xmlString(exhibitDetails.wantsCatalogue ? "Yes" : "No"))
      for (cage, name) in exhibitDetails.cats {
        openData.append(xmlNumber(cage))
        openData.append(xmlString(name))
      }
      openData.append(excelSheet[End_row]!)
    }
    openData.append(excelSheet[End_exhibitor]!)
    
    // Finish spreadsheet
    // ------------------------------
    openData.append(excelSheet[End_workbook]!)
    
    // Write spreadsheet
    // ------------------------------
    let challengesURL  = newURLfrom(url, with: "\(name) challenges.xml")

    do {
      try openData.write(to: challengesURL)
    } catch  {
      errorAlert(message: "Error writing file: \(error)")
    }


  }
}
