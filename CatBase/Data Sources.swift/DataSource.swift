//
//  DataSource.swift
//  CatBase
//
//  Created by John Sandercock on 8/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Cocoa

class DataSource: NSObject {
  
  var limitToList: Bool
  
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
}
