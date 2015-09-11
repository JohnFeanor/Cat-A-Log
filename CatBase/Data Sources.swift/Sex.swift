//
//  Sex.swift
//  CatBase
//
//  Created by John Sandercock on 8/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Foundation

var sexesToken: dispatch_once_t = 0

class Sex: DataSource {
  
  // ******************************
  // Class methods and properties
  // ******************************
  
  static var list = DictOfStringArray()
  
  static var sexes: [String] {
    if let showAffiliation = Globals.currentShow?.affiliation {
      return Sex.list[showAffiliation]!
    } else {
      return []
    }
  }
  
  override class func initialize() {
    dispatch_once(&sexesToken) {       // This will only ever execute once
      // load in an array of the group names & breeds in the group
      // for each show type e.g. QFA, ACF or COWOCA
      for (showType, dict1) in Globals.dataByGroup {
        let sexes = dict1[Headings.sexes] as! [String]
        list[showType] = sexes
      }
    }
  }
  
  class func isEntire(gender: String) -> Bool? {
    if let showAffiliation = Globals.currentShow?.affiliation {
      let list = Sex.list[showAffiliation]
      return list?.indexOf(gender) != (Section.desexed.rawValue)
    }
    return nil
  }
  
  class func rankOf(gender: String) -> Int? {
    if let showAffiliation = Globals.currentShow?.affiliation {
      let list = Sex.list[showAffiliation]
      return list?.indexOf(gender)
    }
    return nil
  }
  
  class func nameOf(number: Int) -> String? {
    if let showAffiliation = Globals.currentShow?.affiliation {
      let list = Sex.list[showAffiliation]
      return list?[number]
    }
    return nil
  }
  
  
  // *********************************
  // Instance methods and properties
  // ********************************
  
  override init() {
    super.init()
    self.limitToList = true
  }
  
  override var list: [String] {
    return Sex.sexes
  }
}