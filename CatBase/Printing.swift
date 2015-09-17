//
//  Printing.swift
//  CatBase
//
//  Created by John Sandercock on 6/09/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

postfix func ++(inout c: Character) -> Character {
  let s = String(c).unicodeScalars
  let i = s[s.startIndex].value
  c = Character(UnicodeScalar(i + 1))
  return Character(UnicodeScalar(i))
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


private let TITLE   = "Title"


extension NSMutableData{
  func appendRow(data: NSData ...) {
    self.appendData(excelSheet[Start_row]!)
    for datum in data {
      self.appendData(datum)
    }
    self.appendData(excelSheet[End_row]!)
  }
}


private let excelSheet: [String : NSData] = {
  let e = dictFromPList("Excel list") as! [String: String]
  var f: [String : NSData] = [:]
  for (name, string) in e {
    f[name] = string.data
  }
  return f
}()

private let places: [NSData]  = {
  let e = arrayFromPList("Places") as! [String]
  var ans : [NSData] = []
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
  var birthDate: NSDate
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
    return Breeds.groupNumberOf(self.breed) ?? -1
  }
  
  var age: String {
    if let showDate = Globals.currentShow?.date {
      return showDate.differenceInMonthsAndYears(self.birthDate)
    }
    return "No show date"
  }
  
  init(entry: Entry) {
    let cat = entry.cat
    name = cat.name
    birthDate = cat.birthDate
    breed = cat.breed
    sire = cat.sire
    dam = cat.dam
    breeder = cat.breeder
    exhibitor = cat.exhibitor
    
    number = Litter._number++
  }
  
  func contains(cat: Cat) -> Bool {
    if !self.birthDate.isEqualToDate(cat.birthDate) { return false }
    if self.sire != cat.sire { return false }
    if self.dam != cat.dam { return false }
    return true
  }

  mutating func addKittenOfSex(sex: String) {
    switch sex {
    case Sex.sexes[0]:
      self.males++
    case Sex.sexes[1]:
      self.females++
    case Sex.sexes[2]:
      self.neuters++
    case Sex.sexes[3]:
      self.spays++
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

private func newURLfrom(oldURL : NSURL, with newName: String) -> NSURL {
  if let noExt = oldURL.URLByDeletingLastPathComponent {
    return noExt.URLByAppendingPathComponent(newName)
  }
  fatalError("Cannot create a new URL with extension \(newName) from \(oldURL)")
}

private func sizeFor(num: Int) -> Int {
  if num < 1 { return 0 }
  if num < 3 { return 1 }
  if num < 6 { return 2 }
  if num < 9 { return 3 }
  return 5
}

private func xmlString(str: String) -> NSData {
  var xmlStr = str.stringByReplacingOccurrencesOfString("&", withString: "&amp;")
  if xmlStr == "Platinum" {
    xmlStr = "Platinum or above"
  }
  let ans = excelSheet[String_data] as! NSMutableData
  ans.appendData(xmlStr.data)
  ans.appendData(excelSheet[End_cell]!)
  return ans as NSData
}

private func xmlNumber(num: Int) -> NSData {
  let ans = excelSheet[Number_data] as! NSMutableData
  ans.appendData(String(num).data)
  ans.appendData(excelSheet[End_cell]!)
    return ans as NSData
}

private let xmlEmptyRow: NSData = {
  let ans = excelSheet[Start_row]  as! NSMutableData
  ans.appendData(excelSheet[End_cell]!)
  return ans as NSData
}()



// *********************************
// MARK: - print the catalog
// *********************************

extension MainWindowController {
  func printCatalog(name: String, to url: NSURL) {
    
    var data            = NSMutableData()
    var judgesNotes     = NSMutableData()
    
    var openData        = NSMutableData()
    var goldData        = NSMutableData()
    var platinumData    = NSMutableData()
    var companionData   = NSMutableData()
    var kittenData      = NSMutableData()
    var listData        = NSMutableData()
    var statisticsData  = NSMutableData()
    
    var workers       = Set<String>()
    var catalogues    = Set<String>()
    var breedsPresent = Set<String>()
    var hiring        = NSCountedSet()
    
    var cagelength    = 0
    
    let catalogueFile   = newURLfrom(url, with: "catalogue.html")
    let notesFile       = newURLfrom(url, with: "judges notes.html")
    let challengesFile  = newURLfrom(url, with: "challenges.xml")
    
    var openChallenges: [Int] = []
    var goldChallenges = PrestigeChallenge(prestige: .gold)
    var platinumChallenges = PrestigeChallenge(prestige: .platinum)
    
    
    func addData(newData: NSData...) {
      for next in newData {
        data.appendData(next)
        judgesNotes.appendData(next)
      }
    }
    
    var litters: [Litter] = []
    
    // write out boxes for this entry
    // ------------------------------
    func writeBoxesFor(thisEntry: Entry?, usingforJudges judgeBox: NSData) {
      judgesNotes.appendData(judgeBox)
      for _ in 1 ..< maxNumberOfRings {
        judgesNotes.appendData(noRing)
      }
      
      for i in 1 ... Globals.numberOfRingsInShow {
        if let thisEntry = thisEntry {
          if thisEntry.inRing(i) {
            data.appendData(entered)
          } else {
            data.appendData(notEntered)
          }
        } else {
          data.appendData(entered)
        }
      }
      for _ in Globals.numberOfRingsInShow ..< maxNumberOfRings {
        data.appendData(noRing)
      }
    }
    
    // write table for these entries
    // ------------------------------
    func writeTableFor(var count: Int, catsWithInfo info: String) {
      addData(bestAward2)
      
      if count >= places.count {
        count = places.count - 1
      }
      
      for i in 0 ..< count {
        
        addData(bestAward3, places[i], info.data, bestAward4)
        
        writeBoxesFor(nil, usingforJudges: entered)
        
        addData(rowEnd)
      }
    }
    
    // MARK: - Do best of colour
    // ---------------------------
    func doBestOfColourFor(thisEntry: Entry?, with numCats: Int) {
      if let thisEntry = thisEntry {
        addData(bestAward1)
        
        if numCats == 0 { return }
        
        let count = sizeFor(numCats)
        if count == 0 { return }
        
        let info: String
        if thisEntry.cat.isAgouti {
          info = "\(Globals.agoutiClasses[thisEntry.cat.agoutiRank]) \(thisEntry.cat.breed) \(thisEntry.cat.section))"
        } else if thisEntry.cat.isCompanion {
          info = "\(thisEntry.cat.colour) \(thisEntry.cat.breed)"
        } else {
          info = "\(thisEntry.cat.colour) \(thisEntry.cat.breed) \(thisEntry.cat.section)"
        }
        
        writeTableFor(count, catsWithInfo: info)
        
        addData(bestAward1)
      }
    }
    // End of do best of colour
    // --------------------------
    
    // MARK: - Do best of breed
    // ---------------------------
    func doBestOfBreedFor(thisEntry: Entry?, with numCats: Int) {
      if let thisEntry = thisEntry {
        addData(bestAward1)
        
        let count = sizeFor(numCats)
        if count == 0 { return }
        
        let info: String
        if thisEntry.cat.isCompanion {
          info = thisEntry.cat.breed
        } else {
          info = "\(thisEntry.cat.breed) \(thisEntry.cat.section)"
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
    
    func writeChallenges(theChallenges: [Int], ofType title: String) {
      
      let count = theChallenges.count
      guard count > 0
        else { return }
      
      addData(challenge1, title.data, challenge2)
      
      let start: String
      if count > 1 {
        start = " between \(theChallenges)"
      } else {
        start = "\(theChallenges)"
      }
      addData(start.data, challenge3)
      
      writeBoxesFor(nil, usingforJudges: entered)
      
      addData(rowEnd)
    }
    // End of write challenge
    // ----------------------
    
    // MARK: - write litter
    // ---------------------
    
    func writeLittersForGroup(currentGroupNumber: Int) {
      var first = true
      for litter in litters {
        if litter.groupNumber == currentGroupNumber {
          if first {
            first = false
            addData(breed1, "\(Breeds.nameOfGroupNumber(currentGroupNumber)) Litters".data, breed2)
          }
          addData(tableStart)
          addData(name1Litter, "Litter \(litter.number)".data, name2Litter)
          
          data.appendData("\(litter.name)\(litter.breed) Litter".data)
          judgesNotes.appendData(nbspace)
          
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
          
          addData(numberOfKittens.data, name4)
          
          judgesNotes.appendData(name4)
          
          addData(details1Litter, litter.birthDate.string.data, details2)
          addData(litter.age.data, details3Litter)
          
          data.appendData("\(litter.sire)/\(litter.dam)".data)
          judgesNotes.appendData(nbspace)
          
          addData(details4)
          
          data.appendData("Br:\(litter.breeder) Ex:\(litter.exhibitor)".data)
          judgesNotes.appendData(nbspace)
          
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
    
    func doOpenChallengesFor(thisEntry: Entry?, changingColour changeColour: Bool ) {
      if let thisEntry = thisEntry {
        // ** Kittens do not have challenges
        if thisEntry.cat.isKitten { return }
        
        if openChallenges.isEmpty {
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
    }
    
    func doPrestigeChallengesFor(thisEntry: Entry?, inout with theChallenges: PrestigeChallenge) {
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
          writeChallenges(theChallenges.males, ofType: "\(male) \(theChallenges.title) \(awardType)")
        }
        if f != 0 {
          writeChallenges(theChallenges.females, ofType: "\(female) \(theChallenges.title) \(awardType)")
        }
        
        theChallenges.males = []
        theChallenges.females = []
        
        addData(bestAward1)
      }
     }
    
    // End do challenges
    // -----------------------
    
    // MARK: - begin main loop
    
    let sortedEntrys = theEntriesController.arrangedObjects.sortedArrayUsingSelector(Selector("compareWith:")) as! [Entry]
    
    var lastBreed   = String()
    var lastColour  = String()
    var lastClass   = String()
    
    var countOfCats   = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
    
    var lastAgouti  = 0
    var thisAgouti  = 0
    var colourCount = 1
    var breedCount  = 1
    
    var cageNumber  = 1
    
    // **********************************
    // MARK: - Headers
    // **********************************
    
    // ** for EXCEL data
    // ------------------
    openData.appendData(excelSheet[Start_workbook]!)
    openData.appendData(excelSheet[Open_sheet]!)
    goldData.appendData(excelSheet[Gold_sheet]!)
    platinumData.appendData(excelSheet[Platinum_sheet]!)
    companionData.appendData(excelSheet[Companion_sheet]!)
    kittenData.appendData(excelSheet[Kitten_sheet]!)
    listData.appendData(excelSheet[List_sheet]!)
    statisticsData.appendData(excelSheet[Statistics_sheet]!)
    
    // ** for Catalogue
    // -----------------
    addData(header1, name.data)
    
    data.appendData(header2)
    judgesNotes.appendData(header2judge)
    
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
      }
      if newLitter {
        litters += [Litter(entry: entry)]
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
    
    var _lastEntry: Entry? = nil
    
    for entry in sortedEntrys {
      
      let thisBreed   = entry.cat.breed
      
      if let lastEntry = _lastEntry {
        let lastAgouti = lastEntry.cat.agoutiRank
        
        // MARK: - write out open challenges & best of colour
        // ---------------------------------------------------
        if !entry.sameChallengeAs(lastEntry) || !entry.sameColourAs(lastEntry) {
          doOpenChallengesFor(lastEntry, changingColour: lastEntry.cat.colour == entry.cat.colour)
          
          if !entry.sameColourAs(lastEntry) {
            doBestOfColourFor(lastEntry, with: colourCount)
            colourCount = 1
          } else {
            colourCount++
          }
          
          // Check to see if we need to write out best of breed
          if entry.newBreedTo(lastEntry) {
            doBestOfBreedFor(lastEntry, with: breedCount)
            breedCount = 1
          } else {
            breedCount++
          }
        }
        
        // MARK: - Are we on a new section?
        // ---------------------------------
        if entry.cat.section != lastEntry.cat.section {
          
          // MARK: - Write out litters for this group
          if lastEntry.cat.isKitten && !lastEntry.cat.isCompanion {
            writeLittersForGroup(lastEntry.cat.groupNumber)
          }
          
          // MARK: - Write top ten and prestige challenge boxes
          judgesNotes.appendData(topTenStartTable)
          judgesNotes.appendData("\(Breeds.nameOfGroupForBreed(lastEntry.cat.breed)) \(lastEntry.cat.section)".data)
          judgesNotes.appendData(topTenEndTable)
          
          doPrestigeChallengesFor(lastEntry, with: &goldChallenges)
          doPrestigeChallengesFor(lastEntry, with: &platinumChallenges)
          
          // MARK: - Do ACF awards for judges notes
          if !lastEntry.cat.isKitten && !lastEntry.cat.isCompanion {
            judgesNotes.appendData(ACFAoEstart)
            
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
                  judgesNotes.appendData(ACFAoEstartRow)
                  judgesNotes.appendData("Group 1 \(Sex.nameOf(sex))".data)
                  judgesNotes.appendData(ACFAoEendRow)
                }
              }
            } else {
              for g in 2 ... 3 {
                for sex in firstSex ..< lastSex {
                  if countOfCats[0][sex] > 0 {
                    judgesNotes.appendData(ACFAoEstartRow)
                    judgesNotes.appendData("Group \(g) \(Sex.nameOf(sex))".data)
                    judgesNotes.appendData(ACFAoEendRow)
                  }
                }
              }
            }
            judgesNotes.appendData(tableEnd)
          }
          
          // MARK: - Write up section heading
          // --------------------------------
          let s: String
          if entry.cat.isCompanion {
            s = "\(Breeds.nameOfGroupForBreed(entry.cat.breed))\n)"
          } else {
            s = "\(Breeds.nameOfGroupForBreed(entry.cat.breed)) \(entry.cat.section)\n"
          }
          addData(section1, s.data, section2)
          
          // reset lastBreed
          lastBreed = ""
        }
        
        // MARK: - Are we on a new breed
        // ------------------------------
        if entry.newBreedTo(lastEntry) {
          
          // Check to see if there were any litters
          if entry.cat.isKitten && !entry.cat.isCompanion {
            for litter in litters {
              if entry.cat.breed == litter.breed {
                cagelength += Globals.cageTypes.sizes[6] // cageType 6 is litter cage
              }
            }
          }
          // Write out new breed
          // -------------------
          addData(breed1, "\(thisBreed) \(entry.cat.section)".data, breed2)
          
          lastBreed = thisBreed
          lastColour  = ""
          lastClass   = ""
          
        }
        
        // MARK: - Update the count of cats
        // ---------------------------------
        if !entry.cat.isKitten && !entry.cat.isCompanion {
          let i = Breeds.ACFgroupNumberOf(thisBreed)
          let j = Sex.rankOf(entry.cat.sex)
          if i < 4 && j < 4 {
            countOfCats[i][j] += 1
          } else {
            print("Given bogus number for updating count of cats. i \(i); j = \(j)")
          }
        }
        
        // MARK: - Determine what sort of challenge this is
        // -------------------------------------------------
        
        // Add to excel sheet
        func updateExcelData(inout thisChallengeData: NSMutableData) {
          thisChallengeData.appendData(excelSheet[Start_row]!)
          thisChallengeData.appendData(xmlNumber(cageNumber))
          thisChallengeData.appendData(xmlString(entry.cat.registration))
          thisChallengeData.appendData(xmlString(entry.cat.title))
          thisChallengeData.appendData(xmlString(entry.cat.name))
          thisChallengeData.appendData(xmlString(entry.cat.gender))
          thisChallengeData.appendData(xmlString(entry.cat.colour))
          thisChallengeData.appendData(xmlString(entry.cat.breed))
          thisChallengeData.appendData(xmlString(entry.cat.group))
          thisChallengeData.appendData(xmlString(entry.cat.exhibitor))
          thisChallengeData.appendData(xmlString(entry.cat.breeder))
          thisChallengeData.appendData(xmlString(entry.cat.challenge))
          thisChallengeData.appendData(excelSheet[End_row]!)
        }
        
        func updateChallengeFor(entry: Entry) {
          let maleCat = entry.cat.isMale
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
        
        if entry.cat.isCompanion {
          updateExcelData(&companionData)
          if !entry.cat.isKitten && !entry.cat.registrationIsPending {
            updateChallengeFor(entry)
          }
        } else if entry.cat.isKitten && !entry.cat.isCompanion {
          updateExcelData(&kittenData)
        } else if Challenges.type(entry) == .gold {
          updateChallengeFor(entry)
          updateExcelData(&goldData)
        } else if Challenges.type(entry) == .platinum {
          updateChallengeFor(entry)
          updateExcelData(&platinumData)
        } else if Challenges.type(entry) == .open {
          updateChallengeFor(entry)
          updateExcelData(&openData)
        }
        
        // MARK: - Write out new colour
        if !entry.sameColourAs(lastEntry) || entry.differentBreedTo(lastEntry){
          if lastEntry.cat.isAgouti {
            addData(bestAward1)
          }
          addData(colour1)
          
          if entry.cat.isAgouti && entry.cat.agoutiRank == lastEntry.cat.agoutiRank {
            // A new Agouti grouping
            // write agouti heading
            addData(Globals.agoutiClasses[entry.cat.agoutiRank].data, colour2, colour3)
          }
          
          // then write the new colour
          addData(entry.cat.colour.data, colour2)
          lastColour = entry.cat.colour
          lastClass = ""
        }
        // ** end of colour check
        
        // MARK: - Write out statistics
        // ----------------------------
        listData.appendData(excelSheet[Start_row]!)
        listData.appendData(xmlNumber(cageNumber))
        listData.appendData(xmlString(entry.cat.name))
        listData.appendData(xmlString(entry.cat.exhibitor))
        listData.appendData(xmlString(entry.cat.breed))
        listData.appendData(xmlString(entry.cat.gender))
        if entry.isInLitter {
          for litter in litters {
            if entry.isInLitter(litter) {
              listData.appendData("\(entry.typeOfCage) \(litter.number)".data)
            }
          }
        } else {
          listData.appendData(xmlString(entry.typeOfCage))
        }
        listData.appendData(excelSheet[End_row]!)
        
        // *******************************************
        // MARK: - Write out this entry in catalogue
        // *******************************************
        
        // Write out the cage number
        // --------------------------
        addData(name1, String(cageNumber++).data, name2)
        
        // Write out title and name
        // -------------------------
        judgesNotes.appendData(nbspace)
        if entry.cat.title.isEmpty {
          data.appendData(entry.cat.name.data)
        } else {
          data.appendData("\(entry.cat.title) \(entry.cat.name)".data)
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
        
        if entry.newBreedTo(lastEntry) || entry.newColourTo(lastEntry) || catClass != lastClass {
          addData(catClass.data)
          lastClass = catClass
        } else {
          addData(nbspace)
        }
        
        addData(name4)
        judgesNotes.appendData(name4)
        
        // Write the birthdate and age
        // ----------------------------
        addData(details1, entry.cat.birthDate.string.data, details2, entry.cat.age.data, details3)
        
        // Write sire and dam names
        // -------------------------
        if !entry.cat.isCompanion {
          data.appendData("\(entry.cat.sire)/\(entry.cat.dam)".data)
          judgesNotes.appendData(nbspace)
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
          if breeder == exhibitor { regoEtc = "Br/Ex:\(breeder)" }
          else { regoEtc = "Br:\(breeder) Ex:\(exhibitor)" }
        }
        data.appendData(regoEtc.data)
        judgesNotes.appendData(nbspace)
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
        if entry.hireCage.boolValue { hiring.addObject(entry.cat.exhibitor) }
        
        // Add up cage sizes
        if !entry.isInLitter { cagelength += entry.cageSize.integerValue }
      }
      _lastEntry = entry
    } // end of looping through the entries
    
    // MARK: - Do best of colour
    // --------------------------
    doOpenChallengesFor(_lastEntry!, changingColour: true)
    doBestOfColourFor(_lastEntry, with: colourCount)
    doBestOfBreedFor(_lastEntry, with: breedCount)
    
    doPrestigeChallengesFor(_lastEntry, with: &goldChallenges)
    doPrestigeChallengesFor(_lastEntry, with: &platinumChallenges)
    
    addData(endOfEntries)
    
    // MARK: - Do best of breed list
    // ------------------------------
    for i in 0 ..< Breeds.numberOfBreeds {
      if breedsPresent.contains(Breeds.nameOf(i)) {
        addData(bestOfBreedStart, Breeds.nameOf(i).data, bestOfBreedEnd)
      }
    }
    addData(tableEnd)
    
    // MARK: - Add count of cats to list sheet
    // ----------------------------------------
    listData.appendRow("".data)
    
    for group in 1 ... 3 {
      listData.appendRow(xmlString("Group \(group)"))
      
      for sex in 0 ..< 4 {
        listData.appendRow(xmlString(" "), xmlString(Sex.nameOf(sex)))
      }
    }
    
    // MARK: - Finish catalogue & judges notes
    // ----------------------------------------
    let numberNames = ["One", "Two", "Three", "Four"]
    data.appendData(ACFstartTable)
    for group in 0 ..< 4 {
      for sex in 0 ..< 4 {
        if countOfCats[group][sex] > 0 {
          data.appendData(ACFstartRow)
          data.appendData("Group \(numberNames[group])  \(Sex.nameOf(sex)))".data)
          data.appendData(ACFendRow)
        }
      }
    }
    data.appendData(endOfFile)
    judgesNotes.appendData(endOfFileJudge)
    
    data.writeToURL(catalogueFile, atomically: true)
    judgesNotes.writeToURL(notesFile, atomically: true)
    
    openData.appendData(excelSheet[End_open]!)
    openData.appendData(goldData)
    openData.appendData(excelSheet[End_gold]!)
    openData.appendData(platinumData)
    openData.appendData(excelSheet[End_platinum]!)
    openData.appendData(companionData)
    openData.appendData(excelSheet[End_companion]!)
    openData.appendData(kittenData)
    openData.appendData(excelSheet[End_kitten]!)
    openData.appendData(listData)
    openData.appendData(excelSheet[End_list]!)
    openData.appendData(statisticsData)
    
    // MARK: - Do hire cage data
    // --------------------------
    openData.appendData(excelSheet[Hiring_row]!)
    if hiring.count > 0 {
      for person in hiring {
        if let person = person as? String {
          openData.appendRow(xmlString(person), xmlNumber(hiring.countForObject(person)))
        } else {
          fatalError("Object \(person) in hiring list is not a string")
        }
      }
    } else {
      openData.appendRow("NONE".data)
    }
    
    // MARK: - Check to see if we have some workers
    // ---------------------------------------------
    openData.appendData(excelSheet[Workers_row]!)
    
    if workers.count > 0 {
      for person in workers {
        openData.appendRow(xmlString(person))
      }
    } else {
      openData.appendRow("None".data)
    }

    // MARK: - Check to see who needs catalogues
    // -------------------------------------------
    openData.appendData(excelSheet[Catalogue_row]!)
    
    if catalogues.count > 0 {
      for person in catalogues {
        openData.appendRow(xmlString(person))
      }
    } else {
      openData.appendRow(xmlString("NONE"))
    }
    
    // MARK: - Finish writing files
    // ------------------------------
    openData.appendData(excelSheet[End_statistics]!)
    openData.appendData(excelSheet[End_workbook]!)
    
    openData.writeToURL(challengesFile, atomically: true)
    
    let fileManager = NSFileManager.defaultManager()
    guard let dirURL = url.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("Catalog_files", isDirectory: true)
    else { fatalError("Cannot create URL for folder Catalog_files") }
    
    do {
      try fileManager.createDirectoryAtURL(dirURL, withIntermediateDirectories: true, attributes: nil)
    } catch let error{
      fatalError("Cannot create directory for folder Catalog_files.\n error: \(error)")
    }
    
    let headerFiles = NSMutableData()
    headerFiles.appendData(readFile("header"))
    headerFiles.appendData(Globals.currentShowName.data)
    headerFiles.appendData(" ".data)
    headerFiles.appendData(Globals.currentShowDate.data)
    headerFiles.appendData(headerPt2)
    
    let headerURL = dirURL.URLByAppendingPathComponent("header.htm")
    guard headerFiles.writeToURL(headerURL, atomically: true)
      else { fatalError("Cannot write header files") }
    
    let judgeHeaderFiles = NSMutableData()
    judgeHeaderFiles.appendData(readFile("judge_header"))
    judgeHeaderFiles.appendData(Globals.currentShowName.data)
    judgeHeaderFiles.appendData(readFile("judge_headerPt2"))
    judgeHeaderFiles.appendData(Globals.currentShowDate.data)
    judgeHeaderFiles.appendData(readFile("judge_headerPt3"))
    
    let judgeHeaderURL = dirURL.URLByAppendingPathComponent("judge_header.htm")
    guard judgeHeaderFiles.writeToURL(judgeHeaderURL, atomically: true)
      else { fatalError("Cannot write judges notes header files") }
    
  }
}