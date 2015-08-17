//
//  Globals.swift
//  CatBase
//
//  Created by John Sandercock on 4/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

typealias DictOfStringArray = [String : [String]]

struct AgeStruct {
  var minimumAge: Int
  var timeUnit : String
}

struct Headings {
  static let minAge     = "MinAge"
  static let pending    = "Pending"
  static let sexes      = "Sexes"
  static let challenges = "Challenges"
  static let groups     = "Groups"
  static let group      = "group"
  static let subgroups  = "subgroups"
  static let breeds     = "breeds"
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

// MARK: - reading in and writing arrays and dictionaries to Plists

func dictFromPList(listName: String) -> NSDictionary {
  let path = NSBundle.mainBundle().pathForResource(listName, ofType:"plist")
  if let path = path {
    return NSDictionary(contentsOfFile:path)!
  } else {
    fatalError("Cannot load internal data \(listName)")
  }
}

func arrayFromPList(listName: String) -> [String]? {
  let path = NSBundle.mainBundle().pathForResource(listName, ofType:"plist")
  if let path = path {
    return (NSArray(contentsOfFile:path) as! [String]?)
  } else {
    fatalError("Cannot load internal data \(listName)")
  }
}

func array(array: [String], ToPlist listName: String) -> Bool {
  let path = NSBundle.mainBundle().pathForResource(listName, ofType:"plist")
  if let path = path {
    return (array as NSArray).writeToFile(path, atomically: true)
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
    let options = NSCalendarOptions(rawValue: 0)
    let testDate = calendar.dateByAddingComponents(interval, toDate: self, options: options)
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
}


class Globals: NSObject {
  
  static var currentShow: Show? = nil
  static var currentEntry: Entry? = nil
  
  static var dataByGroup:[String : NSDictionary] = {
    return dictFromPList("ShowFormats") as! [String : NSDictionary]
    }()
  
  static var showTypes: [String] = {
    let allKeys = dataByGroup.keys.array
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
}
