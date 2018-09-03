//
//  Challenges.swift
//  CatBase
//
//  Created by John Sandercock on 9/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Foundation

var challengesToken: Int = 0


enum ChallengeTypes: Int {
  case kitten = 0
  case open
  case gold
  case platinum
  
  var description: String {
    guard let ans = Challenges.list[Globals.currentShowType]?[self.rawValue]
      else { fatalError("Cannot get description of challenge \(self)") }
    return ans
  }
}

class Challenges: DataSource {
  
  // ******************************
  // Class methods and properties
  // ******************************

  class func reloadChallenges() {
    for (showType, dict1) in Globals.dataByGroup {
      let challenges = dict1[Headings.challenges] as! [String]
      Challenges.list[showType] = challenges
    }
  }

  static var entity = "Challenges"
  static var list = [String : [String]]()
  
  class func createList() {
    // load in an array of the challenge classes in the group
    // for each show type e.g. QFA, ACF or COWOCA
    for (showType, dict1) in Globals.dataByGroup {
      let challenges = dict1[Headings.challenges] as! [String]
      list[showType] = challenges
    }
  }
  
  // *********************************
  // Instance methods and properties
  // ********************************
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  class func  isAKitten(_ name: String) -> Bool {
    guard let challenges = Challenges.list[Globals.currentShowType]
      else {
        print("Cannot get kitten name for show type: \(Globals.currentShowType)")
        print("returning default of'Kitten'")
        return name == "Kitten"
    }
    return name == challenges[0]
  }

  override init() {
    super.init()
    self.limitToList = true
  }
  
  override var list: [String] {
    guard let ans = Challenges.list[Globals.currentShowType]
      else { return [] }
    return ans
  }
  
  // *****************
  // MARK: - Queries
  // *****************
  
  class func type(_ entry: Entry) -> ChallengeTypes {
    var index = Challenges.list[Globals.currentShowType]?.index(of: entry.cat.challenge)
    if index == nil {
      //        fatalError("Cannot get challenge type of entry for show type: \(Globals.currentShowType)")
      index = 2
    }
    
    guard let ans = ChallengeTypes(rawValue: index!)
      else { fatalError("Cannot determine challenge type of entry: \(entry.cat.name)") }
    return ans
  }

  class func nameOf(_ rank: ChallengeTypes) -> String {
    if Challenges.list[Globals.currentShowType]?[rank.rawValue] == nil {
      reloadChallenges()
    }
    guard let ans = Challenges.list[Globals.currentShowType]?[rank.rawValue]
      else {
        fatalError("Challenge type not found for category: [\(rank)] and show type: [\(Globals.currentShowType)]\n in list: \(Challenges.list)") }
    return ans
  }
}
