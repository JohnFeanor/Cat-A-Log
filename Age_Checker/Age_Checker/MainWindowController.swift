//
//  MainWindowController.swift
//  Age_Checker
//
//  Created by John Sandercock on 5/07/2016.
//  Copyright © 2016 Feanor. All rights reserved.
//

import Cocoa

extension NSDate {
  
  var string: String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd MMMM yyyy HH:mm"
    return formatter.stringFromDate(self)
  }
  
  
  func lessThan(months months: Int = 0, weeks: Int = 0, before date2: NSDate) -> Bool {
    
    let calendar = NSCalendar.currentCalendar()
    
    let maxAge = NSDateComponents()
    maxAge.month = months
    maxAge.day = weeks * 7
    if let grownUpDate = calendar.dateByAddingComponents(maxAge, toDate: self, options: NSCalendarOptions(rawValue: 0)) {
      print("Becomes adult on \(grownUpDate.description); showDate is \(date2.description)")
      if calendar.compareDate(grownUpDate, toDate: date2, toUnitGranularity: .Day) == .OrderedDescending {
        return true
      }
    }
    return false
  }
  
  func monthsDifferenceTo(otherDate: NSDate) -> Int {
    let calendar = NSCalendar.currentCalendar()
    var fromDate: NSDate?, toDate: NSDate?
    
    calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
    calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: otherDate)
    if let fromDate = fromDate, toDate = toDate {
      let difference = calendar.components(.Month, fromDate: fromDate, toDate: toDate, options: [])
      return abs(difference.month)
    }
    return -1
  }
  
  func differenceInMonthsAndYears(otherDate: NSDate) -> String {
    let calendar = NSCalendar.currentCalendar()
    var fromDate: NSDate?, toDate: NSDate?
    
    calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
    calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: otherDate)
    if let fromDate = fromDate, toDate = toDate {
      let difference = calendar.components([.Year, .Month], fromDate: fromDate, toDate: toDate, options: [])
      difference.year = abs(difference.year)
      difference.month = abs(difference.month)
      let months : String
      if difference.month < 10 {
        months = "0\(difference.month)"
      } else {
        months = "\(difference.month)"
      }
      return "\(difference.year).\(months)"
    }
    return "error"
  }
  
  func numberOfDaysUntilDateTime(toDateTime: NSDate, inTimeZone timeZone: NSTimeZone? = nil) -> Int {
    let calendar = NSCalendar.currentCalendar()
    if let timeZone = timeZone {
      calendar.timeZone = timeZone
    }
    
    var fromDate: NSDate?, toDate: NSDate?
    
    calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: self)
    calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
    
    let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
    return difference.day
  }

}


class MainWindowController: NSWindowController {
  
  dynamic var dateString = "1 January 2000"
  dynamic var showDateString = "Unknown"
  dynamic var catBDay = 1
  dynamic var catBMonth = "January"
  dynamic var catBYear = "2000"
  
  
  dynamic var birthDate: NSDate = NSDate() {
    didSet {
      dateString = birthDate.description
    }
  }
  

  var shDate = NSDate()
  
  dynamic var showDate: NSDate = NSDate() {
    didSet {
      let calendar = NSCalendar.currentCalendar()
      let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: showDate)
      dateComponents.hour = 2
      shDate = calendar.dateFromComponents(dateComponents) ?? showDate
      
      showDateString = shDate.description
    }
  }
  dynamic var result = ""
  dynamic var months = 9
  dynamic var weeks = 0
  
  dynamic var age = "0.09"
  
  dynamic var daysDifference = 0
  
  override var windowNibName: String {
    return "MainWindowController"
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }
  
  @IBAction func check(sender: NSButton) {
    if birthDate.lessThan(weeks: weeks, months: months, before: shDate) {
      result = "Kitten"
    } else {
      result = "Cat"
    }
    age = birthDate.differenceInMonthsAndYears(shDate)
    daysDifference = birthDate.numberOfDaysUntilDateTime(shDate)
    print()
    print("age is \(birthDate.monthsDifferenceTo(shDate)) months old")
  }
  
}
