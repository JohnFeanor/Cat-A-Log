//
//  AllCapsFormatter.swift
//  Formatting tester
//
//  Created by John Sandercock on 12/07/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

class AllCapsFormatter: NSFormatter {

  var exempted: NSArray = ["P", "Pe", "Pen", "Pend", "Pendi", "Pendin", "Pending"]
  
  override var description: String {
    get {
      return "All caps formatter exempting: \(self.exempted)"
    }
  }
  
  // MARK: - Specific formatter methods
  
  private func capitalized(s: String) -> String {
    if !exempted.containsObject(s) {
      return s.uppercaseString
    } else {
      if exempted.count == 0 {
        return ""
      } else {
        return exempted.lastObject! as! String
      }
    }
  }
  
  // MARK: - general formatter methods that must be overwritten

  override func stringForObjectValue(obj: AnyObject?) -> String? {
    // watch out for obj being nil
    if obj == nil {
      return nil
    }
    return obj as? String
  }
  
  override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
    obj.memory = string
    return true
  }
  
  override func isPartialStringValid(partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString?>, proposedSelectedRange proposedSelRangePtr: NSRangePointer, originalString origString: String, originalSelectedRange origSelRange: NSRange, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
    
    // allow deletes
    if (origSelRange.location == proposedSelRangePtr.memory.location) {
      return true
    }
    
    var partialString = ""
    var partialStringCount = 0
    if partialStringPtr.memory != nil {
      partialString = partialStringPtr.memory! as String
      partialStringCount = partialString.characters.count
    }
    
    let match = capitalized(partialString)
    
    // if the partial string is shorter than the match, set the selection
    let matchCount = match.characters.count
    if matchCount != partialStringCount {
      proposedSelRangePtr.memory.length = matchCount - partialStringCount
    }
    
    partialStringPtr.memory = match
    return false
    }

}
