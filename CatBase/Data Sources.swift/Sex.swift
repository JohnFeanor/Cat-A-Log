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

enum SexType: Int, CustomStringConvertible {
  case male = 0
  case female
  case neuter
  case spay
  
  var description: String {
    switch self {
    case .male:
      return "Male"
    case .female:
      return "Female"
    case .neuter:
      return "Neuter"
    case .spay:
      return "Spay"
    }
  }
  
  mutating func increment() {
    self = SexType(rawValue: self.rawValue + 1) ?? .male
  }
}

var sexesToken: Int = 0

class Sex: DataSource {

  // ******************************
  // Class structures
  // ******************************

  
  static var list = DictOfStringArray()
  
  static var sexes: [String] {
    return Sex.list[Globals.currentShowType] ?? []
  }
  
  // ******************************
  // Class methods
  // ******************************

  class func createList() {
    // load in an array of the group names & breeds in the group
    // for each show type e.g. QFA, ACF or COWOCA
    for (showType, dict1) in Globals.dataByGroup {
      let sexes = dict1[Headings.sexes] as! [String]
      list[showType] = sexes
    }
  }

  class func isEntire(_ gender: String) -> Bool? {
    return Sex.sexes.index(of: gender) < 2
  }
  
  class func rank(of gender: String) -> Int? {
    guard let ans = Sex.sexes.index(of: gender)
      else { return nil }
    return ans
  }
  
  class func name(ranked number: Int) -> String {
    guard number < Sex.sexes.count
      else { return "" }
    return Sex.sexes[number]
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
