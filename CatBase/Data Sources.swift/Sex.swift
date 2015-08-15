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
  
  static var list = DictOfStringArray()
  
  override class func initialize() {
    dispatch_once(&sexesToken) {       // This will only ever execute once
      // load in an array of the group names & breeds in the group
      // for each show type e.g. QFA, ACF or COWOCA
      print("** Loading Sexes")
      for (showType, dict1) in Globals.dataByGroup {
        let sexes = dict1[Headings.sexes] as! [String]
        list[showType] = sexes
      }
    }
  }
  
  override init() {
    super.init()
    self.limitToList = true
  }
  
  override var list: [String] {
    if let theShow = Globals.currentShow {
      let currentShowType = theShow.affiliation
      return Sex.list[currentShowType]!
    } else {
      return []
    }
  }

}