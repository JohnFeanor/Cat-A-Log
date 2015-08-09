//
//  Breeds.swift
//  CatBase
//
//  Created by John Sandercock on 2/08/2015.
//  Copyright (c) 2015 Feanor. All rights reserved.
//

import Cocoa

var breedsToken: dispatch_once_t = 0

class Breeds: DataSource {
  
  static var entity = "Breeds"
  static var groupBreeds   = DictOfStringArray()
  
  override class func initialize() {
    dispatch_once(&breedsToken) {       // This will only ever execute once
      
      // load in an array of the group names & breeds in the group for each of the show types
      // for each show type e.g. QFA, ACF or COWOCA
      for (showType, dict1) in Globals.dataByGroup {
        let groups = dict1["Groups"] as! [NSDictionary]
        var tempBreeds = [String]()
        for dict2 in groups {
          let groupBreeds = dict2["breeds"] as! [String]
          tempBreeds += groupBreeds
        }
        groupBreeds[showType] = tempBreeds
      }
    }
  }
  
  override var list: [String] {
    if let theShow = Globals.currentShow {
      let currentShowType = theShow.affiliation
      
      return Breeds.groupBreeds[currentShowType]!
    } else {
      return []
    }
  }
  
  // MARK: - ComboBox datasource methods
  
  
  func comboBox(aComboBox: NSComboBox, indexOfItemWithStringValue aString: String) -> Int {
    var count = 0
    for s in list {
      if aString == s {
        break
      }
      count++
    }
    return count
  }

}