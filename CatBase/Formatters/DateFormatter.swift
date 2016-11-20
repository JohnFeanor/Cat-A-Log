//
//  DateFormatter.swift
//  Cat-A-Log
//
//  Created by John Sandercock on 4/10/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

class DateFormatter: NSObject, NSDatePickerCellDelegate {
  
  private func datePickerCell(_ aDatePickerCell: NSDatePickerCell, validateProposedDateValue proposedDateValue: AutoreleasingUnsafeMutablePointer<Date>, timeInterval proposedTimeInterval: UnsafeMutablePointer<TimeInterval>?) {
    
    let date = proposedDateValue.pointee
    
    let calendar = Calendar.current
    var components = (calendar as NSCalendar).components([.year, .month, .day], from: date)
    if let year = components.year, year < 2000 || year >= 2100 {
      components.year = year % 100 + 2000
      if let newDate = calendar.date(from: components) {
        speaker.startSpeaking("Did you mean \(year)?")
        proposedDateValue.pointee = newDate
      }
    }
  }
}
