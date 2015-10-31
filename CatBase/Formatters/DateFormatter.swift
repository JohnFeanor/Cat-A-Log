//
//  DateFormatter.swift
//  Cat-A-Log
//
//  Created by John Sandercock on 4/10/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

class DateFormatter: NSObject, NSDatePickerCellDelegate {
  
  func datePickerCell(aDatePickerCell: NSDatePickerCell, validateProposedDateValue proposedDateValue: AutoreleasingUnsafeMutablePointer<NSDate?>, timeInterval proposedTimeInterval: UnsafeMutablePointer<NSTimeInterval>) {
    
    guard let date = proposedDateValue.memory
      else { return }
    
    let calendar = NSCalendar.currentCalendar()
    let components = calendar.components([.Year, .Month, .Day], fromDate: date)
    if components.year < 2000 || components.year >= 2100 {
      let newValue = components.year % 100 + 2000
      components.year = newValue
      if let newDate = calendar.dateFromComponents(components) {
        speaker.startSpeakingString("Did you mean \(newValue)?")
        proposedDateValue.memory = newDate
      }
    }
  }
}
