//
//  Printing.swift
//  CatBase
//
//  Created by John Sandercock on 6/09/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

postfix func ++(c: inout Character) -> Character {
  let s = String(c).unicodeScalars
  let i = s[s.startIndex].value
  c = Character(UnicodeScalar(i + 1)!)
  return Character(UnicodeScalar(i)!)
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

extension NSMutableData {
  func addData(_ data: Datamaker ...) {
    for datum in data {
      self.append(datum.data)
    }
  }
}

// MARK: - names of keys used

private let Start_workbook      = "Start workbook"
private let Open_sheet          = "Open sheet"
private let End_open            = "End open"
private let Gold_sheet          = "Gold sheet"
private let End_gold            = "End gold"
private let Platinum_sheet      = "Platinum sheet"
private let End_platinum        = "End platinum"
private let Companion_sheet     = "Companion sheet"
private let End_companion       = "End companion"
private let Kitten_sheet        = "Kitten sheet"
private let End_kitten          = "End kitten"
private let List_sheet          = "List sheet"
private let End_list            = "End list"
private let Statistics_sheet    = "Statistics sheet"
private let End_statistics      = "End statistics"
private let Number_data         = "Number data"
private let String_data         = "String data"
private let Start_row           = "Start row"
private let Hiring_row          = "Hiring row"
private let Workers_row         = "Workers row"
private let Catalogue_row       = "Catalogue row"
private let End_row             = "End row"
private let End_cell            = "End cell"
private let End_sheet           = "End sheet"
private let End_workbook        = "End workbook"




extension NSMutableData{
  func appendRow(_ data: Datamaker ...) {
    self.append(excelSheet[Start_row]!)
    for datum in data {
      self.append(datum.data)
    }
    self.append(excelSheet[End_row]!)
  }
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


// MARK: - litter structure

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
    return Breeds.groupNumberOf(self.breed)
  }
  
  var age: String {
    if let showDate = Globals.currentShow?.date {
      return showDate.differenceInMonthsAndYears(self.birthDate)
    }
    return "No show date"
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
      self.males += 1
    case Sex.sexes[1]:
      self.females += 1
    case Sex.sexes[2]:
      self.neuters += 1
    case Sex.sexes[3]:
      self.spays += 1
    default:
      break
    }
  }
}

private struct PrestigeChallenge {
  let title: ChallengeTypes
  var males    = [Int]()
  var females  = [Int]()
  
  init(prestige: ChallengeTypes) {
    title = prestige
  }
}


// MARK: - Helper functions

private func newURLfrom(_ oldURL : URL, with newName: String) -> URL {
    return oldURL.deletingLastPathComponent().appendingPathComponent(newName)
  //  fatalError("Cannot create a new URL with extension \(newName) from \(oldURL)")
}

private func sizeFor(_ num: Int) -> Int {
  if num < 1 { return 0 }
  if num < 3 { return 1 }
  if num < 6 { return 2 }
  if num < 9 { return 3 }
  return 5
}

private func xmlString(_ str: String) -> Data {
  var xmlStr = str.replacingOccurrences(of: "&", with: "&amp;")
  if xmlStr == "Platinum" {
    xmlStr = "Platinum or above"
  }
  return excelSheet[String_data]! + xmlStr.data + excelSheet[End_cell]!
}

private func xmlNumber(_ num: Int) -> Data {
  return excelSheet[Number_data]! + String(num).data + excelSheet[End_cell]!
}

private let xmlEmptyRow: Data = {
  return excelSheet[Start_row]! + excelSheet[End_cell]!
}()



// *********************************
// MARK: - print the catalog
// *********************************

var debugCount = 1

