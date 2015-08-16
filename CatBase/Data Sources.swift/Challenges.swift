//
//  Challenges.swift
//  CatBase
//
//  Created by John Sandercock on 9/08/2015.
//  Copyright © 2015 Feanor. All rights reserved.
//

import Foundation

var challengesToken: dispatch_once_t = 0

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
    if let theShow = Globals.currentShow {
      let currentShowType = theShow.affiliation
      if let challenges = Challenges.list[currentShowType] {
        return name == challenges[0]
      }
    }
    return name == "Kitten"
  }
  
  override init() {
    super.init()
    self.limitToList = true
  }
  
  override var list: [String] {
    if let theShow = Globals.currentShow {
      let currentShowType = theShow.affiliation
      return Challenges.list[currentShowType]!
    } else {
      return []
    }
  }

}
