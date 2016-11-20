//
//  AllCapsFormatter.swift
//  Formatting tester
//
//  Created by John Sandercock on 12/07/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

private extension Character {
  var bannedChar: Bool {
    switch self {
    case ("\0" ... " "):
      return true
    default:
      return false
    }
  }
}

class AllCapsFormatter: Formatter {

  let exempted: NSArray = ["P", "Pe", "Pen", "Pend", "Pendi", "Pendin", "Pending"]
  
  override var description: String {
    get {
      return "All caps formatter exempting: \(self.exempted)"
    }
  }
  
  // MARK: - Specific formatter methods
  
  fileprivate func capitalized(_ s: String) -> String {
    if !exempted.contains(s) {
      return s.uppercased()
    } else {
      if exempted.count == 0 {
        return ""
      } else {
        return exempted.lastObject! as! String
      }
    }
  }
  
  // MARK: - general formatter methods that must be overwritten

  override func string(for obj: Any?) -> String? {
    // watch out for obj being nil
    if obj == nil {
      return nil
    }
    return obj as? String
  }
  
  override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
    obj?.pointee = string as AnyObject?
    return true
  }
  
  override func isPartialStringValid(_ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>, proposedSelectedRange proposedSelRangePtr: NSRangePointer?, originalString origString: String, originalSelectedRange origSelRange: NSRange, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
    
    // allow deletes
    if (origSelRange.location == proposedSelRangePtr?.pointee.location) {
      return true
    }
    
    var partialString = ""
    var partialStringCount = 0
    partialString = partialStringPtr.pointee as String
    partialStringCount = partialString.characters.count
    
    if let ch = partialString.characters.last , ch.bannedChar { return false }
    
    let match = capitalized(partialString)
    
    // if the partial string is shorter than the match, set the selection
    let matchCount = match.characters.count
    if matchCount != partialStringCount {
      proposedSelRangePtr?.pointee.length = matchCount - partialStringCount
    }
    
    partialStringPtr.pointee = match as NSString
    return false
    }

}
