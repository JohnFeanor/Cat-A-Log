//
//  DataSource.swift
//  CatBase
//
//  Created by John Sandercock on 8/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

class DataSource: Formatter {
  
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
  
  @objc func firstRowMatchingPrefix(_ prefix: String) -> String? {
    let lowerCasePrefix = prefix.lowercased()
    // if we find a string that matches, return that
    for string in list {
      if string.lowercased().hasPrefix(lowerCasePrefix) {
        return string
      }
    }
    // have not found a matching string, so return nil
    return nil
  }
  
  @objc func numberOfItemsInComboBox(_ aComboBox: NSComboBox) -> Int {
    return list.count
  }
  
  @objc func comboBox(_ aComboBox: NSComboBox, objectValueForItemAtIndex index: Int) -> AnyObject {
    if list.count > 0 && index >= 0 && index < list.count {
      return list[index] as AnyObject
    } else {
      return "" as AnyObject
    }
  }
  
  @objc func comboBox(_ aComboBox: NSComboBox, completedString uncompletedString: String) -> String?{
      let candidate = firstRowMatchingPrefix(uncompletedString)
    return candidate ?? uncompletedString
  }
  
  // ==========================================================
  // Formatter source methods
  // ==========================================================

  override func string(for obj: Any?) -> String? {
    guard obj != nil
      else { return nil }
    guard let returnString = obj as? String
      else { return "@" }
    return firstRowMatchingPrefix(returnString)
  }
  
  override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
      if string.isEmpty {
        obj?.pointee = "" as AnyObject?
        return true
      } else if let returnString = firstRowMatchingPrefix(string) {
        obj?.pointee = returnString as AnyObject?
        return true
      } else {
       // let index1 = string.index(string.endIndex, offsetBy: -1)
        let substring = string[..<string.endIndex]
      //  let substring = string.substring(to: index1)
        obj?.pointee = substring as AnyObject?
        return true
      }
  }
  
  override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
    
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
