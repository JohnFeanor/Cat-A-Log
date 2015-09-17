//
//  Challenges.swift
//  CatBase
//
//  Created by John Sandercock on 9/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Foundation

var challengesToken: dispatch_once_t = 0


enum ChallengeTypes: Int {
  case kitten = 0
  case open
  case gold
  case platinum
  
  var description: String {
    guard let ans = Challenges.list[Globals.currentShowType]?[self.rawValue]
      else { fatalError("Cannot get description of challenge \(self.rawValue)") }
    return ans
  }
}

class Challenges: DataSource {
  
  static var entity = "Challenges"
  static var list = [String : [String]]()
  
  override class func initialize() {
    dispatch_once(&challengesToken) {       // This will only ever execute once
      // load in an array of the challenge classes in the group
      // for each show type e.g. QFA, ACF or COWOCA
      for (showType, dict1) in Globals.dataByGroup {
        let challenges = dict1[Headings.challenges] as! [String]
        list[showType] = challenges
      }
    }
  }
  
  class func  isAKitten(name: String) -> Bool {
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
  
  class func type(entry: Entry) -> ChallengeTypes {
    guard let index = Challenges.list[Globals.currentShowType]?.indexOf(entry.cat.challenge)
      else { fatalError("Cannot get challenge type of entry for show type: \(Globals.currentShowType)") }
    
    guard let ans = ChallengeTypes(rawValue: index)
      else { fatalError("Cannot determine challenge type of entry: \(entry.cat.name)") }
    return ans
  }

  class func nameOf(rank: ChallengeTypes) -> String {
    guard let ans = Challenges.list[Globals.currentShowType]?[rank.rawValue]
      else { fatalError("Cannot determine name of challenge of rank: \(rank) in show type: \(Globals.currentShowType)") }
    return ans
  }
}
