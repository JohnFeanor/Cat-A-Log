//
//  DataSource.swift
//  CatBase
//
//  Created by John Sandercock on 8/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

class DataSource: NSFormatter {
  
  var limitToList: Bool = false
  
  var list: [String] {
      return []
  }
  // ==============================
  // MARK: - Initializers
  // ==============================
  
  override init() {
    limitToList = false
    super.init()
  }
  
  convenience init(willLimit:Bool) {
    self.init()
    self.limitToList = willLimit
  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  // ==============================
  // MARK: - Combo box data sources
  // ==============================
  
  func firstRowMatchingPrefix(prefix: String) -> String? {
    let lowerCasePrefix = prefix.lowercaseString
    // if we find a string that matches, return that
    for string in list {
      if string.lowercaseString.hasPrefix(lowerCasePrefix) {
        return string
      }
    }
    // have not found a matching string, so return nil
    return nil
  }
  
  func numberOfItemsInComboBox(aComboBox: NSComboBox) -> Int {
    return list.count
  }
  
  func comboBox(aComboBox: NSComboBox, objectValueForItemAtIndex index: Int) -> AnyObject {
    if list.count > 0 && index >= 0 && index < list.count {
      return list[index]
    } else {
      return ""
    }
  }
  
  func comboBox(aComboBox: NSComboBox, completedString uncompletedString: String) -> String?{
      let candidate = firstRowMatchingPrefix(uncompletedString)
    return candidate ?? uncompletedString
  }
  
  // ==========================================================
  // Formatter source methods
  // ==========================================================

  override func stringForObjectValue(obj: AnyObject?) -> String? {
    guard obj != nil
      else { return nil }
    guard let returnString = obj as? String
      else { return "@" }
    return firstRowMatchingPrefix(returnString)
  }
  
  override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>,
    forString string: String,
    errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
      if string.isEmpty {
        obj.memory = ""
        return true
      } else if let returnString = firstRowMatchingPrefix(string) {
        obj.memory = returnString
        return true
      } else {
        let index1 = string.endIndex.advancedBy(-1)
        let substring = string.substringToIndex(index1)
        obj.memory = substring
        return true
      }
  }
  
  
  override func isPartialStringValid(partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
    
    if !limitToList { return true }
    
    //Zero length strings are OK
    if partialString.isEmpty { return true }
    
    // do not allow if there is no match
    let maybeMatch = firstRowMatchingPrefix(partialString)
    guard let _ = maybeMatch
      else { return false }
    return true
  }
}
