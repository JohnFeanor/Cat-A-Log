//
//  Sex.swift
//  CatBase
//
//  Created by John Sandercock on 8/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


var sexesToken: Int = 0

class Sex: DataSource {
  
  // ******************************
  // Class methods and properties
  // ******************************
  
  static var list = DictOfStringArray()
  
  static var sexes: [String] {
    return Sex.list[Globals.currentShowType] ?? []
  }
  
  class func createList() {
    // load in an array of the group names & breeds in the group
    // for each show type e.g. QFA, ACF or COWOCA
    for (showType, dict1) in Globals.dataByGroup {
      let sexes = dict1[Headings.sexes] as! [String]
      list[showType] = sexes
    }
  }

  class func isEntire(_ gender: String) -> Bool? {
    let list = Sex.list[Globals.currentShowType]
    return list?.index(of: gender) < 2
  }
  
  class func rankOf(_ gender: String) -> Int? {
    guard let ans = Sex.list[Globals.currentShowType]?.index(of: gender)
      else { return nil }
    return ans
  }
  
  class func nameOf(_ number: Int) -> String {
    guard let ans = Sex.list[Globals.currentShowType]? [number]
      else { fatalError("Cannot get sex number \(number) for show type \(Globals.currentShowType)") }
    return ans
  }
  
  
  // *********************************
  // Instance methods and properties
  // ********************************
  
  override init() {
    super.init()
    self.limitToList = true
  }

  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    self.limitToList = true
  }
  
  override var list: [String] {
    return Sex.sexes
  }
}