extension MainWindowController {
  func printCatalog(_ name: String, to url: URL) {
    
    var data            = NSMutableData()
    var judgesNotes     = NSMutableData()
    
    var openData        = NSMutableData()
    var goldData        = NSMutableData()
    var platinumData    = NSMutableData()
    var companionData   = NSMutableData()
    var kittenData      = NSMutableData()
    var listData        = NSMutableData()
    var statisticsData  = NSMutableData()

    let headerFiles     = NSMutableData()

    var workers       = Set<String>()
    var catalogues    = Set<String>()
    var breedsPresent = Set<String>()
    var hiring        = NSCountedSet()
    
    var cagelength    = 0
    var headerSectionNumber = 2
    
    let catalogueFile   = newURLfrom(url, with: "\(Globals.currentShowName) catalogue.html")
    let notesFile       = newURLfrom(url, with: "\(Globals.currentShowName) judges notes.html")
    let challengesFile  = newURLfrom(url, with: "\(Globals.currentShowName) challenges.xml")
    
    var openChallenges: [Int] = []
    var goldChallenges = PrestigeChallenge(prestige: .gold)
    var platinumChallenges = PrestigeChallenge(prestige: .platinum)
    
    
    func addData(_ newData: Datamaker...) {
      for next in newData {
        data.append(next.data)
        judgesNotes.append(next.data)
      }
    }
    
    var litters: [Litter] = []
    
    headerFiles.addData(head1, Globals.currentShowName, head2, Globals.currentShowName, head3, "\(Globals.currentShowName) \(Globals.currentShowDate)", head4)
    
    // write out boxes for this entry
    // ------------------------------
    func writeBoxesFor(_ thisEntry: Entry?, usingforJudges judgeBox: Data) {
      judgesNotes.append(judgeBox)
      for _ in 1 ..< maxNumberOfRings {
        judgesNotes.append(noRing)
      }
      
      for i in 1 ... Globals.numberOfRingsInShow {
        if let thisEntry = thisEntry {
          if thisEntry.inRing(i) {
            data.append(entered)
          } else {
            data.append(notEntered)
          }
        } else {
          data.append(entered)
        }
      }
      for _ in Globals.numberOfRingsInShow ..< maxNumberOfRings {
        data.append(noRing)
      }
    }
    
    // write table for these entries
    // ------------------------------
    func writeTableFor(_ count: Int, catsWithInfo info: String) {
      addData(bestAward2)
      
      let numberPlaces: Int
      if count >= places.count {
        numberPlaces = places.count - 1
      } else {
        numberPlaces = count
      }
      
      for i in 0 ..< numberPlaces {
        
        addData(bestAward3, places[i], info, bestAward4)
        
        writeBoxesFor(nil, usingforJudges: entered)
        
        addData(rowEnd)
      }
    }
    
    // MARK: - Do best of colour
    // ---------------------------
    func doBestOfColourFor(_ thisEntry: Entry?, with numCats: Int) {
      if let thisEntry = thisEntry {
        addData(bestAward1)
        
        if numCats < 2 { return }
        
        let count = sizeFor(numCats)
        if count == 0 { return }
        
        let info: String
        if thisEntry.cat.isLimited {
          info = " \(thisEntry.cat.judgingVariety.name) \(thisEntry.cat.breed) \(thisEntry.cat.sectionName)"
        } else if thisEntry.cat.isCompanion {
          info = " \(thisEntry.cat.colour) \(thisEntry.cat.breed)"
        } else {
          info = " \(thisEntry.cat.colour) \(thisEntry.cat.breed) \(thisEntry.cat.sectionName)"
        }
        
        writeTableFor(count, catsWithInfo: info)
        
        addData(bestAward1)
      }
    }
    // End of do best of colour
    // --------------------------
    
    // MARK: - Do best of breed
    // ---------------------------
    func doBestOfBreedFor(_ thisEntry: Entry?, with numCats: Int) {
      if let thisEntry = thisEntry {
        addData(bestAward1)
        
        let count = sizeFor(numCats)
        if count == 0 { return }
        
        let info: String
        if thisEntry.cat.isCompanion {
          info = thisEntry.cat.breed
        } else {
          info = "\(thisEntry.cat.breed) \(thisEntry.cat.sectionName)"
        }
        
        writeTableFor(count, catsWithInfo: info)
        
        breedsPresent.insert(thisEntry.cat.breed)
        
        statisticsData.appendRow(xmlString(info), xmlNumber(numCats), xmlString("cages"), xmlString("length"), xmlNumber(cagelength))
        
        addData(bestAward1)
      }
    }
    // End of do best of breed
    // --------------------------
    
    
    // MARK: - write challenge
    // ----------------------------
    
    func writeChallenges(_ theChallenges: [Int], ofType title: String) {
      
      let count = theChallenges.count
      guard count > 0
        else { return }
      
      addData(challenge1, title, challenge2)
      
      let start: String
      if count > 1 {
        start = " between \(theChallenges)"
      } else {
        start = "\(theChallenges)"
      }
      addData(start, challenge3)
      
      writeBoxesFor(nil, usingforJudges: entered)
      
      addData(rowEnd)
    }
    // End of write challenge
    // ----------------------
    
    // MARK: - write litter
    // ---------------------
    
    func writeLittersForGroup(_ currentGroupNumber: Int) {
      var first = true
      for litter in litters {
        if litter.groupNumber == currentGroupNumber {
          if first {
            first = false
            addData(breed1, "\(Breeds.nameOfGroupNumber(currentGroupNumber)) Litters", breed2)
          }
          addData(tableStart)
          addData(name1Litter, "Litter \(litter.number)", name2Litter)
          
          data.append("\(litter.name) \(litter.breed) Litter".data)
          judgesNotes.append(nbspace)
          
          addData(name3)
          
          // write out number of male & female kittens
          var numberOfKittens = String()
          if litter.males > 0 {
            numberOfKittens += "\(litter.males) \(Sex.nameOf(0))"
            if litter.males > 1 { numberOfKittens += "s" }
          }
          if litter.neuters > 0 {
            numberOfKittens += "\(litter.neuters) \(Sex.nameOf(2))"
            if litter.neuters > 1 { numberOfKittens += "s" }
          }
          if litter.females > 0 {
            numberOfKittens += "\(litter.females) \(Sex.nameOf(1))"
            if litter.females > 1 { numberOfKittens += "s" }
          }
          if litter.spays > 0 {
            numberOfKittens += "\(litter.spays) \(Sex.nameOf(3))"
            if litter.spays > 1 { numberOfKittens += "s" }
          }
          
          addData(numberOfKittens, name4)
          
          judgesNotes.append(name4)
          
          addData(details1Litter, litter.birthDate.string, details2)
          addData(litter.age, details3Litter)
          
          data.append("\(litter.sire)/\(litter.dam)".data)
          judgesNotes.append(nbspace)
          
          addData(details4)
          
          data.append("Br:\(litter.breeder) Ex:\(litter.exhibitor)".data)
          judgesNotes.append(nbspace)
          
          addData(details5)
          
          writeBoxesFor(nil, usingforJudges: underlined)
          
          addData(rowEnd)
        }
        if !first { addData(tableEnd) }
      }
    }
    // End of write litter
    // --------------------
    
    // MARK: - Do challenges
    // ----------------------
    
    func doOpenChallengesFor(_ thisEntry: Entry?, changingColour changeColour: Bool ) {
      // ** check to make sure this is an entry
      guard let thisEntry = thisEntry
        else { return }
      // ** Kittens do not have challenges
      if thisEntry.cat.isKitten { return }
      
      if !openChallenges.isEmpty {
        addData(spacer)
        if thisEntry.cat.isCompanion {
          writeChallenges(openChallenges, ofType: awardOfMerit)
        } else {
          writeChallenges(openChallenges, ofType: challenge)
        }
        if !changeColour {
          addData(spacer)
        }
        openChallenges = []
      }
    }
    
    func doPrestigeChallengesFor(_ thisEntry: Entry?, with theChallenges: inout PrestigeChallenge) {
      if isCCCAShow { return }
      print("Doing prestige challenges")
      if let thisEntry = thisEntry {
        // ** Kittens do not have challenges
        if thisEntry.cat.isKitten { return }
        
        let m = theChallenges.males.count
        let f = theChallenges.females.count
        
        guard (f + m) > 0
          else { return }
        
        addData(prestige1)
        
        let male: String
        let female: String
        if thisEntry.cat.isEntire {
          male = Sex.nameOf(0)
          female = Sex.nameOf(1)
        } else {
          male = Sex.nameOf(2)
          female = Sex.nameOf(3)
        }
        
        let awardType: String
        if thisEntry.cat.isCompanion {
          awardType = awardOfMerit
        } else {
          awardType = challenge
        }
        
        if m != 0 {
          writeChallenges(theChallenges.males, ofType: "\(male) \(theChallenges.title.description) \(awardType)")
        }
        if f != 0 {
          writeChallenges(theChallenges.females, ofType: "\(female) \(theChallenges.title.description) \(awardType)")
        }
        
        theChallenges.males = []
        theChallenges.females = []
        
        addData(bestAward1)
      }
     }
    
    // End do challenges
    // -----------------------
    
    // MARK: - begin main loop
    
    let sortedEntrys = (theEntriesController.arrangedObjects as AnyObject).sortedArray(using: #selector(Cat.compareWith(_:))) as! [Entry]
    
    var lastColour  = String()
    var lastClass   = String()
    
    var countOfCats   = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
    
    var judgingClass  = JudgingVarities.colourClass
    var thisAgouti  = 0
    var colourCount = 1
    var breedCount  = 1
    
    var cageNumber  = 1
    var sectionNumber = 2
    
    // **********************************
    // MARK: - Headers
    // **********************************
    
    // ** for EXCEL data
    // ------------------
    openData.append(excelSheet[Start_workbook]!)
    openData.append(excelSheet[Open_sheet]!)
    goldData.append(excelSheet[Gold_sheet]!)
    platinumData.append(excelSheet[Platinum_sheet]!)
    companionData.append(excelSheet[Companion_sheet]!)
    kittenData.append(excelSheet[Kitten_sheet]!)
    listData.append(excelSheet[List_sheet]!)
    statisticsData.append(excelSheet[Statistics_sheet]!)
    
    // ** for Catalogue
    // -----------------
    addData(header1, name)
    
    data.append(header2)
    judgesNotes.append(header2judge)
    
    // ***************************************
    // MARK: - sort through and find litters
    // ***************************************
    
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
    
    // *****************************************
    // MARK: - Find all kittens in the litters
    //         Update them to show they are in litters
    // *****************************************
    
    for entry in sortedEntrys {
      for var litter in litters {
        guard entry.isInLitter(litter)
          else { continue }
        entry.litter = true
        litter.addKittenOfSex(entry.cat.sex)
        
        break
      }
    }
    
    // ****************************************************
    // MARK: - BEGIN LOOPING THROUGH THE ENTRIES
    // ****************************************************
    
    var lastEntry: Entry? = nil
    
    for entry in sortedEntrys {
      
      let thisBreed   = entry.cat.breed
      
      if let lastEntry = lastEntry {
        judgingClass = lastEntry.cat.judgingVariety
        
        // MARK: - write out open challenges & best of colour
        // ---------------------------------------------------
        if entry.newChallengeColourTo(lastEntry) {
          doOpenChallengesFor(lastEntry, changingColour: lastEntry.cat.colour == entry.cat.colour)
        }
        if entry.newColourTo(lastEntry) {
          doBestOfColourFor(lastEntry, with: colourCount)
          colourCount = 1
        } else {
          colourCount += 1
        }
        
        // Check to see if we need to write out best of breed
        if entry.newBreedTo(lastEntry) {
          doBestOfBreedFor(lastEntry, with: breedCount)
          breedCount = 1
        } else {
          breedCount += 1
        }
        
      
        // MARK: Are we on a new section?
        // ---------------------------------
        if entry.inDifferentSectionTo(lastEntry) {
          
          // MARK: Write out litters for this group
          if lastEntry.isKittenClass {
            writeLittersForGroup(lastEntry.cat.groupNumber)
          }
          
          // MARK: Write top ten and prestige challenge boxes
          judgesNotes.addData(topTenStartTable, "\(Breeds.nameOfGroupForBreed(lastEntry.cat.breed)) \(lastEntry.cat.sectionName)", topTenEndTable)
          
          doPrestigeChallengesFor(lastEntry, with: &goldChallenges)
          doPrestigeChallengesFor(lastEntry, with: &platinumChallenges)
          
          // MARK: Do ACF awards for judges notes
          if !lastEntry.cat.isKitten && !lastEntry.cat.isCompanion {
            judgesNotes.append(ACFAoEstart)
            
            let firstSex: Int
            let lastSex: Int
            if lastEntry.cat.isEntire {
              firstSex = 0
              lastSex = 2
            } else {
              firstSex = 2
              lastSex = 4
            }
            
            if Breeds.ACFgroupNumberOf(lastEntry.cat.breed) == 0 {
              for sex in firstSex ..< lastSex {
                if countOfCats[0][sex] > 0 {
                  judgesNotes.addData(ACFAoEstartRow, "Group 1 \(Sex.nameOf(sex))", ACFAoEendRow)
                }
              }
            } else {
              for g in 2 ... 3 {
                for sex in firstSex ..< lastSex {
                  if countOfCats[0][sex] > 0 {
                    judgesNotes.addData(ACFAoEstartRow, "Group \(g) \(Sex.nameOf(sex))", ACFAoEendRow)
                  }
                }
              }
            }
            judgesNotes.append(tableEnd)
          }
        }
      }
      
          // MARK: - Write up section heading - add a section-break if a new group
          // --------------------------------
        if entry.inDifferentSectionTo(lastEntry) {
          let s: String
          let thisGroup = Breeds.nameOfGroupForBreed(entry.cat.breed)
          if entry.cat.isCompanion {
            s = "\(thisGroup)s"
          } else if entry.cat.isKitten {
            s = "\(thisGroup) \(entry.cat.sectionName)s"
          } else if entry.cat.isEntire {
            s = "\(thisGroup) \(entry.cat.sectionName)s"
          } else {
            s = "\(thisGroup) \(entry.cat.sectionName)"
          }
          
          judgesNotes.addData(Section1_alt, s, section3)
          if entry.inDifferentGroupTo(lastEntry) {
            data.addData(section1, "\(sectionNumber)", section2, s, section3)
            sectionNumber += 1
            headerFiles.addData(headerSectionNumber, head5)
            headerSectionNumber += 1
            for i in 0 ..< 6 {
              headerFiles.addData((Globals.currentShow!.judge(i, forBreed: entry.cat.breed)), head5_1)
            }
            headerFiles.addData(head5_2)
          } else {
            data.addData(Section1_alt, s, section3)
          }
        }
      
        
        // MARK: - Are we on a new breed
        // ------------------------------
        if entry.newBreedTo(lastEntry) {
          
          // Check to see if there were any litters
          if entry.cat.isKitten && !entry.cat.isCompanion {
            for litter in litters {
              if entry.cat.breed == litter.breed {
                cagelength += Globals.litterCageLength
              }
            }
          }
          // Write out new breed
          // -------------------
          let breedHeading: String
          if !entry.cat.isCompanion {
            if entry.cat.isEntire || entry.cat.isKitten {
              breedHeading = "\(thisBreed) \(entry.cat.sectionName)s"
            } else {
              breedHeading = "\(thisBreed) \(entry.cat.sectionName)"
            }
            addData(breed1, breedHeading, breed2)
          }

          lastColour  = ""
          lastClass   = ""
          
        }
        
        // MARK: - Update the count of cats
        // ---------------------------------
        if !entry.cat.isKitten && !entry.cat.isCompanion {
          let i = Breeds.ACFgroupNumberOf(thisBreed)
          let j = Sex.rankOf(entry.cat.sex) ?? 4
          if i < 4 && j < 4 {
            countOfCats[i][j] += 1
          } else {
            print("Given bogus number for updating count of cats. i = \(i); j = \(j)")
          }
        }
        
        // MARK: - Determine what sort of challenge this is
        // -------------------------------------------------
      
        // Add to excel sheet
      func excelDataFor(_ cat: Cat) -> Data {
        let myData = NSMutableData()
        myData.append(excelSheet[Start_row]!)
        myData.append(xmlNumber(cageNumber))
        myData.append(xmlString(cat.registration))
        myData.append(xmlString(cat.title))
        myData.append(xmlString(cat.name))
        myData.append(xmlString(cat.gender))
        myData.append(xmlString(cat.colour))
        myData.append(xmlString(cat.breed))
        myData.append(xmlString(cat.group))
        myData.append(xmlString(cat.exhibitor))
        myData.append(xmlString(cat.breeder))
        myData.append(xmlString(cat.challenge))
        myData.append(excelSheet[End_row]!)
        return myData as Data
      }
      
        func updateChallengeFor(_ entry: Entry) {
          let maleCat = entry.cat.isMale
          if isCCCAShow {
            if Challenges.type(entry) != .kitten {
              openChallenges.append(cageNumber)
              if Challenges.type(entry) == .gold {
                if maleCat { goldChallenges.males.append(cageNumber) }
                else { goldChallenges.females.append(cageNumber) }
              }
            }
          } else {
            switch Challenges.type(entry) {
            case .gold:
              if maleCat { goldChallenges.males.append(cageNumber) }
              else { goldChallenges.females.append(cageNumber) }
            case .platinum:
              if maleCat { platinumChallenges.males.append(cageNumber) }
              else { platinumChallenges.females.append(cageNumber)
              }
            case .open:
              openChallenges.append(cageNumber)
            case .kitten:
              break
            }
          }
        }
      
      if entry.cat.isCompanion {
        companionData.append(excelDataFor(entry.cat))
        if !entry.cat.isKitten && !entry.cat.registrationIsPending {
          updateChallengeFor(entry)
        }
      } else if entry.cat.isKitten {
        kittenData.append(excelDataFor(entry.cat))
      } else if isCCCAShow {
        updateChallengeFor(entry)
        openData.append(excelDataFor(entry.cat))
      } else if Challenges.type(entry) == .gold {
        updateChallengeFor(entry)
        goldData.append(excelDataFor(entry.cat))
      } else if Challenges.type(entry) == .platinum {
        updateChallengeFor(entry)
        platinumData.append(excelDataFor(entry.cat))
      } else if Challenges.type(entry) == .open {
        updateChallengeFor(entry)
        openData.append(excelDataFor(entry.cat))
      }
      
      // MARK: - Write out new colour
      if entry.newColourOrBreedTo(lastEntry) {
          if judgingClass != .colourClass {
            addData(bestAward1)
          }
          addData(colour1)
          
        if entry.cat.isLimited {
          if entry.newJudgingVarietyTo(lastEntry) {
            // A new Agouti grouping
            // write agouti heading
            addData(entry.cat.judgingVariety.name, colour2, colour3)
          }
        } else {
          judgingClass = .colourClass
        }
        
          // then write the new colour
          addData(entry.cat.colour, colour2)
          lastColour = entry.cat.colour
          lastClass = ""
        }
        // ** end of colour check
        
        // MARK: - Write out statistics
        // ----------------------------
        listData.append(excelSheet[Start_row]!)
        listData.append(xmlNumber(cageNumber))
        listData.append(xmlString(entry.cat.name))
        listData.append(xmlString(entry.cat.exhibitor))
        listData.append(xmlString(entry.cat.breed))
        listData.append(xmlString(entry.cat.gender))
        if entry.isInLitter {
          for litter in litters {
            if entry.isInLitter(litter) {
              listData.append(xmlString("\(entry.typeOfCage) \(litter.number)"))
            }
          }
        } else {
          listData.append(xmlString(entry.typeOfCage))
        }
        listData.append(excelSheet[End_row]!)
        
        // *******************************************
        // MARK: - Write out this entry in catalogue
        // *******************************************
        
        // Write out the cage number
        // --------------------------
        addData(name1, String(cageNumber), name2)
        
        // Write out title and name
        // -------------------------
        judgesNotes.append(nbspace)
        if entry.cat.title.isEmpty {
          data.append(entry.cat.name.data)
        } else {
          data.append("\(entry.cat.title) \(entry.cat.name)".data)
        }
        addData(name3)
        
        // Write out cat sex and class if they have changed
        // -------------------------------------------------
        let catClass: String
        if entry.cat.isKitten {
          catClass = "\(entry.cat.sex) \(entry.cat.challenge) \(entry.cat.ageCategory)"
        } else {
          catClass = "\(entry.cat.sex) class"
        }
        
        if entry.newColourTo(lastEntry) || catClass != lastClass {
          addData(catClass)
          lastClass = catClass
        } else {
          addData(nbspace)
        }
        
        addData(name4)
      
        // Write the birthdate and age
        // ----------------------------
        addData(details1, entry.cat.birthDate.string, details2, entry.cat.age, details3)
      
        // Write sire and dam names
        // -------------------------
        if !entry.cat.isCompanion {
          data.append("\(entry.cat.sire)/\(entry.cat.dam)".data)
          judgesNotes.append(nbspace)
        }
        addData(details4)
        
        // write rego number, breeder and exhibitor
        let regoEtc: String
        if entry.cat.isCompanion {
          if entry.cat.registrationIsPending { regoEtc = entry.cat.exhibitor }
          else { regoEtc = "\(entry.cat.registration) Ex:\(entry.cat.exhibitor)" }
        } else {
          let breeder = entry.cat.breeder
          let exhibitor = entry.cat.exhibitor
          if breeder == exhibitor { regoEtc = "\(entry.cat.registration) Br/Ex:\(breeder)" }
          else { regoEtc = "\(entry.cat.registration) Br:\(breeder) Ex:\(exhibitor)" }
        }
        data.append(regoEtc.data)
        judgesNotes.append(nbspace)
        addData(details5)
        
        // MARK: - Write out the boxes for this entry
        writeBoxesFor(entry, usingforJudges: underlined)
        addData(rowEnd)
        
        // Will they work ??
        // ------------------
        if entry.willWork.boolValue { workers.insert(entry.cat.exhibitor) }
        
        // Do they need a catalogue ??
        // ----------------------------
        if entry.catalogueRequired.boolValue { catalogues.insert(entry.cat.exhibitor) }
        
        // Are they hiring a cage ??
        // --------------------------
        if entry.hireCage.boolValue { hiring.add(entry.cat.exhibitor) }
        
        // Add up cage sizes
        if !entry.isInLitter { cagelength += entry.cageSize.intValue }
      
      lastEntry = entry
      cageNumber += 1
    } // end of looping through the entries
    
    // MARK: - Do best of colour
    // --------------------------
    doOpenChallengesFor(lastEntry, changingColour: true)
    doBestOfColourFor(lastEntry, with: colourCount)
    doBestOfBreedFor(lastEntry, with: breedCount)
    
    doPrestigeChallengesFor(lastEntry, with: &goldChallenges)
    doPrestigeChallengesFor(lastEntry, with: &platinumChallenges)
    
    judgesNotes.addData(endOfEntriesJudge)
    data.addData(endOfEntries1, sectionNumber, endOfEntries2)
    
    // MARK: - Do best of breed list
    // ------------------------------
    let bestOfBreedsNumbers = Breeds.numberOfBreeds - 1
    for i in 0 ..< bestOfBreedsNumbers {
      if breedsPresent.contains(Breeds.nameOf(i)) {
        addData(bestOfBreedStart, Breeds.nameOf(i), bestOfBreedEnd)
      }
    }
    addData(tableEnd)
    
    // MARK: - Add count of cats to list sheet
    // ----------------------------------------
    listData.appendRow("")
    
    for group in 1 ... 3 {
      listData.appendRow(xmlString("Group \(group)"))
      
      for sex in 0 ..< 4 {
        listData.appendRow(xmlString(" "), xmlString(Sex.nameOf(sex)))
      }
    }
    
    // MARK: - Finish catalogue & judges notes
    // ----------------------------------------
    let numberNames = ["One", "Two", "Three", "Four"]
    data.append(ACFstartTable)
    for group in 0 ..< 4 {
      for sex in 0 ..< 4 {
        if countOfCats[group][sex] > 0 {
          data.append(ACFstartRow)
          data.append("Group \(numberNames[group])  \(Sex.nameOf(sex))".data)
          data.append(ACFendRow)
        }
      }
    }
    data.append(endOfFile)
    judgesNotes.append(endOfFileJudge)
    
    data.write(to: catalogueFile, atomically: true)
    judgesNotes.write(to: notesFile, atomically: true)
    
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
    
    // MARK: - Do hire cage data
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
    
    // MARK: - Check to see if we have some workers
    // ---------------------------------------------
    openData.append(excelSheet[Workers_row]!)
    
    if workers.count > 0 {
      for person in workers {
        openData.appendRow(xmlString(person))
      }
    } else {
      openData.appendRow("None")
    }

    // MARK: - Check to see who needs catalogues
    // -------------------------------------------
    openData.append(excelSheet[Catalogue_row]!)
    
    if catalogues.count > 0 {
      for person in catalogues {
        openData.appendRow(xmlString(person))
      }
    } else {
      openData.appendRow(xmlString("NONE"))
    }
    
    // MARK: - Finish writing files
    // ------------------------------
    openData.append(excelSheet[End_statistics]!)
    openData.append(excelSheet[End_workbook]!)
    
    openData.write(to: challengesFile, atomically: true)
    
    let fileManager = FileManager.default
    let dirURL = url.deletingLastPathComponent().appendingPathComponent("Catalog_files", isDirectory: true)
    
    do {
      try fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
    } catch let error{
      fatalError("Cannot create directory for folder Catalog_files.\n error: \(error)")
    }
    
    headerFiles.addData(headerSectionNumber, head6)
    
    let headerURL = dirURL.appendingPathComponent("header.htm")
    guard headerFiles.write(to: headerURL, atomically: true)
      else { fatalError("Cannot write header files") }
    
    let judgeHeaderFiles = NSMutableData()
    judgeHeaderFiles.append(readFile("judge_header"))
    judgeHeaderFiles.append(Globals.currentShowName.data)
    judgeHeaderFiles.append(readFile("judge_headerPt2"))
    judgeHeaderFiles.append(Globals.currentShowDate.data)
    judgeHeaderFiles.append(readFile("judge_headerPt3"))
    
    let judgeHeaderURL = dirURL.appendingPathComponent("judge_header.htm")
    guard judgeHeaderFiles.write(to: judgeHeaderURL, atomically: true)
      else { fatalError("Cannot write judges notes header files") }
    
  }
}
